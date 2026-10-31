---
name: cvss-auditoria
description: Puntúa con CVSS v4.0 cada hallazgo de las comprobaciones de los tests (tests/comentarios.md), los reordena por criticidad y compara con el orden original. Usar al priorizar la remediación de los hallazgos de los tests.
---
# Priorización CVSS v4.0 de los hallazgos de las comprobaciones de los tests

Entrada: `tests/comentarios.md`, que recoge los hallazgos de las comprobaciones de los
tests. Si no existe, o no contiene hallazgos, dilo y no inventes ninguno.

1. Toma cada hallazgo de `tests/comentarios.md` y asígnale un puntaje **CVSS v4.0**
   con su **vector** (`CVSS:4.0/AV:.../AC:.../AT:.../PR:.../UI:.../VC:.../VI:.../VA:.../SC:.../SI:.../SA:...`)
   y su **severidad**: Ninguna, Baja, Media, Alta o Crítica. Justifica en una línea las
   métricas no evidentes y señala los supuestos cuando el hallazgo no dé información
   suficiente para fijar una métrica. Si un hallazgo describe un test que falla o que
   no cubre algo, puntúa el riesgo del comportamiento que queda sin comprobar, no el
   hecho de que el test falle.
2. Reordena los hallazgos de **mayor a menor criticidad** (por puntaje; ante empate,
   mantén el orden original entre ellos).
3. Compara el **orden original** del documento con el **orden por CVSS**: indica qué
   hallazgos **subieron o bajaron** de posición, **cuántas posiciones** se movieron y
   **qué implica** esa diferencia para la priorización de la remediación.

## Salida

- Una tabla con: posición original, hallazgo, vector CVSS v4.0, puntaje, severidad.
- La lista reordenada, de mayor a menor criticidad.
- Una tabla de comparación: hallazgo, posición original, posición nueva, movimiento
  (`↑ n`, `↓ n` o `=`).
- Un párrafo con las implicaciones para la remediación: qué se adelanta, qué se retrasa
  y qué riesgo había en seguir el orden del documento.

No modifiques `tests/comentarios.md`: el resultado se entrega en la respuesta.
