# Hallazgos

Aquí van **las tres líneas** del ejercicio, una por cada punto de abajo. Es lo único que hay que
traer hecho: un cambio de motor a medias con estas tres líneas escritas vale más que lo contrario,
porque lo que se discute en el directo es dónde te chocaste.

Escribe **una sola línea por punto**, con tus palabras y con lo que mediste, no con lo que suponías.

## 1. Las filas que cambian y la rama

Cuántas filas cambian de valor en tu cambio de esquema, medido con una consulta, y en qué rama del
árbol de reversibilidad cae. Si tu migración no toca datos, dilo tal cual: también es una respuesta.

- Mi migración no transforma datos existentes: mediante `COUNT(*)` comprobé que `users`, `tasks` y `auth_access_tokens` contienen 0 filas en ambos motores; el SQLite original se conserva intacto y no hay transformación de datos cuya reversibilidad evaluar.

## 2. Lo que la batería de pruebas no podía ver

Una cosa que la batería de pruebas no podía ver. Si no encontraste ninguna, escribe qué buscaste y dónde.

- Comprobé que una tarea pendiente con vencimiento `2026-11-24`, evaluada el `2026-11-25`, devuelve `true` en SQLite y `false` en PostgreSQL porque `dueDate` se recupera como `Date` en lugar de `string`, aunque las 23 pruebas y el `typecheck` pasan.

## 3. Tu duda

De qué dudaste, o qué no pudiste comprobar.

- No pude comprobar si la API devuelve un `isOverdue` diferente al actualizar la fecha de vencimiento y al recuperar posteriormente la misma tarea, ni cómo serializa `dueDate` en JSON.
