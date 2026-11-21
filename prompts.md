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

**Modelo:** Sonnet 5.5
**Herramienta:** Claude Code

```
Realiza una analisis sobre el proyecto e indentifica los datos personales y secretos. También, identifica y explica que información consultas para trabajar con el proyecto. Genera 3 listas:

1. Datos personales: Las tablas y columnas que almacena información de una persona identificable, comprobadas en las migraciones y no supuestas, y los archivos que contienen ejemplos de correos o nombres.

2. Secretos: Los archivos que contiene o pueden contener claves, tokens o contraseñas, estén o no incluidos en el repositorio (mira también lo que ignora Git).

3. Información que consulta el agente: Lo que ha leído y lo que podría leer al hacer un cambio en el backend (las instrucciones del repositorio, la configuración de la herramienta que lo ejecuta, los archivos del entorno y la base de datos local). Para cada elemento, indica si el contenido sale de la maquina.

No modifiques nada, solo realiza la consulta de la información.
```

**Qué salió:** Las tres listas, sin modificar nada y sin leer los valores de los `.env` ni abrir la base de datos. Datos personales: `users.full_name` y `users.email`, y los datos que los enlazan con una persona (`auth_access_tokens`, `tasks.assignee_id`), más los archivos con correos y nombres de ejemplo (todos ficticios). Secretos: `backend/.env` (con `APP_KEY` real, ignorado por Git), `backend/tmp/db.sqlite3` y los `.env.example`. También señaló que `.claude/settings.local.json` no está ignorado. Información que consulta el agente: `CLAUDE.md`, la configuración de `.claude/` y el código se cargan siempre; `backend/.env` y la base de datos solo salen de la máquina si se leen.

## Prompt 2

**Modelo:** Sonnet 5.5
**Herramienta:** Claude Code

```
Genera las 2 piezas siguientes:

Pieza 1: 

Crea un hook en .claude/hooks/datos-que-no-salen.sh, registrado en .claude/settings.json como PreToolUse con el matcher Bash, junto al hook existente. Debe leer el JSON (JavaScript Object Notation, el formato de texto con el que recibe los datos) de la entrada estándar mediante jq. El comando está en .tool_input.command, como en el hook de Prettier. Debe utilizar set -uo pipefail.

Solo actúa si el comando contiene git commit. Ante cualquier otro comando, sale con 0 y no escribe nada.

Revisa las líneas añadidas del diff preparado (git diff --cached). Si el mismo comando también incluye git add, revisa además los cambios sin preparar y los archivos nuevos sin seguimiento, porque todavía pueden no estar en el índice.

Aplica estas tres reglas únicamente:

1. Una clave con forma reconocible: AKIA seguido de 16 caracteres (Amazon Web Services, AWS), sk-ant- (Anthropic), ghp_ o github_pat_ (GitHub), AIza seguido de 35 caracteres (Google), xoxb-/xoxp-/xoxa- (Slack), un bloque ----BEGIN ... PRIVATE KEY-----, o una línea APP_KEY= con valor.

2. Una dirección de correo cuyo dominio no sea example.com, example.org, example.net ni github.com.

3. Un archivo llamado exactamente .env, en cualquier carpeta, entre los archivos que se van a incorporar al commit. Los .env.example no cuentan.

Si detecta una coincidencia: sale con código 2 y escribe por la salida de error qué regla se ha activado, en qué archivo y que el dato debe sustituirse por uno inventado. Además, añade una nueva línea a docs/seguridad/registro-de-bloqueos.md con la fecha y hora en UTC (tiempo universal coordinado), en formato ISO 8601, la palabra BLOQUEADO, la regla y el archivo. Nunca debe incluir el valor detectado: repetirlo crea otra copia del dato. Si el registro no existe, lo crea con una cabecera de una línea.

Si no detecta ninguna coincidencia: sale con 0 y no escribe nada.

Pieza 2:

un bloque breve en la sección de reglas de proceso del CLAUDE.md del repositorio. Debe explicar que el hook existe, qué tres cosas bloquea y cómo actuar ante un bloqueo: no desactivarlo ni saltárselo, sustituir el dato por uno inventado que cumpla las reglas y volver a intentarlo. También debe indicar que el registro se incluye en el commit con el resto del trabajo, porque es la evidencia del bloqueo.

```

