#!/usr/bin/env bash
# PreToolUse (Bash): bloquea un `git commit` si lo que va a entrar en él lleva
# una clave reconocible, un correo real o un fichero `.env`.
#
# Entrada: JSON por stdin (el comando está en .tool_input.command).
# Salida: 0 = deja pasar (sin escribir nada); 2 = bloquea (el motivo va por stderr).
# Nunca imprime ni registra el valor detectado: repetirlo crearía otra copia.

set -uo pipefail

input=$(cat)
cmd=$(printf '%s' "$input" | jq -r '.tool_input.command // empty')

# Solo actúa ante `git commit`.
printf '%s' "$cmd" | grep -Eq 'git[[:space:]]+commit' || exit 0

cd "${CLAUDE_PROJECT_DIR:-.}" || exit 0
git rev-parse --git-dir >/dev/null 2>&1 || exit 0

# Si el mismo comando hace `git add`, lo que aún no está en el índice también
# va a entrar en el commit.
con_add=0
printf '%s' "$cmd" | grep -Eq 'git[[:space:]]+add' && con_add=1

TAB=$'\t'

# --- Regla 1: clave con forma reconocible --------------------------------
# AWS, Anthropic (sk-ant- + cuerpo, para no dispararse con el prefijo suelto
# en la documentación), GitHub, Google, Slack y clave privada PEM.
RE_CLAVE='AKIA[0-9A-Z]{16}|sk-ant-[A-Za-z0-9_-]{20,}|ghp_[A-Za-z0-9]{36}|github_pat_[A-Za-z0-9_]{22,}|AIza[0-9A-Za-z_-]{35}|xox[bpa]-[A-Za-z0-9-]{10,}|-----BEGIN [A-Z ]*PRIVATE KEY-----'
# APP_KEY con valor, al principio de la línea. Cada línea analizada lleva el
# nombre del fichero y un TAB delante, así que el ancla ^ pasa a ser "tras el TAB".
RE_APPKEY="${TAB}[[:space:]]*(export[[:space:]]+)?APP_KEY=[\"']?[^[:space:]\"']"
# --- Regla 2: correo (dominio permitido más abajo) -----------------------
RE_CORREO='[A-Za-z0-9._%+-]+@[A-Za-z0-9-]+(\.[A-Za-z0-9-]+)+'

# Emite "fichero<TAB>línea" por cada línea añadida de un diff (sin contexto).
lineas_anadidas() {
  awk '
    /^\+\+\+ /   { f = ($2 == "/dev/null") ? "" : substr($0, 7); next }
    /^\+/        { if (f != "") printf "%s\t%s\n", f, substr($0, 2) }
  '
}

# Emite "fichero<TAB>línea" con todo el contenido de los ficheros nuevos de texto.
# Un solo grep para todos (-I salta los binarios); antes era un bucle read/printf por línea.
lineas_sin_seguimiento() {
  git -c core.quotepath=off ls-files -z --others --exclude-standard \
    | xargs -0 grep -I -H '' 2>/dev/null \
    | sed 's/^\([^:]*\):/\1\t/'
}

# Ficheros que entrarán en el commit.
ficheros() {
  git -c core.quotepath=off diff --cached --name-only
  if [ "$con_add" -eq 1 ]; then
    git -c core.quotepath=off diff --name-only
    git -c core.quotepath=off ls-files --others --exclude-standard
  fi
}

# Líneas añadidas que se revisan.
contenido() {
  git -c core.quotepath=off diff --cached -U0 --no-color | lineas_anadidas
  if [ "$con_add" -eq 1 ]; then
    git -c core.quotepath=off diff -U0 --no-color | lineas_anadidas
    lineas_sin_seguimiento
  fi
}

hallazgos=""
anota() { hallazgos+="$1"$'\t'"$2"$'\n'; }

# Regla 3: un fichero llamado exactamente .env (los .env.example no cuentan).
while IFS= read -r f; do
  [ -n "$f" ] || continue
  [ "${f##*/}" = ".env" ] && anota "regla-3-fichero-env" "$f"
done < <(ficheros)

# Reglas 1 y 2: el contenido se vuelca UNA vez a un temporal y se analiza con un
# proceso por regla. Antes se lanzaban grep/tr por cada línea añadida, y en
# Windows eso tardaba minutos (más que el timeout de 30 s del hook).
tmp=$(mktemp)
trap 'rm -f "$tmp"' EXIT
contenido >"$tmp"

# Regla 1.
while IFS= read -r f; do
  [ -n "$f" ] && anota "regla-1-clave-reconocible" "$f"
done < <(grep -E -e "$RE_CLAVE|$RE_APPKEY" "$tmp" | cut -f1 | sort -u)

# Regla 2: un solo awk extrae los correos de cada línea y descarta los dominios permitidos.
while IFS= read -r f; do
  [ -n "$f" ] && anota "regla-2-correo-real" "$f"
done < <(RE="$RE_CORREO" awk -F'\t' '
  { f = $1; l = substr($0, length($1) + 2)
    while (match(l, ENVIRON["RE"])) {
      c = substr(l, RSTART, RLENGTH); l = substr(l, RSTART + RLENGTH)
      d = tolower(substr(c, index(c, "@") + 1))
      if (d != "example.com" && d != "example.org" && d != "example.net" && d != "github.com") print f
    }
  }' "$tmp" | sort -u)

[ -n "$hallazgos" ] || exit 0

# Hay coincidencias: un registro por (regla, fichero), sin repetir y sin valores.
hallazgos=$(printf '%s' "$hallazgos" | sort -u)
registro="docs/seguridad/registro-de-bloqueos.md"
mkdir -p "$(dirname "$registro")"
[ -f "$registro" ] || printf '# Registro de bloqueos del hook datos-que-no-salen\n' >"$registro"
ahora=$(date -u +%Y-%m-%dT%H:%M:%SZ)

while IFS=$'\t' read -r regla fichero; do
  [ -n "$regla" ] || continue
  printf '%s BLOQUEADO %s %s\n' "$ahora" "$regla" "$fichero" >>"$registro"
  printf 'BLOQUEADO (%s) en %s: sustituye ese dato por uno inventado (example.com, claves de mentira) y vuelve a intentarlo.\n' \
    "$regla" "$fichero" >&2
done <<<"$hallazgos"

exit 2
