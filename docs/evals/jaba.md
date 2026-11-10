# Módulo 8 — Evaluación de una regla del harness

## Parte A — Medición

### Regla evaluada

La regla de proceso de `CLAUDE.md` establece:

> Un cambio que toque rutas, controladores, validadores o transformers de una capability se cierra en el mismo commit con el documento OpenAPI y el README de esa capability al día.

Se evalúa específicamente si Claude Code actualiza `docs/capabilities/tasks/README.md` al implementar un nuevo endpoint.

### Predicción inicial

**3 de 5 intentos (60 %)**, registrada antes del primer ensayo.

### Procedimiento

- Herramienta: Claude Code.
- Modelo: Opus 5.5 High.
- Punto de partida: `upstream/s8/start`, commit `a883bd1`.
- Cinco sesiones nuevas con el mismo encargo, sin recordar la regla al agente.
- Entre ensayos: `git checkout -f s8/start`, `git reset --hard upstream/s8/start` y `git clean -fd`.
- Control: comprobar que se declara la ruta DELETE en `backend/start/routes.ts`.
- Resultado: comprobar mediante `git diff` que el README de la capability incorpora el endpoint.

### Resultados

| Ensayo | Ruta DELETE | README actualizado | ¿Cuenta? | Commit |
|---|---|---|---|---|
| 1 | Sí | Sí | Sí | `c229d31` |
| 2 | Sí | Sí | Sí | `70d5fed` |
| 3 | Sí | Sí | Sí | `65b286c` |
| 4 | Sí | Sí | Sí | `810b847` |
| 5 | Sí | Sí | Sí | `c9cbfd3` |

**Resultado observado: 5/5 (100 %).**

En los cinco ensayos se verificó `router.delete(':id', ...)` en `backend/start/routes.ts` y un cambio en `docs/capabilities/tasks/README.md` que documenta `DELETE /tasks/:id` y su respuesta `204` sin cuerpo.

La predicción fue del 60 %, mientras que el cumplimiento observado fue del 100 %: una diferencia de 40 puntos porcentuales.

## Parte B — Reflexión

**1. Predicción y resultado.** Predije 3/5 (60 %) y obtuve 5/5 (100 %). Los cinco intentos declararon la ruta y actualizaron el README sin recordatorios adicionales.

**2. Qué haría con la regla.** La convertiría en una comprobación automática, manteniendo de momento la instrucción. Un control podría detectar cambios en rutas o controladores sin la correspondiente actualización del README y OpenAPI. Además, probaría que la comprobación falla ante un incumplimiento deliberado. El 100 % observado no garantiza futuros cumplimientos ni demuestra que la instrucción sea necesaria.

**3. Qué no comprueba la medición.** No hay línea base sin la regla, así que no podemos atribuirle el resultado observado. Solo comprobamos que el README menciona el endpoint, no toda su exactitud ni el cumplimiento completo de la regla. Además, Claude podía detectar ramas de ensayos anteriores, y cinco intentos son una muestra pequeña.

## Observaciones del entorno

- Los 23 tests iniciales pasaron antes de ejecutar los ensayos.
- Claude encontró problemas con los comandos OpenAPI bajo Node 24 y utilizó soluciones temporales diferentes según el ensayo.
- Los cinco ensayos partieron del mismo commit, aunque las ramas creadas anteriormente siguieron siendo visibles.
- Los resultados se comprobaron en los archivos modificados, no únicamente en los mensajes finales del agente.