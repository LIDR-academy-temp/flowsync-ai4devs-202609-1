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
revisa si hay algunra rama creada ahora
```

**Qué salió:** listó las ramas locales y remotas; confirmó que no había rama de trabajo para s5.

## Prompt 2

**Modelo:** Opus 5.5
**Herramienta:** Claude Code

```
crea una rama git checkout -b auditoria-sml
```

**Qué salió:** creó la rama `auditoria-sml` desde `s5/start`.

## Prompt 3

**Modelo:** Opus 5.5
**Herramienta:** Claude Code (modo plan)

```
revisa los ultimos commits
```

**Qué salió:** resumen de los 5 últimos commits; señaló el validador de `status` que no rechaza valores inventados.

## Prompt 4

**Modelo:** Opus 5.5
**Herramienta:** Claude Code

```
Lee las reglas de proceso de `CLAUDE.md` y contrástalas contra los últimos 15 commits de
este repositorio y el estado actual del árbol. Para cada regla, una fila: qué dice, qué
evidencia has mirado, y si se ha cumplido, no se ha cumplido, o no se puede comprobar
desde el historial. Usa solo lo que puedas verificar con comandos de git y leyendo
archivos: si una regla no deja rastro comprobable, dilo en vez de suponer. No cambies
ningún archivo: esto es una auditoría, no un arreglo.
```

**Qué salió:** primera tabla de 5 reglas; detectó que la historia está reescrita y que solo la regla 3 se puede dar por cumplida.

## Prompt 5

**Modelo:** Opus 5.5
**Herramienta:** Claude Code

```
genera una tabla donde queden contrastadas esta reglas, siguiendo esta estructura:Usa una fila por regla y completa estas cinco columnas:

Qué pide la regla. Resúmela en una frase y con tus propias palabras. Si necesitas varias frases, puede que estés mezclando más de una regla.

Qué se revisó para comprobarla. Indica el comando ejecutado o el archivo consultado. Sin esta información no hay forma de saber en qué se apoya el veredicto.

Veredicto. Solo puede ser se cumple , no se cumple o no se puede comprobar con la información disponible . Este último caso también es un resultado válido. Significa que la regla no deja suficiente evidencia para verificarla.

Pruebas. Escríbela en una línea. Si la regla no se cumple , indica dónde se incumple. Si no se puede comprobar , explique qué información falta.

¿Qué harías con ella? Elige una opción: dejarla , borrarla o convertirla en una comprobación automática .
```

**Qué salió:** tabla con las cinco columnas pedidas y justificación de la última columna.

## Prompt 6

**Modelo:** Opus 5.5
**Herramienta:** Claude Code

```
guarda la tabla en un archivo auditoria.md
```

**Qué salió:** creó `auditoria.md` en la raíz.

## Prompt 7

**Modelo:** Opus 5.5
**Herramienta:** Claude Code

```
Guarda el resultado en docs/auditoria/sml.md
```

**Qué salió:** movió el archivo a `docs/auditoria/sml.md`.

## Prompt 8

**Modelo:** Opus 5.5
**Herramienta:** Claude Code

```
Quiero que en el fichero Prompts guardes todos los prompts genados en esta sesión y no haga commit aún
```

**Qué salió:** rellenó este `prompts.md`, sin commit.