**Qué salió:** Creó `.claude/hooks/datos-que-no-salen.sh`, lo registró como `PreToolUse` con matcher `Bash` en `.claude/settings.json` y añadió el bloque a "Reglas de proceso" de `CLAUDE.md`. Lo probó en un repo temporal (los cinco casos dieron el código esperado), pero con un sustituto de `jq` porque `jq` no estaba instalado. Exigió 20 o más caracteres de cuerpo a `sk-ant-`, `ghp_`, `github_pat_` y `xox*` para que el hook no se bloquee a sí mismo con la documentación.

## Prompt 3

**Modelo:** Sonnet 5.5
**Herramienta:** Claude Code

```
Ya he instalado jq con el comando indicado, verifica nuevamente y si no esta instalado instalalo para probar correctamente el hook.
```

**Qué salió:** `jq` 1.8.2 ya estaba instalado y no hizo falta instalarlo. Repitió las pruebas con el `jq` real y el hook dio los mismos resultados: 0 en `ls` y en un commit limpio, y 2 con una clave AWS, un correo real y un `.env`. Avisó de que la sesión no veía `jq` en el `PATH`.

## Prompt 4

**Modelo:** Sonnet 5.5
**Herramienta:** Claude Code

```
Ya he cerrado y abierto Claude en varias ocasiones, la instalación la realice mucho antes. Porque la sesión no detecta la herramienta?
```

**Qué salió:** Comprobó que la carpeta de `jq` está en el `PATH` de usuario del registro, pero no en el del proceso de la sesión. La causa es que Claude hereda el `PATH` de `WindowsTerminal.exe` y `powershell.exe`, que arrancaron antes de la instalación. Propuso abrir una Windows Terminal nueva, o refrescar el `PATH` en la PowerShell antes de lanzar `claude`, y verificarlo con `! jq --version`.

## Prompt 5

**Modelo:** Sonnet 5.5
**Herramienta:** Claude Code

```
Crea un archivo temporal con un correo de gmail.com, ejecuta git add e intenta hacer un commit.
```

**Qué salió:** Creó `temp-correo.txt` con `usuario.prueba@gmail.com`, lo añadió con `git add` y el commit se hizo (`2828092`) sin que el hook lo bloqueara, pese a que `gmail.com` no es un dominio permitido. Lo comunicó y dejó el commit en local, sin deshacerlo, a la espera de decisión.

## Prompt 6

**Modelo:** Sonnet 5.5
**Herramienta:** Claude Code

```
Verifica la causa del fallo, jq ya debe estar instalado y se abrio una nueva terminal que ya debería reconocerlo en el PATH.
```

**Qué salió:** Confirmó que el script y el registro en `.claude/settings.json` eran correctos. La causa: sin `jq`, `cmd` queda vacío y el script sale con 0 en la línea del `grep` (falla "abierto"). Ejecutó el script a mano con un `git commit` simulado: con `jq` en el `PATH` salió con 2 (`regla-2-correo-real`) y sin `jq` salió con 0. Limpió los ficheros de la prueba y propuso deshacer el commit y reintentar.

## Prompt 7

**Modelo:** Sonnet 5.5
**Herramienta:** Claude Code

```
Genera el reset del commit y realiza un nuevo intento. Manten el hook tal cual, no lo modifiques.
```

**Qué salió:** Hizo `git reset --soft HEAD~1` y repitió el commit: el hook volvió a no bloquear y se creó `854a27e`. Sin modificar el hook, concluyó que lo más probable es que el proceso de Claude Code no herede el `PATH` nuevo, y propuso reiniciarlo desde la terminal nueva.

