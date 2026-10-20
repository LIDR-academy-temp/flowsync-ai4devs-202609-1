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

**Modelo:** Opus 5.5
**Herramienta:** Claude Code

```
Haz una auditoría de las reglas de proceso de este repositorio. Es solo lectura: no modifiques, crees, borres ni commitees ningún archivo, salvo el que se indica al final.

Reglas a auditar: las de la sección "Reglas de proceso" de CLAUDE.md. Una fila por regla, sin mezclar varias en una.

Contrasta cada regla con los últimos 15 commits (git log -15, y git show / git diff cuando necesites ver qué tocó cada commit) y con el estado actual de los archivos del proyecto.

La tabla tiene exactamente estas cinco columnas:
1. Qué pide la regla: una frase, con tus palabras.
2. Qué se revisó: el comando exacto ejecutado o el archivo consultado.
3. Veredicto: solo uno de "se cumple", "no se cumple" o "no se puede comprobar con la información disponible".
4. Evidencia: una línea. Cita el hash del commit o el archivo concreto. Si no se cumple, indica dónde. Si no se puede comprobar, indica qué información falta.
5. Qué harías con ella: solo una de "dejarla", "borrarla" o "convertirla en una comprobación automática".

Criterios:
- No supongas. Si la regla trata de algo que no queda registrado en git ni en los archivos (por ejemplo, lo que ocurre en el chat), el veredicto es "no se puede comprobar", no "se cumple".
- Un veredicto "se cumple" o "no se cumple" necesita un hash o un archivo como evidencia. Sin eso, no lo emitas.
- No incluyas nada que no sea una regla de proceso.

Escribe el resultado únicamente en docs/auditoria/prm.md, debajo del apartado "Expectativa inicial" que ya existe. No lo modifiques ni lo reescribas. Esa es la única escritura permitida. No escribas las tres líneas finales: las redacto yo.
```

**Qué salió:** funcionó a la primera: respetó el solo lectura (solo escribió en `docs/auditoria/prm.md`), separó mis 5 reglas en 8 filas y marcó 7 como "no se puede comprobar" y 1 como "se cumple"; cada veredicto citaba hash o archivo.
