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

**Modelo:** Opus 5.5 (claude-opus-5-5), effort xhigh
**Herramienta:** Claude Code

```
Lee los scenarios del requirement "Lo que cada tarea muestra de su responsable" en `openspec/specs/tasks/spec.md` y los tests que haya en `backend/tests/` para generar una matriz de trazabilidad en `docs/verificacion/SGCA.md` con los siguiente puntos: cada scenario en una línea (Qué se espera y en qué situación) → qué prueba lo cubre (nombrada tal cual aparece en la suite de tests) → Cubierto/NO cubierto/No lo sé → Si pusiste "No lo sé", qué te faltó para decidirlo (resumido en media línea). Cuenta cuántos scenarios tiene el requirement y cuántos están cubiertos y ponlo arriba. No hagas NADA más y menos tocar código
```

## Prompt 2

**Modelo:** Opus 5.5 (claude-opus-5-5), effort xhigh
**Herramienta:** Claude Code

```
Escribe los tests de integración para los scenarios del requirement «Lo que cada tarea muestra de su responsable» de `openspec/specs/tasks/spec.md` que quedaron como «NO cubierto» en la matriz de trazabilidad: uno por cada scenario, en `backend/tests/functional/tasks/` siguiendo el estilo de los que ya existen en `backend/tests/functional/auth/`. No toques nada fuera de `backend/tests/` y del archivo prompts.md. Después de escribirlos ejecutalos y si algún test falla, no arregles el código y déjalo fallando, y no aflojes el test para que pase. Si algo se pone rojo, se queda rojo y se entrega rojo: quiero saber qué está mal para verificarlo sin taparlo.
```
