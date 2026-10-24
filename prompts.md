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
Lista los últimos 15 commits del proyecto y una pequeña descripción de cada uno.
```

**Qué salió:** Funcionó. Listo los últimos commits y se indicó un resumen general de estos últimos cambios.

## Prompt 2

**Modelo:** Sonnet 5.5
**Herramienta:** Claude Code

```
En base a los últimos 15 commits, verifica las reglas de procesos descritas en el archivo CLAUDE.md para verificar si se están cumpliendo. Al finalizar el analisis, genera una tabla con lo siguientes puntos como columnas:

1. QUE PIDE LA REGLA: Resume en una frase, evita usar varias frases porque se podrían estar mezclando más de una regla.
2. QUE SE REVISO PARA COMPROBAR: Indica el comando ejecutado o el archivo consultado. Esta información es la base del veredicto.
3. VEREDICTO: Solo existen tres valores SE CUMPLE, NO SE CUMPLE ó NO SE PUEDE COMPROBAR CON LA INFORMACIÓN ACTUAL.
4. EVIDENCIA: Que sea una sola linea. Si la regla no se cumple, indica donde se incumple. Sino se puede comprobar, indica que información falta.
5. QUE SE HARÍA CON ELLA: Indica si se debe conservar, borrar o si es mejor convertirla en una comprobación automatica.

Reglas a considerar:
1. La tabla escribela en la ruta docs/auditoria/aup.md
2. No se modifica código, solo es el analisis.

```

**Qué salió:** Genero la tabla pero algunas reglas las dividió para dar su explicación más a detalle sobre cada aspecto. Esto la IA lo incluyó como parte de notas al final del archivo (Se deja como evidencia).
