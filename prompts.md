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
Migra la base de datos del proyecto de SQLite a PostgreSQL en Docker, considerando una base de datos para desarrollo y otra para pruebas. Restricciones:

1. El archivo de Compose se llama compose.yaml y define dos servicios, db y db-test.

2. Usa pgvector/pgvector:pg17, que incluye PostgreSQL 17 con la extensión pgvector.

3. Usa los puertos 54410 para desarrollo y 54411 para pruebas.

4. La base de pruebas va en memoria, sin volumen. Así, los datos de una ejecución no quedan guardados para la siguiente.

5. Configura una comprobación de salud en ambos servicios. El arranque debe esperar a que las dos bases acepten conexiones. En el primer arranque, PostgreSQL todavía está inicializando la base cuando otros procesos pueden intentar conectarse.

6. Omite la clave version: de compose.yaml. Está obsoleta y Docker muestra un aviso si la incluyes.

7. Haz que la batería de pruebas se conecte a la base de pruebas mediante su propio archivo de entorno. El framework lo carga solo en ese entorno.

8. Añade atajos en el Makefile para arrancar y detener las bases, ejecutar las migraciones en ambas y lanzar las pruebas.
```

**Qué salió:** Migración completa: `compose.yaml` (db :54410 con volumen, db-test :54411 en tmpfs, healthcheck por TCP con `--wait`), `config/database.ts` con `pg` y `DB_*`, `.env.test` propio, atajos de Makefile (`db-up`, `db-down`, `migrate-test`, `migrate-all`, `test`), docs actualizados y commit `c932f49`. 23 tests, typecheck y lint en verde. Quedó sin detectar que `due_date` pasaba a llegar como `Date` (lo descubrieron los prompts siguientes). `make` no está instalado en la máquina, así que los atajos no se ejecutaron como tales.

## Prompt 2

**Modelo:** Sonnet 5.5
**Herramienta:** Claude Code

```
Ejecuta npm run typecheck sobre el backend. Solo valida la salida, no realices ajustes o correcciones.
```

**Qué salió:** `tsc --noEmit` sin errores, código de salida 0. No se tocó nada.

## Prompt 3

**Modelo:** Sonnet 5.5
**Herramienta:** Claude Code

```
Analiza el archivo schema.ts del backend y determina los cambios realizados contra el archivo de la rama de partida. Si existen cambios, identifica las declaraciones que cambiaron de tipo y muestra el tipo actual y el anterior. No modifiques nada solo analiza.
```

**Qué salió:** Sin cambios de contenido contra `s10/start` (rama de partida de `motor-aup`): el fichero solo difiere en saltos de línea (LF/CRLF). Se listaron los tipos actuales, iguales a los anteriores.

## Prompt 4

**Modelo:** Sonnet 5.5
**Herramienta:** Claude Code

```
como se fijan los tipos al cambiar de motor de base de datos? Quiero entender porque no cambio nada en el archivo schema.ts
```

**Qué salió:** Explicación apoyada en el generador de Lucid 22: la tabla de `mappings.js` lleva los tipos de cada motor al mismo tipo interno, y `schema_rules.ts` lo pisa para `due_date` (`string`). Avisó de que el generador tipa lo que dice la base, no lo que devuelve el driver.

## Prompt 5

**Modelo:** Sonnet 5.5
**Herramienta:** Claude Code

```
Analiza como el proyecto determina si una tarea está vencida. Esta relacionado con la regla de due_date? Verifica si la comparación o comprobación sigue siendo valida y realiza una prueba sobre el proyecto para asegurarte. No modifiques nada, solo valida.
```

**Qué salió:** Hallazgo principal: `Task.isOverdueOn` compara `this.dueDate < referenceDay` como texto, pero con `pg` la columna `date` llega como `Date` y `isOverdue` sale `false` al releer la tarea (correcto solo en la respuesta del `PUT`). Reproducido contra la API real en la base de pruebas. Además, el código no comprueba que la tarea no esté `done`, pese a que el comentario lo dice.

## Prompt 6

**Modelo:** Sonnet 5.5
**Herramienta:** Claude Code

```
Para confirmar la situación, due_date en PG se guarda como DATE pero en el código se utiliza/convierte a string. Pero en la consulta como el driver recupera con formato ISO, esto genero el fallo en la validación?
```

**Qué salió:** Matizó la hipótesis: el driver no devuelve texto ISO sino un objeto `Date`; el ISO aparece al serializar a JSON. `Date < "2026-11-25"` es `false` por `NaN`. Detectó además que `pg` interpreta `date` en la zona horaria del proceso (riesgo de un día de menos). Propuso `pg.types.setTypeParser(1082, v => v)`.

## Prompt 7

**Modelo:** Sonnet 5.5
**Herramienta:** Claude Code

```
Explica cual es la diferencia con SQLIte, SQLite si devolvia un texto? o porque con ese motor si funcionaba? Muestra un ejemplo de comparación entre ambos casos
```

**Qué salió:** Demostrado con `better-sqlite3` instalado en un directorio temporal: SQLite guarda `text` y devuelve `string` (comparación `true`); PostgreSQL devuelve `Date` (`false`); con el `setTypeParser` vuelve a `true`.

## Prompt 8

**Modelo:** Sonnet 5.5
**Herramienta:** Claude Code

```
Entonces, la declaración que indica que due_date sea tratado como string no surte efecto y el valor que llega se sigue manejando como Date?
```

**Qué salió:** Aclaró que `: string | null` es solo una anotación de TypeScript y `@column()` no convierte nada, así que en lectura sigue llegando un `Date`. La regla sí cuenta en compilación y en escritura. Comparó `setTypeParser` frente a `consume` en la columna.

## Prompt 9

**Modelo:** Sonnet 5.5
**Herramienta:** Claude Code

```
Llena el archivo prompts.md con los prompts de esta sesión. Sigue las instrucciones del archivo.
```

**Qué salió:** Este mismo archivo: se completó «Qué salió» del Prompt 1 y se añadieron los Prompts 2 a 9, sin reescribirlos.
