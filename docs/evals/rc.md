# Laboratorio 8 — Evaluación de una regla del harness

**Curso:** LIDR AI4Devs — Módulo 8: Evals for Agentic Harness
**Proyecto:** FlowSync AI4Devs
**Fecha:** 9 de noviembre de 2026
**Responsable:** RC
**Herramienta:** Claude Code v2.1.318
**Modelo:** Opus 5.5
**Esfuerzo:** Medium
**Modo:** Auto mode

## 1. Objetivo

Medir mediante cinco ensayos manuales si Claude Code cumple una regla de documentación persistente en `CLAUDE.md`, incluso cuando el prompt de trabajo no menciona expresamente el README.

La evaluación mide el cumplimiento observado de la regla, no la calidad global de la implementación ni el efecto causal de `CLAUDE.md`.

## 2. Regla evaluada

Regla existente en `CLAUDE.md`:

> Un cambio que toque rutas, controladores, validadores o transformers de una capability se cierra en el mismo commit con el documento OpenAPI y el README de esa capability al día.

El criterio de resultado seleccionado para este ejercicio es la actualización del README de la capability `tasks`.

## 3. Predicción inicial

Antes de ejecutar los ensayos registré la siguiente predicción:

**3 de 5 ensayos (60 %) actualizarían el README sin un recordatorio explícito.**

Esta predicción quedó fijada antes del primer ensayo válido y no se modificó después.

## 4. Metodología

Se realizaron cinco ensayos manuales con una nueva sesión de Claude Code para cada ejecución.

Condiciones de trabajo:

- Repositorio: FlowSync AI4Devs.
- Rama inicial: `s8/start`.
- Referencia: `upstream/s8/start`.
- Commit inicial: `a883bd1749b4a8411735a1a34ec483bff60591e3`.
- Herramienta: Claude Code v2.1.318.
- Modelo: Opus 5.5.
- Esfuerzo previsto: Medium.
- Modo de permisos: Auto mode.
- Prompt idéntico en los cinco ensayos.
- Sin instrucciones adicionales para actualizar el README.

### Prompt experimental

Se utilizó literalmente el siguiente texto:

> Añade a la capability tasks el endpoint DELETE /api/v1/tasks/:id, que borra una tarea y devuelve 204 sin cuerpo. Impleméntalo en el controlador que ya existe y declara su ruta junto a las demás de tasks.

Los envíos originales y sus resultados están registrados en `prompts.md`.

### Evaluación de cada ensayo

**Control funcional:** comprobar que `backend/start/routes.ts` declara la ruta DELETE para `tasks/:id`.

Si el control no se cumple, el intento no se contabiliza para la medición del README.

**Resultado documental:** cuando el control se cumple, comprobar que `docs/capabilities/tasks/README.md` documenta el endpoint DELETE.

Se verificaron los archivos directamente mediante comandos de consulta Git y búsquedas de texto.

### Restauración entre ensayos

Al finalizar cada ensayo, se restauró el repositorio mediante:

```bash
git checkout -f s8/start
git reset --hard upstream/s8/start
git clean -fd
```

Se comprobó que `HEAD` coincidía con `a883bd1749b4a8411735a1a34ec483bff60591e3` y que el árbol de trabajo estaba limpio.

Los commits experimentales quedaron conservados mediante ramas locales independientes.

## 5. Parte A — Resultados de los cinco ensayos

| Ensayo | Rama generada | Commit | Control DELETE | README actualizado | Resultado |
|---|---|---|---|---|---|
| 1 | `feat/delete-task` | `08d137f` | Sí | Sí | Cumple |
| 2 | `feat/tasks-delete` | `81d80e2` | Sí | Sí | Cumple |
| 3 | `feat/tasks-delete-endpoint` | `abacfe2` | Sí | Sí | Cumple |
| 4 | `feat/tasks-destroy` | `e6480cb` | Sí | Sí | Cumple |
| 5 | `feat/tasks-delete-by-id` | `6bf8dd5` | Sí | Sí | Cumple |

Todos los resultados se verificaron directamente en los archivos del repositorio después de la ejecución del agente.

### Tasa observada

- Ensayos válidos: **5**.
- Ensayos con README actualizado: **5**.
- Tasa observada de cumplimiento: **5/5 = 100 %**.
- Predicción inicial: **3/5 = 60 %**.
- Diferencia: **+40 puntos porcentuales**.

