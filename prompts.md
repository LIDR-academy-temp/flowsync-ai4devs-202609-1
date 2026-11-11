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

**Modelo:** Claude Opus 5.5 (`claude-opus-5-5`)
**Herramienta:** Claude Code

```
Añade a la capability tasks el endpoint DELETE /api/v1/tasks/:id, que borra una tarea y devuelve 204 sin cuerpo. Impleméntalo en el controlador que ya existe y declara su ruta junto a las demás de tasks.
```

**Qué salió:** funcionó a la primera. Rama nueva `feat/tasks-destroy` desde `s8/start`; `TasksController.destroy` y ruta en el grupo de tasks; tests functional nuevos; `docs/api/openapi.json` regenerado y el README de la capability al día, todo en el mismo commit (`bc77064`). Avisó de que la spec no tiene requisito de borrado. No abrió PR (eso va al cerrar la unidad de trabajo).

## Prompt 2

**Modelo:** Claude Opus 5.5 (`claude-opus-5-5`)
**Herramienta:** Claude Code

```
crea el archivo prompts.md en el raiz del proyecto y añade los prompts de esta sesión con el formato y la información que se especifica
```

**Qué salió:** el fichero ya existía como plantilla; lo rellenó con los dos prompts de la sesión y borró el ejemplo.

## Prompt 3

**Modelo:** Claude Opus 5.5 (`claude-opus-5-5`)
**Herramienta:** Claude Code

```
estoy haciendo el ejercicio de evals, el resultado ha sido que la IA ha aactualizado el README.md con el nuevo endpoint dos veces de 5
```

**Qué salió:** revisó `docs/evals/maj.md` y el enunciado. Señaló que los fallos van seguidos (1–3 fallan, 4–5 aciertan), que la regla del `CLAUDE.md` se contradice sobre el fichero OpenAPI y que con 5 intentos el margen es muy amplio. Propuso un borrador de la Parte B sin escribirlo en el fichero.

## Prompt 4

**Modelo:** Claude Opus 5.5 (`claude-opus-5-5`)
**Herramienta:** Claude Code

```
dime un ejemplo de regla mas corta para README.md y otra para OpenAPI, queiro reescribir la regla original
```

**Qué salió:** propuso dos reglas separadas, cada una con el fichero exacto y un comando que la verifica (`npm run openapi:check` para OpenAPI). Avisó de que cambiar la regla obliga a repetir los 5 intentos para comparar.

## Prompt 5

**Modelo:** Claude Opus 5.5 (`claude-opus-5-5`)
**Herramienta:** Claude Code

```
añade los últimos prompts al archivo de prompts
```

**Qué salió:** añadió los prompts 3, 4 y 5 a `prompts.md`.
