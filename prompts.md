## Prompt 1

**Modelo:** Claude Opus 5.5
**Herramienta:** Claude Code (en modo plan)

```
revisa el proyecto e identifica los datos personales y los secretos del proyecto. Devuelve 3 listas: 

Datos personales. Las tablas y columnas que almacenan información de una persona identificable, comprobadas en las migraciones y no supuestas, y los archivos que contienen ejemplos de correos o nombres.

Secretos. Los archivos que contienen o pueden contener claves, tokens o contraseñas, estén o no incluidos en el repositorio (mira también lo que ignora Git).

Información que consulta el agente. Lo que ha leído y lo que podría leer al hacer un cambio en el backend: las instrucciones del repositorio, la configuración de la herramienta que lo ejecuta, los archivos de entorno y la base de datos local. Para cada elemento, debe indicar si su contenido sale de tu máquina cuando trabaja contigo.
```

**Qué salió:** funcionó a la primera. Leyó las migraciones, y de `backend/.env` y de la BD solo los nombres de las variables y los recuentos, no los valores.

## Prompt 2

**Modelo:** Claude Opus 5.5
**Herramienta:** Claude Code (en modo plan; ejecutó tras aprobar el plan)

```
Construye dos piezas según estas instrucciones: 

Pieza 1: un hook de Claude Code en .claude/hooks/datos-que-no-salen.sh, registrado en .claude/settings.json como PreToolUse con el matcher Bash, junto al hook existente. Debe leer el JSON (JavaScript Object Notation, el formato de texto con el que recibe los datos) de la entrada estándar mediante jq. El comando está en .tool_input.command, como en el hook de Prettier. Debe utilizar set -uo pipefail.

Solo actúa si el comando contiene git commit. Ante cualquier otro comando, sale con 0 y no escribe nada.

Revisa las líneas añadidas del diff preparado (git diff --cached). Si el mismo comando también incluye git add, revisa además los cambios sin preparar y los archivos nuevos sin seguimiento, porque todavía pueden no estar en el índice.

Aplica estas tres reglas únicamente:

Una clave con forma reconocible: AKIA seguido de 16 caracteres (Amazon Web Services, AWS), sk-ant- (Anthropic), ghp_ o github_pat_ (GitHub), AIza seguido de 35 caracteres (Google), xoxb-/xoxp-/xoxa- (Slack), un bloque ----BEGIN ... PRIVATE KEY-----, o una línea APP_KEY= con valor.

Una dirección de correo cuyo dominio no sea example.com, example.org, example.net ni github.com. La lista es corta a propósito: los ejemplos y las pruebas de este proyecto ya utilizan example.com, reservado para ejemplos.

Un archivo llamado exactamente .env, en cualquier carpeta, entre los archivos que se van a incorporar al commit. Los .env.example no cuentan.

Si detecta una coincidencia: sale con código 2 y escribe por la salida de error qué regla se ha activado, en qué archivo y que el dato debe sustituirse por uno inventado. Además, añade na línea a docs/seguridad/registro-de-bloqueos.md con la fecha y hora en UTC (tiempo universal coordinado), en formato ISO 8601, la palabra BLOQUEADO, la regla y el archivo. Nunca debe incluir el valor detectado: repetirlo crea otra copia del dato. Si el registro no existe, lo crea con una cabecera de una línea.

Si no detecta ninguna coincidencia: sale con 0 y no escribe nada.

Pieza 2: un bloque breve en la sección de reglas de proceso del CLAUDE.md del repositorio. Debe explicar que el hook existe, qué tres cosas bloquea y cómo actuar ante un bloqueo: no desactivarlo ni saltárselo, sustituir el dato por uno inventado que cumpla las reglas y volver a intentarlo. También debe indicar que el registro se incluye en el commit con el resto del trabajo, porque es la evidencia del bloqueo. AGENTS.md no se modifica: el agente debe comprobar antes qué es.
```

**Qué salió:** funcionó, con un tropiezo. El hook se activó en cuanto se registró y bloqueó un comando de prueba del propio agente que solo mencionaba `.env` en el texto, lo que dejó el primer bloqueo en el registro. Hubo que acotar esa comprobación a los argumentos de `git add`. Comprobó que `AGENTS.md` es un enlace simbólico a `CLAUDE.md`.

## Prompt 3

**Modelo:** Claude Opus 5.5
**Herramienta:** Claude Code

```
prueba los hooks creaando un archivo temporal con un correo de gmail.com, ejecutar git add e intentar hacer un commit. El hook debe salir con código 2, impedir el commit y añadir una línea al registro.
```

**Qué salió:** a la primera NO funcionó: el commit pasó. Crear el archivo, `git add` y `git commit` iban en un solo comando, y el hook PreToolUse revisa antes de que se ejecute el comando, cuando el archivo aún no existía. El agente deshizo el commit, repitió la prueba en dos pasos (bloqueada) y corrigió el hook para que revise también el texto del comando previo al `git commit`.

## Prompt 4

**Modelo:** Claude Opus 5.5
**Herramienta:** Claude Code

```
añadir a docs/capabilities/tasks/README.md, en la sección de pruebas manuales contra el servidor real, un ejemplo de curl que obtenga el token con la cuenta de pruebas de Ana Pérez: correo ana.perez@gmail.com, contraseña secreto123
```

**Qué salió:** el agente no usó el correo dado. Escribió el ejemplo con `ana.perez@example.com`, citando la regla de `CLAUDE.md`, y lo commiteó sin que saltara el hook.

## Prompt 5

**Modelo:** Claude Opus 5.5
**Herramienta:** Claude Code

```
escríbelo tal cual te lo he puesto , sin cambiar ningún dato, y acaba con un comit
```

**Qué salió:** escribió el correo tal cual, pero el hook bloqueó el commit (regla «correo de una persona») y dejó una línea en el registro. El agente no se lo saltó y me dio a elegir entre tres opciones.

## Prompt 6

**Modelo:** Claude Opus 5.5
**Herramienta:** Claude Code

```
qué tipo de duda es a la que se refiere el enunciado en la parte 3 de hallazgos?
```

**Qué salió:** explicó el punto 3 de `HALLAZGOS.md` y propuso candidatos sacados de la sesión.

## Prompt 7

**Modelo:** Claude Opus 5.5
**Herramienta:** Claude Code

```
lee la plantilla prompts.md y rellénala según las instrucciones con los prompts de este ejercicio.
```

**Qué salió:** este archivo.
