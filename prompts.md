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

**Modelo:** Grok 4.7
**Herramienta:** Cursor

```
De ahora en adelante, escrbe todos los prompts que te pase en el archivo @prompts.md con el esquema que pide el archivo
```

**Qué salió:** registrado en este archivo; a partir de aquí cada prompt nuevo se añade como el siguiente apartado.

## Prompt 2

**Modelo:** Grok 4.7
**Herramienta:** Cursor

```
Migra el proyecto de SQLite a PostgreSQL en Docker, con una base de datos para desarrollo y otra para pruebas, cumpliendo estas restricciones:

- El archivo de Compose se llama compose.yaml y define dos servicios: db y db-test.
- Usa la imagen pgvector/pgvector:pg17, que incluye PostgreSQL 17 con la extensión pgvector.
- Usa los puertos 54410 para desarrollo y 54411 para pruebas.
- La base de pruebas va en memoria, sin volumen, para que los datos de una ejecución no queden guardados para la siguiente.
- Configura una comprobación de salud (healthcheck) en ambos servicios y haz que el arranque espere a que las dos bases acepten conexiones.
- Omite la clave version: en compose.yaml.
- Haz que la batería de pruebas se conecte a la base de pruebas mediante su propio archivo de entorno cargado solo en ese entorno.
- Añade atajos en el Makefile para arrancar y detener las bases, ejecutar las migraciones en ambas y lanzar las pruebas.
- Conserva intactas las migraciones existentes; no modifiques los archivos de migración actuales.
```

**Qué salió:** funcionó a la primera: las dos bases quedan sanas, las migraciones existentes no se tocaron, el typecheck está en verde y las 23 pruebas pasan contra la base de pruebas.

## Prompt 3

**Modelo:** Grok 4.7
**Herramienta:** Cursor

```
Realiza las siguientes comprobaciones en el proyecto sin modificar archivos de migración ni dar por válidas las suposiciones sin verificarlas:

1. Ejecuta la comprobación de tipos en backend (`npm run typecheck`) y dime exactamente si pasa o falla (con los errores si los hay).
2. Compara el archivo de tipos generado (`backend/database/schema.ts`) con el estado de la rama `s10/start` usando `git diff s10/start -- backend/database/schema.ts`. Si hay cambios, lista qué declaraciones cambiaron y cuál era su tipo anterior y su tipo nuevo; si el diff está vacío, revisa qué configuración del proyecto fija esos tipos al cambiar de motor y qué quedó fuera de lo declarado.
3. Busca en el código cómo decide el proyecto si una tarea está vencida. Localiza el comentario que explica por qué funciona esa comparación, contrástalo con lo encontrado en el paso anterior y pruébalo creando o consultando una tarea con fecha ya vencida sobre PostgreSQL para verificar si la comparación sigue funcionando o falla silenciosamente.
4. Indica también mediante consulta cuántos registros o valores existentes cambiaron con el cambio de esquema/motor, para documentarlo en `HALLAZGOS.md`.
```

**Qué salió:** typecheck en verde, diff de schema.ts vacío, y la comparación de vencimiento falla en silencio al releer un Date desde PostgreSQL.
