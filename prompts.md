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
compárame este repositorio que tienes ahora con este https://github.com/LIDR-academy-temp/flowsync-ai4devs-202609-1/tree/main
```

**Qué salió:** funcionó a la primera: los dos repos son idénticos (mismo commit `df31be3`, diff vacío).

## Prompt 2

**Modelo:** Sonnet 5.5
**Herramienta:** Claude Code

```
compáralo con el fork origin
```

**Qué salió:** funcionó: el fork es idéntico en `main` y en las ramas comunes; solo le faltan `s8` y `s9`. Se equivocó al decir que `HEAD` llevaba un commit local de ventaja (luego lo corrigió).

## Prompt 3

**Modelo:** Sonnet 5.5
**Herramienta:** Claude Code

```
puedes cambiar el origin de mi repo a este? https://github.com/LIDR-academy-temp/flowsync-ai4devs-202609-1/
```

**Qué salió:** funcionó a la primera: `origin` apunta ahora al repo de LIDR-academy-temp.

## Prompt 4

**Modelo:** Sonnet 5.5
**Herramienta:** Claude Code

```
sí, haz el fetch de origin
```

**Qué salió:** funcionó: trajo `origin/s8/start`, `origin/s8/end` y `origin/s9/start`.

## Prompt 5

**Modelo:** Sonnet 5.5
**Herramienta:** Claude Code

```
Añade a la capability tasks el endpoint DELETE /api/v1/tasks/:id, que borra una tarea y devuelve 204 sin cuerpo. Impleméntalo en el controlador que ya existe y declara su ruta junto a las demás de tasks
```

**Qué salió:** funcionó: implementó el endpoint (commit `294902d`, 3 tests, lint y typecheck OK). Me preguntó por la rama y reseteó `evals-CLA` a `origin/s8/start` para tener `tasks`.

## Prompt 6

**Modelo:** Sonnet 5.5
**Herramienta:** Claude Code

```
Añade a la capability tasks el endpoint DELETE /api/v1/tasks/:id, que borra una tarea y devuelve 204 sin cuerpo. Impleméntalo en el controlador que ya existe y declara su ruta junto a las demás de tasks.
```

**Qué salió:** no hizo nada nuevo: contestó que ya estaba implementado en `294902d`. Lo lancé repetido.

## Prompt 7

**Modelo:** Sonnet 5.5
**Herramienta:** Claude Code

```
 Añade a la capability tasks el endpoint DELETE /api/v1/tasks/:id, que borra una tarea y devuelve 204 sin cuerpo. Impleméntalo en el controlador que ya existe y declara su ruta junto a las demás de tasks
```

**Qué salió:** tampoco hizo nada: tercera vez, respondió que ya estaba hecho y sugirió no reenviarlo.

## Prompt 8

**Modelo:** Sonnet 5.5
**Herramienta:** Claude Code

```
esit
```

**Qué salió:** typo mío, sin respuesta útil.

## Prompt 9

**Modelo:** Sonnet 5.5
**Herramienta:** Claude Code

```
 Añade a la capability tasks el endpoint DELETE /api/v1/tasks/:id, que borra una tarea y devuelve 204 sin cuerpo. Impleméntalo en el controlador que ya existe y declara su ruta junto a las demás de tasks
