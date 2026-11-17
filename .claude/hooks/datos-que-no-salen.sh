#!/usr/bin/env bash
# Hook PreToolUse (matcher: Bash) — datos-que-no-salen
#
# Antes de que un `git commit` lanzado por Claude Code se ejecute, revisa lo
# que va a entrar en el commit y lo bloquea (exit 2) si encuentra:
#   1. un secreto reconocible,
#   2. un correo cuyo dominio no sea de ejemplo (example.com/.org/.net) ni github.com,
#   3. un archivo llamado exactamente `.env`.
#
# Nunca escribe el valor detectado: ni en stderr ni en el registro.
# Sin coincidencias, o si el comando no es un `git commit`, sale 0 sin escribir nada.

set -uo pipefail

input=$(cat)

if ! command -v jq >/dev/null 2>&1; then
  # Sin jq no se puede leer .tool_input.command: solo se descarta, en silencio,
  # lo que en la entrada cruda ni siquiera contiene un git commit.
  printf '%s' "$input" | grep -Eq 'git([[:space:]]|\\[tnr])+commit' || exit 0
  echo "datos-que-no-salen: jq no está instalado; el hook no puede revisar el commit." >&2
  exit 1 # error no bloqueante: avisa, pero no impide trabajar
fi

cmd=$(printf '%s' "$input" | jq -r '.tool_input.command // empty')
cwd=$(printf '%s' "$input" | jq -r '.cwd // empty')

# Solo actúa ante un `git commit`.
printf '%s' "$cmd" | grep -Eq 'git[[:space:]]+commit' || exit 0

includes_add=0
printf '%s' "$cmd" | grep -Eq 'git[[:space:]]+add' && includes_add=1

root=$(git -C "${cwd:-${CLAUDE_PROJECT_DIR:-.}}" rev-parse --show-toplevel 2>/dev/null) || exit 0
g() { git -C "$root" -c core.quotePath=false "$@"; }

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
lines="$tmp/lines" # una línea por línea añadida: <archivo>\t<contenido>
files="$tmp/files" # archivos que entrarían en el commit
: >"$lines"
: >"$files"

# Extrae de un diff -U0 las líneas añadidas, precedidas de su archivo.
added_lines() {
  awk '
    /^\+\+\+ / { f = substr($0, 5); sub(/^b\//, "", f); next }
    /^\+/      { if (f != "/dev/null") print f "\t" substr($0, 2) }
  '
}

g diff --cached -U0 --no-color --no-ext-diff | added_lines >>"$lines"
g diff --cached --name-only --diff-filter=ACMR >>"$files"

if [ "$includes_add" -eq 1 ]; then
  g diff -U0 --no-color --no-ext-diff | added_lines >>"$lines"
  g diff --name-only --diff-filter=ACMR >>"$files"
  while IFS= read -r -d '' f; do
    printf '%s\n' "$f" >>"$files"
    # Archivo nuevo: todas sus líneas son añadidas (los binarios se saltan).
    if grep -Iq . "$root/$f" 2>/dev/null; then
      awk -v f="$f" '{ print f "\t" $0 }' "$root/$f" >>"$lines"
    fi
  done < <(g ls-files --others --exclude-standard -z)
fi

hits="$tmp/hits" # <regla>\t<archivo>
: >"$hits"
T=$'\t'

# Regla 1 — secretos reconocibles. Tras sk-ant-, ghp_, github_pat_ y xox[bpa]-
# basta un carácter del alfabeto del token; la mención del prefijo seguida de un
# delimitador (`, coma, espacio, …, <, fin de línea) no salta. AKIA y AIza exigen
# su longitud fija (16 y 35).
secret_re="AKIA[0-9A-Z]{16}|sk-ant-[A-Za-z0-9_-]+|ghp_[A-Za-z0-9]+|github_pat_[A-Za-z0-9_]+|AIza[0-9A-Za-z_-]{35}|xox[bpa]-[A-Za-z0-9-]+|-----BEGIN ([A-Z]+ )?PRIVATE KEY-----"
grep -E "^[^$T]*$T.*($secret_re)" "$lines" | cut -f1 | sed "s/^/secreto$T/" >>"$hits"
# APP_KEY= con valor, al principio de la línea (formato .env).
grep -E "^[^$T]*$T[[:space:]]*(export[[:space:]]+)?APP_KEY[[:space:]]*=[[:space:]]*['\"]?[^[:space:]'\"#]" "$lines" |
  cut -f1 | sed "s/^/secreto$T/" >>"$hits"

# Regla 2 — correos con dominio que no es de ejemplo ni github.com.
email_re='[A-Za-z0-9._%+-]+@([A-Za-z0-9-]+\.)+[A-Za-z]{2,}'
while IFS="$T" read -r f content; do
  while IFS= read -r domain; do
    case "${domain,,}" in
      example.com | example.org | example.net | github.com) ;;
      *) printf 'correo\t%s\n' "$f" >>"$hits" ;;
    esac
  done < <(printf '%s\n' "$content" | grep -oE "$email_re" | sed 's/.*@//')
done < <(grep -E "^[^$T]*$T.*$email_re" "$lines")

# Regla 3 — archivos llamados exactamente .env (.env.example no cuenta).
grep -E '(^|/)\.env$' "$files" | sed "s/^/archivo-env$T/" >>"$hits"

[ -s "$hits" ] || exit 0

log_rel="docs/seguridad/registro-de-bloqueos.md"
log="$root/$log_rel"
mkdir -p "$(dirname "$log")"
[ -f "$log" ] || echo "# Registro de bloqueos del hook datos-que-no-salen" >"$log"

now=$(date -u +%Y-%m-%dT%H:%M:%SZ)
{
  echo "datos-que-no-salen: commit BLOQUEADO."
  sort -u "$hits" | while IFS="$T" read -r rule f; do
    echo "- regla: $rule · archivo: $f"
    echo "- $now BLOQUEADO regla=$rule archivo=$f" >>"$log"
  done
  echo "Sustituye el dato por uno inventado (correos en example.com/.org/.net; nada de secretos reales; ningún .env) y vuelve a intentarlo."
  echo "No desactives ni eludas este hook. El bloqueo queda en $log_rel: inclúyelo en el commit."
} >&2

exit 2
