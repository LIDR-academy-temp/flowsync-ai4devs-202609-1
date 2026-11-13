#!/usr/bin/env bash
# PreToolUse (Bash): bloquea `git commit` si lo que va a entrar lleva un dato que no debe salir
# de la máquina. Lee el JSON del evento por stdin con jq; el comando está en .tool_input.command.
#
# Reglas (y solo estas):
#   clave-reconocible    clave con forma conocida (AWS, Anthropic, GitHub, Google, Slack, clave
#                        privada PEM o línea de APP_KEY con valor)
#   correo-no-permitido  correo cuyo dominio no sea example.com/.org/.net ni github.com
#   archivo-env          archivo llamado exactamente .env entre los que entran al commit
#
# Coincidencia: exit 2, motivo por stderr y una línea en docs/seguridad/registro-de-bloqueos.md.
# Nunca se escribe el valor detectado, solo regla y archivo. Sin coincidencia: exit 0 y silencio.
#
# Los patrones de claves van partidos en trozos entre comillas a propósito: así este fichero no
# se reconoce a sí mismo cuando se commitea.

set -uo pipefail

input=$(cat)
cmd=$(jq -r '.tool_input.command // empty' <<<"$input" 2>/dev/null)

# Solo actúa con `git commit`; cualquier otro comando pasa sin ruido.
[[ $cmd =~ git[[:space:]]+commit ]] || exit 0

add_en_comando=0
[[ $cmd =~ git[[:space:]]+add ]] && add_en_comando=1

repo=${CLAUDE_PROJECT_DIR:-$(jq -r '.cwd // empty' <<<"$input" 2>/dev/null)}
[[ -n $repo ]] || repo=$PWD
git -C "$repo" rev-parse --git-dir >/dev/null 2>&1 || exit 0

g() { git -C "$repo" -c core.quotepath=off "$@"; }

# --- Qué se revisa -------------------------------------------------------------------------
# Salida: "archivo<TAB>línea" por cada línea añadida.
lineas_de_diff() {
  g diff --no-color --no-ext-diff -U0 "$@" | awk '
    /^diff --git /      { cab = 1; next }
    /^@@ /              { cab = 0; next }
    cab && /^\+\+\+ /   { f = $0; sub(/^\+\+\+ (b\/)?/, "", f); next }
    !cab && /^\+/       { print f "\t" substr($0, 2) }'
}

lineas_de_sin_seguimiento() {
  local f
  for f in "${sin_seguimiento[@]}"; do
    [[ -f $repo/$f ]] && grep -Iq '' "$repo/$f" 2>/dev/null \
      && awk -v f="$f" '{ print f "\t" $0 }' "$repo/$f"
  done
}

mapfile -d '' -t en_indice < <(g diff --cached --name-only --diff-filter=ACMR -z)
archivos=("${en_indice[@]}")
sin_seguimiento=()

lineas=$(lineas_de_diff --cached)

if ((add_en_comando)); then
  mapfile -d '' -t sin_preparar < <(g diff --name-only --diff-filter=ACMR -z)
  mapfile -d '' -t sin_seguimiento < <(g ls-files --others --exclude-standard -z)
  archivos+=("${sin_preparar[@]}" "${sin_seguimiento[@]}")
  lineas+=$'\n'$(lineas_de_diff)
  lineas+=$'\n'$(lineas_de_sin_seguimiento)
fi

# --- Reglas --------------------------------------------------------------------------------
re_clave="AKI""A[0-9A-Z]{16}|sk-""ant-|gh""p_|github""_pat_|AI""za[0-9A-Za-z_-]{35}|xo""x[bpa]-"
re_clave+="|-----BEGIN ""[A-Z ]*PRIVATE KEY-----|^[[:space:]]*APP""_KEY=[^[:space:]]"
re_correo='[A-Za-z0-9._%+-]+@([A-Za-z0-9.-]+\.[A-Za-z]{2,})'

hallazgos=()

while IFS=$'\t' read -r f l; do
  [[ -n $f ]] || continue
  if [[ $l =~ $re_clave ]]; then
    hallazgos+=("clave-reconocible"$'\t'"$f")
  fi
  if [[ $l == *@* ]]; then
    resto=$l
    while [[ $resto =~ $re_correo ]]; do
      dominio=${BASH_REMATCH[1],,}
      case $dominio in
        example.com | example.org | example.net | github.com) ;;
        *) hallazgos+=("correo-no-permitido"$'\t'"$f") ;;
      esac
      resto=${resto#*"${BASH_REMATCH[0]}"}
    done
  fi
done <<<"$lineas"

for f in "${archivos[@]}"; do
  [[ ${f##*/} == .env ]] && hallazgos+=("archivo-env"$'\t'"$f")
done

((${#hallazgos[@]})) || exit 0

# --- Aviso y registro ----------------------------------------------------------------------
registro="$repo/docs/seguridad/registro-de-bloqueos.md"
mkdir -p "${registro%/*}"
[[ -f $registro ]] || printf '# Registro de bloqueos del hook datos-que-no-salen\n' >"$registro"
ahora=$(date -u +%Y-%m-%dT%H:%M:%SZ)

while IFS=$'\t' read -r regla f; do
  echo "BLOQUEADO: regla '$regla' en el archivo '$f'. Sustituye el dato por uno inventado y vuelve a intentar el commit." >&2
  printf '%s BLOQUEADO %s %s\n' "$ahora" "$regla" "$f" >>"$registro"
done < <(printf '%s\n' "${hallazgos[@]}" | sort -u)

exit 2