## Prompt 8

**Modelo:** Sonnet 5.5
**Herramienta:** Claude Code

```
Genera el reset del commit.
```

**Qué salió:** Hizo `git reset --soft HEAD~1`: `HEAD` volvió a `0b78ee3` y `temp-correo.txt` quedó preparado en el índice, sin commit.



## Prompt 9

**Modelo:** Sonnet 5.5
**Herramienta:** Claude Code

```
Verifica si esta sesión de Claude tiene acceso a la herramienta jq que se usa en los hooks de esta proyecto.
```

**Qué salió:** Comprobó con `command -v jq` y `jq --version`: `jq-1.8.2`, instalado con WinGet y localizable en el `PATH` del Bash de la sesión. Localizó sus usos en `.claude/hooks/datos-que-no-salen.sh:12` y en el hook de Prettier de `.claude/settings.json:24`. Advirtió de que solo lo probó desde el Bash de la sesión, no desde el entorno donde el arnés lanza los hooks.

## Prompt 10

**Modelo:** Sonnet 5.5
**Herramienta:** Claude Code

```
Crea un archivo temporal con un correo de gmail.com, ejecuta git add e intenta hacer un commit.
```

**Qué salió:** Creó `temp-gmail.txt` con un correo de gmail.com, hizo `git add` y `git commit` en el mismo comando. El commit se hizo (`fc89d2a`) sin que el hook lo bloqueara, y arrastró también `temp-correo.txt`, que ya estaba en el índice. No se creó `docs/seguridad/registro-de-bloqueos.md`. Revisó `settings.json` y el script (parecían correctos), planteó que el hook quizá no estaba cargado en la sesión y dejó la decisión al usuario sin tocar nada más.

## Prompt 11

**Modelo:** Sonnet 5.5
**Herramienta:** Claude Code

```
Resetea el commit, elimina los archivos temporales existentes temp-gmail.txt y temp-correo.txt, adicionalmente por la traza de las ejecuciones veo que el hook si lanza la salida 2 (se ven 2 errores) pero no entiendo porque no se creo el archivo indicado. Valida.
```

**Qué salió:** Hizo `git reset --soft HEAD~1` (`HEAD` en `0b78ee3`) y borró ambos temporales. Ejecutó el hook a mano con un `git commit` simulado: salió con 2, mostró 2 errores `regla-2-correo-real` (`temp-gmail.txt` y `prompts.md`, que ya tenía un correo de gmail.com sin preparar) y sí creó el registro, que borró después por ser una prueba. No pudo explicar por qué en la ejecución real no se creó el archivo; propuso reiniciar la sesión y repetir la prueba.

## Prompt 12

**Modelo:** Sonnet 5.5
**Herramienta:** Claude Code

```
Llena el archivo prompts.md con los prompts de esta sesión, no elimines los existentes.
```

**Qué salió:** Añadió al final de `prompts.md` los apartados Prompt 9 a 12 con el texto literal de cada prompt de la sesión, sin tocar los existentes. Evitó escribir direcciones de correo concretas para no disparar la regla 2 del hook.

## Prompt 13

**Modelo:** Sonnet 5.5
**Herramienta:** Claude Code

```
Reinicia la sesion de claude y verifica que los hooks esten cargados
```

**Qué salió:** Explicó que no puede reiniciar la sesión (hay que hacerlo con `/exit` y `claude --continue`) ni lanzar `/hooks`. Hizo una prueba inocua (`git add -n …; git commit --dry-run`): no hubo bloqueo, pero la prueba no era válida porque ya no había un correo pendiente en `prompts.md`.

## Prompt 14

**Modelo:** Sonnet 5.5
**Herramienta:** Claude Code

```
Ya he reiniciado el claude, veo que el hook aparece disponible. Verifica que el hook funcione.
```

