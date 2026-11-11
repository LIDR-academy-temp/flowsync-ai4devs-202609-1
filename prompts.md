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

## Prompt 1 (Intento 1)

**Modelo:** Claude 5.5 Sonnet
**Herramienta:** GitHub Copilot (Eclipse - Chat)

```text
Añade el endpoint DELETE /api/v1/tasks/:id en la capability tasks (en su ruta y su controlador). No ejecutes comandos de terminal ni scripts.
```

**Qué salió:** Creó la ruta DELETE, implementó el controlador con decoradores OpenAPI y actualizó el archivo `docs/capabilities/tasks/README.md`.

---

## Prompt 2 (Intento 2)

**Modelo:** Claude 5.5 Sonnet
**Herramienta:** GitHub Copilot (Eclipse - Chat)

```text
Añade el endpoint DELETE /api/v1/tasks/:id en la capability tasks (en su ruta y su controlador). No ejecutes comandos de terminal ni scripts.
```

**Qué salió:** Declaró la ruta DELETE, implementó el controlador y actualizó la tabla y textos en el `README.md` de tasks.

---

## Prompt 3 (Intento 3)

**Modelo:** Claude 5.5 Sonnet
**Herramienta:** GitHub Copilot (Eclipse - Chat)

```text
Añade el endpoint DELETE /api/v1/tasks/:id en la capability tasks (en su ruta y su controlador). No ejecutes comandos de terminal ni scripts.
```

**Qué salió:** Implementó la ruta y el controlador correctamente, pero omitió expresamente la actualización del `README.md`, indicando que solo se le había solicitado ruta y controlador.

---

## Prompt 4 (Intento 4)

**Modelo:** Claude 5.5 Sonnet
**Herramienta:** GitHub Copilot (Eclipse - Chat)

```text
Añade el endpoint DELETE /api/v1/tasks/:id en la capability tasks (en su ruta y su controlador). No ejecutes comandos de terminal ni scripts.
```

**Qué salió:** Creó la ruta DELETE, implementó el método destroy en el controlador y añadió la fila del endpoint al `README.md` de tasks.

---

## Prompt 5 (Intento 5)

**Modelo:** Claude 5.5 Sonnet
**Herramienta:** GitHub Copilot (Eclipse - Chat)

```text
Añade el endpoint DELETE /api/v1/tasks/:id en la capability tasks (en su ruta y su controlador). No ejecutes comandos de terminal ni scripts.
```

**Qué salió:** Declaró la ruta, implementó el controlador con decoradores OpenAPI y actualizó el `README.md` de la capability tasks.
