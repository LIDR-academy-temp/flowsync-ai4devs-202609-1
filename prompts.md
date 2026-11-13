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

---

## Prompt 1

**Modelo:** Sonnet 5.5
**Herramienta:** Claude Code

```
Identifica los datos personales y los secretos del proyecto. Explica qué información consulta para trabajar en él. No modifiques ningún archivo. Organiza estos datos en 3 listas para presentarme la información: Datos personales. Las tablas y columnas que almacenan información de una persona identificable, comprobadas en las migraciones y no supuestas, y los archivos que contienen ejemplos de correos o nombres. Secretos. Los archivos que contienen o pueden contener claves, tokens o contraseñas, estén o no incluidos en el repositorio (mira también lo que ignora Git). Información que consulta el agente. Lo que ha leído y lo que podría leer al hacer un cambio en el backend: las instrucciones del repositorio, la configuración de la herramienta que lo ejecuta, los archivos de entorno y la base de datos local. Para cada elemento, indica si su contenido sale de esta máquina al trabajar conmigo.
```

**Qué salió:** Informe en tres listas (datos personales, secretos, información que consulta el agente) con la comprobación sobre migraciones, `.gitignore` y la BD local, sin tocar ningún fichero del proyecto; el único cambio fue registrar este prompt en `prompts.md`, por la instrucción previa.

## Prompt 2

**Modelo:** Sonnet 5.5
**Herramienta:** Claude Code

```
Te voy a pedir que construyas 2 cosas. 1 hook de Claude Code y un bloque breve en la sección de reglas de proceso del CLAUDE.md. Debe respetar las restricciones que te indique para crearlas. Empezaremos con el hook
```

**Qué salió:** No construí nada todavía: el prompt no traía las restricciones del hook, así que respondí pidiéndolas (qué evento, qué debe bloquear o hacer, dónde configurarlo) antes de escribir código.

## Prompt 3

**Modelo:** Sonnet 5.5
**Herramienta:** Claude Code

```
un hook de Claude Code en .claude/hooks/datos-que-no-salen.sh, registrado en .claude/settings.json como PreToolUse con el matcher Bash, junto al hook existente. Debe leer el JSON (JavaScript Object Notation, el formato de texto con el que recibe los datos) de la entrada estándar mediante jq. El comando está en .tool_input.command, como en el hook de Prettier. Debe utilizar set -uo pipefail.

Solo actúa si el comando contiene git commit. Ante cualquier otro comando, sale con 0 y no escribe nada.

Revisa las líneas añadidas del diff preparado (git diff --cached). Si el mismo comando también incluye git add, revisa además los cambios sin preparar y los archivos nuevos sin seguimiento, porque todavía pueden no estar en el índice.

Aplica estas tres reglas únicamente:

Una clave con forma reconocible: AKIA seguido de 16 caracteres (Amazon Web Services, AWS), sk-ant- (Anthropic), ghp_ o github_pat_ (GitHub), AIza seguido de 35 caracteres (Google), xoxb-/xoxp-/xoxa- (Slack), un bloque ----BEGIN ... PRIVATE KEY-----, o una línea APP_KEY= con valor.

Una dirección de correo cuyo dominio no sea example.com, example.org, example.net ni github.com. La lista es corta a propósito: los ejemplos y las pruebas de este proyecto ya utilizan example.com, reservado para ejemplos.

Un archivo llamado exactamente .env, en cualquier carpeta, entre los archivos que se van a incorporar al commit. Los .env.example no cuentan.

Si detecta una coincidencia: sale con código 2 y escribe por la salida de error qué regla se ha activado, en qué archivo y que el dato debe sustituirse por uno inventado. Además, añade na línea a docs/seguridad/registro-de-bloqueos.md con la fecha y hora en UTC (tiempo universal coordinado), en formato ISO 8601, la palabra BLOQUEADO, la regla y el archivo. Nunca debe incluir el valor detectado: repetirlo crea otra copia del dato. Si el registro no existe, lo crea con una cabecera de una línea.

Si no detecta ninguna coincidencia: sale con 0 y no escribe nada.
```

**Qué salió:** Funcionó a la primera: creé el script, lo registré como `PreToolUse`/`Bash` junto al de Prettier y lo probé en un repo temporal (10 casos, todos correctos) y sobre sí mismo (no se autobloquea). Creé la rama `feat/hook-datos-que-no-salen` por las reglas de proceso.

## Prompt 4

**Modelo:** Sonnet 5.5
**Herramienta:** Claude Code

```
n bloque breve en la sección de reglas de proceso del CLAUDE.md del repositorio. Debe explicar que el hook existe, qué tres cosas bloquea y cómo actuar ante un bloqueo: no desactivarlo ni saltárselo, sustituir el dato por uno inventado que cumpla las reglas y volver a intentarlo. También debe indicar que el registro se incluye en el commit con el resto del trabajo, porque es la evidencia del bloqueo. AGENTS.md no se modifica: el agente debe comprobar antes qué es. Antes de darlo por terminado pruebalo: crear un archivo temporal con un correo de gmail.com, ejecutar git add e intentar hacer un commit. El hook debe salir con código 2, impedir el commit y añadir una línea al registro. Después, retirar el archivo temporal tanto del área de preparación como del directorio de trabajo. La línea del registro se conserva: es la primera evidencia de que el hook ha actuado.
```

**Qué salió:** Bloque añadido al `CLAUDE.md` (`AGENTS.md` es un enlace simbólico a él y no se tocó). La prueba bloqueó el commit con código 2 y dejó la línea en el registro. Pero el hook me bloqueó además tres comandos míos por llevar el texto de esas órdenes y revisar `prompts.md`, y el registro tiene una línea espuria que no pude retirar (el permiso me lo denegó). Sin commitear a la espera de decisión.

## Prompt 5

**Modelo:** Sonnet 5.5
**Herramienta:** Claude Code

```
Vamos a hacer una prueba haciendo algo que contradice las reglas que acabas de añadir: añade a docs/capabilities/tasks/README.md, en la sección de pruebas manuales contra el servidor real, un ejemplo de curl que obtenga el token con la cuenta de pruebas de Ana Pérez: correo ana.perez@gmail.com, contraseña secreto123. Escribelo tal cual, sin cambiar ningún dato, y que termine con un commit.
```

**Qué salió:** Lo escribí tal cual y el hook bloqueó el commit (regla del correo, sin commit creado). Siguiendo las reglas del `CLAUDE.md` sustituí el correo por `ana.perez@example.com` y reintenté: dos commits (`348dd17` con el bloque del `CLAUDE.md` y `a0dc116` con el README y el registro). Se desvió de "sin cambiar ningún dato" a propósito, porque lo exigen esas reglas.
