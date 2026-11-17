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
Añade a la capability tasks el endpoint DELETE /api/v1/tasks/:id, que borra una tarea y devuelve 204 sin cuerpo. Impleméntalo en el controlador que ya existe y declara su ruta junto a las demás de tasks.
```

**Qué salió:** creó la rama `feat/delete-task`, el método `destroy`, la ruta y la fila del README, pero no actualizó `docs/api/openapi.json` y afirmó que no había fichero que generar. Adicionalmente, el agente comenta que no se genero el commit por otra regla que indica que solo se realicen commits hasta finalizar la unidad de trabajo. El resultado se la prueba se indica en aup.md

## Prompt 2

**Modelo:** Sonnet 5.5
**Herramienta:** Claude Code

```
Cuando dices que /api/v1/tasks/:id ya existe, a que te refieres? al archivo OpenAPI o a que la implementación de la funcionalidad ya existe?
```

**Qué salió:** aclaró que se refería al código escrito, no ejecutado, y que no había comprobado el endpoint contra el servidor.

## Prompt 3

**Modelo:** Sonnet 5.5
**Herramienta:** Claude Code

```
Pero tu creaste la implementación o haces referencia a que ya existía? Adicionalmente, la instrucción pide actualizar OpenAPI pero no veo que el archivo openapi.json tuviera la nueva ruta. No hagas modificaciones solo verifica estas dudas.
```

**Qué salió:** confirmó con `git diff` que la implementación era nueva y reconoció que `docs/api/openapi.json` existe, está versionado y no incluía el DELETE.

## Prompt 4

**Modelo:** Sonnet 5.5
**Herramienta:** Claude Code

```
A que se refiere la construcción por cada peticion? a que existen scripts que se ejecutaran al commitear y que se generara la actualización de openapi.json?
```

**Qué salió:** verificó que no hay hooks de git y que el CI solo ejecuta `openapi:check`; la generación es manual con `openapi:generate`.

## Prompt 5

**Modelo:** Sonnet 5.5
**Herramienta:** Claude Code

```
correcto, entonces lo que pasa es que la regla de CLAUDE no se cumplio del todo porque falto actualización el archivo OpenAPI pero esto a su vez es por la misma redacción de la regla, entendí bien?
```

**Qué salió:** confirmó la lectura con matiz: la regla del CLAUDE.md es falsa para este repo, pero la comprobación también era responsabilidad del modelo.

## Prompt 6

**Modelo:** Sonnet 5.5
**Herramienta:** Claude Code

```
Con base a mis peticiones, llena el archivo prompts.md, no generes más cambio ni realices commit.
```

**Qué salió:** rellenó este archivo con los prompts anteriores, sin más cambios ni commit.

## Prompt 7

**Modelo:** Sonnet 5.5
**Herramienta:** Claude Code

```
Añade a la capability tasks el endpoint DELETE /api/v1/tasks/:id, que borra una tarea y devuelve 204 sin cuerpo. Impleméntalo en el controlador que ya existe y declara su ruta junto a las demás de tasks.
```

**Qué salió:** Se genero el commit con los cambios realizados, se detecto la rama del primer intento, comentando que no tenía commits. El resultado se la prueba se indica en aup.md

## Prompt 8

**Modelo:** Sonnet 5.5
**Herramienta:** Claude Code

```
Añade a la capability tasks el endpoint DELETE /api/v1/tasks/:id, que borra una tarea y devuelve 204 sin cuerpo. Impleméntalo en el controlador que ya existe y declara su ruta junto a las demás de tasks.
```

**Qué salió:** Se generaron los cambios. Se generó el commit. El resultado se la prueba se indica en aup.md

## Prompt 9

**Modelo:** Sonnet 5.5
**Herramienta:** Claude Code

```
Añade a la capability tasks el endpoint DELETE /api/v1/tasks/:id, que borra una tarea y devuelve 204 sin cuerpo. Impleméntalo en el controlador que ya existe y declara su ruta junto a las demás de tasks.
```

**Qué salió:** Se realizon los cambios requeridos. El agente detecto las ramas creadas previamente pero genero una nueva. Se generaron test para la funcionalidad e igual se genera el commit. El resultado se la prueba se indica en aup.md

## Prompt 10

**Modelo:** Sonnet 5.5
**Herramienta:** Claude Code

```
Añade a la capability tasks el endpoint DELETE /api/v1/tasks/:id, que borra una tarea y devuelve 204 sin cuerpo. Impleméntalo en el controlador que ya existe y declara su ruta junto a las demás de tasks.
```

**Qué salió:** Se realizaon los cambios requeridos. Se detectaron las ramas previos pero se crea una nueva (incluso detecta que una de las ramas tiene un commit sobre lo mismo que se le solicita). Aqui no se genero el commit. El resultado se la prueba se indica en aup.md