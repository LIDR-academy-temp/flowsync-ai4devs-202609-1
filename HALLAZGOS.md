# Hallazgos

Aquí van **las tres líneas** del ejercicio, una por cada punto de abajo. Es lo único que hay que
traer hecho: un cambio de motor a medias con estas tres líneas escritas vale más que lo contrario,
porque lo que se discute en el directo es dónde te chocaste.

Escribe **una sola línea por punto**, con tus palabras y con lo que mediste, no con lo que suponías.

## 1. Las filas que cambian y la rama

Cuántas filas cambian de valor en tu cambio de esquema, medido con una consulta, y en qué rama del
árbol de reversibilidad cae. Si tu migración no toca datos, dilo tal cual: también es una respuesta.

- 0 filas cambian de valor (`SELECT count(*)` tras recrear el esquema en Postgres vacío; no hubo UPDATE ni ALTER que reescriba datos): cae en la rama de cambio de motor sin migración de datos, reversible apuntando otra vez al motor anterior.

## 2. Lo que la batería de pruebas no podía ver

Una cosa que la batería de pruebas no podía ver. Si no encontraste ninguna, escribe qué buscaste y dónde.

- Con Postgres, `dueDate` llega como `Date` (no `string`): `isOverdueOn` de una tarea con `due_date=2020-01-01` frente a `2026-11-24` devolvió `false`; la suite no cubre vencimiento (ni un test en `tests/` menciona `isOverdue`/`dueDate`).

## 3. Tu duda

De qué dudaste, o qué no pudiste comprobar.

- Dudé de si el diff vacío de `schema.ts` era «nada cambió» o un espejismo: lo fija `schema_rules.ts` (`due_date` → `string`), así que el typecheck sigue verde mientras el runtime ya no es texto comparable.
