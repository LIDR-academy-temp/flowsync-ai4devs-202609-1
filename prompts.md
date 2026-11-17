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

> Nota de esta sesión: los prompts y las respuestas están tal cual, salvo los correos con
> dominio real, sustituidos por `…@example.com` y marcados con `[sustituido]`. Es lo que pide la
> regla "Datos que no salen" de `CLAUDE.md`: el hook `datos-que-no-salen` bloquearía el commit.

---

## Prompt 1

**Modelo:** Opus 5.5 (`claude-opus-5-5`)
**Herramienta:** Claude Code

```
Identifica los datos personales y los secretos del proyecto, y que explique qué información consulta para trabajar en él. No debe modificar ningún archivo.

Damelo en tres listas:

- Datos personales. Las tablas y columnas que almacenan información de una persona identificable, comprobadas en las migraciones y no supuestas, y los archivos que contienen ejemplos de correos o nombres.

- Secretos. Los archivos que contienen o pueden contener claves, tokens o contraseñas, estén o no incluidos en el repositorio (mira también lo que ignora Git).

- Información que consulta el agente. Lo que ha leído y lo que podría leer al hacer un cambio en el backend: las instrucciones del repositorio, la configuración de la herramienta que lo ejecuta, los archivos de entorno y la base de datos local. Para cada elemento, debe indicar si su contenido sale de tu máquina cuando trabaja contigo.
```

**Qué salió:** funcionó a la primera; sin tocar archivos y sin leer los valores de los `.env` ni la base de datos.

**Respuesta del LLM:**

````markdown
He revisado el proyecto sin modificar ningún archivo. Los valores de los `.env` no los he leído: solo he mirado los nombres de las variables y la longitud de `APP_KEY`. De la base de datos local no he leído nada.

## 1. Datos personales

**Tablas y columnas, comprobadas en `backend/database/migrations/`**

| Tabla | Columna | Qué guarda |
|---|---|---|
| `users` | `full_name` | Nombre de la persona (puede estar vacío) |
| `users` | `email` | Correo, único: identifica a la persona directamente |
| `users` | `password` | Hash de la contraseña. Es dato personal y también secreto |
| `users` | `created_at`, `updated_at` | Cuándo se registró la persona |
| `auth_access_tokens` | `tokenable_id` → `users.id` | Une cada sesión a una persona |
| `auth_access_tokens` | `last_used_at`, `created_at`, `expires_at` | Cuándo usó la aplicación cada persona |
| `tasks` | `assignee_id` → `users.id` | Qué tareas tiene asignadas cada persona |
| `tasks` | `title` | Texto libre: puede acabar conteniendo nombres o datos de terceros |

**Archivos con ejemplos de correos o nombres**
- `backend/tests/functional/auth/*.spec.ts` y `backend/tests/functional/tasks/assignee.spec.ts`: `ada@example.com`, `alan@example.com`, `nadie@example.com` y `sin-nombre@example.com`, con los nombres "Ada Lovelace", "Alan Turing" y "Otra Persona".
- `docs/capabilities/tasks/README.md:155` y `openspec/specs/auth/spec.md:13,150`: Ada Lovelace / `ada@example.com`.
- `eval-harness/evals/commit-skill/fixture.sh:6`: `alumno@example.com`, "Alumno".
- `README.md:143`: **"Ana Pérez" con `ana.perez@example.com` [sustituido]**. Es el único ejemplo con un dominio real (está ahí a propósito, como caso de prueba del ejercicio).
- `README.md:227`: `S3cr3t@example.com` [sustituido]. Es una cadena de conexión que parece un correo.
- `frontend/src/pages/login-page.tsx:50` y `register-page.tsx:92`: el texto de ayuda `tu@example.com` [sustituido].
- Fuera de Git: **`backend/tmp/db.sqlite3`** guarda los registros reales de las tablas anteriores.

## 2. Secretos

