# Prompts

Aquí van **todos los prompts que lanzaste** para hacer el ejercicio, en el orden en que los
lanzaste, con el modelo y la herramienta de cada uno.

Esto no es papeleo. Lo que se revisa es **cómo pediste las cosas**, no solo lo que salió: un
resultado flojo con un prompt bueno y un resultado flojo con un prompt vago necesitan feedback
distinto, y sin este archivo no se distinguen.

## Cómo rellenarlo

- Un apartado `## Prompt N` por cada prompt.
- **Pega el prompt tal cual lo lanzaste**, dentro del bloque de código, aunque ocupe diez líneas
  y aunque tenga faltas. No lo reescribas para que quede bien: el que arreglaste mentalmente
  después no es el que lanzaste.
- Incluye también los que **no funcionaron**. Suelen ser los más útiles de leer.
- `Modelo` y `Herramienta` en todos. Si cambiaste de una a otra a mitad, se nota aquí.

Borra el ejemplo de abajo cuando escribas el primero.

---

## Prompt 1

**Modelo:** Opus 5.5M medium
**Herramienta:** Claude Code

```
Sin modificar ningún archivo, realiza una revisión del proyecto y obtén la lista de datos personales (correos con dominios distintos a @prueba o @example, nombres, etc.), secretos (claves, tokens, contraseñas) e información que consulta el agente
```

**Qué salió:** 

Ya tengo casi todo el inventario; hago una última comprobación (los autores del historial de git) y te lo presento.

  Ran 1 shell command

No he modificado ningún archivo. Tampoco he abierto el contenido de backend/.env, frontend/.env ni backend/tmp/db.sqlite3: rechazaste esa lectura antes y no hacía falta para el inventario. Todo lo de abajo sale de las migraciones, de los ficheros versionados y de la configuración.

1. Datos personales

En la base de datos (sacado de backend/database/migrations/):

┌────────────────────┬─────────────────────────────────────────────────────────────────────────────────────┐
│       Tabla        │                   Columnas con datos de una persona identificable                   │
├────────────────────┼─────────────────────────────────────────────────────────────────────────────────────┤
│ users              │ full_name, email (único), password (guardada como hash), created_at/updated_at      │
├────────────────────┼─────────────────────────────────────────────────────────────────────────────────────┤
│ auth_access_tokens │ tokenable_id (apunta a users.id), hash, name, last_used_at, expires_at. Juntos      │
│                    │ dicen quién se conecta y cuándo.                                                    │
├────────────────────┼─────────────────────────────────────────────────────────────────────────────────────┤
│ tasks              │ assignee_id (apunta a users.id). La tarea queda ligada a una persona.               │
└────────────────────┴─────────────────────────────────────────────────────────────────────────────────────┘

El fichero backend/tmp/db.sqlite3 existe en tu máquina (32 KB). Está ignorado por git, pero tiene datos reales de las cuentas que hayas creado.

Correos con dominio distinto de @example/@prueba:
- README.md:143: ana.perez@gmail.com, junto a "Ana Pérez" y la contraseña secreto123. Es el caso de la parte C, inventado a propósito.
- README.md:227: admin:S3cr3t@bd.miempresa.com. Es una cadena de conexión con contraseña, pero el detector la ve como un correo.
- frontend/src/pages/login-page.tsx:50 y register-page.tsx:92: tu@email.com, un texto de ejemplo en el formulario.
- Historial de git (en las líneas de autor, no en los ficheros): correos de gmail.com (43 commits) y de lidr.co/lidr.es. Un hook que solo mira el diff no los ve nunca.
- La URL del remoto contiene tu usuario de GitHub: github.com/hamonteroa/....

Nombres y correos ficticios aceptables:
- Nombres: "Ada Lovelace", "Alan Turing" y "Otra Persona" en los tests de backend/tests/functional/, en las specs de openspec/specs/{auth,tasks}, en docs/capabilities/tasks/README.md, en docs/api/openapi.json y en register-page.tsx.
- Correos: ada@, alan@, nadie@ y sin-nombre@, todos con @example.com, en los tests.

2. Secretos (claves, tokens, contraseñas)

