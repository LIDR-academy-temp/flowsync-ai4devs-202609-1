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

Borra el ejemplo de abajo cuando escribas el primero.

---

## Prompt 1

**Modelo:** Sonnet 5.5
**Herramienta:** Claude Code

```
Migra el proyecto de SQLite a PostgreSQL en Docker con una base de datos para desarrollo y otra para pruebas. Ten en cuenta las siguientes restricciones: 

<pasted_content id="a298">
El archivo de Compose se llama compose.yaml y define dos servicios, db y db-test.

Usa pgvector/pgvector:pg17, que incluye PostgreSQL 17 con la extensión pgvector.

Usa los puertos 54410 para desarrollo y 54411 para pruebas. Así evitas un conflicto si ya tienes una instancia de PostgreSQL en el 5432.

La base de pruebas va en memoria, sin volumen. Así, los datos de una ejecución no quedan guardados para la siguiente.

Configura una comprobación de salud en ambos servicios. El arranque debe esperar a que las dos bases acepten conexiones. En el primer arranque, PostgreSQL todavía está inicializando la base cuando otros procesos pueden intentar conectarse.

Omite la clave version: de compose.yaml. Está obsoleta y Docker muestra un aviso si la incluyes.

Haz que la batería de pruebas se conecte a la base de pruebas mediante su propio archivo de entorno. El framework lo carga solo en ese entorno.

Añade atajos en el Makefile para arrancar y detener las bases, ejecutar las migraciones en ambas y lanzar las pruebas.
</pasted_content id="a298">

 Además Conserva intactas las migraciones existentes
```

**Qué salió:** funcionó a la primera: `compose.yaml` con `db`/`db-test` sanas, config `pg` por entorno, `.env.test` para pruebas, targets `db-up`/`db-down`/`db-migrate`/`test` en el Makefile, migraciones intactas y los 23 tests pasan contra `db-test`.

## Prompt 2

**Modelo:** Sonnet 5.5
**Herramienta:** Claude Code

```
Crea un HALLAZGOS.md y en el anota las respuestas a las prueguntas que te formularé ahora
```

**Qué salió:** `HALLAZGOS.md` ya existía, sembrado con tres apartados vacíos, así que no lo creé de nuevo: lo usaré tal cual. Aún no había ninguna pregunta en el prompt; quedé a la espera.

## Prompt 3

**Modelo:** Sonnet 5.5
**Herramienta:** Claude Code

```
Cuántas filas cambian de valor con el cambio de esquema, medido con una consulta, y en qué rama del árbol de reversibilidad cae el cambio. Si tu migración no modifica datos, indícalo
```

**Qué salió:** midió con una consulta (0 filas en las 3 tablas de la base de desarrollo, 4 migraciones aplicadas, `git diff` vacío en migraciones) y lo anotó en el punto 1 de `HALLAZGOS.md`. No pudo nombrar la rama del árbol de reversibilidad porque ese árbol no está en el repo.

## Prompt 4

**Modelo:** Sonnet 5.5
**Herramienta:** Claude Code

```
Qué caso quedó fuera de la batería de pruebas. Si no encontraste ninguno, explica qué buscaste y dónde.
```

**Qué salió:** encontró un caso real: `isOverdueOn` da `false` con una tarea vencida porque `pg` devuelve `date` como `Date` y no como texto; lo comprobó con una consulta contra `db-test` (no por el endpoint HTTP) y lo anotó en el punto 2 de `HALLAZGOS.md`. No arregló el código, porque no se pidió.

## Prompt 5

**Modelo:** Sonnet 5.5
**Herramienta:** Claude Code

```
De qué dudaste o qué no pudiste comprobar -> En el apartado B se indica que ejecutemos la comprobación de tipos. Ejecutarlo no muestra nada, solo muestra > backend@0.0.0 typecheck
        > tsc --noEmit
```

**Qué salió:** confirmó que el silencio es verde (código de salida 0), comparó `schema.ts` con `s10/start` (sin cambios) y anotó la duda y lo no comprobado en el punto 3 de `HALLAZGOS.md`.