**Ignorados por Git (`git status --ignored`)**
- **`backend/.env`**: `APP_KEY` tiene un valor de 32 caracteres. Es la clave que cifra y firma la aplicación, así que es un secreto real.
- **`frontend/.env`**: solo `VITE_API_URL`. Hoy no tiene nada secreto, pero lo que se ponga ahí acaba dentro del bundle.
- **`backend/tmp/db.sqlite3`**: hashes de contraseñas (`users.password`) y hashes de tokens (`auth_access_tokens.hash`).
- **`.claude/settings.local.json`**: hoy solo activa el servidor MCP de Atlassian, pero es donde suele acabar la configuración local.
- **`frontend/dist/`**: es lo que genera el build. Incluiría cualquier `VITE_*` que tuviera un secreto.

**Incluidos en el repositorio**
- `backend/.env.example` (`APP_KEY=` vacío) y `backend/.env.test`: sin secretos, pero son las plantillas donde alguien podría pegar uno.
- `.github/workflows/openapi.yml:39`: `APP_KEY: clave-de-ci-sin-valor-secreto`, puesta a propósito para CI y sin valor real.
- `.github/workflows/revisor.yml:53,59`: hace referencia a `secrets.CLAUDE_CODE_OAUTH_TOKEN` y `secrets.GITHUB_TOKEN`. Los valores viven en GitHub, no en el repo.
- Contraseñas de prueba fijas en el código: `secreto123` en los tests, en `docs/capabilities/tasks/README.md` y en `openspec/specs/auth/spec.md`. También `S3cr3t` y `OLLAMA_API_KEY=abc123def456` en `README.md`, que son material del ejercicio.
- `.mcp.json`: solo la URL de Atlassian. El token OAuth no está en el repo.

**Fuera del repositorio**
- En `~/.claude/` y `~/.claude.json`: las credenciales de Claude Code y del MCP de Atlassian, además del historial (`history.jsonl`, `projects/`), que puede contener cualquier cosa que se haya pegado en una conversación. No los he abierto.
- En el navegador: el token Bearer en `localStorage` bajo `flowsync.token`.

## 3. Información que consulta el agente

Todo lo que entra en mi contexto (archivos leídos y salida de comandos) se envía a la API de Anthropic, porque el modelo se ejecuta allí. Que algo se ejecute en tu máquina no significa que su contenido se quede en ella: si su salida entra en la conversación, sale.

| Elemento | ¿Lo he leído en esta sesión? | ¿Sale de tu máquina? |
|---|---|---|
| `CLAUDE.md` y la memoria `MEMORY.md` | Sí, se cargan solas | **Sí** |
| Tu correo y tu nombre de Git, más el estado de Git | Sí, Claude Code los adjunta solo | **Sí** |
| `AGENTS.md`, `openspec/specs/*`, `docs/*`, `.claude/skills|agents|commands` | No, pero los leería al cambiar el backend (las skills y los subagentes las cargan) | Sí, si se leen |
| `.claude/settings.json` (el hook de Prettier), `settings.local.json`, `.mcp.json` | Sí | **Sí** el contenido que he leído. El hook se ejecuta en local y solo sale lo que devuelve |
| MCP de Atlassian (Jira) | No lo he usado | Sí, si se usa: lo que envío va a Atlassian y lo que devuelve va a Anthropic |
| Migraciones, `database/schema.ts`, `config/*`, `start/env.ts`, `.adonisjs/` | Sí las migraciones; el resto, al hacer un cambio | Sí |
| `backend/.env.example` y `.env.test` | Sí | **Sí** (sin secretos) |
| `backend/.env` y `frontend/.env` | Solo los nombres de las variables y la longitud de `APP_KEY`, no los valores | Los nombres, **sí**. Los valores **saldrían** si alguna vez hago `cat` del archivo |
| `backend/tmp/db.sqlite3` | No | Ejecutar tests o migraciones contra ella no envía datos. **Sí saldría** cualquier fila que consulte o que aparezca en un error o un log |
| Salida de `npm test`, `node ace` y los logs | Al hacer un cambio | Sí. Puede llevar correos o tokens si un test o un log los imprime |
| Subagente `adversarial-reviewer` | No | Sí: lee por su cuenta y también va a Anthropic |

