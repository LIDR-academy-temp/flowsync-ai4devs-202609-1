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
Lee las reglas de proceso de `CLAUDE.md` y contrástalas contra los últimos 15 commits de este repositorio y el estado actual del árbol. Para cada regla, una fila y completa estas cinco columnas:
1. **Qué pide la regla**. Resúmela en una frase. Si necesitas varias frases, puede que estés mezclando más de una regla.
2. **Qué se revisó para comprobarla**. Indica el comando ejecutado o el archivo consultado. Sin esta información no hay forma de saber en qué se apoya el veredicto.
3. **Veredicto**. Solo puede ser _se cumple_, _no se cumple_ o _no se puede comprobar con la información disponible_. Este último caso también es un resultado válido. Significa que la regla no deja suficiente evidencia para verificarla.
4. **Evidencia**. Escríbela en una línea. Si la regla no se cumple, indica dónde se incumple. Si no se puede comprobar, explica qué información falta.
5. **Qué harías con ella**. Elige una opción: _dejarla_, _borrarla_ o _convertirla en una comprobación automática_.
Usa solo lo que puedas verificar con comandos de git y leyendo archivos: si una regla no deja rastro comprobable, dilo en vez de suponer. No cambies ningún archivo: esto es una auditoría, no un arreglo. Solo escribe la tabla solicitada en `docs/auditoria/<tus-iniciales>.md`
No realices commit o PR alguno.
```

**Qué salió:** 

---