#!/usr/bin/env bash
# PreToolUse (Bash): impide que un `git commit` incorpore claves, correos reales
# o archivos .env. Solo lee; lo único que escribe es el registro de bloqueos,
# y nunca con el valor detectado.
#
# Los patrones están escritos con corchetes (p. ej. gh[p]_) para que este mismo
# archivo no coincida con sus propias reglas al commitearlo.
set -uo pipefail

cmd=$(jq -r '.tool_input.command // empty' 2>/dev/null) || exit 0
[[ -n $cmd ]] || exit 0
[[ $cmd =~ git[[:space:]]+commit ]] || exit 0

con_add=0
[[ $cmd =~ git[[:space:]]+add ]] && con_add=1

cd "${CLAUDE_PROJECT_DIR:-$PWD}" 2>/dev/null || exit 0
git rev-parse --is-inside-work-tree >/dev/null 2>&1 || exit 0

RE_CLAVE="AKIA[0-9A-Z]{16}|sk-an[t]-|gh[p]_|github_pa[t]_|AIza[0-9A-Za-z_-]{35}|xox[bpa]-|-----BEGIN [A-Z ]*PRIVATE KEY-----|^[[:space:]]*(export[[:space:]]+)?APP_KEY=[^[:space:]\"']"
RE_CORREO='[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}'
NOMBRES=("" "clave con forma reconocible" "correo con dominio no permitido" "archivo .env")

hits=()
declare -A vistos
hit() { # regla archivo (una entrada por pareja)
  local k="$1|$2"
  [[ -n ${vistos[$k]:-} ]] && return
  vistos[$k]=1
  hits+=("$k")
}

# stdin: "archivo<TAB>línea añadida"
escanear() {
  local f l m dom
  while IFS=$'\t' read -r f l; do
    [[ $l =~ $RE_CLAVE ]] && hit 1 "$f"
    while [[ $l =~ $RE_CORREO ]]; do
      m=${BASH_REMATCH[0]}
      dom=${m#*@}
      dom=${dom,,}
      case $dom in
        example.com | example.org | example.net | github.com) ;;
        *) hit 2 "$f" ;;
      esac
      l=${l#*"$m"}
    done
  done
}

# stdin: rutas separadas por NUL
buscar_env() {
  local f
  while IFS= read -r -d '' f; do
    [[ ${f##*/} == .env ]] && hit 3 "$f"
  done
}

lineas_añadidas() { # args de git diff; emite "archivo<TAB>línea"
  git -c core.quotepath=false diff "$@" -U0 --no-color --no-ext-diff |
    awk '/^diff --git/{h=1} /^@@/{h=0} h && /^\+\+\+ /{f=substr($0,7);next} /^\+/{print f "\t" substr($0,2)}'
}

lineas_sin_seguimiento() { # todas las líneas de los archivos nuevos de texto
  local f
  git ls-files --others --exclude-standard -z | while IFS= read -r -d '' f; do
    [[ -f $f ]] && grep -I '' -- "$f" 2>/dev/null | F=$f awk '{print ENVIRON["F"] "\t" $0}'
  done
}

# Lo preparado
escanear < <(lineas_añadidas --cached)
buscar_env < <(git diff --cached --name-only -z --diff-filter=ACMR)

# Lo que el mismo comando va a preparar con `git add`
if ((con_add)); then
  escanear < <(lineas_añadidas)
  escanear < <(lineas_sin_seguimiento)
  buscar_env < <(git diff --name-only -z --diff-filter=ACMR; git ls-files --others --exclude-standard -z)
  # `git add -f .env` salta el .gitignore: mira también los argumentos del comando
  IFS=$' \t\n' read -r -d '' -a palabras <<<"$cmd"
  for w in "${palabras[@]}"; do
    w=${w//[\"\';&|()]/}
    [[ ${w##*/} == .env && -f $w ]] && hit 3 "$w"
  done
fi

((${#hits[@]} == 0)) && exit 0

ts=$(date -u +%Y-%m-%dT%H:%M:%SZ)
registro=docs/seguridad/registro-de-bloqueos.md
mkdir -p docs/seguridad
[[ -f $registro ]] || printf '%s\n' '# Registro de bloqueos del hook datos-que-no-salen' >"$registro"

for h in "${hits[@]}"; do
  regla=${h%%|*}
  archivo=${h#*|}
  echo "BLOQUEADO por datos-que-no-salen: regla $regla (${NOMBRES[$regla]}) en $archivo. Sustituye el dato por uno inventado (o no incorpores el archivo) y vuelve a intentar el commit." >&2
  printf '%s BLOQUEADO regla %s (%s) %s\n' "$ts" "$regla" "${NOMBRES[$regla]}" "$archivo" >>"$registro"
done
exit 2
