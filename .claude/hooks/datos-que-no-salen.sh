#!/usr/bin/env bash
# Hook PreToolUse (matcher Bash) de Claude Code: impide que un secreto
# reconocible, el correo de una persona o un fichero .env entren en un commit.
#
# Solo actúa si el comando contiene `git commit`. Revisa las líneas añadidas
# del diff preparado y, si el mismo comando hace también `git add`, los cambios
# sin preparar y los ficheros nuevos sin seguimiento.
#
# Si hay coincidencia: sale con 2, explica la regla y el fichero por stderr y
# añade una línea a docs/seguridad/registro-de-bloqueos.md. Nunca escribe el
# valor detectado. Sin coincidencias: sale con 0 sin escribir nada.
set -uo pipefail
export LC_ALL=C

input=$(cat)
cmd=$(printf '%s' "$input" | jq -r '.tool_input.command // empty' 2>/dev/null) || exit 0
case "$cmd" in
  *"git commit"*) ;;
  *) exit 0 ;;
esac

cwd=$(printf '%s' "$input" | jq -r '.cwd // empty' 2>/dev/null)
root=$(git -C "${CLAUDE_PROJECT_DIR:-${cwd:-.}}" rev-parse --show-toplevel 2>/dev/null) || exit 0
cd "$root" || exit 0

registro="docs/seguridad/registro-de-bloqueos.md"
con_add=0
case "$cmd" in *"git add"*) con_add=1 ;; esac

lineas=$(mktemp "${TMPDIR:-/tmp}/datos-que-no-salen.XXXXXX") || exit 0
trap 'rm -f "$lineas"' EXIT

bloquear() {
  local regla=$1 archivo=$2
  mkdir -p "$(dirname "$registro")"
  [ -f "$registro" ] || printf '# Registro de bloqueos del hook datos-que-no-salen\n' >"$registro"
  printf -- '- %s BLOQUEADO %s — %s\n' "$(date -u +%Y-%m-%dT%H:%M:%SZ)" "$regla" "$archivo" >>"$registro"
  {
    printf 'BLOQUEADO por el hook datos-que-no-salen.\n'
    printf '  Regla:   %s\n' "$regla"
    printf '  Archivo: %s\n' "$archivo"
    printf '  Sustituye el dato por uno inventado que cumpla las reglas (correos solo de\n'
    printf '  example.com, example.org, example.net o github.com; nada de claves reales;\n'
    printf '  ningún fichero .env) y vuelve a intentar el commit. No desactives el hook.\n'
    printf '  El bloqueo ha quedado anotado en %s: inclúyelo en el commit.\n' "$registro"
  } >&2
  exit 2
}

# --- Regla 3: ficheros llamados exactamente .env --------------------------------
candidatos() {
  git -c core.quotePath=false diff --cached --name-only --diff-filter=ACMR
  if [ "$con_add" -eq 1 ]; then
    git -c core.quotePath=false diff --name-only --diff-filter=ACMR
    git -c core.quotePath=false ls-files --others --exclude-standard
    # Rutas nombradas tras `git add` (cubre `git add -f ruta/.env`, que el
    # .gitignore ocultaría a ls-files).
    printf '%s\n' "$cmd" | grep -oE 'git add[^;&|]*' | tr -s ' \t' '\n' | tr -d "\"'"
  fi
}
env_file=$(candidatos | awk -F/ '$NF == ".env" { print; exit }')
[ -n "$env_file" ] && bloquear "Regla 3 (fichero de entorno .env)" "$env_file"

# --- Líneas añadidas, como "ruta<TAB>contenido" ---------------------------------
lineas_diff() {
  git -c core.quotePath=false diff --no-color --no-ext-diff -U0 \
    --src-prefix=a/ --dst-prefix=b/ "$@" 2>/dev/null |
    awk '
      /^diff --git / { cab = 1; next }
      cab && /^\+\+\+ / { f = substr($0, 5); sub(/^b\//, "", f); next }
      /^@@/ { cab = 0; next }
      !cab && /^\+/ { print f "\t" substr($0, 2) }
    '
}
{
  lineas_diff --cached
  if [ "$con_add" -eq 1 ]; then
    lineas_diff
    git -c core.quotePath=false ls-files --others --exclude-standard |
      while IFS= read -r f; do
        # Fuera los vacíos y los binarios (grep -I los trata como sin coincidencia).
        if [ -f "$f" ] && grep -Iq . "$f" 2>/dev/null; then
          awk -v f="$f" '{ print f "\t" $0 }' "$f"
        fi
      done
  fi
} >"$lineas"

[ -s "$lineas" ] || exit 0

# Imprime la ruta de la primera línea añadida cuyo contenido casa con la ERE $1.
primer_archivo() {
  local n
  n=$(cut -f2- "$lineas" | grep -a -n -m1 -E -e "$1" | cut -d: -f1)
  [ -n "$n" ] && sed -n "${n}p" "$lineas" | cut -f1
}

# --- Regla 1: secretos reconocibles ---------------------------------------------
comprobar_secreto() {
  local nombre=$1 re=$2 f
  f=$(primer_archivo "$re")
  [ -n "$f" ] && bloquear "Regla 1 (secreto reconocible: $nombre)" "$f"
}
comprobar_secreto "clave de acceso de AWS" 'AKIA[0-9A-Z]{16}'
comprobar_secreto "clave de API de Anthropic" 'sk-ant-[A-Za-z0-9_-]+'
comprobar_secreto "token de GitHub" '(ghp_[A-Za-z0-9]+|github_pat_[A-Za-z0-9_]+)'
comprobar_secreto "clave de API de Google" 'AIza[0-9A-Za-z_-]{35}'
comprobar_secreto "token de Slack" 'xox[bpa]-[A-Za-z0-9-]+'
comprobar_secreto "clave privada" '-----BEGIN[ A-Z0-9]*PRIVATE KEY'
# `[=]` en vez de `=`: así el propio script no contiene el texto que busca.
comprobar_secreto "APP_KEY con valor" '(^|[^A-Za-z0-9_])APP_KEY[=]["'\'']?[^[:space:]"'\'']'

# --- Regla 2: correos de dominios no permitidos ---------------------------------
# (En una función y no dentro de $(...): el bash 3.2 de macOS no parsea un
# `case` dentro de una sustitución de comando.)
primer_correo_no_permitido() {
  local m dominio
  cut -f2- "$lineas" | grep -a -n -o -E '[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}' |
    while IFS= read -r m; do
      dominio=$(printf '%s' "${m##*@}" | tr '[:upper:]' '[:lower:]')
      case "$dominio" in
        example.com | example.org | example.net | github.com) continue ;;
      esac
      sed -n "${m%%:*}p" "$lineas" | cut -f1
      break
    done
}
correo=$(primer_correo_no_permitido)
[ -n "$correo" ] && bloquear "Regla 2 (correo de un dominio no permitido)" "$correo"

exit 0
