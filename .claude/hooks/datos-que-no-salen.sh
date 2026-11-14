#!/usr/bin/env bash
# Hook PreToolUse (matcher Bash): impide que un `git commit` lanzado por Claude
# incorpore claves reconocibles, correos reales o ficheros .env.
#
# Sale con 0 sin escribir nada si el comando no es un commit o no hay
# coincidencias. Si las hay, sale con 2, lo explica por stderr y deja una línea
# en docs/seguridad/registro-de-bloqueos.md. Nunca escribe el valor detectado.
set -uo pipefail

input=$(cat)
cmd=$(printf '%s' "$input" | jq -r '.tool_input.command // empty' 2>/dev/null) || exit 0

case "$cmd" in
  *"git commit"*) ;;
  *) exit 0 ;;
esac

incluye_add=0
case "$cmd" in *"git add"*) incluye_add=1 ;; esac

cwd=$(printf '%s' "$input" | jq -r '.cwd // empty' 2>/dev/null)
cd "${cwd:-${CLAUDE_PROJECT_DIR:-.}}" 2>/dev/null || exit 0
raiz=$(git rev-parse --show-toplevel 2>/dev/null) || exit 0
cd "$raiz" || exit 0

tmp=$(mktemp -d) || exit 0
trap 'rm -rf "$tmp"' EXIT

# Vuelca las líneas añadidas de un diff en un fichero por archivo:
# $tmp/<prefijo><n> (contenido) y $tmp/<prefijo><n>.path (ruta).
# Solo cuenta como cabecera el `+++` que va entre `diff --git` y el primer `@@`,
# para no confundirlo con una línea añadida que empiece por `++`.
volcar_diff() {
  awk -v dir="$tmp" -v pre="$1" '
    /^diff --git / { cabecera = 1; out = ""; next }
    cabecera && /^\+\+\+ / {
      ruta = substr($0, 5)
      if (ruta == "/dev/null") { out = ""; next }
      sub(/^b\//, "", ruta)
      i++
      out = dir "/" pre i
      printf "" > out
      close(out)
      print ruta > (out ".path")
      close(out ".path")
      next
    }
    /^@@/ { cabecera = 0; next }
    !cabecera && out != "" && /^\+/ { print substr($0, 2) >> out }
  '
}

git -c core.quotepath=off diff --cached --no-color --no-ext-diff -U0 | volcar_diff s
git -c core.quotepath=off diff --cached --name-only --diff-filter=ACMR > "$tmp/nombres"

if [ "$incluye_add" -eq 1 ]; then
  git -c core.quotepath=off diff --no-color --no-ext-diff -U0 | volcar_diff u
  git -c core.quotepath=off diff --name-only --diff-filter=ACMR >> "$tmp/nombres"

  n=0
  while IFS= read -r -d '' f; do
    printf '%s\n' "$f" >> "$tmp/nombres"
    # Solo ficheros de texto con contenido; los binarios no se revisan.
    [ -f "$f" ] && grep -Iq . "$f" 2>/dev/null || continue
    n=$((n + 1))
    cp "$f" "$tmp/t$n"
    printf '%s\n' "$f" > "$tmp/t$n.path"
  done < <(git ls-files --others --exclude-standard -z)
fi

hallazgos="$tmp/hallazgos"
: > "$hallazgos"
anotar() { printf '%s\t%s\n' "$1" "$2" >> "$hallazgos"; }

# Regla 3.1: claves con forma reconocible. Cada patrón exige el cuerpo de la
# clave, no solo el prefijo, para que mencionar "sk-ant-" en un texto no bloquee.
claves=(
  'AWS|AKIA[0-9A-Z]{16}'
  'Anthropic|sk-ant-[A-Za-z0-9_-]{20,}'
  'GitHub|ghp_[A-Za-z0-9]{36}'
  'GitHub|github_pat_[A-Za-z0-9_]{22,}'
  'Google|AIza[0-9A-Za-z_-]{35}'
  'Slack|xox[bpa]-[A-Za-z0-9-]{10,}'
  'clave privada|-----BEGIN[A-Z ]*PRIVATE KEY-----'
  'APP_KEY|^[[:space:]]*(export[[:space:]]+)?APP_KEY[[:space:]]*=[[:space:]]*[^[:space:]#]'
)

dominios_permitidos='example.com
example.org
example.net
github.com'

for p in "$tmp"/*.path; do
  [ -e "$p" ] || continue
  cuerpo=${p%.path}
  [ -s "$cuerpo" ] || continue
  archivo=$(cat "$p")

  for c in "${claves[@]}"; do
    tipo=${c%%|*}
    patron=${c#*|}
    if grep -qE -- "$patron" "$cuerpo"; then
      anotar "3.1 clave con forma reconocible ($tipo)" "$archivo"
    fi
  done

  if grep -oE '[A-Za-z0-9._%+-]+@([A-Za-z0-9-]+\.)+[A-Za-z]{2,}' "$cuerpo" \
    | sed 's/.*@//' | tr '[:upper:]' '[:lower:]' \
    | grep -qvxF "$dominios_permitidos"; then
    anotar "3.2 correo con dominio no permitido" "$archivo"
  fi
done

# Regla 3.3: un fichero llamado exactamente .env entre los que entran al commit.
sort -u "$tmp/nombres" | while IFS= read -r f; do
  [ "${f##*/}" = ".env" ] && anotar "3.3 fichero .env en el commit" "$f"
done

[ -s "$hallazgos" ] || exit 0

sort -u "$hallazgos" -o "$hallazgos"

registro="${CLAUDE_PROJECT_DIR:-$raiz}/docs/seguridad/registro-de-bloqueos.md"
mkdir -p "$(dirname "$registro")"
[ -f "$registro" ] || printf '# Registro de bloqueos del hook datos-que-no-salen\n\n' > "$registro"
ahora=$(date -u +%Y-%m-%dT%H:%M:%SZ)

{
  echo "Commit bloqueado por el hook datos-que-no-salen:"
  while IFS=$'\t' read -r regla archivo; do
    echo "  - regla $regla, en el archivo $archivo"
    printf -- '- %s BLOQUEADO regla: %s, archivo: %s\n' "$ahora" "$regla" "$archivo" >> "$registro"
  done < "$hallazgos"
  echo "Sustituye el dato por uno inventado (correos en example.com, claves de mentira sin forma real) o saca el archivo del commit, y vuelve a intentarlo."
} >&2

exit 2
