#!/usr/bin/env bash
# datos-que-no-salen — hook PreToolUse (matcher Bash) de Claude Code.
#
# Antes de un `git commit`, mira las líneas que van a entrar y bloquea (exit 2) si encuentra:
#   regla 1: una clave con forma reconocible (AWS, Anthropic, GitHub, Google, Slack,
#            un bloque de clave privada o una línea APP_KEY= con valor);
#   regla 2: un correo cuyo dominio no sea example.com/.org/.net ni github.com;
#   regla 3: un fichero llamado exactamente `.env`, en cualquier carpeta.
#
# Cada bloqueo deja una línea en docs/seguridad/registro-de-bloqueos.md con la hora UTC,
# BLOQUEADO, la regla y el archivo. Nunca el valor encontrado: el registro no es otra copia
# del dato. Si no encuentra nada sale con 0 sin escribir nada.
set -uo pipefail

input=$(cat)

if ! command -v jq >/dev/null 2>&1; then
  # Sin jq no se puede leer el comando con garantías. Solo se frena si huele a commit,
  # para no bloquear cualquier otro comando de terminal.
  if printf '%s' "$input" | grep -Eq 'git[[:space:]]+commit'; then
    echo "datos-que-no-salen: jq no está instalado y no puedo revisar este commit. Instala jq (p. ej. 'sudo apt install jq') y vuelve a intentarlo." >&2
    exit 2
  fi
  exit 0
fi

cmd=$(printf '%s' "$input" | jq -r '.tool_input.command // empty' 2>/dev/null) || exit 0
printf '%s' "$cmd" | grep -Eq 'git[[:space:]]+commit' || exit 0

cwd=$(printf '%s' "$input" | jq -r '.cwd // empty' 2>/dev/null)
cd "${cwd:-${CLAUDE_PROJECT_DIR:-.}}" 2>/dev/null || exit 0
root=$(git rev-parse --show-toplevel 2>/dev/null) || exit 0
cd "$root" || exit 0

# Si el mismo comando prepara cambios (`git add`, o `git commit -a/--all`), lo que todavía no
# está en el índice también va a entrar: se mira además el árbol de trabajo.
incluye_sin_preparar=0
if printf '%s' "$cmd" | grep -Eq 'git[[:space:]]+add([[:space:]]|$)|git[[:space:]]+commit[^;&|]*[[:space:]](-[A-Za-z]*a[A-Za-z]*|--all)([[:space:]]|$)'; then
  incluye_sin_preparar=1
fi

GIT=(git -c core.quotePath=false)

# Diff unificado → una línea "ruta<TAB>contenido" por cada línea añadida.
lineas_anadidas() {
  awk '
    /^diff --git / { cabecera = 1; f = ""; next }
    cabecera && /^\+\+\+ / { f = substr($0, 5); sub(/^b\//, "", f); sub(/\t$/, "", f); next }
    /^@@/ { cabecera = 0; next }
    !cabecera && /^\+/ && f != "" && f != "/dev/null" { print f "\t" substr($0, 2) }
  '
}

anadidas=$(
  {
    "${GIT[@]}" diff --cached --no-color --no-ext-diff -U0 --diff-filter=ACMR
    if [ "$incluye_sin_preparar" -eq 1 ]; then
      "${GIT[@]}" diff --no-color --no-ext-diff -U0 --diff-filter=ACMR
      while IFS= read -r -d '' f; do
        [ -f "$f" ] && "${GIT[@]}" diff --no-index --no-color --no-ext-diff -U0 -- /dev/null "$f"
      done < <(git ls-files --others --exclude-standard -z)
    fi
  } 2>/dev/null | lineas_anadidas
)

ficheros=$(
  {
    git diff --cached --name-only --diff-filter=ACMR
    if [ "$incluye_sin_preparar" -eq 1 ]; then
      git diff --name-only --diff-filter=ACMR
      git ls-files --others --exclude-standard
    fi
  } 2>/dev/null
)
# Un `git add -f ruta/.env` nombra en el propio comando un fichero ignorado que aún no
# aparece en ningún listado de arriba.
if printf '%s' "$cmd" | grep -Eq 'git[[:space:]]+add([[:space:]]|$)'; then
  read -ra palabras <<<"$cmd"
  for p in "${palabras[@]}"; do
    p=${p//\"/}
    p=${p//\'/}
    p=${p%;}
    if [ "${p##*/}" = ".env" ] && [ -f "$p" ]; then
      ficheros+=$'\n'"$p"
    fi
  done
fi

hallazgos=() # "regla<TAB>archivo"

# Regla 1: claves con forma reconocible.
re_clave='AKIA[0-9A-Z]{16}|sk-ant-[A-Za-z0-9_-]+|ghp_[A-Za-z0-9]+|github_pat_[A-Za-z0-9_]+|AIza[0-9A-Za-z_-]{35}|xox[bpa]-[A-Za-z0-9-]+|-----BEGIN ([A-Z0-9]+ )*PRIVATE KEY-----'
re_app_key='^[[:space:]]*(export[[:space:]]+)?APP_KEY[[:space:]]*=[[:space:]]*[^[:space:]#]'
while IFS=$'\t' read -r f linea; do
  [ -n "$f" ] || continue
  if printf '%s\n' "$linea" | grep -Eq -- "$re_clave" || printf '%s\n' "$linea" | grep -Eq -- "$re_app_key"; then
    hallazgos+=("regla 1 (clave con forma reconocible)"$'\t'"$f")
  fi
done <<<"$anadidas"

# Regla 2: correos de dominios que no son de ejemplo.
re_correo='[A-Za-z0-9._%+-]+@([A-Za-z0-9-]+\.)+[A-Za-z]{2,}'
while IFS=$'\t' read -r f linea; do
  [ -n "$f" ] || continue
  case "$linea" in *@*) ;; *) continue ;; esac
  while IFS= read -r correo; do
    dominio=$(printf '%s' "${correo##*@}" | tr '[:upper:]' '[:lower:]')
    case "$dominio" in
      example.com | example.org | example.net | github.com) ;;
      *) hallazgos+=("regla 2 (correo de una persona)"$'\t'"$f"); break ;;
    esac
  done < <(printf '%s\n' "$linea" | grep -oE -- "$re_correo")
done <<<"$anadidas"

# Regla 3: un fichero `.env` (ese nombre exacto) entre lo que entra.
while IFS= read -r f; do
  [ -n "$f" ] || continue
  if [ "${f##*/}" = ".env" ]; then
    hallazgos+=("regla 3 (fichero .env)"$'\t'"$f")
  fi
done <<<"$ficheros"

[ "${#hallazgos[@]}" -eq 0 ] && exit 0

registro="docs/seguridad/registro-de-bloqueos.md"
mkdir -p "$(dirname "$registro")"
[ -f "$registro" ] || echo "# Registro de bloqueos del hook datos-que-no-salen" >"$registro"

ahora=$(date -u +%Y-%m-%dT%H:%M:%SZ)
echo "datos-que-no-salen: commit BLOQUEADO." >&2
while IFS=$'\t' read -r regla f; do
  f=$(printf '%s' "$f" | tr -d '\r\n')
  echo "  - $regla en $f" >&2
  echo "- $ahora BLOQUEADO $regla en $f" >>"$registro"
done < <(printf '%s\n' "${hallazgos[@]}" | sort -u)
echo "Sustituye el dato por uno inventado (correos con @example.com, claves de mentira sin forma real, .env fuera del commit) y vuelve a intentarlo. No desactives ni te saltes este hook." >&2
exit 2
