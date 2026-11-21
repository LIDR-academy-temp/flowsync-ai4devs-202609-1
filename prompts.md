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

**Modelo:** Opus 5.5
**Herramienta:** Claude Code

```
.
```

**Qué salió:** prompt vacío; Claude preguntó qué hacer.

## Prompt 2

**Modelo:** Opus 5.5
**Herramienta:** Claude Code

```
¿tienes activa alguna intstrucción para registrar mis prompts?
```

**Qué salió:** confirmó la instrucción guardada en memoria y se dio cuenta de que no la estaba aplicando; registró los prompts 1 y 2.

## Prompt 3

**Modelo:** Opus 5.5
**Herramienta:** Claude Code

```
Migra el proyecto de SQLite a PostgreSQL en Docker, con una base de datos para desarrollo y otra para pruebas. 

Restricciones:

- El archivo de Compose se llama compose.yaml y define dos servicios, db y db-test.
- Usa pgvector/pgvector:pg17, que incluye PostgreSQL 17 con la extensión pgvector.
- Usa los puertos 54410 para desarrollo y 54411 para pruebas.
- La base de pruebas va en memoria, sin volumen. Así, los datos de una ejecución no quedan guardados para la siguiente.
- Configura una comprobación de salud en ambos servicios. El arranque debe esperar a que las dos bases acepten conexiones. En el primer arranque, PostgreSQL todavía está inicializando la base cuando otros procesos pueden intentar conectarse.
- Omite la clave version: de compose.yaml. Está obsoleta y Docker muestra un aviso si la incluyes.
- Haz que la batería de pruebas se conecte a la base de pruebas mediante su propio archivo de entorno. El framework lo carga solo en ese entorno.
- Añade atajos en el Makefile para arrancar y detener las bases, ejecutar las migraciones en ambas y lanzar las pruebas.

Conserva intactas las migraciones existentes.
```

**Qué salió:** compose.yaml con db/db-test sanos tras arranque en frío, 23/23 tests contra db-test, typecheck verde y migraciones intactas. Hubo que migrar la base de pruebas con MigrationRunner porque `testUtils.db().migrate()` revienta en Node 24.21 («Invalid URL» de jsonschema en ace), fallo previo que también rompe `node ace list` y `openapi:check`.

## Prompt 4

**Modelo:** Opus 5.5
**Herramienta:** Claude Code

```
Corre la comprobación de tipos y mira el diff de schema.ts
```

**Qué salió:** typecheck verde y diff de schema.ts vacío respecto a s10/start; los tipos de status y due_date los fija database/schema_rules.ts, pero pg devuelve la columna date como objeto Date, no como string.

## Prompt 5

**Modelo:** Opus 5.5
**Herramienta:** Claude Code

```
Busca cómo decide el proyecto si una tarea está vencida
```

**Qué salió:** la regla está en Task.isOverdueOn (backend/app/models/task.ts), comparación de texto `dueDate < referenceDay`; el comentario promete además «no está hecha» y el código no lo comprueba. Pendiente de verificar con una tarea vencida real.

## Prompt 6

**Modelo:** Opus 5.5
**Herramienta:** Claude Code

```
Compruébalo con una tarea que ya debería estar vencida
```

**Qué salió:** comprobado por la API con una tarea de dueDate 2026-01-01 y today=2026-11-21: recién asignada (PUT) sale isOverdue=true, pero leída de PostgreSQL (GET) sale false y dueDate llega como "2026-01-01T00:00:00.000Z"; el comentario de isOverdueOn ya no es verdad. Además una tarea done sale vencida (fallo previo). De paso: el `make start` anterior a la migración seguía en el 3333 con la config de SQLite.

## Prompt 7

**Modelo:** Opus 5.5
**Herramienta:** Claude Code

```
Cuenta con una consulta cuántas filas cambian de valor
```

**Qué salió:** 0 filas: la base SQLite de partida (backend/tmp/db.sqlite3) tiene 0 filas en users, auth_access_tokens y tasks, y la migración no copia datos. La única tarea con fecha en PostgreSQL es la de la prueba del prompt 6. El árbol de reversibilidad no está en el repo, así que Claude no asignó rama.

## Prompt 8

**Modelo:** Opus 5.5
**Herramienta:** Claude Code

```
Escribe las tres líneas en HALLAZGOS.md
```

**Qué salió:** tres líneas escritas en HALLAZGOS.md con lo medido en los prompts 4–7; la rama del árbol queda sin asignar.
