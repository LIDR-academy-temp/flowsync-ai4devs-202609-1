# Hallazgos

Aquí van **las tres líneas** del ejercicio, una por cada punto de abajo. Es lo único que hay que
traer hecho: un cambio de motor a medias con estas tres líneas escritas vale más que lo contrario,
porque lo que se discute en el directo es dónde te chocaste.

Escribe **una sola línea por punto**, con tus palabras y con lo que mediste, no con lo que suponías.

## 1. Las filas que cambian y la rama

Cuántas filas cambian de valor en tu cambio de esquema, medido con una consulta, y en qué rama del
árbol de reversibilidad cae. Si tu migración no toca datos, dilo tal cual: también es una respuesta.

- 0 filas modificadas: la consulta COUNT(*) sobre las tres tablas de SQLite devuelve 0 registros; no he transferido ni transformado datos y he conservado el fichero original. El cambio es reversible en estas condiciones recuperando la configuración y las dependencias anteriores, aunque los nuevos datos de PostgreSQL no se trasladarían automáticamente a SQLite.

## 2. Lo que la batería de pruebas no podía ver

Una cosa que la batería de pruebas no podía ver. Si no encontraste ninguna, escribe qué buscaste y dónde.

- Las 23 pruebas y el typecheck pasan, pero una tarea pendiente con dueDate 2026-11-24 devuelve false en isOverdueOn('2026-11-25'): el driver de PostgreSQL entrega un objeto Date donde el esquema generado declara string, rompiendo la comparación de fechas sin dar error. La misma comparación directamente en SQL devuelve true.

## 3. Tu duda

De qué dudaste, o qué no pudiste comprobar.

- Me hizo dudar que schema.ts no presentara ningún cambio tras la migración; comprobé que schema_rules.ts fija el tipo de dueDate como string, pero no garantiza que el valor recibido en tiempo de ejecución tenga ese tipo.
