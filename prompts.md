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

**Modelo:** Sonnet 5.5
**Herramienta:** Claude Code

```
a partir de ahora escribe cada prompt que te mande de forma literal en el fichero prompts.md siguiendo la plantilla que ya se encuentra en el fichero, empezando a numerarlos desde el 1 y eliminando la propia plantilla. Puedes empezar por este
```

## Prompt 2

**Modelo:** Opus 5.5
**Herramienta:** Claude Code

```
migra este proyecto desde SQLite a PostgreSQL en Docker, con una base de datos para desarrollo y otra para pruebas. Estas son las restricciones:



El archivo de Compose se llama compose.yaml y define dos servicios, db y db-test.

Usa pgvector/pgvector:pg17, que incluye PostgreSQL 17 con la extensión pgvector.

Usa los puertos 54410 para desarrollo y 54411 para pruebas. Así evitas un conflicto si ya tienes una instancia de PostgreSQL en el 5432.

La base de pruebas va en memoria, sin volumen. Así, los datos de una ejecución no quedan guardados para la siguiente.

Configura una comprobación de salud en ambos servicios. El arranque debe esperar a que las dos bases acepten conexiones. En el primer arranque, PostgreSQL todavía está inicializando la base cuando otros procesos pueden intentar conectarse.

Omite la clave version: de compose.yaml. Está obsoleta y Docker muestra un aviso si la incluyes.

Haz que la batería de pruebas se conecte a la base de pruebas mediante su propio archivo de entorno. El framework lo carga solo en ese entorno.

Añade atajos en el Makefile para arrancar y detener las bases, ejecutar las migraciones en ambas y lanzar las pruebas.
```

## Prompt 3

**Modelo:** Opus 5.5
**Herramienta:** Claude Code

```
(cd backend && npm run typecheck)
```

## Prompt 4

**Modelo:** Opus 5.5
**Herramienta:** Claude Code

```
Task.isOverdue parece decidir si la tarea está vencida. Dime si hay algún otro punto que decida esto
```

## Prompt 5

**Modelo:** Opus 5.5
**Herramienta:** Claude Code

```
me cuesta entender la redacción del comentario. Pero creo entender por qué antes funcionaba el criterio. Los strings de fecha estaban formateados de tal forma (año, mes y día, en ese orden), que la comparación alfabética que se hace mediante el operador < de strings equivalía a una comparación de orden de fechas: 2025-* es siempre menor a cualquier 2026-* y asi sucesivamente con el mes y el día, en caso de empates. Pero ahora, this.dueDate va a ser un Date y referenceDay va a ser un string. Usar el < ahí va a ser un poco impredecible y no tiene pinta de que funcione en todos los casos. Dime qué ocurre si se usa < entre string y Date y casos esquina.

Comprueba si hay alguna tarea metida que tenga que estar ya vencida, mete una de prueba si es necesario con vencimiento en 2025, levanta la aplicación y dame la url para el navegador para comprobar el comportamiento en la propia app.
```

## Prompt 6

**Modelo:** Opus 5.5
**Herramienta:** Claude Code

```
prepara un test de backend que ponga este fallo en evidencia: la comparación entre string y Date ya no funciona y no da como vencidas tareas que sí deberían estarlo.
```

## Prompt 7

**Modelo:** Opus 5.5
**Herramienta:** Claude Code

```
Puedes tirar la instancia de la app en marcha (ya no la uso) y hacer la prueba en una copia aparte con sqlite, para validar que los nuevos tests sí pasan verde en ese caso
```
