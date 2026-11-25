## Prompt 1

**Modelo:** Opus 5.5
**Herramienta:** Claude Code (CLI)

```
/opsx:explore migra la base de datos de SQLite a PostgreSQL en docker, con una db para datos y otra para pruebas. Restricciones: El archivo de Compose se llama compose.yaml y define dos servicios, db y db-test.

Usa pgvector/pgvector:pg17, que incluye PostgreSQL 17 con la extensión pgvector.

Usa los puertos 54410 para desarrollo y 54411 para pruebas. Así evitas un conflicto si ya tienes una instancia de PostgreSQL en el 5432.

La base de pruebas va en memoria, sin volumen. Así, los datos de una ejecución no quedan guardados para la siguiente.

Configura una comprobación de salud en ambos servicios. El arranque debe esperar a que las dos bases acepten conexiones. En el primer arranque, PostgreSQL todavía está inicializando la base cuando otros procesos pueden intentar conectarse.

Omite la clave version: de compose.yaml. Está obsoleta y Docker muestra un aviso si la incluyes.

Haz que la batería de pruebas se conecte a la base de pruebas mediante su propio archivo de entorno. El framework lo carga solo en ese entorno.

Añade atajos en el Makefile para arrancar y detener las bases, ejecutar las migraciones en ambas y lanzar las pruebas.

Conserva intactas las migraciones existentes.  Si propones modificar alguna, dímelo primero
```

**Qué salió:** Lanzado en modo explore + plan. El agente preguntó dos cosas (respondidas eligiendo opción, sin escribir prompt): dejar el problema de `due_date` para la Parte B y arrancar la base de desarrollo vacía. Aprobé el plan y lo implementó: 23/23 tests en verde contra `db-test`, sin tocar migraciones. Por el camino falló dos veces (contraseña `secret` sin `.release()` y `testUtils.db().migrate()` chocando con `commands/openapi_check.ts`) y lo corrigió.

## Prompt 2

**Modelo:** Opus 5.5
**Herramienta:** Claude Code (CLI)

```
Compara el archivo de tipos generado (backend/database/schema.ts) con el de la rama de partida (diff)
```

**Qué salió:** Diff vacío; señaló `database/schema_rules.ts` como lo que fija los tipos de `status` y `due_date`.

## Prompt 3

**Modelo:** Opus 5.5
**Herramienta:** Claude Code (CLI)

```
Busca cómo decide el proyecto si una tarea está vencida
```

**Qué salió:** Trazó la cadena hasta `Task.isOverdueOn` y encontró, leyendo, que el código no comprueba `done` aunque el comentario y la spec lo exigen.

## Prompt 4

**Modelo:** Opus 5.5
**Herramienta:** Claude Code (CLI)

```
Sí, compruébalo con una tarea vencida
```

**Qué salió:** Confirmado: una tarea vencida el 2026-11-20 sale `isOverdue: false` en el `GET` con `today=2026-11-25` (pg devuelve `date` como `Date`), y una tarea `done` sale vencida en la respuesta del `PUT`. Intentó parar su servidor con un `pkill` que se habría llevado también el mío; el modo auto lo bloqueó y lo rehízo por PID.

## Prompt 5

**Modelo:** Opus 5.5
**Herramienta:** Claude Code (CLI)

```
a qué se refiere el ejercicio con De qué dudaste ( la línea 3 de hallazgos.md? )
```

**Qué salió:** Explicación de la línea 3 y una lista de dudas candidatas de la sesión.

## Prompt 6

**Modelo:** Opus 5.5
**Herramienta:** Claude Code (CLI)

```
vamos a rellenar prompts.md. Lee el archivo y complétalo con mis prompts. Pon cada prompt en su propio bloque de código, con el modelo y la herramienta que usaste. Así se distingue dónde empieza y termina cada uno.
```

**Qué salió:** Este fichero.
