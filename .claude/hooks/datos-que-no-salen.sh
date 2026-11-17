#!/usr/bin/env bash
# Hook PreToolUse (matcher Bash): impide que un `git commit` meta en el
# repositorio claves, correos de personas o archivos .env.
#
# Solo mira comandos que contienen `git commit`. Revisa las líneas añadidas del
# diff preparado y, si el mismo comando hace también `git add` (o
# `git commit -a`), lo que todavía no está en el índice.
#
# Reglas (y solo estas):
#   1. Clave con forma reconocible (AWS, Anthropic, GitHub, Google, Slack,
#      bloque de clave privada, o APP_KEY= con valor).
#   2. Correo cuyo dominio no sea example.com/.org/.net ni github.com.
#   3. Un archivo llamado exactamente .env entre los que entran en el commit.
#
# Al bloquear: sale con 2, explica regla y archivo por stderr y apunta una línea
# en docs/seguridad/registro-de-bloqueos.md. NUNCA escribe el valor detectado:
# repetirlo en otro sitio sería crear otra copia del dato.
set -uo pipefail

entrada=$(cat)
comando=$(jq -r '.tool_input.command // empty' <<<"$entrada")
directorio=$(jq -r '.cwd // empty' <<<"$entrada")

[[ $comando =~ git[[:space:]]+commit ]] || exit 0

cd "${directorio:-${CLAUDE_PROJECT_DIR:-.}}" 2>/dev/null || exit 0
git rev-parse --is-inside-work-tree >/dev/null 2>&1 || exit 0

# ¿El mismo comando prepara más cosas antes de hacer el commit?
con_add=0
[[ $comando =~ git[[:space:]]+add ]] && con_add=1
con_all=0
re_commit_all='git[[:space:]]+commit[^;&|]*[[:space:]](-[[:alnum:]]*a[[:alnum:]]*|--all)([[:space:]]|$)'
[[ $comando =~ $re_commit_all ]] && con_all=1

tab=$'\t'

# Imprime "archivo<TAB>línea" por cada línea añadida del diff indicado.
lineas_anadidas() {
  git -c core.quotePath=false diff --no-color --no-ext-diff -U0 "$@" 2>/dev/null |
    awk '
      /^diff --git /      { cabecera = 1; next }
      /^@@/               { cabecera = 0; next }
      cabecera && /^\+\+\+ / { f = substr($0, 7); next }
      !cabecera && /^\+/  { print f "\t" substr($0, 2) }
    '
}

archivos_sin_seguimiento() {
  git -c core.quotePath=false ls-files --others --exclude-standard 2>/dev/null
}

registros=$(
  lineas_anadidas --cached
  if ((con_add || con_all)); then
    lineas_anadidas
  fi
  if ((con_add)); then
    while IFS= read -r f; do
      [[ -f $f ]] && grep -Iq . -- "$f" 2>/dev/null || continue
      F="$f" awk '{ print ENVIRON["F"] "\t" $0 }' <"$f"
    done < <(archivos_sin_seguimiento)
  fi
)

archivos=$(
  git -c core.quotePath=false diff --cached --name-only --diff-filter=d 2>/dev/null
  if ((con_add || con_all)); then
    git -c core.quotePath=false diff --name-only --diff-filter=d 2>/dev/null
  fi
  if ((con_add)); then
    archivos_sin_seguimiento
    # Un .env ignorado no aparece arriba, pero `git add -f ruta/.env` lo mete igual.
    # Solo los argumentos de cada `git add`, no el resto del comando (el
    # mensaje del commit puede nombrar .env sin incorporarlo).
    grep -oE 'git[[:space:]]+add[^;&|]*' <<<"$comando" | sed -E 's/^git[[:space:]]+add//' |
      tr -s " \t\"'()" '\n'
  fi
)

declare -A vistos=()
bloqueos=()
anotar() { # $1 = regla, $2 = archivo
  local clave="$1$tab$2"
  [[ -n ${vistos[$clave]:-} ]] && return
  vistos[$clave]=1
  bloqueos+=("$clave")
}

regla1='regla 1 (clave o token con forma reconocible)'
regla2='regla 2 (correo con un dominio no reservado para ejemplos)'
regla3='regla 3 (archivo .env)'

# --- Regla 3: archivos .env ------------------------------------------------
while IFS= read -r f; do
  [[ $f == .env || $f == */.env ]] && anotar "$regla3" "$f"
done <<<"$archivos"

# --- Regla 1: claves con forma reconocible ---------------------------------
# El bloque de clave privada lleva el espacio como [ ] para que este mismo
# archivo no se detecte a sí mismo.
re_claves='AKIA[0-9A-Z]{16}|sk-ant-[A-Za-z0-9_-]+|ghp_[A-Za-z0-9]+|github_pat_[A-Za-z0-9_]+|AIza[0-9A-Za-z_-]{35}|xox[bpa]-[A-Za-z0-9-]+|-----BEGIN ([A-Z0-9]+ )*PRIVATE[ ]KEY-----'
re_app_key='[[:space:]]*(export[[:space:]]+)?APP_KEY[[:space:]]*=[[:space:]]*["'\'']?[^[:space:]"'\''#]'
if [[ -n $registros ]]; then
  while IFS= read -r f; do
    [[ -n $f ]] && anotar "$regla1" "$f"
  done < <(grep -E "${tab}.*(${re_claves})|${tab}${re_app_key}" <<<"$registros" | cut -f1)
fi

# --- Regla 2: correos fuera de los dominios de ejemplo ----------------------
re_correo='[A-Za-z0-9._%+-]+@[A-Za-z0-9-]+(\.[A-Za-z0-9-]+)*\.[A-Za-z]{2,}'
if [[ -n $registros ]]; then
  while IFS= read -r registro; do
    f=${registro%%"$tab"*}
    contenido=${registro#*"$tab"}
    while IFS= read -r correo; do
      dominio=${correo##*@}
      case ${dominio,,} in
        example.com | example.org | example.net | github.com) ;;
        *)
          anotar "$regla2" "$f"
          break
          ;;
      esac
    done < <(grep -oE "$re_correo" <<<"$contenido")
  done < <(grep -E "${tab}.*${re_correo}" <<<"$registros")
fi

((${#bloqueos[@]} == 0)) && exit 0

# --- Bloqueo: aviso y registro (sin el valor detectado) ---------------------
raiz=${CLAUDE_PROJECT_DIR:-$(git rev-parse --show-toplevel)}
registro_bloqueos="$raiz/docs/seguridad/registro-de-bloqueos.md"
mkdir -p "$(dirname "$registro_bloqueos")"
if [[ ! -f $registro_bloqueos ]]; then
  echo '# Registro de bloqueos del hook datos-que-no-salen (fecha UTC en ISO 8601, regla, archivo; nunca el valor)' >"$registro_bloqueos"
fi
fecha=$(date -u +%Y-%m-%dT%H:%M:%SZ)

{
  echo "Commit bloqueado por el hook datos-que-no-salen:"
  for b in "${bloqueos[@]}"; do
    echo "  - ${b%%"$tab"*} en ${b#*"$tab"}"
    echo "- $fecha BLOQUEADO ${b%%"$tab"*} ${b#*"$tab"}" >>"$registro_bloqueos"
  done
  echo "El dato debe sustituirse por uno inventado (para correos, un dominio example.com)."
  echo "Un .env no se versiona: sácalo del índice con 'git restore --staged <ruta>'."
  echo "Bloqueo apuntado en docs/seguridad/registro-de-bloqueos.md (sin el valor)."
} >&2
exit 2
