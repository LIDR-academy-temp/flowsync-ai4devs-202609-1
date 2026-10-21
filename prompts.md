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

**Modelo:** Opus 5.5 medium
**Herramienta:** Claude Code

```
El objetivo es contrastar las reglas del proceso indicadas en CLAUDE.md con los 15 últimos commits del repositorio y el estado actual del proyecto. El resultado va en el fichero docs/auditoria/ajr.md. No modifiques archivos ni corrijas ningún hallazgo que encuentres, solo interesa el resultado del análisis. No hagas commit con el resultado hasta que yo no te lo indique; yo revisaré el fichero y también lo editaré manualmente.

Para cada regla de proceso encontrada genera una fila. Cada fila tiene estas 5 columnas:
  - "Qué pide la regla": resumido en una frase en lenguaje sencillo.
  - "Qué se revisó para comprobarla": Pon aquí el comando ejecutado o el archivo consultado. Será una forma de ver la razón del veredicto de la siguiente columna. Si salen comandos muy largos no es necesario ponerlos al pie de la letra, basta la parte significativa y una breve frase para explicar lo que hace.
  - "Veredicto": Los posibles valores aquí son "se cumple", "no se cumple", "no se puede comprobar con la información disponible". El último también vale y significa que la regla no deja suficiente evidencia para verificación.
  - "Evidencia": Una linea. Si no se cumple, ¿dónde se incumple? Si no se puede comprobar, ¿qué info falta?
  - "Qué harías con ella": Los posibles valores son "dejarla", "borrarla", "convertirla en una comprobación automática". Esta la dejas vacía, pero lista para poder escribir el valor yo manualmente después; para evaluarme. Luego te pediré opinión.
```

**Qué salió:** partió varias reglas en varias filas porque hablaban de varias cosas a comprobar y tenían veredictos diferentes.

## Prompt 2

**Modelo:** Opus 5.5 medium
**Herramienta:** Claude Code

```
No partas las reglas aunque hablen de varias cosas. Quiero una fila por cada regla. Para el veredicto: si una parte de la regla no cumple, entonces la regla entera no cumple sin importar el resto de partes; si una parte de la regla no se puede comprobar y otras sí, entonces la regla entera no se puede comprobar. Para la evidencia escoge una coherente con el veredicto elegido.
```

**Qué salió:** funcionó

## Prompt 3

**Modelo:** Opus 5.5 medium
**Herramienta:** Claude Code

```
He rellenado la última columna. Dime tu opinión sobre mis respuestas.
```

**Qué salió:** (opcional, una línea) funcionó a la primera / tuve que insistir / me inventó una ruta que no existe.

## Prompt 4

**Modelo:** Opus 5.5 medium
**Herramienta:** Claude Code

```
en markdown se puede marcar un texto para que salga como tachado? me gustaría dejar mi respuesta original indicando que cambio de opinión
```

**Qué salió:** 

## Prompt 5

**Modelo:** Opus 5.5 medium
**Herramienta:** Claude Code

```
agrega una sección nueva al final del fichero. Título: "Parte B". Dentro, tres preguntas para contestar:
  - La regla en la que más te equivocaste
  - Una regla que no se puede comprobar con la información disponible
  - La regla que eliminarías y por qué

No las contestes, deja un hueco para contestarlas yo manualmente. Las preguntas, al pie de la letra y con negrita.
```

**Qué salió:** 