┌─────────────────────────────────────┬───────────────┬───────────────────────────────────────────────────┐
│               Fichero               │    ¿En el     │             Qué lleva o puede llevar              │
│                                     │ repositorio?  │                                                   │
├─────────────────────────────────────┼───────────────┼───────────────────────────────────────────────────┤
│                                     │               │ Mide 435 bytes. Por diseño lleva APP_KEY, que     │
│ backend/.env                        │ No (ignorado) │ cifra y firma la app. Pediste credenciales de     │
│                                     │               │ AWS, así que puede que también las tenga. No lo   │
│                                     │               │ he abierto.                                       │
├─────────────────────────────────────┼───────────────┼───────────────────────────────────────────────────┤
│ frontend/.env                       │ No (ignorado) │ VITE_API_URL. Cuidado: cualquier VITE_* acaba     │
│                                     │               │ metido en el bundle del navegador.                │
├─────────────────────────────────────┼───────────────┼───────────────────────────────────────────────────┤
│ backend/tmp/db.sqlite3              │ No            │ Hashes de contraseñas y hashes de tokens de       │
│                                     │               │ acceso.                                           │
├─────────────────────────────────────┼───────────────┼───────────────────────────────────────────────────┤
│ backend/.env.example                │ Sí            │ APP_KEY= vacío. Correcto.                         │
├─────────────────────────────────────┼───────────────┼───────────────────────────────────────────────────┤
│ .github/workflows/openapi.yml:39    │ Sí            │ APP_KEY: clave-de-ci-sin-valor-secreto, puesta a  │
│                                     │               │ propósito para CI.                                │
├─────────────────────────────────────┼───────────────┼───────────────────────────────────────────────────┤
│                                     │               │ Usa secrets.CLAUDE_CODE_OAUTH_TOKEN y             │
│ .github/workflows/revisor.yml:53,59 │ Sí            │ secrets.GITHUB_TOKEN. Los valores están en        │
│                                     │               │ GitHub, no en el repositorio.                     │
├─────────────────────────────────────┼───────────────┼───────────────────────────────────────────────────┤
│ backend/config/database.ts          │ Sí            │ DB_PASSWORD y LIBSQL_AUTH_TOKEN, comentados. Si   │
│                                     │               │ un día se activan, irán en .env.                  │
├─────────────────────────────────────┼───────────────┼───────────────────────────────────────────────────┤
│ Tests del backend                   │ Sí            │ Contraseña secreto123 (y no-es-la-suya, corta).   │
│                                     │               │ Son de prueba.                                    │
├─────────────────────────────────────┼───────────────┼───────────────────────────────────────────────────┤
│ README.md:224-227                   │ Sí            │ OLLAMA_API_KEY=abc123def456 y S3cr3t, como        │
│                                     │               │ ejemplos del ejercicio.                           │
├─────────────────────────────────────┼───────────────┼───────────────────────────────────────────────────┤
│ frontend/src/auth/auth-provider.tsx │ Código        │ El token Bearer se guarda en localStorage bajo    │
│                                     │               │ flowsync.token.                                   │
├─────────────────────────────────────┼───────────────┼───────────────────────────────────────────────────┤
│ ~/.claude.json                      │ Fuera del     │ Credenciales y estado de Claude Code.             │
│                                     │ repositorio   │                                                   │
├─────────────────────────────────────┼───────────────┼───────────────────────────────────────────────────┤
│ Conexión a Atlassian (.mcp.json)    │ Fuera del     │ Un token OAuth de Atlassian que guarda el         │
│                                     │ repositorio   │ cliente.                                          │
└─────────────────────────────────────┴───────────────┴───────────────────────────────────────────────────┘

3. Lo que leo o leería por defecto para un cambio en el backend

Regla general: todo lo que leo sale de tu máquina hacia la API de Anthropic, porque entra en mi contexto. Lo único que no sale es lo que solo ejecuta el harness en local sin enseñarme el resultado.

