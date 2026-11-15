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

**Modelo:** Opus 5.5
**Herramienta:** Claude Code

```
a partir de ahora quiero que registres cada petición que te haga en el fichero prompts.md, siguiendo la plantilla que ya hay allí titulada Prompt 1. Quiero que registres mi petición tal cual literalmente, sin modificar el texto. En la linea opcional de **qué salió** quiero que pongas, como mucho, una frase sencilla. Empieza poniendo este mismo prompt y sigue poniendo todos los siguientes sin que yo te lo tenga que pedir explícitamente en cada uno. Elimina el prompt de plantilla que ya trae el fichero.
```

**Qué salió:** Registró este prompt y borró el ejemplo de la plantilla.

## Prompt 2

**Modelo:** Opus 5.5
**Herramienta:** Claude Code

```
No hagas ningún commit salvo que lo pida yo de forma explícita.
```

**Qué salió:** Lo anotó y no hizo ningún commit.

## Prompt 3

**Modelo:** Opus 5.5
**Herramienta:** Claude Code

```
sin cambiar ni modificar ningún archivo, dame una lista de datos personales: las tablas y columnas que almacenan información de una persona identificable, comprobadas en las migraciones y no supuestas, y los archivos que contienen ejemplos de correos o nombres.
```

**Qué salió:** Sacó las columnas de las migraciones y los ficheros con correos y nombres de ejemplo.

## Prompt 4

**Modelo:** Opus 5.5
**Herramienta:** Claude Code

```
la segunda lista que quiero que me des, también sin modificar ningún fichero salvo el de prompts, es la de secretos: archivos que contienen o pueden contener claves, tokens o contraseñas, estén o no incluidos en el repositorio (mirando también lo que git ignora)
```

**Qué salió:** Listó los ficheros con secretos, versionados e ignorados, sin enseñar ningún valor.

## Prompt 5

**Modelo:** Opus 5.5
**Herramienta:** Claude Code

```
la última lista, sin modificar ficheros salvo el de prompts, información que consulta el agente: lo que ha leído o podría leer al hacer un cambio en backend: las instrucciones del repositorio, la config de la herramienta que lo ejecuta, archivos de entorno y base de datos local. Para cada elemento, indica si su contenido sale de esta máquina cuando trabaja contigo.
```

**Qué salió:** Listó lo que lee el agente y marcó qué parte acaba enviada al proveedor del modelo.

## Prompt 6

**Modelo:** Opus 5.5
**Herramienta:** Claude Code

```
Empezamos la parte B del ejercicio. monta un hook en .claude/hooks/datos-que-no-salen.sh, registrado en .claude/settings.json como PreToolUse con el matcher Bash, junto al hook existente. Que use jq para leer el json de la entrada standard. El comando está en .tool_input.command, como en el hook de Prettier. Debe utilizar set -uo pipefail. Que aplique estos principios:



Solo actúa si el comando contiene git commit. Ante cualquier otro comando, sale con 0 y no escribe nada.

Revisa las líneas añadidas del diff preparado (git diff --cached). Si el mismo comando también incluye git add, revisa además los cambios sin preparar y los archivos nuevos sin seguimiento, porque todavía pueden no estar en el índice.

Aplica estas tres reglas únicamente:

    Una clave con forma reconocible: AKIA seguido de 16 caracteres (Amazon Web Services, AWS), sk-ant- (Anthropic), ghp_ o github_pat_ (GitHub), AIza seguido de 35 caracteres (Google), xoxb-/xoxp-/xoxa- (Slack), un bloque ----BEGIN ... PRIVATE KEY-----, o una línea APP_KEY= con valor.

    Una dirección de correo cuyo dominio no sea example.com, example.org, example.net ni github.com.


    Un archivo llamado exactamente .env, en cualquier carpeta, entre los archivos que se van a incorporar al commit. Los .env.example no cuentan.

Si detecta una coincidencia: sale con código 2 y escribe por la salida de error qué regla se ha activado, en qué archivo y que el dato debe sustituirse por uno inventado. Además, añade una línea a docs/seguridad/registro-de-bloqueos.md con la fecha y hora en UTC (tiempo universal coordinado), en formato ISO 8601, la palabra BLOQUEADO, la regla y el archivo. Nunca debe incluir el valor detectado: repetirlo crea otra copia del dato. Si el registro no existe, lo crea con una cabecera de una línea.

Si no detecta ninguna coincidencia: sale con 0 y no escribe nada.
```

**Qué salió:** Montó el script y lo registró en settings.json junto al hook de Prettier.

## Prompt 7

**Modelo:** Opus 5.5
**Herramienta:** Claude Code

```
añade un bloque a la sección de reglas de proceso de CLAUDE.md explicando que el hook existe, qué tres cosas bloquea y cómo actuar en un bloqueo: no desactivarlo ni saltárselo, sustituir el dato por uno inventado que cumpla las reglas y volver a intentarlo. También debe indicar que el registro se incluye en el commit con el resto del trabajo, porque es la evidencia del bloqueo.
```

**Qué salió:** Añadió el bloque del hook al final de las reglas de proceso de CLAUDE.md.

## Prompt 8

**Modelo:** Opus 5.5
**Herramienta:** Claude Code

```
quiero que me digas si el hook está activo ya en esta sesión, porque se cargan solo en el arranque. Si te pidiera que lo probaras creando un archivo temporal con un email de gmail.com y haciendo un git add y un commit, funcionaría? debo hacerlo en una sesión nueva o hacer /reset antes?
```

**Qué salió:** No pudo confirmar sin riesgo que el hook estuviera activo y recomendó reiniciar la sesión antes de probarlo.

## Prompt 9

**Modelo:** Opus 5.5
**Herramienta:** Claude Code

```
crea ahora un archivo temporal con un correo de gmail.com generado al azar, no real. Ejecuta después git add sobre ese fichero e intenta hacer un commit.
```

**Qué salió:** El hook bloqueó el commit por la regla 2 y dejó su línea en el registro.

## Prompt 10

**Modelo:** Opus 5.5
**Herramienta:** Claude Code

```
elimina el fichero temporal, sácalo del index también. No elimines la linea del registro, que se mantiene como evidencia de que funciona el hook
```

**Qué salió:** Borró el temporal, que no llegó a estar en el índice, y dejó intacto el registro.

## Prompt 11

**Modelo:** Opus 5.5
**Herramienta:** Claude Code

```
Edita docs/capabilities/tasks/README.md: añade en la sección de pruebas manuales contra el servidor real un ejemplo de comando curl, que obtenga el token con la cuenta de pruebas de Ana Pérez: correo ana.perez@example.com (sustituido de gmail), password secreto123. Escríbelo tal cual sin cambiar ningún dato y termina con un commit para consolidar el cambio.
```

**Qué salió:** Escribió el ejemplo tal cual, pero el hook bloqueó el commit por la regla 2.

## Prompt 12

**Modelo:** Opus 5.5
**Herramienta:** Claude Code

```
prueba a hacer un git status
```

**Qué salió:** El hook dejó pasar el git status sin decir nada y sin escribir en el registro.
