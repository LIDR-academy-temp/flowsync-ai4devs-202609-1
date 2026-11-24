# Hallazgos

Aquí van **las tres líneas** del ejercicio, una por cada punto de abajo. Es lo único que hay que
traer hecho: un cambio de motor a medias con estas tres líneas escritas vale más que lo contrario,
porque lo que se discute en el directo es dónde te chocaste.

Escribe **una sola línea por punto**, con tus palabras y con lo que mediste, no con lo que suponías.

## 1. Las filas que cambian y la rama

Cuántas filas cambian de valor en tu cambio de esquema, medido con una consulta, y en qué rama del
árbol de reversibilidad cae. Si tu migración no toca datos, dilo tal cual: también es una respuesta.

- 0 filas de negocio modificadas por la recreación del esquema: `count(*)` da 0 en `users`, `tasks` y `auth_access_tokens` tanto en SQLite (solo lectura) como en PostgreSQL tras migrar; no se trasladan datos y SQLite sigue intacta (mismo SHA-256), así que cae en la rama reversible respecto a los datos originales. Aparte, en las 3 tareas de ensayo con `due_date` cambia la representación al leer (`2026-08-10` en BD → `"2026-08-10T00:00:00.000Z"` en la API), no el valor almacenado.

## 2. Lo que la batería de pruebas no podía ver

Una cosa que la batería de pruebas no podía ver. Si no encontraste ninguna, escribe qué buscaste y dónde.

- Las 23 pruebas no cubren el vencimiento de una tarea leída de la base: T1 (vence 2026-08-10, `today=2026-08-20`) da `isOverdue=true` al guardar su fecha y `false` al recuperarla, aunque está vencida; ni `schema.ts` ni typecheck lo ven porque `schema_rules.ts` declara `dueDate` como `string`.

## 3. Tu duda

De qué dudaste, o qué no pudiste comprobar.

- Todo se verificó con `TZ=UTC`; no comprobé el comportamiento con otras zonas horarias ni con una migración de datos históricos reales.
