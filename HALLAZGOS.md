# Hallazgos

Aquí van **las tres líneas** del ejercicio, una por cada punto de abajo. Es lo único que hay que
traer hecho: un cambio de motor a medias con estas tres líneas escritas vale más que lo contrario,
porque lo que se discute en el directo es dónde te chocaste.

Escribe **una sola línea por punto**, con tus palabras y con lo que mediste, no con lo que suponías.

## 1. Las filas que cambian y la rama

Cuántas filas cambian de valor en tu cambio de esquema, medido con una consulta, y en qué rama del
árbol de reversibilidad cae. Si tu migración no toca datos, dilo tal cual: también es una respuesta.

- 0 filas: `select count(*)` sobre `users`, `auth_access_tokens` y `tasks` de `backend/tmp/db.sqlite3` da 0 en las tres, y el cambio de motor no copia datos ni toca ninguna migración, así que no hay valores guardados que cambien; la rama del árbol no la asigno porque el árbol no está en el repo y no lo he contrastado.

## 2. Lo que la batería de pruebas no podía ver

Una cosa que la batería de pruebas no podía ver. Si no encontraste ninguna, escribe qué buscaste y dónde.

- `isOverdueOn` (`backend/app/models/task.ts:52`) compara `dueDate < referenceDay` como texto, pero con PostgreSQL `due_date` llega como `Date` y la comparación con un string da siempre `false`: una tarea con `dueDate` 2026-01-01 sale `isOverdue: true` en el `PUT` (valor en memoria) y `false` en el `GET` con `today=2026-11-21` (leída de la base), y además `dueDate` pasa de `"2026-01-01"` a `"2026-01-01T00:00:00.000Z"`; ni el typecheck (la regla de `schema_rules.ts` lo declara `string`) ni los 23 tests (ninguno prueba el vencimiento) lo ven.

## 3. Tu duda

De qué dudaste, o qué no pudiste comprobar.

- Dudé de en qué rama del árbol de reversibilidad cae un cambio que no toca datos pero sí cambia cómo se leen (`date` como `Date` en vez de texto), y no pude comprobar cómo se correría el día con un `TZ` distinto de `UTC`; de paso vi que una tarea en `done` sale vencida aunque el comentario y el OpenAPI digan que no, un fallo que ya estaba con SQLite.
