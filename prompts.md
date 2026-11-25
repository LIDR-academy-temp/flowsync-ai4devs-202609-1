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

**Modelo:** Opus (claude-opus-5-5)
**Herramienta:** Claude Code 2.1.327

```
Migra FlowSync de SQLite a PostgreSQL utilizando Docker, con una base de datos para desarrollo y otra para pruebas.

Trabaja sobre la rama actual motor-rc y respeta las instrucciones de CLAUDE.md. Inspecciona la configuración existente antes de realizar los cambios.

Cumple las siguientes restricciones:

- El archivo de Docker Compose debe llamarse compose.yaml y definir dos servicios: db y db-test.
- Utiliza la imagen pgvector/pgvector:pg17.
- Utiliza el puerto 54410 para desarrollo y el puerto 54411 para pruebas.
- La base de pruebas debe funcionar en memoria, sin volumen persistente.
- Configura una comprobación de salud en ambos servicios.
- El arranque debe esperar hasta que ambas bases acepten conexiones.
- Omite la clave version: de compose.yaml.
- Configura la batería de pruebas para que se conecte a la base de pruebas mediante su propio archivo de entorno, utilizando el mecanismo existente del framework.
- Añade atajos en el Makefile para arrancar y detener las bases, ejecutar las migraciones en ambas y lanzar las pruebas.
- Conserva intactas todas las migraciones existentes. Si consideras necesario modificar alguna, detente e informa del motivo antes de hacerlo.

Mantén los mecanismos existentes de generación automática del esquema y sus reglas personalizadas. No edites manualmente database/schema.ts.

No elimines la base SQLite original ni realices operaciones destructivas sobre datos, contenedores o volúmenes sin autorización.

Limita los cambios a la migración del motor y a la configuración necesaria para cumplir el ejercicio. No incorpores nuevas funcionalidades, refactorizaciones ajenas al objetivo ni correcciones preventivas de comportamientos funcionales.

Antes de ejecutar las pruebas, comprueba que apuntan a la base de pruebas y no a la de desarrollo.

Valida los cambios realizados, ejecuta las pruebas existentes del backend y comprueba que las migraciones originales permanecen intactas respecto de upstream/s10/start.

Al finalizar, informa de los archivos modificados, las comprobaciones realizadas, los resultados obtenidos y cualquier impedimento o limitación pendiente.

No abras todavía el pull request. Mantén el trabajo en motor-rc y respeta el procedimiento de commits establecido en CLAUDE.md.

```

**Qué salió:** La migración se completó con el primer prompt. Se implementaron dos bases PostgreSQL independientes mediante Docker Compose, se adaptó el Makefile, se conservaron las cuatro migraciones originales y las 23 pruebas funcionales pasaron correctamente. Commit de implementación: 7dc740d.

## Prompt 2

**Modelo:** Opus (claude-opus-5-5)
**Herramienta:** Claude Code 2.1.327

```
Investiga empíricamente el comportamiento de las tareas vencidas de FlowSync después de migrar de SQLite a PostgreSQL.

Trabaja sobre la rama actual motor-rc. El objetivo es investigar y obtener evidencia, no corregir la implementación.

Inspecciona backend/app/models/task.ts, backend/database/schema.ts, backend/database/schema_rules.ts y las pruebas funcionales existentes relacionadas con tareas.

Realiza una comprobación controlada utilizando exclusivamente la base PostgreSQL de pruebas, flowsync_test, puerto 54411. Verifica la conexión efectiva antes de crear datos experimentales.

Utiliza como día de referencia 2026-11-25 y comprueba los siguientes casos:

- Tarea pending con vencimiento 2026-11-24.

- Tarea pending con vencimiento 2026-11-25.

- Tarea pending con vencimiento 2026-11-26.

- Tarea pending sin fecha de vencimiento.

- Tarea done con vencimiento 2026-11-24.

Para cada caso, registra:

Valor almacenado y tipo físico de la columna due_date en PostgreSQL.

Valor y tipo JavaScript recuperados mediante el driver pg.

Valor y tipo JavaScript recuperados mediante el modelo Task de Lucid.

Resultado real de Task.isOverdueOn.

Resultado esperado según el comentario del método.

Diferencias observadas.

Comprueba los tipos reales en tiempo de ejecución, sin asumir que coinciden con las declaraciones TypeScript.

Contrasta los resultados con la lógica existente en la rama original upstream/s10/start y distingue los posibles defectos preexistentes de las regresiones introducidas por el cambio de motor. Si no puedes demostrar esa diferencia empíricamente, indícalo como limitación.

Utiliza datos ficticios y operaciones aisladas, preferentemente mediante transacciones que puedan revertirse. No modifiques la base de desarrollo ni el archivo SQLite original.

No modifiques las migraciones, schema_rules.ts, schema.ts, el modelo Task ni otros archivos de implementación. No añadas correcciones funcionales, no realices commits y no abras el pull request.

Al finalizar, presenta los comandos ejecutados, los resultados reales obtenidos, una tabla comparativa de los casos y las limitaciones del experimento.

```

