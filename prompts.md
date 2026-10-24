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

**Modelo:** Opus 1M xHigh
**Herramienta:** Claude Code

```
contrasta las reglas con los últimos 15 commits del repositorio y las reglas de proceso definidas en claude.md 
Guarda el resultado en docs/auditoria/AA.md, no en el chat.
Crea una tabla con una fila por regla y completa estas cinco columnas:

-Resumen de que pide la regla. Una sola frase, no mezcles reglas.
-Qué se revisó para comprobarla. Indica el comando ejecutado o el archivo consultado, tenes que dejar evidencia de en qué se apoya tu veredicto.
-Veredicto. Solo pueden ser tres opciones: se cumple, no se cumple ,  no se puede comprobar con la información disponible. Esta ultima opcion, usala cuando no conseguis suficiente evidencia.
-Evidencia. Escríbela en una línea. Si la regla no se cumple, indica dónde se incumple. Si no se puede comprobar, explica qué información faltaria.
- Qué harías con ella. Elige una de estas opciónes: dejarla, borrarla o convertirla en una comprobación automática.
No modifiques nada del codigo ni intentes reparar nada, se trata de un informe de auditoria lo que te estoy pidiendo
```

**Qué salió:** (opcional, una línea) funcionó a la primera 
