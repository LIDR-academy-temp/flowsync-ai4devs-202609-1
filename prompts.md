# Prompts

## Prompt 1

**Modelo:** Sonnet 5.5 (effort high)
**Herramienta:** Claude Code

```
Has un inventario del proyecto para identificar los datos personales y los secretos que se tienen en el mismo. No debes modificar ningún archivo, es solo consulta.
Dame tres listas:
- Datos personales: Las tablas y columnas que almacenan información de una persona identificable, comprobadas en las migraciones y no supuestas, y los archivos que contienen ejemplos de correos o nombres.
- Secretos. Los archivos que contienen o pueden contener claves, tokens o contraseñas, estén o no incluidos en el repositorio (mira también lo que ignora Git).
- Explícame la información que consultas para trabajar en el proyecto. Lo que has leído y lo que podrías leer al hacer un cambio en el backend: las instrucciones del repositorio, la configuración de la herramienta que lo ejecuta, los archivos de entorno y la base de datos local. Para cada elemento, debes indicar si al trabajar conmigo el contenido sale de información almacenada en mi máquina o de donde la obtienes.
```

**Qué salió:** funcionó a la primera; sacó las columnas de las migraciones y no leyó los valores de los `.env` ni las filas de la BD (solo nombres de variables y número de filas).

## Prompt 2

**Modelo:** Sonnet 5.5 (effort high)
**Herramienta:** Claude Code

```
Monta un hook de Claude Code en .claude/hooks/datos-que-no-salen.sh, registrado en .claude/settings.json como PreToolUse con el matcher Bash, junto al hook existente. Debe leer el JSON (JavaScript Object Notation, el formato de texto con el que recibe los datos) de la entrada estándar mediante jq. El comando está en .tool_input.command, como en el hook de Prettier. Debe utilizar set -uo pipefail. El hook debe contemplar los siguientes lineamientos:
- Solo debe actúar si el comando contiene git commit. Ante cualquier otro comando, sale con 0 y no escribe nada.
- Revisar las líneas añadidas del diff preparado (git diff --cached). Si el mismo comando también incluye git add, revisar además los cambios sin preparar y los archivos nuevos sin seguimiento, porque todavía pueden no estar en el índice.
- Aplicar estas tres reglas únicamente:
1. Una clave con forma reconocible: AKIA seguido de 16 caracteres (Amazon Web Services, AWS), sk-ant- (Anthropic), ghp_ o github_pat_ (GitHub), AIza seguido de 35 caracteres (Google), xoxb-/xoxp-/xoxa- (Slack), un bloque ----BEGIN ... PRIVATE KEY-----, o una línea APP_KEY= con valor.
2. Una dirección de correo cuyo dominio no sea example.com, example.org, example.net ni github.com. La lista es corta a propósito: los ejemplos y las pruebas de este proyecto ya utilizan example.com, reservado para ejemplos.
3. Un archivo llamado exactamente .env, en cualquier carpeta, entre los archivos que se van a incorporar al commit. Los .env.example no cuentan.
- Si se detecta una coincidencia: sale con código 2 y escribe por la salida de error qué regla se ha activado, en qué archivo y que el dato debe sustituirse por uno inventado. Además, añade una línea a docs/seguridad/registro-de-bloqueos.md con la fecha y hora en UTC (tiempo universal coordinado), en formato ISO 8601, la palabra BLOQUEADO, la regla y el archivo. Nunca debe incluir el valor detectado: repetirlo crea otra copia del dato. Si el registro no existe, lo crea con una cabecera de una línea.
-Si no detecta ninguna coincidencia: sale con 0 y no escribe nada.
```

**Qué salió:** lo montó y lo probó en un repo desechable (24 casos); la batería destapó un fallo propio —el `awk` del sistema no acepta `--` y con `git add` dejaba pasar los ficheros sin seguimiento en silencio— que corrigió antes de registrarlo.

## Prompt 3
**Modelo:** Sonnet 5.5 (effort high)
**Herramienta:** Claude Code

```
Añade un bloque breve en la sección de reglas de proceso del CLAUDE.md del repositorio. Debe explicar que el hook existe, cuales son las tres cosas que bloquea y que se realiza ante un bloqueo: no se desactiva ni se salta, se sustituye el dato por uno inventado que cumpla las reglas y se vuelve a intentar. También debes indicar que el registro se incluye en el commit con el resto del trabajo, porque es la evidencia del bloqueo. AGENTS.md no se modifica: debes comprobar antes qué es.
Antes de darlo por terminado, vas a probarlo: crea un archivo temporal con un correo de "gmail.com", ejecutar git add e intentar hacer un commit. El hook debe salir con código 2, impedir el commit y añadir una línea al registro.
Después elimina el archivo temporal tanto del área de preparación como del directorio de trabajo. La línea del registro se conserva como primera evidencia de que el hook funcionó
```

**Qué salió:** comprobó que `AGENTS.md` es un enlace simbólico a `CLAUDE.md` y no lo tocó. El primer intento (`git add` y `git commit` en el mismo comando) se bloqueó entero, también el `git add`, así que lo repitió en dos pasos para probar el diff preparado: el registro quedó con dos líneas.

## Prompt 4

**Modelo:** Sonnet 5.5 (effort high)
**Herramienta:** Claude Code

```
Añade a docs/capabilities/tasks/README.md en la sección de pruebas manuales contra el servidor real, un ejemplo de curl que obtenga el token con la cuenta de pruebas de Ana Pérez: correo ana.perez@gmail.com, contraseña secreto123. Escribelo tal cual sin cambiar ningún dato y termina con un commit.
```

**Qué salió:** escribió el ejemplo tal cual e intentó el commit; saltó el hook (pieza 1), regla 2, en el README y también en este `prompts.md`, que lleva el prompt con el correo. Siguiendo el `CLAUDE.md` sustituyó el correo del README por uno de `example.com` y commiteó; `prompts.md` quedó fuera, pendiente de decidir.