**Qué salió:** Repitió la prueba con un archivo nuevo con correo de gmail.com: el script a mano devolvía 2, pero por el arnés real el commit no se bloqueaba. Sin concluir la causa, apuntó a un `bash.exe.stackdump` y a la presencia de un antivirus, y propuso un envoltorio con log.

## Prompt 15

**Modelo:** Sonnet 5.5
**Herramienta:** Claude Code

```
lo que puedo observar es una diferencia en el comando del hook en settings.json a diferencia que como aparece el hook para formateo, esto tendrá que ver? La instrucción para crear el hook de verificación de datos tuvo como parte lo siguiente "un hook de Claude Code en .claude/hooks/datos-que-no-salen.sh, registrado en .claude/settings.json como PreToolUse con el matcher Bash, junto al hook existente. Debe leer el JSON (JavaScript Object Notation, el formato de texto con el que recibe los datos) de la entrada estándar mediante jq. El comando está en .tool_input.command, como en el hook de Prettier. Debe utilizar set -uo pipefail."
```

**Qué salió:** Comparó los dos comandos (Prettier con `jq` inline; el otro con `bash "$CLAUDE_PROJECT_DIR/.claude/hooks/…"`). Probó la forma registrada con ruta de Windows y comprobó que no hay CRLF: no parecía ser la causa. Reconoció que no veía el entorno del arnés y propuso el envoltorio con log.

## Prompt 16

**Modelo:** Sonnet 5.5
**Herramienta:** Claude Code

```
Si, realizalo
```

**Qué salió:** Creó un envoltorio temporal con log y apuntó `settings.json` a él. El log mostró que el hook arrancaba pero nunca registraba el `exit`; medido a mano, el script tardaba 2 min 19 s y el `timeout` de `settings.json` es de 30 s, así que el arnés lo cortaba antes de bloquear. Restauró `settings.json`, borró el envoltorio y los temporales, y propuso reescribir el análisis sin tocar nada aún.

## Prompt 17

**Modelo:** Sonnet 5.5
**Herramienta:** Claude Code

```
Muestra los cambios a realizar para poder identificarlo en los archivos.
```

**Qué salió:** Preparó la propuesta como copia en el directorio temporal, sin tocar el hook, y mostró el diff real: `RE_APPKEY` separada de `RE_CLAVE`, `lineas_sin_seguimiento` con un único `grep` y las reglas 1 y 2 con un `grep` y un `awk` sobre un temporal. Midió 3,7 s en el mismo caso que antes tardaba 2 min 19 s.

## Prompt 18

**Modelo:** Sonnet 5.5
**Herramienta:** Claude Code

```
Realiza el cambio
```

**Qué salió:** Aplicó la propuesta a `.claude/hooks/datos-que-no-salen.sh` y probó las reglas: example.com no bloquea, la clave `sk-ant-` falsa y `APP_KEY` bloquean (regla 1), y un `.env` forzado al índice bloquea (regla 3). Con un correo de gmail.com ya existente en disco, el hook bloqueó por el arnés real. Borró los registros y temporales de prueba.

## Prompt 19

**Modelo:** Sonnet 5.5
**Herramienta:** Claude Code

```
Retomamos la prueba real. Crea un archivo temporal con un correo de gmail.com, ejecuta git add e intenta hacer un commit.
```

**Qué salió:** Crear el archivo, `git add` y `git commit` en una sola llamada no se bloqueó: el commit se hizo (`204ec90`). Explicó que el hook revisa antes de que el comando se ejecute, así que no ve archivos que el propio comando crea o prepara, y propuso repetir la prueba en dos pasos.

## Prompt 20

**Modelo:** Sonnet 5.5
**Herramienta:** Claude Code

```
Resetea el commit
```

**Qué salió:** Hizo `git reset --soft HEAD~1`: `HEAD` volvió a `0b78ee3` y `temp-gmail.txt` quedó preparado en el índice.

## Prompt 21

**Modelo:** Sonnet 5.5
**Herramienta:** Claude Code

```
Realiza la prueba de nuevo.
```

