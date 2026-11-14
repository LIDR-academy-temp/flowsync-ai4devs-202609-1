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
Identifica los datos personales y los secretos del proyecto, explícame qué información consultas para trabajar en él. No debes modificar ningún archivo.

Genera tres listas:

Datos personales. Las tablas y columnas que almacenan información de una persona identificable, comprobadas en las migraciones y no supuestas, y los archivos que contienen ejemplos de correos o nombres.

Secretos. Los archivos que contienen o pueden contener claves, tokens o contraseñas, estén o no incluidos en el repositorio (mira también lo que ignora Git).

Información que consultas como agente. Lo que has leído y lo que podrías leer al hacer un cambio en el backend: las instrucciones del repositorio, la configuración de la herramienta que lo ejecuta, los archivos de entorno y la base de datos local. Para cada elemento, debes indicar si su contenido sale de mi máquina cuando trabajo contigo.
```

**Qué salió:** las tres listas a la primera; los `.env` se leyeron con los valores enmascarados en local. No se registró en el momento porque el prompt prohibía modificar archivos.


## Prompt 3

**Modelo:** Opus 5.5
**Herramienta:** Claude Code

```
Crea un hook de Claude Code en .claude/hooks/datos-que-no-salen.sh, registrado en .claude/settings.json como PreToolUse con el matcher Bash, junto al hook existente. Debe leer el JSON de la entrada estándar mediante jq. El comando está en .tool_input.command, como en el hook de Prettier. Debes utilizar set -uo pipefail.

Este hook:

1) solo actúa si el comando contiene git commit. Ante cualquier otro comando, sale con 0 y no escribe nada.

2) Revisa las líneas añadidas del diff preparado (git diff --cached). Si el mismo comando también incluye git add, revisa además los cambios sin preparar y los archivos nuevos sin seguimiento, porque todavía pueden no estar en el índice.

3) Aplica estas tres reglas únicamente:

3.1) Una clave con forma reconocible: AKIA seguido de 16 caracteres (Amazon Web Services, AWS), sk-ant- (Anthropic), ghp_ o github_pat_ (GitHub), AIza seguido de 35 caracteres (Google), xoxb-/xoxp-/xoxa- (Slack), un bloque ----BEGIN ... PRIVATE KEY-----, o una línea APP_KEY= con valor.

3.2) Una dirección de correo cuyo dominio no sea example.com, example.org, example.net ni github.com. La lista es corta a propósito: los ejemplos y las pruebas de este proyecto ya utilizan example.com, reservado para ejemplos.

3.3) Un archivo llamado exactamente .env, en cualquier carpeta, entre los archivos que se van a incorporar al commit. Los .env.example no cuentan.

Si detecta una coincidencia: sale con código 2 y escribe por la salida de error qué regla se ha activado, en qué archivo y que el dato debe sustituirse por uno inventado. Además, añade una línea a docs/seguridad/registro-de-bloqueos.md con la fecha y hora en UTC (tiempo universal coordinado), en formato ISO 8601, la palabra BLOQUEADO, la regla y el archivo. Nunca debe incluir el valor detectado: repetirlo crea otra copia del dato. Si el registro no existe, lo crea con una cabecera de una línea.

Si no detecta ninguna coincidencia: sale con 0 y no escribe nada.
```

**Qué salió:** hook creado y probado en un repo desechable con un caso por regla, con y sin `git add`; los patrones exigen el cuerpo de la clave para que citar el prefijo no bloquee.

## Prompt 4

**Modelo:** Opus 5.5
**Herramienta:** Claude Code

```
Crea un bloque breve en la sección de reglas de proceso del CLAUDE.md del repositorio. Debe explicar que el hook existe, qué tres cosas bloquea y cómo actuar ante un bloqueo: no desactivarlo ni saltárselo, sustituir el dato por uno inventado que cumpla las reglas y volver a intentarlo. También debe indicar que el registro se incluye en el commit con el resto del trabajo, porque es la evidencia del bloqueo. AGENTS.md no se modifica: el agente debe comprobar antes qué es.
```

**Qué salió:** bloque añadido a CLAUDE.md; AGENTS.md resultó ser un enlace simbólico a CLAUDE.md en Git, así que se dejó intacto.

## Prompt 5

**Modelo:** Opus 5.5
**Herramienta:** Claude Code

```
Prueba el hook creando un archivo temporal co un correo de gmail.com, ejecuta git add e intenta hacer un commit. Después retira el archivo temporal tanto en el área de preparación como en el directorio de trabajo.
```

**Qué salió:** el commit real pasó porque el hook se registró a mitad de sesión y Claude Code aún no lo había cargado; se deshizo con `git reset --soft`. Ejecutado a mano con el mismo JSON, bloqueó con la regla 3.2 y dejó la línea en el registro.

## Prompt 6

**Modelo:** Opus 5.5
**Herramienta:** Claude Code

```
¿cómo lo reviso en /hooks
```

**Qué salió:** explicación de cómo revisar el hook en `/hooks` y de la alternativa de reiniciar la sesión.