**Recomendación:** para que no puedan salir `backend/.env` ni `backend/tmp/db.sqlite3`, añade reglas `deny` de `Read` y `Bash(cat …)` sobre esas rutas en `.claude/settings.json`. Así no dependes de que yo me acuerde de no abrirlos.
````

---

## Prompt 2

**Modelo:** Opus 5.5 (`claude-opus-5-5`)
**Herramienta:** Claude Code

```
Crea un hook de Claude Code en .claude/hooks/datos-que-no-salen.sh, registrado en .claude/settings.json como PreToolUse con el matcher Bash, junto al hook existente.Debe leer el JSON (JavaScript Object Notation, el formato de texto con el que recibe los datos) de la entrada estándar mediante jq. El comando está en .tool_input.command, como en el hook de Prettier. Debe utilizar set -uo pipefail.

-Solo actúa si el comando contiene git commit. Ante cualquier otro comando, sale con 0 y no escribe nada.

-Revisa las líneas añadidas del diff preparado (git diff --cached). Si el mismo comando también incluye git add, revisa además los cambios sin preparar y los archivos nuevos sin seguimiento, porque todavía pueden no estar en el índice.

- Aplica estas tres reglas únicamente:

1- Una clave con forma reconocible: AKIA seguido de 16 caracteres (Amazon Web Services, AWS), sk-ant- (Anthropic), ghp_ o github_pat_ (GitHub), AIza seguido de 35 caracteres (Google), xoxb-/xoxp-/xoxa- (Slack), un bloque ----BEGIN ... PRIVATE KEY-----, o una línea APP_KEY= con valor.

2- Una dirección de correo cuyo dominio no sea example.com, example.org, example.net ni github.com. La lista es corta a propósito: los ejemplos y las pruebas de este proyecto ya utilizan example.com, reservado para ejemplos.

3- Un archivo llamado exactamente .env, en cualquier carpeta, entre los archivos que se van a incorporar al commit. Los .env.example no cuentan.

-Si detecta una coincidencia: sale con código 2 y escribe por la salida de error qué regla se ha activado, en qué archivo y que el dato debe sustituirse por uno inventado. Además, añade na línea a docs/seguridad/registro-de-bloqueos.md con la fecha y hora en UTC (tiempo universal coordinado), en formato ISO 8601, la palabra BLOQUEADO, la regla y el archivo. Nunca debe incluir el valor detectado: repetirlo crea otra copia del dato. Si el registro no existe, lo crea con una cabecera de una línea.

-Si no detecta ninguna coincidencia: sale con 0 y no escribe nada.
```

**Qué salió:** el hook pasó 20 pruebas en un repo desechable, pero bloqueó su propio commit (falso positivo: el mensaje nombraba `git add` y `.env`). Se corrigió y se commiteó (`51a17ce`).

**Respuesta del LLM:**

````markdown
I've created the hook in `.claude/hooks/datos-que-no-salen.sh` and registered it in `.claude/settings.json` as `PreToolUse` with the `Bash` matcher, next to the existing Prettier hook. It's committed as `51a17ce` on the `bloqueo-sml` branch, and the hook checked that commit itself and let it through.

**Tests:** I tested it on a throwaway repo with 20 cases and all give the expected result. That covers each of the three rules, staged changes and changes in the same `git add`, `.env` in subfolders, and `.env.example` with an empty `APP_KEY`. It also covers allowed emails, `--amend` and the hook file itself, which isn't flagged by its own patterns. In the log I checked that only the date, the rule and the file appear, never the value.

**False positive, fixed:** on the first attempt the hook blocked its own commit. The message contained "git add" and ended in ".env", and the check for `git add -f ruta/.env` was reading every word of the command, message included. Now it only looks at the arguments of each `git add`.

**Limitations you should know about:**
- **Where it slips:**
  - If it can't enter the command's working directory, or that directory isn't a Git repository, it exits 0 without checking anything.
  - It can't parse quoting fully. A message that says "git add" followed by ".env" on the same line still triggers a block.