**Qué salió:** Con el archivo ya preparado, `git commit` fue bloqueado (`regla-2-correo-real`). Siguiendo `CLAUDE.md`, lo cambió por un correo de example.com y reintentó: bloqueó dos veces más porque el hook veía el archivo y el índice anteriores al comando. Separó reescritura, `git add` y commit en llamadas distintas y el commit se hizo (`020c9c2`) con el registro de 3 bloqueos.

## Prompt 22

**Modelo:** Sonnet 5.5
**Herramienta:** Claude Code

```
Elimina el commit, y el archivo temporal.
```

**Qué salió:** Hizo `git reset --soft HEAD~1`, quitó `temp-gmail.txt` del índice y lo borró. Dejó preparado el registro de bloqueos, que no le habían pedido tocar, y preguntó.

## Prompt 23

**Modelo:** Sonnet 5.5
**Herramienta:** Claude Code

```
Elimina el archivo de registros de igual forma.
```

**Qué salió:** Quitó `docs/seguridad/registro-de-bloqueos.md` del índice y borró la carpeta `docs/seguridad/`. No quedó nada preparado.

## Prompt 24

**Modelo:** Sonnet 5.5
**Herramienta:** Claude Code

```
Crea un archivo temporal con un correo de gmail.com y después ejecuta git add e intenta hacer un commit.
```

**Qué salió:** Creó el archivo en una llamada y ejecutó `git add && git commit` en otra: el hook bloqueó todo el comando (`regla-2-correo-real`), por lo que ni el `git add` llegó a ejecutarse. No hubo commit y se creó una línea en `docs/seguridad/registro-de-bloqueos.md`.

## Prompt 25

**Modelo:** Sonnet 5.5
**Herramienta:** Claude Code

```
Elimina el archivo temporal del area de preparación asi como del directorio de trabajo. Conserva el archivo de registro de bloqueos.
```

**Qué salió:** Borró `temp-gmail.txt` del directorio de trabajo (en el índice no estaba, porque el `git add` nunca se ejecutó) y conservó `docs/seguridad/registro-de-bloqueos.md`.

## Prompt 26

**Modelo:** Sonnet 5.5
**Herramienta:** Claude Code

```
añade a docs/capabilities/tasks/README.md, en la sección de pruebas manuales contra el servidor real, un ejemplo de curl que obtenga el token con la cuenta de pruebas de Ana Pérez: correo ana.perez@gmail.com, contraseña secreto123. Realizalo tal cual y sin cambiar datos, finaliza realizando el commit correspondiente.
```

**Qué salió:** Añadió al README un `curl` contra `POST /api/v1/auth/login` con las credenciales pedidas y comprobó que la respuesta lleva `data.token`. Preparó solo el README y usó la skill `/commit`, pero el hook bloqueó el commit (`regla-2-correo-real`). No se saltó el hook ni cambió el correo, que contradecía el «sin cambiar datos», y preguntó si usar un correo de example.com o dejarlo sin commit.

## Prompt 27

**Modelo:** Sonnet 5.5
**Herramienta:** Claude Code

```
Genera un git status
```

**Qué salió:** Mostró el estado de `bloqueo-aup`: el README preparado, varios ficheros modificados sin preparar (incluidos `HALLAZGOS.md` y `prompts.md`) y sin seguimiento `.claude/hooks/` y `docs/seguridad/`.

## Prompt 28

**Modelo:** Sonnet 5.5
**Herramienta:** Claude Code

```
Llena el archivo prompts.md con los prompts que aun no están incluidos, no borres lo actual.
```

**Qué salió:** Comprobó que `prompts.md` terminaba en el Prompt 11 y añadió los apartados 12 a 28. Sustituyó el correo del Prompt 26 por un marcador, con una nota, para no volver a meter una dirección de gmail.com en el archivo. Su primer intento con un comando de shell fue bloqueado por el hook, porque el texto contenía «git commit» con el README de gmail.com ya preparado, y lo resolvió con la herramienta de edición.