```

**Qué salió:** no cambió nada: respondió que el endpoint ya estaba en `294902d`.

## Prompt 10

**Modelo:** Sonnet 5.5
**Herramienta:** Claude Code

```
devuelve el repositorio a como estaba antes de añadir la capability Delete
```

**Qué salió:** funcionó: lo deshizo con `git revert` (`d677bcf`) en vez de `reset --hard`, porque no se lo pedí explícitamente.

## Prompt 11

**Modelo:** Sonnet 5.5
**Herramienta:** Claude Code

```
Añade a la capability tasks el endpoint DELETE /api/v1/tasks/:id, que borra una tarea y devuelve 204 sin cuerpo. Impleméntalo en el controlador que ya existe y declara su ruta junto a las demás de tasks
```

**Qué salió:** implementó el endpoint (`f1d50e2`) revirtiendo el revert `d677bcf` en vez de reescribir el código.

## Prompt 12

**Modelo:** Sonnet 5.5
**Herramienta:** Claude Code

```
retorna el repositorio como estaba antes de hacer este cambio
```

**Qué salió:** otra vez usó `git revert` (`6add31b`) en lugar de borrar historia; ofreció el reset si confirmaba.

## Prompt 13

**Modelo:** Sonnet 5.5
**Herramienta:** Claude Code

```
haz git reset hard
```

**Qué salió:** funcionó: `reset --hard d677bcf`, rama limpia.

## Prompt 14

**Modelo:** Sonnet 5.5
**Herramienta:** Claude Code

```
Añade a la capability tasks el endpoint DELETE /api/v1/tasks/:id, que borra una tarea y devuelve 204 sin cuerpo. Impleméntalo en el controlador que ya existe y declara su ruta junto a las demás de tasks
```

**Qué salió:** implementó el endpoint (`2f2625e`) de nuevo revirtiendo el revert.

## Prompt 15

**Modelo:** Sonnet 5.5
**Herramienta:** Claude Code

```
borra todo lo relacionado con este cambio y haz hard reset
```

**Qué salió:** funcionó: reset a `d677bcf`, sin restos del cambio.

## Prompt 16

**Modelo:** Sonnet 5.5
**Herramienta:** Claude Code

```
Añade a la capability tasks el endpoint DELETE /api/v1/tasks/:id, que borra una tarea y devuelve 204 sin cuerpo. Impleméntalo en el controlador que ya existe y declara su ruta junto a las demás de tasks
```

**Qué salió:** implementó el endpoint (`3921592`), mismo método.

## Prompt 17

**Modelo:** Sonnet 5.5
**Herramienta:** Claude Code

```
borra todo lo relacionado con este cambio y haz hard reset
```

**Qué salió:** funcionó: reset a `d677bcf`.

## Prompt 18

**Modelo:** Sonnet 5.5
**Herramienta:** Claude Code

```
Añade a la capability tasks el endpoint DELETE /api/v1/tasks/:id, que borra una tarea y devuelve 204 sin cuerpo. Impleméntalo en el controlador que ya existe y declara su ruta junto a las demás de tasks
```

**Qué salió:** implementó el endpoint (`205f29c`), mismo método.

## Prompt 19

**Modelo:** Sonnet 5.5
**Herramienta:** Claude Code

```
borra todo lo relacionado con este cambio y haz hard reset
```

**Qué salió:** funcionó: reset a `d677bcf`.

## Prompt 20

**Modelo:** Sonnet 5.5
**Herramienta:** Claude Code

```
Añade a la capability tasks el endpoint DELETE /api/v1/tasks/:id, que borra una tarea y devuelve 204 sin cuerpo. Impleméntalo en el controlador que ya existe y declara su ruta junto a las demás de tasks
```

**Qué salió:** implementó el endpoint (`4980057`), mismo método.

## Prompt 21

**Modelo:** Sonnet 5.5
**Herramienta:** Claude Code

```
borra todo lo relacionado con este cambio y haz hard reset
```

**Qué salió:** funcionó: reset a `d677bcf` (sesión del 10 de noviembre).

## Prompt 22

**Modelo:** Sonnet 5.5
**Herramienta:** Claude Code

```
Añade a la capability tasks el endpoint DELETE /api/v1/tasks/:id, que borra una tarea y devuelve 204 sin cuerpo. Impleméntalo en el controlador que ya existe y declara su ruta junto a las demás de tasks.
```

**Qué salió:** funcionó: endpoint commiteado como `de9e3d1` (revirtió el revert; incluye tests, spec, README y `.adonisjs/`). Es el estado final de la rama.

## Prompt 23

**Modelo:** Sonnet 5.5
**Herramienta:** Claude Code

```
rellena la plantilla prompts.md con todos los prompts que hemos hecho en este worktree, aunque hayan pertenecido a distintas sesiones de Claude.
```

**Qué salió:** funcionó: rellenó la plantilla con los 23 prompts anteriores y dejó "Qué salió" vacío.

## Prompt 24

**Modelo:** Sonnet 5.5
**Herramienta:** Claude Code

```
rellena qué salió
```

**Qué salió:** este mismo: rellenar la línea "Qué salió" de cada prompt a partir de las sesiones.