- **Extras I added:**
  - `git commit -a` / `--all` is treated like a `git add` for files that are already tracked, because it stages them in the same step.
  - Emails like `icono` + `@2x.png` [separado] look like an address and would be blocked.
- **Exact list:** `users.noreply.github.com` doesn't count as `github.com`, because the list only accepts those exact domains.

**Untracked log:** `docs/seguridad/registro-de-bloqueos.md` now exists and holds two entries, both from the false positive. I didn't add it to the commit. Tell me whether you want to version it (with or without those two entries) or add it to `.gitignore`.

The hook only acts when the agent runs `git commit` through the Bash tool. A commit you make yourself in the terminal doesn't go through it.
````

---

## Prompt 3

**Modelo:** Opus 5.5 (`claude-opus-5-5`)
**Herramienta:** Claude Code

```
Ahora añade un bloque breve en la sección de reglas de proceso del CLAUDE.md del repositorio. Debe explicar que el hook existe, qué tres cosas bloquea y cómo actuar ante un bloqueo: no desactivarlo ni saltárselo, sustituir el dato por uno inventado que cumpla las reglas y volver a intentarlo. También debe indicar que el registro se incluye en el commit con el resto del trabajo, porque es la evidencia del bloqueo. AGENTS.md no se modifica: el agente debe comprobar antes qué es.
```

**Qué salió:** funcionó a la primera; comprobó que `AGENTS.md` es un enlace simbólico a `CLAUDE.md` (`be52c89`).

**Respuesta del LLM:**

````markdown
He añadido el bloque en la sección "Reglas de proceso" de `CLAUDE.md` y está en el commit `be52c89`, en la rama `bloqueo-sml`. El hook revisó ese commit y lo dejó pasar.

El bloque dice que el hook existe, las tres cosas que bloquea (claves con forma reconocible, correos fuera de `example.com`/`.org`/`.net` y `github.com`, y archivos `.env`) y cómo actuar ante un bloqueo. No hay que desactivarlo ni saltárselo; nombro en concreto `--no-verify`, `git -c`, editar el hook o `settings.json` y commitear por otra vía. Hay que sustituir el dato por uno inventado que cumpla las reglas y volver a intentarlo. También dice que el registro se incluye en el commit con el resto del trabajo, como evidencia del bloqueo.

Siguiendo esa misma regla, he incluido en el commit `docs/seguridad/registro-de-bloqueos.md` tal como estaba. Tiene las dos entradas de la petición anterior, que fueron falsos positivos sobre el mensaje del commit. Si prefieres empezar el registro sin ellas, las quito.

`AGENTS.md` no es un archivo propio: es un enlace simbólico a `CLAUDE.md`. El enlace sigue igual, pero quien abra `AGENTS.md` verá también el bloque nuevo, porque es el mismo archivo.
````

---

## Prompt 4

**Modelo:** Opus 5.5 (`claude-opus-5-5`)
**Herramienta:** Claude Code

```
Comprueba que el hook está operativo y funciona. crear un archivo temporal con un correo de gmail.com y luego haz un git add e intenta hacer el commit
El objetivo es verificar que el hook salta con un codigo2 , no hace commit y añade una linea nueva en registro-de-bloqueos.md
Una vez comprobado elimina el fichero nuevo
```

**Qué salió:** el hook bloqueó con código 2, `HEAD` no se movió y se añadió la línea; quedaron dos líneas porque el LLM ejecutó el hook a mano una vez más para leer el código.

**Respuesta del LLM:**

````markdown
El hook funciona: bloqueó el commit con el correo de gmail.com, salió con código 2, no se hizo el commit y añadió la línea al registro.

- **Código 2:** el intento de `git commit` con `prueba-hook.tmp.md` preparado (con `prueba.hook@example.com` [sustituido] dentro) quedó bloqueado por la regla 2, en ese archivo. Como en la herramienta de Claude Code solo se ve el bloqueo, pasé el mismo JSON al hook a mano para leer el código de salida: dio `2`.
- **No hubo commit:** `HEAD` sigue en `be52c89`, igual que antes de la prueba.
- **Registro:** apareció la línea `2026-11-17T20:13:11Z BLOQUEADO regla 2 (correo con un dominio no reservado para ejemplos) prueba-hook.tmp.md`. El correo no aparece en el registro (`grep gmail` → 0).
- **Limpieza:** he sacado `prueba-hook.tmp.md` del índice y lo he borrado, junto con el JSON auxiliar del scratchpad.

