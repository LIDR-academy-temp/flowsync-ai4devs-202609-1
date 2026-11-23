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

**Modelo:** Claude Opus 5.5 (`claude-opus-5-5`)
**Herramienta:** Claude Code

```
Dame el MER (Modelo entidad relacion) de la base de datos que tiene este proyecto
```

**Qué salió:** funcionó a la primera: diagrama Mermaid de las 3 tablas sacado de las migraciones.

## Prompt 2

**Modelo:** Claude Opus 5.5 (`claude-opus-5-5`)
**Herramienta:** Claude Code

```
Busca si hay alguna regla en el modelo que no hayas tenido en cuenta
```

**Qué salió:** encontró las reglas de `schema_rules.ts` y de los validadores, y que la base SQLite local venía de migraciones de otra rama.

## Prompt 3

**Modelo:** Claude Opus 5.5 (`claude-opus-5-5`)
**Herramienta:** Claude Code

```
ejecuta node ace migration:fresh
```

**Qué salió:** funcionó: la base local quedó igual que las migraciones del repo (y se borraron sus datos).

## Prompt 4

**Modelo:** Claude Opus 5.5 (`claude-opus-5-5`)
**Herramienta:** Claude Code

```
Migra el proyecto de SQLite a PostgreSQL en Docker, con una base de datos para desarrollo y otra para pruebas. Antes de hacerlo quiero asegurarme que los datos que se migren siguen iguales en el nuevo motor de base de 
datos, si cambian quiero que lo dejes documentado en el fichero Hallazgos.md 
Ten en cuenta también que hay una fecha en la tabla de tasks que es un due_date ,donde solo guarda fechas sin horas ni minutos. También en la misma tabla
esta la columna status que es un string a la cual tenemos que seguir teniendo la restricción actual (solo permite una serie de valores) , quizás en PostgresSQL hay algún  mecanismo que permita tener esta restricción 

Otras restricciones que has de cumplir son :

- El archivo de Compose se llama compose.yaml y define dos servicios, db y db-test.
- Usa pgvector/pgvector:pg17, que incluye PostgreSQL 17 con la extensión pgvector.
- Usa los puertos 54410 para desarrollo y 54411 para pruebas. Así evitas un conflicto si ya tienes una instancia de PostgreSQL en el 5432.
- La base de pruebas va en memoria, sin volumen. Así, los datos de una ejecución no quedan guardados para la siguiente.
- Configura una comprobación de salud en ambos servicios. El arranque debe esperar a que las dos bases acepten conexiones. En el primer arranque, PostgreSQL todavía está inicializando la base cuando otros procesos pueden intentar conectarse.
- Omite la clave version: de compose.yaml. Está obsoleta y Docker muestra un aviso si la incluyes.
- Haz que la batería de pruebas se conecte a la base de pruebas mediante su propio archivo de entorno. El framework lo carga solo en ese entorno.
- Añade atajos en el Makefile para arrancar y detener las bases, ejecutar las migraciones en ambas y lanzar las pruebas.

Conserva intactas las migraciones existentes. Si el agente propone modificar alguna, detente y anótalo como hallazgo.
```

**Qué salió:** funcionó: migración hecha sin tocar migraciones existentes. La comparación de datos destapó que `due_date` volvía como `Date` (isOverdue siempre false) y se corrigió; CHECK nuevo para `status`.

## Prompt 5

**Modelo:** Claude Opus 5.5 (`claude-opus-5-5`)
**Herramienta:** Claude Code

```
 Si las pruebas vuelven a pasar, sigue con estas tres comprobaciones y anota lo que observes.

Ejecuta la comprobación de tipos ((cd backend && npm run typecheck)) y anota si pasa o falla. Las dos respuestas son normales, y las dos enseñan algo.

Compara el archivo de tipos generado (backend/database/schema.ts) con el de la rama de partida. El diff puede mostrar declaraciones cambiadas o salir vacío, y las dos salidas son normales. Si hay cambios, indica qué declaraciones cambiaron de tipo y anota, para cada una, el tipo anterior y el nuevo. Si el diff está vacío, busca qué fija esos tipos al cambiar de motor: vacío no significa que no haya cambiado nada, sino que lo que cambió no está en lo que el proyecto declara.

Busca cómo decide el proyecto si una tarea está vencida. Lee el comentario que explica por qué funciona esa comparación y contrástalo con lo que encontraste en el paso anterior. Indica si sigue siendo válido y compruébalo con una tarea que ya debería estar vencida, no solo leyendo el código.
```

**Qué salió:** funcionó: typecheck en verde, diff de schema.ts vacío por `schema_rules.ts`, y vencimiento medido por la API con y sin el arreglo; apareció además que una tarea hecha sale vencida.

## Prompt 6

**Modelo:** Claude Opus 5.5 (`claude-opus-5-5`)
**Herramienta:** Claude Code

```
haz la PR
```

**Qué salió:** funcionó: PR #51 contra `s10/start` y revisión adversarial, sin hallazgos críticos.

## Prompt 7

**Modelo:** Claude Opus 5.5 (`claude-opus-5-5`)
**Herramienta:** Claude Code

```
Añade los prompts en el fichero prompts.md y subelo tambien a la PR
```

**Qué salió:** este fichero.
