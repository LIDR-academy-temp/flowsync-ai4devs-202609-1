#!/usr/bin/env bash
# PreToolUse (Bash): impide que un secreto con forma reconocible, el correo de
# una persona o un fichero .env entren al repositorio en un `git commit`.
#
# Solo mira las líneas AÑADIDAS. Si el comando incluye también `git add`, mira
# además lo no preparado y los ficheros nuevos sin seguimiento.
# Si bloquea: exit 2, motivo por stderr y una línea en
# docs/seguridad/registro-de-bloqueos.md. Nunca escribe el valor detectado.
#
# Los prefijos literales de las claves van escritos con un corchete
# (p. ej. "sk-an[t]-") para que este mismo fichero no se bloquee a sí mismo.

set -uo pipefail

input=$(cat)
cmd=$(printf '%s' "$input" | jq -r '.tool_input.command // empty' 2>/dev/null)
cwd=$(printf '%s' "$input" | jq -r '.cwd // empty' 2>/dev/null)

printf '%s' "$cmd" | grep -Eq 'git( -C [^ ]+)? commit' || exit 0

con_add=0
printf '%s' "$cmd" | grep -Eq 'git( -C [^ ]+)? add' && con_add=1

[ -n "$cwd" ] || cwd="${CLAUDE_PROJECT_DIR:-$PWD}"
root=$(git -C "$cwd" rev-parse --show-toplevel 2>/dev/null) || exit 0
cd "$root" || exit 0

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
lineas="$tmp/lineas"      # <fichero>\t<línea añadida>
ficheros="$tmp/ficheros"  # rutas que entran al commit
hallazgos="$tmp/hallazgos" # <regla>\t<fichero>
: >"$lineas" ; : >"$ficheros" ; : >"$hallazgos"

lineas_de_diff() {
  awk '
    /^\+\+\+ / { f = substr($0, 5); sub(/^b\//, "", f); next }
    /^\+/      { if (f != "/dev/null") print f "\t" substr($0, 2) }
  '
}

git diff --cached -U0 --no-color 2>/dev/null | lineas_de_diff >>"$lineas"
git diff --cached --name-only --diff-filter=ACMR 2>/dev/null >>"$ficheros"

if [ "$con_add" -eq 1 ]; then
  git diff -U0 --no-color 2>/dev/null | lineas_de_diff >>"$lineas"
  git diff --name-only 2>/dev/null >>"$ficheros"
  git ls-files --others --exclude-standard 2>/dev/null | while IFS= read -r f; do
    printf '%s\n' "$f" >>"$ficheros"
    [ -f "$f" ] || continue
    grep -Iq . "$f" 2>/dev/null || continue   # binario o vacío
    awk -v f="$f" '{ print f "\t" $0 }' "$f" >>"$lineas"
  done
  # `git add -f ruta/.env` mete un fichero ignorado que no sale en la lista de
  # arriba: se miran también los argumentos del propio comando.
  printf '%s\n' "$cmd" | grep -oE 'git( -C [^ ]+)? add[^;&|]*' | tr ' ' '\n' \
    | grep -E '(^|/)\.env$' >>"$ficheros"
fi

# El hook corre ANTES del comando: si el propio comando escribe el dato
# (`echo ... > f && git add f && git commit`), el fichero aún no existe.
# Se revisa también el texto del comando previo al `git commit`, sin el mensaje
# del commit (que lleva el Co-Authored-By con un correo legítimo).
printf '%s' "$cmd" | awk 'BEGIN { RS = "\001" }
  { if (match($0, /git( -C [^ ]+)? commit/)) print substr($0, 1, RSTART - 1) }' \
  | awk '{ print "(comando previo al commit)\t" $0 }' >>"$lineas"

# Regla 1: clave con forma reconocible
tab=$(printf '\t')
grep -E "${tab}.*(AKI[A][0-9A-Z]{16}|sk-an[t]-|gh[p]_|github_pa[t]_|AIz[a][0-9A-Za-z_-]{35}|xo[x][bpa]-|-----BEGI[N] [A-Z ]*PRIVATE KE[Y]-----)|^[^${tab}]*${tab}[[:space:]]*(export[[:space:]]+)?APP_KE[Y]=[^[:space:]]" "$lineas" \
  | cut -f1 | sort -u | sed 's/^/clave con forma reconocible\t/' >>"$hallazgos"

# Regla 2: correo fuera de los dominios reservados para ejemplos
awk -F'\t' '
  {
    file = $1; rest = substr($0, length($1) + 2)
    while (match(rest, /[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z][A-Za-z]+/)) {
      m = substr(rest, RSTART, RLENGTH)
      d = tolower(substr(m, index(m, "@") + 1))
      if (d != "example.com" && d != "example.org" && d != "example.net" && d != "github.com")
        print "correo de una persona\t" file
      rest = substr(rest, RSTART + RLENGTH)
    }
  }
' "$lineas" | sort -u >>"$hallazgos"

# Regla 3: un fichero llamado exactamente .env
grep -E '(^|/)\.env$' "$ficheros" | sort -u | sed 's/^/fichero .env\t/' >>"$hallazgos"

[ -s "$hallazgos" ] || exit 0

registro="$root/docs/seguridad/registro-de-bloqueos.md"
mkdir -p "$(dirname "$registro")"
[ -f "$registro" ] || printf '# Registro de bloqueos del hook datos-que-no-salen\n' >"$registro"
ahora=$(date -u +%Y-%m-%dT%H:%M:%SZ)

sort -u "$hallazgos" | while IFS="$tab" read -r regla archivo; do
  printf 'BLOQUEADO: regla «%s» en %s. Sustituye el dato por uno inventado (un correo @example.com, una clave sin forma real, nada de .env) y vuelve a intentarlo.\n' "$regla" "$archivo" >&2
  printf -- '- %s BLOQUEADO regla=%s archivo=%s\n' "$ahora" "$regla" "$archivo" >>"$registro"
done

exit 2
