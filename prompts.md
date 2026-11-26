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
