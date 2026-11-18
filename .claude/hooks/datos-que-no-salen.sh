#!/usr/bin/env bash
# Hook PreToolUse (matcher Bash) "datos-que-no-salen".
#
# Antes de que el agente ejecute un comando con `git commit`, mira las líneas
# añadidas de lo que va a entrar en el commit y lo bloquea (exit 2) si encuentra:
#   1. una clave con forma reconocible,
#   2. un correo cuyo dominio no es de ejemplo,
#   3. un fichero llamado exactamente `.env`.
# Cada bloqueo deja una línea en docs/seguridad/registro-de-bloqueos.md, SIN el
# valor encontrado. Si no encuentra nada, sale con 0 sin escribir nada.
#
# Ojo: los patrones están escritos para no coincidir con su propio texto
# (p. ej. `sk[-]ant[-]`), para que este fichero pueda commitearse.

set -uo pipefail

input="$(cat)"

if ! command -v jq >/dev/null 2>&1; then
  # Sin jq no se puede leer el comando: si huele a commit, se falla cerrado.
  case "$input" in
    *"git commit"*)
      echo "datos-que-no-salen: falta jq; no se puede revisar el commit, así que se bloquea." >&2
      exit 2 ;;
  esac
  exit 0
fi

cmd="$(printf '%s' "$input" | jq -r '.tool_input.command // empty' 2>/dev/null)"

case "$cmd" in
  *"git commit"*) ;;
  *) exit 0 ;;
esac

cwd="$(printf '%s' "$input" | jq -r '.cwd // empty' 2>/dev/null)"
cd "${cwd:-${CLAUDE_PROJECT_DIR:-.}}" 2>/dev/null || exit 0
root="$(git rev-parse --show-toplevel 2>/dev/null)" || exit 0
cd "$root" || exit 0

also_add=0
case "$cmd" in
  *"git add"*) also_add=1 ;;
esac

# --- Qué entra: líneas añadidas como "ruta<TAB>línea" y lista de ficheros ----

# Convierte un diff unificado en "ruta<TAB>contenido" de cada línea añadida.
added_from_diff() {
  awk '
    /^\+\+\+ / { path = substr($0, 5); sub(/^b\//, "", path); next }
    /^\+/      { if (path != "/dev/null") print path "\t" substr($0, 2) }
  '
}

lines="$(git diff --cached -U0 --no-color --no-ext-diff | added_from_diff)"
files="$(git diff --cached --name-only --diff-filter=ACMR)"

if [ "$also_add" -eq 1 ]; then
  lines+=$'\n'"$(git diff -U0 --no-color --no-ext-diff | added_from_diff)"
  files+=$'\n'"$(git diff --name-only --diff-filter=ACMR)"

  untracked="$(git ls-files --others --exclude-standard)"
  files+=$'\n'"$untracked"
  while IFS= read -r f; do
    [ -n "$f" ] && [ -f "$f" ] || continue
    grep -Iq . "$f" 2>/dev/null || continue   # binarios y vacíos fuera
    lines+=$'\n'"$(awk -v p="$f" '{ print p "\t" $0 }' "$f")"
  done <<<"$untracked"

  # Un `.env` ignorado solo entra si el comando lo nombra (git add -f ruta/.env).
  set -f   # que un `*` del comando no se expanda contra el disco
  for word in $cmd; do
    word="${word%\"}"; word="${word#\"}"; word="${word%\'}"; word="${word#\'}"
    [ "$(basename -- "$word")" = ".env" ] && [ -f "$word" ] && files+=$'\n'"${word#./}"
  done
  set +f
fi

# --- Reglas -------------------------------------------------------------------

hits=""   # "regla<TAB>ruta" por línea
add_hit() { hits+="$1"$'\t'"$2"$'\n'; }

R1="regla 1: secreto con forma reconocible"
R2="regla 2: correo con dominio no permitido"
R3="regla 3: fichero .env"

# Regla 1. Se aplica al contenido (lo que va tras el primer TAB).
secret_res=(
  'AKIA[0-9A-Z]{16}'
  'sk[-]ant[-]'
  'gh[p]_'
  'github[_]pat_'
  'AIz[a][0-9A-Za-z_-]{35}'
  'xox[bpa][-]'
  '-{5}BEGIN [A-Z0-9 ]*PRIVATE KEY-{5}'
)
appkey_re=$'^[^\t]*\t''[[:space:]]*(export[[:space:]]+)?APP[_]KEY[[:space:]]*=[[:space:]]*[^[:space:]#"'"'"']'
appkey_quoted_re=$'^[^\t]*\t''[[:space:]]*(export[[:space:]]+)?APP[_]KEY[[:space:]]*=[[:space:]]*("[^"]+"|'"'"'[^'"'"']+'"'"')'

while IFS= read -r path; do
  [ -n "$path" ] && add_hit "$R1" "$path"
done < <(
  {
    for re in "${secret_res[@]}"; do
      printf '%s\n' "$lines" | grep -E -- $'^[^\t]*\t.*'"$re"
    done
    printf '%s\n' "$lines" | grep -E -- "$appkey_re"
    printf '%s\n' "$lines" | grep -E -- "$appkey_quoted_re"
  } | cut -f1 | sort -u
)

# Regla 2. Correos cuyo dominio no es exactamente uno de la lista.
email_re='[A-Za-z0-9._%+-]+@([A-Za-z0-9-]+\.)+[A-Za-z]{2,}'
while IFS=$'\t' read -r path content; do
  [ -n "$path" ] || continue
  while IFS= read -r addr; do
    domain="${addr##*@}"
    domain="${domain,,}"
    case "$domain" in
      example.com|example.org|example.net|github.com) ;;
      *) add_hit "$R2" "$path" ;;
    esac
  done < <(printf '%s\n' "$content" | grep -oE -- "$email_re")
done < <(printf '%s\n' "$lines" | grep -F '@')

# Regla 3. Ficheros llamados exactamente `.env` (no `.env.example`).
while IFS= read -r f; do
  [ -n "$f" ] || continue
  [ "$(basename -- "$f")" = ".env" ] && add_hit "$R3" "$f"
done <<<"$files"

[ -n "$hits" ] || exit 0

# --- Bloqueo: mensaje y registro, nunca el valor --------------------------------

log="docs/seguridad/registro-de-bloqueos.md"
mkdir -p "$(dirname "$log")"
[ -f "$log" ] || echo "# Registro de bloqueos del hook datos-que-no-salen" >"$log"

now="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
{
  echo "datos-que-no-salen: commit BLOQUEADO."
} >&2

while IFS=$'\t' read -r rule path; do
  [ -n "$rule" ] || continue
  echo "- $now | BLOQUEADO | $rule | $path" >>"$log"
  echo "  - $rule en $path" >&2
done < <(printf '%s' "$hits" | sort -u)

cat >&2 <<'EOF'
Sustituye el dato por uno inventado que cumpla las reglas (por ejemplo, un correo
de example.com o una clave de mentira sin forma reconocible), o saca el fichero
.env del commit, y vuelve a intentarlo. No desactives ni eludas este hook.
El bloqueo ha quedado anotado en docs/seguridad/registro-de-bloqueos.md.
EOF
exit 2
