# FlowSync — atajos de desarrollo (Windows nativo, PowerShell).
#
# Requisitos: Node.js + npm y GNU Make para Windows.
#   - winget install ezwinports.make   (o: choco install make / scoop install make)
#
# Las recetas se ejecutan con Windows PowerShell 5.1 (powershell.exe), que viene
# con Windows. En macOS, Linux o WSL usa la versión POSIX:
#   make -f Makefile.linux <target>

SHELL := powershell.exe
.SHELLFLAGS := -NoProfile -ExecutionPolicy Bypass -Command

BACKEND  := backend
FRONTEND := frontend

.DEFAULT_GOAL := help
.PHONY: help setup start install env migrate clean

# Cada línea de una receta se lanza en un powershell.exe distinto, así que el
# `Set-Location` de una línea no afecta a la siguiente. Las cadenas van entre
# comillas simples: Windows se come las dobles al pasar el comando a
# powershell.exe. Las variables de PowerShell se escriben `$$x` para que make
# no las expanda.
#
# Los mensajes de las recetas van en ASCII a propósito: PowerShell 5.1 decodifica
# su línea de comandos con la página de códigos ANSI, así que acentos y emojis
# llegarían corruptos, y algunos de sus bytes se convierten en comillas
# tipográficas que PowerShell toma por delimitadores y rompen las cadenas.

# La ayuda se genera a partir de los comentarios `## ...` de cada target, para
# que no haya un segundo listado que mantener a mano y que pueda divergir.
help: ## Muestra esta ayuda
	@Write-Host 'FlowSync - targets disponibles:'; Write-Host ''
	@Select-String -Path '$(firstword $(MAKEFILE_LIST))' -Encoding UTF8 -Pattern '^([a-zA-Z_-]+):.*## (.*)$$' | ForEach-Object { '  make {0,-8} {1}' -f $$_.Matches[0].Groups[1].Value, $$_.Matches[0].Groups[2].Value }
	@Write-Host ''

# ---------------------------------------------------------------------------
# setup
# ---------------------------------------------------------------------------

setup: install env migrate ## Deja el proyecto listo para arrancar
	@Write-Host ''; Write-Host '[OK] Setup completado. Arranca todo con: make start'

install:
	@if (-not (Get-Command node -ErrorAction SilentlyContinue)) { Write-Host '[ERROR] Node.js no esta instalado.'; exit 1 }
	@if (-not (Get-Command npm -ErrorAction SilentlyContinue)) { Write-Host '[ERROR] npm no esta instalado.'; exit 1 }
	@Write-Host 'Instalando dependencias del backend...'
	@Set-Location '$(BACKEND)'; npm install; exit $$LASTEXITCODE
	@Write-Host 'Instalando dependencias del frontend...'
	@Set-Location '$(FRONTEND)'; npm install; exit $$LASTEXITCODE

env:
	@if (-not (Test-Path '$(BACKEND)/.env')) { Write-Host 'Creando $(BACKEND)/.env desde .env.example...'; Copy-Item '$(BACKEND)/.env.example' '$(BACKEND)/.env' } else { Write-Host '$(BACKEND)/.env ya existe, no se toca.' }
	@if (-not (Test-Path '$(FRONTEND)/.env')) { Write-Host 'Creando $(FRONTEND)/.env desde .env.example...'; Copy-Item '$(FRONTEND)/.env.example' '$(FRONTEND)/.env' } else { Write-Host '$(FRONTEND)/.env ya existe, no se toca.' }
	@if (Select-String -Path '$(BACKEND)/.env' -Pattern '^APP_KEY=.+' -Quiet) { Write-Host 'APP_KEY ya definida, no se regenera.' } else { Write-Host 'Generando APP_KEY...'; Set-Location '$(BACKEND)'; node ace generate:key; exit $$LASTEXITCODE }

migrate:
	@Write-Host 'Ejecutando migraciones...'
	@Set-Location '$(BACKEND)'; node ace migration:run; exit $$LASTEXITCODE

# ---------------------------------------------------------------------------
# start
# ---------------------------------------------------------------------------

# Lanza los dos servidores en paralelo, compartiendo la consola, y espera a que
# cualquiera de los dos termine.
#
# Un Ctrl-C en la consola llega a todos los procesos enganchados a ella, así que
# los dos servidores lo reciben igual que en una terminal normal. El `finally`
# cubre el resto de casos: si uno de los servidores se cae por su cuenta, el
# bucle sale y `taskkill /T` se lleva por delante el árbol del otro (el wrapper
# de npm y el node que cuelga de él), sin dejar procesos huérfanos ocupando los
# puertos. Sin esto, si el backend crashea al arrancar, el frontend seguiría
# vivo para siempre y el usuario no se enteraría.
#
# El script se define como variable para poder partirlo en varias líneas: en
# una definición, make une las líneas terminadas en `\` en una sola.
START_PS = \
	$$b = Start-Process -FilePath 'npm.cmd' -ArgumentList 'run','dev' -WorkingDirectory '$(BACKEND)' -NoNewWindow -PassThru; \
	$$f = Start-Process -FilePath 'npm.cmd' -ArgumentList 'run','dev' -WorkingDirectory '$(FRONTEND)' -NoNewWindow -PassThru; \
	try { \
		while (-not $$b.HasExited -and -not $$f.HasExited) { Start-Sleep -Milliseconds 500 }; \
		Write-Host ''; \
		if ($$b.HasExited) { Write-Host '[AVISO] El backend se ha parado. Cerrando el frontend.' } \
		else { Write-Host '[AVISO] El frontend se ha parado. Cerrando el backend.' } \
	} finally { \
		foreach ($$p in @($$b, $$f)) { if (-not $$p.HasExited) { taskkill /T /F /PID $$p.Id 2>&1 | Out-Null } } \
	}

start: ## Levanta backend y frontend a la vez
	@if (-not (Test-Path '$(BACKEND)/node_modules') -or -not (Test-Path '$(FRONTEND)/node_modules')) { Write-Host '[ERROR] Faltan dependencias. Ejecuta primero: make setup'; exit 1 }
	@if (-not (Test-Path '$(BACKEND)/.env')) { Write-Host '[ERROR] Falta $(BACKEND)/.env. Ejecuta primero: make setup'; exit 1 }
	@Write-Host 'Arrancando backend (http://localhost:3333) y frontend (http://localhost:5173)...'
	@Write-Host '   Ctrl-C para parar los dos. Si uno se cae, el otro se cierra tambien.'
	@Write-Host ''
	@$(START_PS)

# ---------------------------------------------------------------------------
# clean
# ---------------------------------------------------------------------------

clean: ## Borra node_modules y la base de datos SQLite
	@Write-Host 'Limpiando...'
	@'$(BACKEND)/node_modules', '$(FRONTEND)/node_modules' | Where-Object { Test-Path $$_ } | Remove-Item -Recurse -Force
	@'$(BACKEND)/tmp/db.sqlite3', '$(BACKEND)/tmp/db.sqlite3-wal', '$(BACKEND)/tmp/db.sqlite3-shm' | Where-Object { Test-Path $$_ } | Remove-Item -Force
	@Write-Host '[OK] Listo. Vuelve a ejecutar: make setup'
