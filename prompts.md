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

**Modelo:** Composer
**Herramienta:** Cursor Agent

```
Lee primero el estado actual del repositorio (estructura del proyecto, `package.json`, `Makefile` existente si lo hay, ficheros `.env*`, configuración de base de datos, carpeta de migraciones y `backend/database/schema.ts`) antes de modificar o crear ningún archivo.

Necesito migrar el motor de base de datos del backend de SQLite a **PostgreSQL en Docker**, configurando dos instancias separadas (desarrollo y pruebas) bajo estas restricciones estrictas y no negociables:

1. **Docker Compose (`compose.yaml` en la raíz):**
   - No incluyas la clave obsoleta `version:`.
   - Define exactamente dos servicios: `db` (desarrollo) y `db-test` (pruebas).
   - Ambos deben usar la imagen `pgvector/pgvector:pg17`.
   - Mapeo de puertos: `54410:5432` para `db` y `54411:5432` para `db-test`.
   - Persistencia: `db` debe usar un volumen nombrado para persistir datos; `db-test` debe ser **completamente efímera en memoria** (sin volumen persistente, usando `tmpfs` en `/var/lib/postgresql/data`).
   - Salud (`healthcheck`): ambos servicios deben incluir `healthcheck` con `pg_isready` para asegurar que PostgreSQL ya terminó su inicialización y acepta conexiones antes de darlos por listos.

2. **Entornos y conexión:**
   - Configura las variables de entorno de desarrollo apuntando al puerto `54410` (actualiza `.env` / `.env.example` según corresponda).
   - Crea o configura el fichero de entorno específico de pruebas (por ejemplo `.env.test`) apuntando al puerto `54411`, asegurando que el framework/runner de tests lo cargue automáticamente cuando `NODE_ENV=test`.
   - Adapta el cliente/driver de base de datos y la configuración de migraciones/ORM al dialecto PostgreSQL.

3. **Regla de oro sobre migraciones:**
   - **NO modifiques ni borres ninguna migración existente.** Si el cambio de motor exige una nueva migración o ajuste de esquema/tipos, detente antes de tocar las existentes y repórtamelo para revisarlo.

4. **Atajos en el `Makefile`:**
   - Añade o actualiza objetivos claros para: levantar las bases de datos esperando a que estén sanas (`--wait`), pararlas, ejecutar las migraciones en **ambas** bases de datos (desarrollo y pruebas), y lanzar la suite de tests contra `db-test`.

5. **Verificación final:**
   - Levanta los contenedores, aplica migraciones en ambas bases, ejecuta la batería de tests del backend hasta dejarla en verde y corre `npm run typecheck` en `backend` reportándome el resultado exacto (sin alterar aún `HALLAZGOS.md` ni `prompts.md`).

Antes de escribir código, muéstrame brevemente qué stack/ORM usa el proyecto y tu plan de archivos a tocar.
```

**Qué salió:** el agente explicó las tres partes (A/B/C), comprobó el entorno y pidió confirmación antes de tocar código.

## Prompt 2

**Modelo:** Composer
**Herramienta:** Cursor Agent

```
Si, empieza
```

**Qué salió:** creó `motor-tcf`, migró a Postgres (compose + env + Makefile), dejó 23 tests en verde, midió el bug de vencidas y rellenó HALLAZGOS.md.

## Prompt 3

**Modelo:** Composer
**Herramienta:** Cursor Agent

```
NO modifiques ningún archivo del proyecto todavía. Quiero que actúes como auditor técnico y me ayudes a investigar exactamente qué cambió y qué comportamiento silencioso se perdió tras migrar de SQLite a PostgreSQL.

Ejecuta estas tres comprobaciones y muéstrame los resultados literales:

1. **Comprobación de tipos (`typecheck`):**
   - Ejecuta `(cd backend && npm run typecheck)` y muéstrame la salida completa y exacta (si está en verde o en rojo, y cada error si los hay).

2. **Análisis del diff de `backend/database/schema.ts`:**
   - Ejecuta `git diff s10/start -- backend/database/schema.ts` (o contra la rama base desde la que partimos) y muéstrame el diff íntegro.
   - Si el diff muestra cambios de tipos, lístalos uno a uno indicando qué columna o declaración cambió y de qué tipo a qué tipo.
   - Si el diff sale vacío, inspecciona la configuración de generación de tipos, el ORM/query builder o los ficheros de migración para explicarme exactamente qué está fijando esos tipos para que no cambien al pasar de SQLite a PostgreSQL, y qué diferencia real hay ahora en la base de datos PostgreSQL (`\d` de las tablas en `db`) frente a lo que declara `schema.ts`.

3. **Lógica de tareas vencidas (overdue) y prueba empírica:**
   - Busca en todo el codebase dónde y cómo decide el proyecto si una tarea está vencida. Muéstrame el bloque de código completo y el comentario que explica por qué funciona la comparación.
   - Analiza si la premisa de ese comentario sigue siendo cierta en PostgreSQL frente a SQLite (por ejemplo: formato de fechas/timestamps, zonas horarias, tipos de columna o cómo se serializan al comparar).
   - **No te quedes solo en leer el código:** haz una comprobación real contra la base de datos de desarrollo (`db` en el puerto `54410`) insertando o consultando una tarea con fecha pasada que ya debería estar vencida, ejecuta la lógica/endpoint/consulta del proyecto sobre ella y muéstrame tanto la query SQL o dato guardado en Postgres como el resultado que devuelve la aplicación.

Entrégame un informe claro con las evidencias de los 3 puntos para que yo pueda redactar `HALLAZGOS.md`.
```

**Qué salió:** typecheck en verde; diff de `schema.ts` vacío (tipos fijados por `schema_rules.ts`); en runtime Postgres entrega `dueDate` como `Date` y `isOverdueOn` de una tarea 2020-01-01 devolvió `false`.
