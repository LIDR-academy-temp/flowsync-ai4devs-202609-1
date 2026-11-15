#!/usr/bin/env bash
# datos-que-no-salen: hook PreToolUse (matcher Bash) de Claude Code.
#
# Antes de un `git commit`, revisa las líneas que van a entrar al repositorio y
# lo bloquea (código 2) si encuentra alguna de estas tres cosas:
#   1. una clave con forma reconocible (AWS, Anthropic, GitHub, Google, Slack,
#      clave privada PEM o una línea APP_KEY= con valor);
#   2. un correo cuyo dominio no sea example.com/.org/.net ni github.com;
#   3. un fichero llamado exactamente .env, en cualquier carpeta.
#
# Cada bloqueo deja una línea en docs/seguridad/registro-de-bloqueos.md con la
# fecha UTC, la regla y el archivo. Nunca el valor encontrado.
set -uo pipefail

cmd=$(jq -r '.tool_input.command // empty' 2>/dev/null) || exit 0

# Solo actúa ante un commit; con cualquier otro comando, silencio y 0.
case "$cmd" in
  *"git commit"*) ;;
  *) exit 0 ;;
esac

root=$(git -C "${CLAUDE_PROJECT_DIR:-.}" rev-parse --show-toplevel 2>/dev/null) || exit 0
cd "$root" || exit 0

con_add=0
case "$cmd" in *"git add"*) con_add=1 ;; esac

tmp=$(mktemp) || exit 0
trap 'rm -f "$tmp" "$tmp.files"' EXIT

g() { git -c core.quotePath=false "$@"; }

# Convierte un diff en líneas "archivo<TAB>contenido añadido".
lineas_anadidas() {
  awk '
    /^diff --git / { cab = 1; next }
    cab && /^\+\+\+ / { f = substr($0, 5); sub(/^b\//, "", f); next }
    /^@@/ { cab = 0; next }
    !cab && /^\+/ { print f "\t" substr($0, 2) }
  '
}

diff_opts=(--no-color --no-ext-diff --unified=0 --src-prefix=a/ --dst-prefix=b/)

# Lo que ya está preparado.
g diff --cached "${diff_opts[@]}" | lineas_anadidas >>"$tmp"
g diff --cached --name-only --diff-filter=ACMR >>"$tmp.files"

# Si el mismo comando prepara cambios, también lo que aún no está en el índice.
if [ "$con_add" -eq 1 ]; then
  g diff "${diff_opts[@]}" | lineas_anadidas >>"$tmp"
  g diff --name-only --diff-filter=ACMR >>"$tmp.files"
  while IFS= read -r f; do
    [ -f "$f" ] || continue
    echo "$f" >>"$tmp.files"
    grep -Iq . "$f" 2>/dev/null || continue   # vacío o binario
    awk -v f="$f" '{ print f "\t" $0 }' "$f" >>"$tmp"
  done < <(g ls-files --others --exclude-standard)
fi

hallazgos=()   # "regla|archivo"

# Regla 1: clave con forma reconocible.
re_clave='AKIA[0-9A-Z]{16}|sk-ant-[A-Za-z0-9_-]+|ghp_[A-Za-z0-9]+|github_pat_[A-Za-z0-9_]+|AIza[0-9A-Za-z_-]{35}|xox[bpa]-[0-9A-Za-z-]+|-----BEGIN ([A-Z]+ )*PRIVATE KEY-----'
re_app_key='^[[:space:]]*(export[[:space:]]+)?APP_KEY=["'"'"']?[^[:space:]"'"'"']'
while IFS=$'\t' read -r f contenido; do
  if grep -qE "$re_clave" <<<"$contenido" || grep -qE "$re_app_key" <<<"$contenido"; then
    hallazgos+=("1 (clave o token con forma reconocible)|$f")
  fi
done <"$tmp"

# Regla 2: correo de un dominio que no está reservado para ejemplos.
re_correo='[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}'
while IFS=$'\t' read -r f contenido; do
  while IFS= read -r correo; do
    dominio=$(tr '[:upper:]' '[:lower:]' <<<"${correo##*@}")
    case "$dominio" in
      example.com | example.org | example.net | github.com) ;;
      *) hallazgos+=("2 (correo de una persona)|$f") ;;
    esac
  done < <(grep -oE "$re_correo" <<<"$contenido")
done < <(grep -E "$re_correo" "$tmp")

# Regla 3: un fichero .env (ese nombre exacto) entre lo que entra.
while IFS= read -r f; do
  [ "${f##*/}" = ".env" ] && hallazgos+=("3 (fichero .env)|$f")
done <"$tmp.files"

[ "${#hallazgos[@]}" -eq 0 ] && exit 0

registro="docs/seguridad/registro-de-bloqueos.md"
mkdir -p "$(dirname "$registro")"
[ -f "$registro" ] || echo "# Registro de bloqueos del hook datos-que-no-salen" >"$registro"

ahora=$(date -u +%Y-%m-%dT%H:%M:%SZ)
while IFS='|' read -r regla f; do
  echo "datos-que-no-salen: commit bloqueado. Regla ${regla} en ${f}. Sustituye el dato por uno inventado y vuelve a intentarlo." >&2
  echo "- ${ahora} BLOQUEADO regla ${regla} archivo ${f}" >>"$registro"
done < <(printf '%s\n' "${hallazgos[@]}" | sort -u)

exit 2
