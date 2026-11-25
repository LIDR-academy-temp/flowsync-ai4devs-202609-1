# Hallazgos

Aquí van **las tres líneas** del ejercicio, una por cada punto de abajo. Es lo único que hay que
traer hecho: un cambio de motor a medias con estas tres líneas escritas vale más que lo contrario,
porque lo que se discute en el directo es dónde te chocaste.

Escribe **una sola línea por punto**, con tus palabras y con lo que mediste, no con lo que suponías.

## 1. Las filas que cambian y la rama

Cuántas filas cambian de valor en tu cambio de esquema, medido con una consulta, y en qué rama del
árbol de reversibilidad cae. Si tu migración no toca datos, dilo tal cual: también es una respuesta.

- 0 filas cambian de valor: no escribí ninguna migración nueva (las 4 existentes intactas, `git diff` vacío sobre `backend/database/migrations`) ni ningún UPDATE; medido con `select count(*)` en la base de desarrollo, `users`, `tasks` y `auth_access_tokens` tienen 0 filas, así que ni siquiera hay datos que pudieran cambiar. Como no hay migración que deshacer, no cae en ninguna rama del árbol de reversibilidad (el fichero del árbol no está en el repo, así que no puedo citar sus ramas); lo único que se revierte es la config, con `git revert` y `make db-down`.

## 2. Lo que la batería de pruebas no podía ver

Una cosa que la batería de pruebas no podía ver. Si no encontraste ninguna, escribe qué buscaste y dónde.

- Ninguna prueba cubre `due_date` ni `isOverdueOn` (en `backend/tests/functional/tasks/` solo está `assignee.spec.ts`), y con PostgreSQL ese caso se rompe sin ruido: el driver `pg` devuelve las columnas `date` como objeto `Date` y no como texto `AAAA-MM-DD`, así que `this.dueDate < referenceDay` compara un `Date` con un string y da `false`; medido contra `db-test` con una tarea de `2020-01-01` y día de referencia `2026-11-25`, `isOverdueOn` devuelve `false` en vez de `true`, es decir, ninguna tarea saldría nunca vencida, y el comentario de `backend/app/models/task.ts` («se compara texto contra texto») ha dejado de ser verdad. `schema.ts` sigue declarando `string` y `typecheck` sigue en verde, por eso nada lo avisa.

## 3. Tu duda

De qué dudaste, o qué no pudiste comprobar.

- Dudé de si `npm run typecheck` en silencio era verde: solo imprime la cabecera de npm y `tsc --noEmit`, sin ningún «OK», pero salió con código 0, o sea verde, y con `schema.ts` sin cambios respecto a `s10/start` (declara `dueDate: string`) tampoco podía avisar del `Date` de `pg`; no pude comprobar el `dueDate` por el endpoint HTTP (solo con el driver), ni el árbol de reversibilidad (no está en el repo), ni los datos reales de `backups/produccion-2026-10-02.dump`, que no abrí por llevar datos personales.
