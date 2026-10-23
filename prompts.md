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

**Modelo:** Opus 5.5
**Herramienta:** Claude Code

```
/rename
Auditoria
```

**Qué salió:** no funcionó: `/rename` sin argumento falló y «Auditoria» llegó como un prompt aparte.

## Prompt 2

**Modelo:** Opus 5.5
**Herramienta:** Claude Code

```
/rename Auditoria
```

**Qué salió:** funcionó: la sesión quedó renombrada.

## Prompt 3

**Modelo:** Opus 5.5
**Herramienta:** Claude Code

```
resume los últimos commits del repositorio
```

**Qué salió:** funcionó a la primera: resumen de los 15 commits por temas, con dos avisos para la auditoría.

## Prompt 4

**Modelo:** Opus 5.5
**Herramienta:** Claude Code

```
Contrasta las Reglas de proceso definidas en CLAUDE.md con los últimos 15 commits del repositorio y el estado actual de los archivos del proyecto, guarda los resultados en docs/auditoria/maj.md

Usa una fila por regla y completa estas cinco columnas:

Qué pide la regla. Resúmela en una frase y con tus propias palabras. Si necesitas varias frases, puede que estés mezclando más de una regla.
Qué se revisó para comprobarla. Indica el comando ejecutado o el archivo consultado. Sin esta información no hay forma de saber en qué se apoya el veredicto.
Veredicto. Solo puede ser se cumple, no se cumple o no se puede comprobar con la información disponible. Este último caso también es un resultado válido. Significa que la regla no deja suficiente evidencia para verificarla.
Evidencia. Escríbela en una línea. Si la regla no se cumple, indica dónde se incumple. Si no se puede comprobar, explica qué información falta.
Qué harías con ella. Elige una opción: dejarla, borrarla o convertirla en una comprobación automática.

No debes de modificar ningún archivo.
```

**Qué salió:** funcionó: creó `docs/auditoria/maj.md` con 6 filas (1 no se cumple, 1 se cumple, 4 no se pueden comprobar).

## Prompt 5

**Modelo:** Opus 5.5
**Herramienta:** Claude Code

```
para esta regla: "Cada petición se cierra con su propio commit, hecho con la skill /commit.", ¿que harías para poder verificar esta regla?, no modifiques nada, solo plantea una solución
```

**Qué salió:** funcionó: propuso trailers en el commit + hooks de Claude Code + script de verificación, sin tocar ficheros.

## Prompt 6

**Modelo:** Opus 5.5
**Herramienta:** Claude Code

```
hazme un resumen dde lo que acabas de explicar, es para añadirlo al archivo docs/auditoria/maj.md
```

**Qué salió:** a medias: con el modo plan activo escribió el resumen en un plan en vez de en el fichero; rechacé salir del modo plan.

## Prompt 7

**Modelo:** Opus 5.5
**Herramienta:** Claude Code

```
añade tu descripción en el fichero
```

**Qué salió:** a medias: el texto ya estaba pegado a mano con los bordes `│` de la terminal; solo los limpió.

## Prompt 8

**Modelo:** Opus 5.5
**Herramienta:** Claude Code

```
añade tu descripción en el fichero de nuevo
```

**Qué salió:** funcionó: añadió el resumen al final de `docs/auditoria/maj.md`.

## Prompt 9

**Modelo:** Opus 5.5
**Herramienta:** Claude Code

```
crea el fichero prompts.md en el raíz del proyecto
```

**Qué salió:** el fichero ya existía con la plantilla; lo rellenó con los prompts de esta sesión.
