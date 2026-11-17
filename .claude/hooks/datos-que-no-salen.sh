#!/usr/bin/env bash
# PreToolUse / beforeShellExecution: bloquea secretos, correos reales y .env en git commit.
set -uo pipefail

# jq puede vivir en ~/.local/bin (instalación sin root) o en el PATH del sistema
export PATH="${HOME}/.local/bin:/usr/local/bin:/usr/bin:${PATH:-}"

if ! command -v jq >/dev/null 2>&1; then
  printf '%s\n' "datos-que-no-salen: jq no está en el PATH; el hook no puede leer la entrada." >&2
  exit 2
fi

input=$(cat)
# Claude Code: .tool_input.command — Cursor: .command
command=$(printf '%s' "$input" | jq -r '.tool_input.command // .command // empty')

if [[ "$command" != *"git commit"* ]]; then
  exit 0
fi

# Asegurar raíz del repo (Claude inyecta CLAUDE_PROJECT_DIR; Cursor/WSL puede arrancar fuera)
project_dir="${CLAUDE_PROJECT_DIR:-}"
if [[ -z "$project_dir" ]]; then
  project_dir=$(printf '%s' "$input" | jq -r '.cwd // .tool_input.cwd // empty')
fi
if [[ -n "$project_dir" && -d "$project_dir" ]]; then
  cd "$project_dir" || exit 0
elif git rev-parse --show-toplevel >/dev/null 2>&1; then
  cd "$(git rev-parse --show-toplevel)" || exit 0
fi

registro_path="docs/seguridad/registro-de-bloqueos.md"

block() {
  local rule="$1"
  local file="$2"
  local msg
  msg="Bloqueado: regla «${rule}» en «${file}». Sustituye el dato por uno inventado (p. ej. dominio example.com) y vuelve a intentar. No desactives ni saltes el hook."
  printf '%s\n' "$msg" >&2

  mkdir -p docs/seguridad
  if [[ ! -f "$registro_path" ]]; then
    printf '%s\n' "# Registro de bloqueos" >"$registro_path"
  fi
  local ts
  ts=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
  # Nunca el valor encontrado: solo marca, regla y archivo
  printf '%s\n' "${ts} BLOQUEADO ${rule} ${file}" >>"$registro_path"
  exit 2
}

# ¿El basename es exactamente .env? (.env.example no cuenta)
is_dotenv() {
  local base
  base=$(basename -- "$1")
  [[ "$base" == ".env" ]]
}

# Texto añadido (+) de un path ya en el índice
staged_added_text() {
  git diff --cached -U0 -- "$1" 2>/dev/null | grep -E '^\+' | grep -vE '^\+\+\+' || true
}

# Contenido a inspeccionar si aún no está staged (git add en el mismo comando)
working_text() {
  local f="$1"
  if [[ -f "$f" ]]; then
    cat -- "$f" 2>/dev/null || true
  fi
}

check_text() {
  local file="$1"
  local text="$2"
  [[ -z "$text" ]] && return 0

  # Regla 1: claves con forma reconocible (sin imprimir el valor).
  # Prefijos partidos para que ESTE script no dispare la regla al commitearse.
  # -- evita que patrones que empiezan por '-' se lean como opciones de grep.
  local p_akia='AKIA'
  local p_ant='sk-''ant-'
  local p_ghp='gh''p_'
  local p_gpat='github_''pat_'
  local p_aiza='AI''za'
  local p_xox='xo''x'
  local p_pem_a='-----''BEGIN '
  local p_pem_b='PRIVATE ''KEY-----'
  local p_app='APP_''KEY='

  if printf '%s\n' "$text" | grep -qE -- "${p_akia}[A-Z0-9]{16}"; then
    block "clave-aws" "$file"
  fi
  if printf '%s\n' "$text" | grep -qE -- "${p_ant}"; then
    block "clave-anthropic" "$file"
  fi
  if printf '%s\n' "$text" | grep -qE -- "${p_ghp}|${p_gpat}"; then
    block "clave-github" "$file"
  fi
  if printf '%s\n' "$text" | grep -qE -- "${p_aiza}[0-9A-Za-z_-]{35}"; then
    block "clave-google" "$file"
  fi
  if printf '%s\n' "$text" | grep -qE -- "${p_xox}[bpa]-"; then
    block "clave-slack" "$file"
  fi
  if printf '%s\n' "$text" | grep -qE -- "${p_pem_a}[A-Z0-9 ]*${p_pem_b}"; then
    block "clave-privada" "$file"
  fi
  # Valor real tras = (al menos 8 chars de clave); evita falsos positivos en docs.
  if printf '%s\n' "$text" | grep -qE -- "(^|[^A-Za-z0-9_])${p_app}[A-Za-z0-9+/=_-]{8,}"; then
    block "clave-app" "$file"
  fi

  # Regla 2: correo cuyo dominio no esté en la lista corta de reservados
  local email domain
  while IFS= read -r email; do
    [[ -z "$email" ]] && continue
    domain="${email##*@}"
    domain=$(printf '%s' "$domain" | tr '[:upper:]' '[:lower:]')
    case "$domain" in
      example.com | example.org | example.net | github.com) ;;
      *) block "correo" "$file" ;;
    esac
  done < <(printf '%s\n' "$text" | grep -oE -- '[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}' || true)
}

# Rutas ya preparadas para el commit
mapfile -t staged_files < <(git diff --cached --name-only 2>/dev/null || true)

declare -A seen=()

for f in "${staged_files[@]}"; do
  [[ -z "$f" ]] && continue
  seen["$f"]=1
  if is_dotenv "$f"; then
    block "fichero-env" "$f"
  fi
  check_text "$f" "$(staged_added_text "$f")"
done

# Si el mismo comando también hace git add, aún no está todo en el índice
if [[ "$command" == *"git add"* ]]; then
  mapfile -t dirty < <(
    {
      git diff --name-only 2>/dev/null || true
      git ls-files --others --exclude-standard 2>/dev/null || true
    } | sort -u
  )
  for f in "${dirty[@]}"; do
    [[ -z "$f" ]] && continue
    [[ -n "${seen[$f]+x}" ]] && continue
    if is_dotenv "$f"; then
      block "fichero-env" "$f"
    fi
    check_text "$f" "$(working_text "$f")"
  done
fi

exit 0
