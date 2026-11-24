# Hallazgos

Aquí van **las tres líneas** del ejercicio, una por cada punto de abajo. Es lo único que hay que
traer hecho: un cambio de motor a medias con estas tres líneas escritas vale más que lo contrario,
porque lo que se discute en el directo es dónde te chocaste.

Escribe **una sola línea por punto**, con tus palabras y con lo que mediste, no con lo que suponías.

## 1. Las filas que cambian y la rama

Cuántas filas cambian de valor en tu cambio de esquema, medido con una consulta, y en qué rama del
árbol de reversibilidad cae. Si tu migración no toca datos, dilo tal cual: también es una respuesta.

- Medí PostgreSQL (`users`, `tasks` y `auth_access_tokens` a 0 filas y `n_tup_upd` a 0; el único update es 1 fila de `adonis_schema_versions`, que queda en `version` 2) y el SQLite de `backend/tmp/db.sqlite3` (mtime 2026-11-09, 1 usuario, 1 token, 0 tareas): la migración no cambia ni copia ningún dato existente y cae en la rama de [nombre/rama del árbol de reversibilidad].

## 2. Lo que la batería de pruebas no podía ver

Una cosa que la batería de pruebas no podía ver. Si no encontraste ninguna, escribe qué buscaste y dónde.

- Busqué `isOverdue`, `dueDate` y `due_date` en `backend/tests` y no hay ninguna prueba; al releer desde PostgreSQL una tarea con `due_date` 2020-01-15 el valor llega como `Date` y `isOverdueOn('2026-11-24')` devuelve false.

## 3. Tu duda

De qué dudaste, o qué no pudiste comprobar.

- No comprobé el mismo caso con un huso distinto de UTC: el proceso cargó `TZ=UTC` y el `Date` salió como `2020-01-15T00:00:00.000Z`, así que no vi si el día se desplaza, porque la comparación con el texto ya daba false.
