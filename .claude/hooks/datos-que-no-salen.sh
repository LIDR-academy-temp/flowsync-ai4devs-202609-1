#!/usr/bin/env bash
# Hook PreToolUse (Bash): datos-que-no-salen.
# Bloquea (exit 2) un `git commit` si lo que va a entrar contiene claves o tokens
# conocidos, correos reales o un archivo llamado `.env`.
# Nunca imprime ni guarda el dato encontrado: solo la regla y el archivo.

set -u

if ! command -v jq >/dev/null 2>&1; then
  echo "datos-que-no-salen: jq no está instalado; no se pudo revisar el commit." >&2
  exit 1
fi

entrada=$(cat)
comando=$(printf '%s' "$entrada" | jq -r '.tool_input.command // empty' 2>/dev/null)
[ -z "$comando" ] && exit 0

# Actuar solo cuando el comando contiene `git commit`.
printf '%s' "$comando" | grep -Eq '(^|[^[:alnum:]_-])git[[:space:]]+commit' || exit 0

cd "${CLAUDE_PROJECT_DIR:-.}" 2>/dev/null || exit 0
git rev-parse --git-dir >/dev/null 2>&1 || exit 0

# Si el comando lleva `git add` (o `commit -a`), también se revisan los cambios
# sin preparar y los archivos nuevos sin seguimiento.
revisar_extra=0
printf '%s' "$comando" | grep -Eq '(^|[^[:alnum:]_-])git[[:space:]]+add([[:space:]]|$)' && revisar_extra=1
printf '%s' "$comando" | grep -Eq '[[:space:]]-[a-zA-Z]*a|[[:space:]]--all([[:space:]]|$)' && revisar_extra=1

REGISTRO="docs/seguridad/registro-de-bloqueos.md"
# Estos archivos describen las reglas y no se escanean.
excluido() {
  case "$1" in
    ".claude/hooks/datos-que-no-salen.sh" | "$REGISTRO") return 0 ;;
  esac
  return 1
}

hallazgos=""   # líneas "regla<TAB>archivo", sin datos reales

anotar() {
  local linea
  linea=$(printf '%s\t%s' "$1" "$2")
  case "$hallazgos" in
    *"$linea"*) return ;;
  esac
  hallazgos="${hallazgos}${linea}"$'\n'
}

# $1 = origen (staged|worktree|untracked), $2 = ruta
texto_anadido() {
  case "$1" in
    staged)    git -c core.quotepath=off diff --cached -U0 --no-color -- "$2" 2>/dev/null | grep '^+' | grep -v '^+++' ;;
    worktree)  git -c core.quotepath=off diff -U0 --no-color -- "$2" 2>/dev/null | grep '^+' | grep -v '^+++' ;;
    untracked) [ -f "$2" ] && grep -Iq . "$2" 2>/dev/null && cat "$2" ;;
  esac
}

revisar() {
  local origen="$1" ruta="$2" texto emails
  excluido "$ruta" && return

  if [ "$(basename "$ruta")" = ".env" ]; then
    anotar "archivo .env" "$ruta"
  fi

  texto=$(texto_anadido "$origen" "$ruta")
  [ -z "$texto" ] && return

  regla() {
    printf '%s\n' "$texto" | grep -Eq -- "$2" && anotar "$1" "$ruta"
  }
  regla "clave AWS (AKIA)"          'AKIA[0-9A-Z]{16}'
  regla "token Anthropic (sk-ant-)" 'sk-ant-[A-Za-z0-9_-]{10,}'
  regla "token GitHub (ghp_)"       'ghp_[A-Za-z0-9]{20,}'
  regla "token GitHub (github_pat_)" 'github_pat_[A-Za-z0-9_]{20,}'
  regla "clave Google (AIza)"       'AIza[0-9A-Za-z_-]{30,}'
  regla "token Slack (xoxb-/xoxp-/xoxa-)" 'xox[bpa]-[A-Za-z0-9-]{10,}'
  regla "clave privada (PRIVATE KEY)" 'BEGIN [A-Z ]*PRIVATE KEY'
  regla "APP_KEY con valor"         "APP_KEY[[:space:]]*[=:][[:space:]]*['\"]?[A-Za-z0-9+/=_-]{8,}"

  emails=$(printf '%s\n' "$texto" \
    | grep -oE '[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}' \
    | awk -F@ '{d=tolower($2); if (d!="example.com" && d!="example.org" && d!="example.net" && d!="github.com") print "x"}')
  [ -n "$emails" ] && anotar "correo real (no example.com/.org/.net ni github.com)" "$ruta"
}

while IFS= read -r f; do
  [ -n "$f" ] && revisar staged "$f"
done < <(git -c core.quotepath=off diff --cached --name-only --diff-filter=ACMR 2>/dev/null)

if [ "$revisar_extra" -eq 1 ]; then
  while IFS= read -r f; do
    [ -n "$f" ] && revisar worktree "$f"
  done < <(git -c core.quotepath=off diff --name-only --diff-filter=ACMR 2>/dev/null)

  while IFS= read -r f; do
    [ -n "$f" ] && revisar untracked "$f"
  done < <(git -c core.quotepath=off ls-files --others --exclude-standard 2>/dev/null)
fi

[ -z "$hallazgos" ] && exit 0

ahora=$(date -u +%Y-%m-%dT%H:%M:%SZ)
mkdir -p "$(dirname "$REGISTRO")"
if [ ! -f "$REGISTRO" ]; then
  {
    echo "# Registro de bloqueos"
    echo
    echo "Generado por \`.claude/hooks/datos-que-no-salen.sh\`. Formato: fecha UTC, BLOQUEADO, regla, archivo. Nunca se guarda el dato real."
    echo
  } > "$REGISTRO"
fi

echo "datos-que-no-salen: commit BLOQUEADO." >&2
while IFS=$'\t' read -r regla archivo; do
  [ -z "$regla" ] && continue
  echo "  - Regla: $regla | Archivo: $archivo" >&2
  printf '%s BLOQUEADO %s %s\n' "$ahora" "$regla" "$archivo" >> "$REGISTRO"
done <<< "$hallazgos"
echo "Cambia el dato por uno inventado (p. ej. ada@example.com o un valor falso), quita el archivo .env del commit y vuelve a intentarlo. Incluye $REGISTRO en el commit." >&2
exit 2