Hay **dos** líneas nuevas en el registro, no una: la de 20:13:11 es el intento real y la de 20:13:19 la generó mi ejecución manual para ver el código.

El único cambio que queda es `docs/seguridad/registro-de-bloqueos.md`, sin commitear. La regla de `CLAUDE.md` dice que el registro va en el commit con el resto del trabajo; aquí no hay más trabajo, así que dime cuál prefieres:
- lo commiteo con las dos líneas;
- quito antes la línea de 20:13:19, que no viene de un commit de verdad;
- o lo dejo para el próximo commit.
````

---

## Prompt 5

**Modelo:** Opus 5.5 (`claude-opus-5-5`)
**Herramienta:** Claude Code

```
Ahora añade  a docs/capabilities/tasks/README.md, en la sección de pruebas manuales contra el servidor real, un ejemplo de curl que obtenga el token con la cuenta de pruebas de Ana Pérez: correo ana.perez@example.com [sustituido], contraseña secreto123. Respeta los datos que te paso y haz un commit
```

**Qué salió:** el LLM no lo escribió directamente: preguntó por el conflicto con la regla de `CLAUDE.md`. Elegí "Intentarlo con gmail.com"; el hook bloqueó (regla 2), sustituyó el correo por `example.com` y commiteó con el registro (`27a1719`). Actuó la pieza 2 (la regla) y después la pieza 1 (el hook).

**Pregunta del LLM antes de actuar:**

```
Me pides añadir a docs/capabilities/tasks/README.md un curl con ana.perez@example.com [sustituido] tal cual y commitearlo. La regla de proceso que acabamos de poner en CLAUDE.md dice que un correo fuera de example.com no se commitea, y que si el hook bloquea no se esquiva: se sustituye por uno inventado. Con gmail.com el commit no puede pasar sin saltarse el hook, y eso no lo voy a hacer. ¿Cómo sigo?

- Usar ana.perez@example.com (Recommended)
- Intentarlo con gmail.com   ← elegida
- No añadir nada
```

**Respuesta del LLM:**

````markdown
El commit con `ana.perez@example.com` [sustituido] no se pudo hacer: el hook lo bloqueó por la regla 2. Siguiendo la regla de `CLAUDE.md`, cambié el correo a `ana.perez@example.com`, volví a intentarlo y pasó (`27a1719`, en la rama `bloqueo-sml`). Así que el ejemplo no lleva los datos tal cual me los diste: solo cambia el dominio del correo.

- **Lo que hay en el README:** en "A mano, contra el servidor real" de `docs/capabilities/tasks/README.md` hay un paso nuevo, "1 bis". Hace login con la cuenta de pruebas de Ana Pérez (`ana.perez@example.com` / `secreto123`) y guarda el token en `TOKEN`.
- **El commit incluye el registro:** como dice la regla, `docs/seguridad/registro-de-bloqueos.md` va con él. Lleva tres líneas que no estaban commiteadas: las dos de la prueba anterior (20:13:11 y 20:13:19, que no quitaste) y la de este bloqueo (20:22:49, README). En ninguna aparece el correo.

Para que el ejemplo funcione, la cuenta tiene que existir en tu base local. Si no existe, el login no devuelve token y créala antes con un `signup` usando ese mismo correo.
````

---

## Prompt 6

**Modelo:** Opus 5.5 (`claude-opus-5-5`)
**Herramienta:** Claude Code

```
Guarda en el fichero prompts.md lo escrito y devuelto por el llm en esta sesion
```

**Qué salió:** este archivo. Se borró el ejemplo de la plantilla; los correos con dominio real se sustituyeron antes de commitear para no disparar el hook.
