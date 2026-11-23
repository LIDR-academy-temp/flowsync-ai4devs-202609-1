# Hallazgos

Aquí van **las tres líneas** del ejercicio, una por cada punto de abajo. Es lo único que hay que
traer hecho: un cambio de motor a medias con estas tres líneas escritas vale más que lo contrario,
porque lo que se discute en el directo es dónde te chocaste.

Escribe **una sola línea por punto**, con tus palabras y con lo que mediste, no con lo que suponías.

## 1. Las filas que cambian y la rama

Cuántas filas cambian de valor en tu cambio de esquema, medido con una consulta, y en qué rama del
árbol de reversibilidad cae. Si tu migración no toca datos, dilo tal cual: también es una respuesta.

- **0 filas.** La única migración nueva (`1795449136134_add_status_check_to_tasks_table`) añade un `CHECK (status IN ('pending','in_progress','done'))` y no reescribe datos: `select count(*) filter (where status not in (...)) from tasks` dio 0 de 15 en desarrollo. Cae en la rama **reversible sin pérdida**: `down()` es un `DROP CONSTRAINT`, comprobado con `migration:rollback` + `migration:run` en `db-test`. Las cuatro migraciones existentes no se han tocado (`git diff database/migrations` vacío), y la copia de SQLite a PostgreSQL dejó **105 de 105 valores iguales** en las 3 tablas.

## 2. Lo que la batería de pruebas no podía ver

Una cosa que la batería de pruebas no podía ver. Si no encontraste ninguna, escribe qué buscaste y dónde.

- **La fecha de vencimiento.** Con PostgreSQL la suite seguía en verde (23/23), igual que `typecheck`, y `schema.ts` salía sin diff porque `schema_rules.ts` fija `dueDate: string`. Pero el driver `pg` devuelve las columnas `date` como `Date`: la API pasó de `"2026-08-26"` a `"2026-08-26T00:00:00.000Z"` (`"2026-08-25T22:00:00.000Z"` con `TZ=Europe/Madrid`), y `isOverdueOn()` compara `Date < texto`, que da siempre `false`. La tarea 4 (vence el 26-08, mirada el 27-08) dejó de salir vencida. Así que el comentario de `isOverdueOn` («texto contra texto») dejó de ser verdad sin que fallara nada. Ningún test lo veía porque ninguno releía una fecha de la base. Arreglado con `pg.types.setTypeParser(DATE)` en `config/database.ts` y cubierto con `due_date_roundtrip.spec.ts`, que falla sin el arreglo («Expected string but received date»).

## 3. Tu duda

De qué dudaste, o qué no pudiste comprobar.

- **Producción.** No he abierto `backups/produccion-2026-10-02.dump`, porque INC-0412 dice que lleva datos personales. Si producción tiene tareas con un `status` fuera de los tres valores, la migración del `CHECK` fallará entera al desplegarla. Además eso explicaría las «unas veinte» tareas que no salen en ningún filtro. Hay que medirlo antes con un `SELECT status, count(*) … GROUP BY status` en producción. Tampoco sé si producción, que ya es PostgreSQL 17, sufre hoy el mismo fallo de `due_date`.

---

## Anexo: qué cambia en los datos al pasar de SQLite a PostgreSQL (medido)

Comprobado copiando `backend/tmp/db.sqlite3` a la base `db` (2 usuarios, 3 tokens y 9 tareas) y comparando dos cosas: los valores almacenados, columna a columna, y lo que devuelve la API con las mismas peticiones en los dos motores.

| Qué | SQLite | PostgreSQL | Consecuencia y qué se hizo |
|---|---|---|---|
| `tasks.due_date` al leerla | Texto `2026-08-26` | `Date` de JS (driver `pg`) | La API cambiaba de formato e `isOverdue` salía siempre `false`. Se corrige con un *type parser* que la deja en texto. Con él, la API devuelve lo mismo que con SQLite (0 diferencias, en lectura y en escritura). |
| `created_at` y `updated_at` de usuarios y tareas | Texto `YYYY-MM-DD HH:MM:SS`, truncado al segundo | `timestamptz` con milisegundos | Las filas nuevas ganan precisión (`.443` en vez de `.000`). Las copiadas conservan `.000`. No se pierde nada. El orden por `createdAt` desempata igual, por `id`. |
| Fechas de `auth_access_tokens` | Número: milisegundos desde 1970 (las escribe el proveedor de tokens con un `Date`) | `timestamptz` | El mismo instante. Una copia que las tratara como texto falla con *date/time field value out of range*. |
| `status` | Cualquier texto; solo lo frena el validador | `CHECK` con los tres valores | Un `INSERT` directo con `'inventado'` entraba antes del `CHECK` y ahora se rechaza. |
| `title varchar(200)` y `email varchar(254)` | Longitud declarada pero **no aplicada** | Longitud aplicada | Hoy no cambia nada, porque el validador ya corta en 200 y 254 antes de llegar a la base. |
| Secuencias de los `id` | Autoincremento implícito | `serial`: tras una copia con `id` explícitos, la secuencia sigue en 1 | La copia ajusta cada secuencia con `setval` al `max(id) + 1`. Sin eso, el siguiente alta choca con la clave primaria. |