┌────────────────────────────────────────────────────────────┬─────────────────┬─────────────────────────┐
│                            Qué                             │    ¿Lo leo?     │ ¿Su contenido sale de   │
│                                                            │                 │       tu máquina?       │
├────────────────────────────────────────────────────────────┼─────────────────┼─────────────────────────┤
│ CLAUDE.md del repositorio (AGENTS.md apunta a él) y        │ Siempre, se     │ Sí, en cada petición    │
│ ~/.claude/CLAUDE.md                                        │ cargan solos    │                         │
├────────────────────────────────────────────────────────────┼─────────────────┼─────────────────────────┤
│ Memoria del proyecto                                       │ Siempre, si     │ Sí                      │
│ (~/.claude/projects/<proyecto>/memory/MEMORY.md)           │ existe          │                         │
├────────────────────────────────────────────────────────────┼─────────────────┼─────────────────────────┤
│ Contexto que añade el harness: tu correo, tu usuario de    │                 │ Sí. Tu correo personal  │
│ git, la rama, git status y los últimos commits             │ Siempre         │ iba en el contexto      │
│                                                            │                 │ inicial de esta sesión. │
├────────────────────────────────────────────────────────────┼─────────────────┼─────────────────────────┤
│                                                            │                 │ Las reglas y los hooks  │
│ .claude/settings.json, ~/.claude/settings.json             │ Los aplica el   │ se ejecutan en local.   │
│                                                            │ harness         │ Solo sale lo que un     │
│                                                            │                 │ hook me devuelva.       │
├────────────────────────────────────────────────────────────┼─────────────────┼─────────────────────────┤
│ .claude/skills/*, .claude/commands/*, .claude/agents/*     │ Al invocarlos   │ Sí                      │
├────────────────────────────────────────────────────────────┼─────────────────┼─────────────────────────┤
│ .mcp.json → Atlassian/Jira (skill priority-ticket)         │ Al usar la      │ Sí: el ticket va a      │
│                                                            │ skill           │ Atlassian y a Anthropic │
├────────────────────────────────────────────────────────────┼─────────────────┼─────────────────────────┤
│ Código, migraciones y database/schema.ts                   │ Sí, para        │ Sí                      │
│                                                            │ trabajar        │                         │
├────────────────────────────────────────────────────────────┼─────────────────┼─────────────────────────┤
│                                                            │ Lo leería si me │ Sí, si llego a leerlo.  │
│ backend/.env                                               │  lo pides o     │ En esta sesión no se ha │
│                                                            │ para depurar    │  leído.                 │
├────────────────────────────────────────────────────────────┼─────────────────┼─────────────────────────┤
│ backend/tmp/db.sqlite3 (vía node ace repl, sqlite3 o la    │ Lo leería al    │ Sí: los correos,        │
│ salida de los tests)                                       │ depurar datos   │ nombres y hashes        │
│                                                            │                 │ saldrían                │
├────────────────────────────────────────────────────────────┼─────────────────┼─────────────────────────┤
│                                                            │                 │ Sí, y git log incluye   │
│ Salidas de comandos (npm test, logs, git log)              │ Sí              │ los correos de los      │
│                                                            │                 │ autores                 │
├────────────────────────────────────────────────────────────┼─────────────────┼─────────────────────────┤
│ Transcripción de esta sesión                               │                 │ Se queda guardada en tu │
│ (~/.claude/projects/.../*.jsonl)                           │ No la leo       │  disco con todo lo que  │
│                                                            │                 │ he visto                │
├────────────────────────────────────────────────────────────┼─────────────────┼─────────────────────────┤
│                                                            │ No me afecta    │ Sí: envía el diff de    │
│ Workflow revisor.yml en CI                                 │ aquí            │ cada PR a Anthropic     │
│                                                            │                 │ desde GitHub            │
└────────────────────────────────────────────────────────────┴─────────────────┴─────────────────────────┘

Lo que el futuro hook no podría cazar:
- Los correos de autor en los commits: no están en el diff.
- La APP_KEY de CI: tiene formato YAML, no APP_KEY=.
- OLLAMA_API_KEY y la contraseña dentro de una URL postgresql://...@localhost.
- Los nombres de persona, como "Ana Pérez".
- Todo lo que yo leo y mando a Anthropic sin que haya un commit de por medio, como .env, la base de datos o los tickets de Jira.



## Prompt 2

**Modelo:** Opus 5.5M medium
**Herramienta:** Claude Code

```
Construye un hook llamado datos-que-no-salen,, ubicado en claude/hooks/datos-que-no-salen.sh, registrado en .claude/settings.json como PreToolUse con el matcher Bash, junto al hook existente. Debe leer el JSON de la entrada estándar mediante jq. El comando está en .tool_input.command, como en el hook de Prettier. Debe utilizar set -uo pipefail. Solo actua y escribe si el comando contiene git commit. Revisa las líneas añadidas del diferencial git diff --cached o de la adición git add

1. Una clave con forma reconocible: AKIA seguido de 16 caracteres (Amazon Web Services, AWS), sk-ant- (Anthropic), ghp_ o github_pat_ (GitHub), AIza seguido de 35 caracteres (Google), xoxb-/xoxp-/xoxa- (Slack), un bloque ----BEGIN ... PRIVATE KEY-----, o una línea APP_KEY= con valor.

2. Una dirección de correo cuyo dominio no sea example.com, example.org, example.net ni github.com. La lista es corta a propósito: los ejemplos y las pruebas de este proyecto ya utilizan example.com, reservado para ejemplos.

3. Un archivo llamado exactamente .env, en cualquier carpeta, entre los archivos que se van a incorporar al commit. Los .env.example no cuentan.


Cada vez que haya un registro bloqueado, debe de registrarse en docs/seguridad/registro-de-bloqueos.md y terminar con salida código 2. Cada línea añaddida debe de tener la fecha y hora en UTC, formato ISO 8601, la palabra BLOQUEADO, la regla y el archivo, sin incluir el valor detectado (no registrar el dato sensible). En caso sea la primera vez, crear el archivo con la cabecera. Si no detecta coincidencia, sale con 0 y no escribe nada

```

**Qué salió:** 

He creado el hook datos-que-no-salen y lo he commiteado en bloqueo-hama (commit 9153115). Pero todavía no protege nada en tu máquina: hace falta jq, que no está instalado, y que la sesión cargue el hook. Más abajo te dejo cómo arreglar las dos cosas.

Qué hace:
- Dónde está: en .claude/hooks/datos-que-no-salen.sh, registrado en .claude/settings.json como PreToolUse con matcher Bash, junto al de Prettier. Has escrito claude/hooks/; lo he puesto en .claude/hooks/, que es la ruta que pide el README del ejercicio.
- Cuándo actúa: solo si el comando contiene git commit. Con cualquier otro comando sale con 0 sin decir nada.
- Qué mira: las líneas añadidas de git diff --cached. Si el mismo comando hace git add, mira también lo que aún no está preparado y los archivos nuevos. Con git add -f ruta/.env caza también un .env ignorado.
- Un añadido que no pediste: también trata git commit -a / --all como si llevara git add, porque ese comando prepara los cambios él mismo.
- Si encuentra algo: sale con 2, dice por la salida de error qué regla saltó y en qué archivo, y pide sustituir el dato por uno inventado. Añade una línea al registro, sin el valor: - 2026-11-19T03:58:12Z BLOQUEADO regla 2 (correo de una persona) en c.txt. Si el registro no existe, lo crea con una cabecera de una línea.

Pruebas: las hice en un repositorio temporal del scratchpad, con un sustituto de jq en Python, así que docs/seguridad/registro-de-bloqueos.md todavía no existe en el proyecto. Resultados:
- Salen con 0: git status, un commit limpio, correos @example.com y @github.com, APP_KEY= vacío y .env.example.
- Bloquean con 2: un correo de gmail (también en mayúsculas), una clave AKIA… cuando el comando hace add + commit, APP_KEY= con valor, .env con git add -f o ya preparado, y commit -am con un correo dentro.
- El propio script no salta con sus expresiones regulares cuando se commitea.
- El README.md del curso sí bloquea si entra como fichero nuevo, porque contiene ana.perez@gmail.com.

Lo que falta:
1. Instala jq: ! sudo apt install -y jq. Sin jq, el hook bloquea cualquier git commit con un aviso, para no dejar pasar nada sin revisar. El hook de Prettier también lo necesita y hoy falla sin avisar.
2. El hook no estaba activo en esta sesión: mi propio commit pasó sin que saltara. Reinicia Claude Code, o revísalo en /hooks, para que lo cargue.
3. Fin de línea: he dejado .claude/settings.json en LF para que el diff solo muestre lo nuevo. Si git vuelve a poner CRLF en el .sh al hacer checkout en Windows, bash fallará. Un .gitattributes con *.sh eol=lf lo evitaría; no lo he añadido.

Siguiendo el README, siguen pendientes:
- el bloque en CLAUDE.md (pieza 2);
- la prueba real con un correo de gmail, que deja la primera línea en el registro;
- la parte C y HALLAZGOS.md.

El PR va al final de la unidad.



## Prompt 3

**Modelo:** Opus 5.5M medium
**Herramienta:** Claude Code

```
añade en CLAUDE.md que existe este nuevo hook, qué cosas bloquea y cómo actuar ante un bloqueo, así como que el registro va con el siguiente commit

```

**Qué salió:** 

He añadido a CLAUDE.md las reglas del hook y está commiteado en bloqueo-hama (commit b78c2cf). Son tres puntos nuevos al final de "Reglas de proceso":

1. Qué es y qué bloquea: dónde vive el hook, cómo está registrado y las tres reglas (clave con forma reconocible, correo fuera de los dominios de ejemplo y fichero .env). También avisa de que sin jq bloquea todo commit.
2. Cómo actuar ante un bloqueo:
   - No se desactiva ni se salta: nada de --no-verify, de tocar el hook o settings.json, ni de commitear por otra vía.
   - Se sustituye el dato por uno inventado y se vuelve a intentar. Para sacar un .env del commit, git restore --staged.
   - He añadido una cosa que no pediste: si el dato tiene que estar ahí de verdad, se para y se pregunta al usuario.
3. El registro va con el siguiente commit: docs/seguridad/registro-de-bloqueos.md es la evidencia y no se borra ni se edita a mano.

En la copia local, CLAUDE.md tenía fin de línea CRLF. Lo he pasado a LF, como está en el repositorio, para que el diff solo muestre las líneas nuevas. AGENTS.md no lo he tocado: solo apunta a CLAUDE.md.

Para que todo esto funcione de verdad, sigue faltando instalar jq (! sudo apt install -y jq) y reiniciar la sesión para que cargue el hook.


## Prompt 4

**Modelo:** Opus 5.5M medium
**Herramienta:** Claude Code

```
realiza la prueba del funcionamiento del hook: crea un archivo temporabl con un correo de @gmail.com, ejecuta git add e intenta hacer un commit manual
```

**Qué salió:** 

Nada en staged. Creo el fichero con un correo inventado de @gmail.com (no el tuyo real) y lo añado al índice.

  Ran 1 shell command, did not run 1 other call
$ git commit -m "test: prueba del hook datos-que-no-salen"
1 action not run · permission denied
│ Reason: PreToolUse:Bash hook error: datos-que-no-salen: commit BLOQUEADO.

Bloqueado, como se esperaba. Compruebo el registro y limpio el fichero de prueba.

  Ran 1 shell command

El hook funciona: bloqueó el commit.

1. Creé prueba-hook.tmp.txt con un correo inventado, persona.inventada@gmail.com. No usé tu correo real.
2. Hice git add prueba-hook.tmp.txt. Era el único fichero en el índice.
3. Lancé git commit -m "test: prueba del hook datos-que-no-salen" y el hook lo frenó con este mensaje:
datos-que-no-salen: commit BLOQUEADO.
  - regla 2 (correo de una persona) en prueba-hook.tmp.txt

Lo que he comprobado después:
- No hubo commit: el último sigue siendo 9b5b888.
- El registro se actualizó: docs/seguridad/registro-de-bloqueos.md tiene una línea nueva, 2026-11-19T04:22:05Z BLOQUEADO regla 2 (correo de una persona) en prueba-hook.tmp.txt. Guarda la regla y el fichero, pero no el correo.
- Limpieza: saqué el fichero de prueba del índice y lo borré. El índice ha quedado vacío.

El registro tiene ahora esa línea sin commitear. Según CLAUDE.md, el registro entra en el siguiente commit junto con el resto de cambios, así que lo he dejado pendiente para cuando hagas el próximo /commit.

