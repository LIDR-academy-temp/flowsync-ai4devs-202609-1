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

**Modelo:** Claude Sonnet 5.5 (effort medium)
**Herramienta:** Claude Code

```
Dame un resumen de los últimos commits
```

**Qué salió:** ejecutó `git log` y resumió los últimos commits de `s5/start`; sirvió para comprobar que el agente lee el historial (paso 6 del entorno).

---

## Prompt 2

**Modelo:** Claude Sonnet 5.5 (effort medium)
**Herramienta:** Claude Code

```
Vamos a realizar una tarea, lee `readme.md` para las intrucciones, no hagas más que leer y esperar el siguiente prompt para iniciar la tarea
```

**Qué salió:** leyó `README.md` (no existe en minúsculas), resumió la tarea y esperó sin tocar nada.

---

## Prompt 3

**Modelo:** Claude Sonnet 5.5 (effort medium)
**Herramienta:** Claude Code

```
Audita las `reglas de proceso` de CLAUDE.md contra los últimos 15 commits y el estado actual del árbol y deja el resultado en una tabla en `docs/auditoria/SGCA.md` con una fila por regla y cinco casillas:
  a. Qué pide la regla: Una sola frase
  b. Qué se miró para comprobar: El comando concreto, o el archivo.
  c. Veredicto: se cumple, no se cumple o no se puede comprobar con lo que hay.
  d. Evidencia: Una línea y si el veredicto es no se cumple, el sitio donde se rompió. Si es no se puede comprobar, qué falta para poder comprobarla.
  e. Qué hacer con ella: dejarla, borrarla o bajarla a algo automático.
Esto es solamente una auditoría, no cambies ningún archivo fuera de `docs/auditoria/SGCA.md` y sobre todo no corrijas NADA
```

**Qué salió:** creó la tabla con 7 filas sin modificar ningún otro archivo; pedí la evidencia en una línea y en varias filas ocupa varias frases.

---

## Prompt 4

**Modelo:** Claude Opus 5.5 (effort xhigh)
**Herramienta:** Claude Code

```
regresa a la sesiòn anterior y dime que has modificado
```

**Qué salió:** no puede volver a otra sesión; resumió con Git y su propio historial lo que modificó en la del harness.

---

## Prompt 5

**Modelo:** Claude Opus 5.5 (effort xhigh)
**Herramienta:** Claude Code

```
Vuelve a leer `README.md` y dime cual es el status que tenemos al momento de la tarea que se tiene que realizar
```

**Qué salió:** listó el estado de cada pieza: tabla hecha, y pendientes la apuesta en el archivo, la parte B, `prompts.md` y el PR.

---

## Prompt 6

**Modelo:** Claude Opus 5.5 (effort xhigh)
**Herramienta:** Claude Code

```
La apuesta la anote por fuera antes de iniciar el ejercicio, me va a servir para contestar la primera linea de la parte B. Agrega las 3 lineas de la parte  B en `docs/auditoria/SGCA.md` para que yo complete la línea 1 y para las líneas 2 y 3 pon tu opinion para que yo revise y modifique a mi consideración. También extrae los prompts del historial de la sesión en la que se hizo la auditoría para poder registrarlos en prompts.md
```

**Qué salió:** dejó la línea 1 en blanco, propuso borradores para la 2 y la 3, y extrajo los 2 prompts de la auditoría.

---

## Prompt 7

**Modelo:** Claude Opus 5.5 (effort xhigh)
**Herramienta:** Claude Code

```
si añade esos 2 grupos de prompts que dejaste pendientes
```

**Qué salió:** no pudo escribir porque la sesión seguía en plan mode; me pidió salir con Shift+Tab sin aprobar el plan de FLOW-1.

---

## Prompt 8

**Modelo:** Claude Opus 5.5 (effort xhigh)
**Herramienta:** Claude Code

```
ya salí de plan mode
```

**Qué salió:** añadió los prompts que faltaban a este archivo.
