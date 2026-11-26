#!/usr/bin/env bash
# datos-que-no-salen — hook PreToolUse (matcher Bash) de Claude Code.
#
# Impide que un commit meta en el repositorio un secreto con forma reconocible,
# el correo de una persona o un fichero .env. Solo actúa si el comando contiene
# `git commit`; con cualquier otro sale con 0 sin decir nada.
#
# Qué mira: las líneas AÑADIDAS del diff preparado (`git diff --cached`). Si el
# mismo comando hace además `git add`, mira también los cambios sin preparar y
# los ficheros nuevos sin seguimiento, porque aún no están en el índice.
#
# Si encuentra algo: sale con 2 (Claude Code no ejecuta el comando y le pasa el
# stderr al agente) y añade una línea por regla y fichero a
# docs/seguridad/registro-de-bloqueos.md. NUNCA escribe el valor encontrado: un
# registro que repite el dato es otra copia del dato.
#
# Las expresiones están escritas para que este propio fichero no las dispare
# (detrás de cada prefijo viene un `[`, que no es un carácter de clave).

set -uo pipefail

input=$(cat)
cmd=$(jq -r '.tool_input.command // empty' <<<"$input")
cwd=$(jq -r '.cwd // empty' <<<"$input")

# Solo `git commit`. Cualquier otro comando: fuera, en silencio.
grep -qE 'git[[:space:]]+commit' <<<"$cmd" || exit 0

[[ -n "$cwd" && -d "$cwd" ]] && cd "$cwd"
root=$(git rev-parse --show-toplevel 2>/dev/null) || exit 0
cd "$root" || exit 0

con_add=0
grep -qE 'git[[:space:]]+add' <<<"$cmd" && con_add=1

TAB=$'\t'
git_q() { git -c core.quotePath=false "$@"; }

# Convierte un diff en líneas "fichero<TAB>línea añadida".
lineas_anadidas() {
  awk '
    /^\+\+\+ /   { f = substr($0, 5); next }
    /^\+/ && f != "/dev/null" { print f "\t" substr($0, 2) }
  '
}

# 1) Qué entra: líneas anadidas y nombres de fichero.
anadidas=$(git_q diff --cached --no-color --no-ext-diff --no-prefix --unified=0 | lineas_anadidas)
ficheros=$(git_q diff --cached --name-only --diff-filter=ACMR)

if (( con_add )); then
  anadidas+=$'\n'$(git_q diff --no-color --no-ext-diff --no-prefix --unified=0 | lineas_anadidas)
  ficheros+=$'\n'$(git_q diff --name-only --diff-filter=ACMR)
  while IFS= read -r f; do
    [[ -n "$f" && -f "$f" ]] || continue
    ficheros+=$'\n'"$f"
    grep -Iq . -- "$f" 2>/dev/null || continue   # binario o vacío
    anadidas+=$'\n'$(awk -v f="$f" '{ print f "\t" $0 }' "./$f")   # ./ evita que awk lea un nombre como opción o asignación
  done < <(git_q ls-files --others --exclude-standard)
fi

hallazgos=()   # cada elemento: "regla<TAB>fichero"

# Regla 1: clave con forma reconocible.
CLAVES='AKIA[0-9A-Z]{16}|sk-ant-[A-Za-z0-9_-]|ghp_[A-Za-z0-9]|github_pat_[A-Za-z0-9_]|AIza[0-9A-Za-z_-]{35}|xox[bpa]-[A-Za-z0-9]|-----BEGIN ([A-Z0-9]+ )*PRIVATE KEY-----'
APP_KEY_CON_VALOR='[[:space:]]*(export[[:space:]]+)?APP_KEY=("[^"]+"|'"'"'[^'"'"']+'"'"'|[^[:space:]"'"'"'#]+)'
while IFS= read -r f; do
  [[ -n "$f" ]] && hallazgos+=("regla 1 (clave con forma reconocible)${TAB}$f")
done < <(grep -E "^[^${TAB}]*${TAB}(.*(${CLAVES})|${APP_KEY_CON_VALOR})" <<<"$anadidas" | cut -f1 | sort -u)

# Regla 2: correo cuyo dominio no es de ejemplo ni github.com.
CORREO='[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}'
while IFS="$TAB" read -r f linea; do
  while IFS= read -r correo; do
    dominio=$(tr '[:upper:]' '[:lower:]' <<<"${correo##*@}")
    case "$dominio" in
      example.com|example.org|example.net|github.com) ;;
      *) hallazgos+=("regla 2 (correo de una persona)${TAB}$f"); break ;;
    esac
  done < <(grep -oE "$CORREO" <<<"$linea")
done < <(grep -E "^[^${TAB}]*${TAB}.*${CORREO}" <<<"$anadidas")

# Regla 3: un fichero llamado exactamente .env, en cualquier carpeta.
while IFS= read -r f; do
  [[ "${f##*/}" == ".env" ]] && hallazgos+=("regla 3 (fichero .env)${TAB}$f")
done <<<"$ficheros"

(( ${#hallazgos[@]} == 0 )) && exit 0

# 2) Bloqueo: stderr para el agente y una línea por hallazgo en el registro.
registro="$root/docs/seguridad/registro-de-bloqueos.md"
mkdir -p "$(dirname "$registro")"
[[ -f "$registro" ]] || echo "# Registro de bloqueos del hook datos-que-no-salen" >"$registro"

ahora=$(date -u +%Y-%m-%dT%H:%M:%SZ)
{
  echo "datos-que-no-salen: commit BLOQUEADO."
  printf '%s\n' "${hallazgos[@]}" | sort -u | while IFS="$TAB" read -r regla f; do
    echo "- $ahora BLOQUEADO $regla en $f" >>"$registro"
    echo "  · Saltó la $regla en el fichero $f."
  done
  echo "Sustituye el dato por uno inventado (un correo @example.com, una clave falsa sin forma real, o saca el .env del commit) y vuelve a intentarlo. No desactives ni te saltes este hook."
} >&2

exit 2