**Qué salió:** El agente identificó una posible incompatibilidad de tipos y un defecto preexistente. Preparó un script experimental y una copia SQLite desechable. La primera solicitud de ejecución fue detenida para revisar su seguridad.

## Prompt 3

**Modelo:** Opus (claude-opus-5-5)
**Herramienta:** Claude Code 2.1.327

```
Antes de ejecutar el experimento, muestra el contenido completo de experiment.mjs para revisar sus operaciones.

Divide el comando propuesto en bloques pequeños, independientes y verificables.

Confirma que el script comprueba la conexión efectiva a flowsync_test antes de realizar cualquier escritura, que los datos experimentales quedan aislados mediante transacciones y que no modifica la base de desarrollo ni el SQLite original.

No ejecutes todavía el experimento. Presenta primero el script y los comandos propuestos para su revisión.

```

**Qué salió:** El agente presentó el diseño del script, las comprobaciones de conexión, el aislamiento mediante transacciones y los bloques de ejecución. No ejecutó los cinco casos.

## Prompt 4

**Modelo:** Opus (claude-opus-5-5)
**Herramienta:** Claude Code 2.1.327

```
Apruebo el diseño del experimento comparativo entre PostgreSQL de pruebas y la copia SQLite desechable de upstream/s10/start.

Antes de ejecutar el experimento completo:

1. Incorpora la opción EXP_SOLO_CONEXION que has propuesto.
2. Utiliza set -o pipefail en los comandos que ejecutan Node.js mediante una tubería hacia tee.
3. Muestra el contenido completo y definitivo de experiment.mjs, sin exponer credenciales ni secretos.
4. Ejecuta el bloque 1 de comprobación del estado de partida.
5. Ejecuta únicamente la comprobación de conexión de PostgreSQL con EXP_SOLO_CONEXION=1.
6. Confirma que no se han realizado escrituras en las bases de datos durante estas comprobaciones.

Presenta los resultados obtenidos y detente antes de ejecutar los cinco casos experimentales.

Mantén todas las restricciones anteriores. No modifiques archivos de implementación, no realices commits y no abras el pull request.

```

**Qué salió:** Se verificó la conexión efectiva a flowsync_test en el puerto 54411, sin escrituras observadas. Los recuentos, contadores y la huella del SQLite original permanecieron sin cambios reportados.

## Prompt 5

**Modelo:** Opus (claude-opus-5-5)
**Herramienta:** Claude Code 2.1.327

```
Apruebo los resultados de la comprobación previa y la conexión efectiva a flowsync_test.

Procedamos con los bloques 2 a 5 del experimento comparativo.

Antes de ejecutar los casos, vuelve a mostrar el contenido completo de experiment.mjs para su revisión, sin exponer secretos. Detente si identificas alguna operación que incumpla las restricciones anteriores.

Mantén los siguientes controles:

- Verificación de la conexión efectiva antes de cualquier escritura.
- Uso exclusivo de flowsync_test para el experimento PostgreSQL.
- Uso exclusivo de la copia SQLite desechable para el experimento de referencia.
- Aislamiento de los datos experimentales mediante transacciones y rollback.
- Uso de set -o pipefail en las ejecuciones con tee.
- Verificación de los recuentos antes y después de cada experimento.
- Verificación de la huella SHA-256 del SQLite original.
- Comprobación final del estado Git.

Presenta los resultados reales de los cinco casos en una única tabla comparativa que incluya el valor almacenado, el tipo recibido por el driver, el tipo recibido por Lucid, el resultado esperado y el resultado obtenido en cada motor.

Distingue explícitamente entre defectos preexistentes, regresiones introducidas por el cambio de motor y comportamientos correctos.

Si alguna comprobación falla, detén la ejecución e informa del motivo.

No corrijas los defectos encontrados. No modifiques archivos de implementación ni las migraciones originales. No realices commits ni abras el pull request.

Al finalizar, informa las evidencias, conclusiones y limitaciones del experimento.

```

**Qué salió:** Se ejecutaron cinco casos sobre ambos motores. Se demostró una regresión en la detección de tareas vencidas y un defecto preexistente relacionado con el estado done. Las seis inserciones experimentales de cada motor fueron revertidas. No se aplicaron correcciones funcionales.