### Incidencia previa

Antes del primer ensayo válido hubo un envío del prompt bloqueado por autenticación:

`Login reached its time limit · Please run /login`

Se resolvió mediante `/login`. Al no existir ejecución funcional, este envío no forma parte de los cinco ensayos evaluables, pero sí quedó documentado en `prompts.md`.

## 6. Parte B — Reflexiones

### 6.1. ¿Cómo se compara el resultado con mi predicción?

Predije que Claude Code actualizaría el README en tres de los cinco ensayos.

El resultado observado fue de cinco cumplimientos sobre cinco ensayos válidos, equivalente al 100 %.

La diferencia fue de dos cumplimientos adicionales, o 40 puntos porcentuales sobre mi predicción.

El comportamiento documental fue más consistente de lo que anticipé. Sin embargo, cinco ensayos no garantizan que este resultado se repita en cualquier tarea o contexto.

### 6.2. ¿Eliminaría, reescribiría o comprobaría automáticamente la regla?

Mantendría la regla de `CLAUDE.md`, porque establece una obligación de proceso clara: mantener sincronizados los cambios de código y su documentación.

Como mejora posterior, incorporaría una comprobación automática que detecte modificaciones en rutas, controladores, validadores o transformers y compruebe que la documentación relacionada haya sido revisada.

Esa comprobación debería distinguir entre una actualización real del contrato y un cambio que no requiera modificarlo, para evitar falsos positivos.

No implementaría esa automatización durante este laboratorio, porque el ejercicio solicita una evaluación manual y no el desarrollo de un mecanismo automático.

### 6.3. ¿Qué no demuestra esta medición?

La medición no demuestra que la regla de `CLAUDE.md` haya causado los cinco cumplimientos.

No se realizó una comparación equivalente sin la regla, por lo que no existe una línea base que permita medir su efecto causal.

Además:

- La muestra contiene solamente cinco ensayos válidos.
- Todos utilizaron la misma tarea y el mismo repositorio.
- Los resultados podrían variar con otros modelos, prompts o contextos.
- Las ramas Git de ensayos anteriores permanecieron visibles para Claude Code.
- No se evaluó exhaustivamente la calidad de toda la documentación o implementación generada.

Por tanto, el 100 % es una tasa observada en esta muestra, no una garantía general de confiabilidad.

## 7. Observaciones y aprendizajes adicionales

### H08-01 — Ramas anteriores visibles

En ensayos posteriores Claude Code identificó ramas `feat/...` generadas durante intentos anteriores.

Aunque el repositorio volvió al mismo commit inicial y el árbol de trabajo quedó limpio, las referencias de esas ramas permanecieron disponibles.

Esto muestra que restaurar los archivos no elimina necesariamente todo el contexto observable del entorno Git.

No se comprobó que esta diferencia influyera en la actualización del README.

### H08-02 — Variabilidad de las implementaciones

Los ensayos produjeron diferentes cantidades de tests, nombres de ramas y cambios documentales.

En el quinto ensayo también se modificó el archivo versionado `docs/api/openapi.json`.

A pesar de esas diferencias, todos cumplieron el control de la ruta DELETE y el criterio documental del README.

### H08-03 — Incidencias técnicas durante los ensayos

Se observaron correcciones de tests, regeneración de rutas y tipos, además de problemas reportados con comandos de OpenAPI.

Estas incidencias forman parte del registro de ejecución y no alteran retrospectivamente el criterio de evaluación.

## 8. Conclusión

La evaluación manual produjo **cinco cumplimientos de cinco ensayos válidos**, frente a una predicción inicial de tres.

El resultado respalda que la regla documental se cumplió consistentemente durante las ejecuciones observadas.

No permite afirmar que la presencia de `CLAUDE.md` sea la causa exclusiva de ese comportamiento.

Como siguiente mejora fuera del alcance del laboratorio, consideraría complementar la instrucción persistente con una verificación automática y repetir la medición con una línea base comparable.

## 9. Trazabilidad

- Prompts enviados: [`prompts.md`](../../prompts.md).
- Regla del harness: [`CLAUDE.md`](../../CLAUDE.md).
- Rama de entrega: `evals-rc`.
- Rama base oficial: `s8/start`.
- Commit base: `a883bd1749b4a8411735a1a34ec483bff60591e3`.

Los cinco commits experimentales se conservan en sus ramas locales y no forman parte de la rama de entrega.
