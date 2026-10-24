# Auditoría de las reglas de proceso

- **Fecha:** 2026-10-24
- **Alcance:** los últimos 15 commits (`b955a72`..`1980e20`) contrastados con la sección «Reglas de proceso» de `CLAUDE.md`.
- **Criterio de filas:** una fila por regla. Las viñetas que mezclan varias reglas se han separado.
- **Limitación general:** git no registra en qué rama se hizo cada commit, y el reflog solo cubre la actividad local reciente.

| # | Regla (resumen) | Qué se revisó | Veredicto | Evidencia | Qué haría |
|---|---|---|---|---|---|
| 1 | Antes de tocar código hay que mirar la rama y, si ya es una rama de trabajo (ni `main` ni `sN/*`), seguir en ella. | `git reflog -30`; `git branch -a -vv` | No se puede comprobar | El reflog solo cubre actividad local reciente (feat/harness-config, trazabilidad-AA…); los 15 commits no dicen en qué rama se hicieron ni si se consultó antes. | Dejarla |
| 2 | Solo desde `main` o `sN/*` se crea una rama nueva, con `git checkout -b feat/<slug>`. | `git branch -a -vv`; `git reflog` | No se puede comprobar | Las ramas locales `auditoria-AA`, `trazabilidad-AA` y `spec-viva-AA` no usan el prefijo `feat/`, pero no pertenecen a los 15 commits; falta el origen de cada rama de los commits auditados. | Convertirla en comprobación automática (hook o CI sobre el nombre de rama) |
| 3 | Nunca se commitea directo en `main` ni en una `sN/*`. | `git log -15 --pretty='%h %p'`; `git branch -a -vv` | No se puede comprobar | Los 15 commits forman una cadena lineal dentro de `s5/start` sin merges ni PR asociado, lo que es compatible con commits directos en una `sN/*`, pero git no guarda la rama de origen; habría que mirar el historial de PRs/push del remoto. | Convertirla en comprobación automática (protección de rama en el remoto) |
| 4 | El commit se hace por petición, usando la skill `/commit`. | `.claude/skills/commit/SKILL.md`; `git log -15 --pretty=%s` | No se puede comprobar | La skill existe y 15/15 asuntos siguen `tipo(scope): descripción`, pero el commit no deja rastro de haber usado la skill ni de a qué petición corresponde. | Dejarla |
| 5 | Un cambio en rutas, controladores, validadores o transformers cierra en el mismo commit con OpenAPI y README de la capability al día. | `git show --stat` de cada commit; `git log -15 --name-only` | Se cumple | Desde que la regla existe (`160fbc7`) solo `cbe9617` toca controladores, y actualiza `docs/capabilities/tasks/README.md` y las anotaciones OpenAPI. Antes de la regla, `4e03d1f` (transformer) no tocó README ni OpenAPI y `ea5db1f` (rutas) no tocó el README de tasks; ambos son anteriores y no cuentan. | Convertirla en comprobación automática (CI que falle si cambia `controllers/validators/transformers/routes` sin tocar `docs/capabilities/`) |
| 6 | `gh pr create` con descripción completa va una sola vez, al terminar la unidad de trabajo. | `gh pr list --state all` | No se puede comprobar | Los únicos PR (#1–#7) son de otros alumnos con título «auditoria: reglas de proceso + prompts»; ninguno corresponde a los 15 commits y no consta si la unidad de trabajo terminó. | Dejarla |
| 7 | El pase de `adversarial-reviewer` sobre el PR va una sola vez y es lo último antes de dar la unidad por terminada. | `.claude/agents/adversarial-reviewer.md`; `git log`; `gh pr list` | No se puede comprobar | El agente existe y se afinó en `8f9e715`, pero una ejecución no deja rastro en git ni en el PR; faltaría el registro del pase (comentario del PR o transcripción). | Convertirla en comprobación automática (paso de CI o checklist obligatoria en la plantilla de PR) |
| 8 | Al abrir el PR, no repetir el resumen en el chat: responder solo con la URL. | — (sin comando posible) | No se puede comprobar | Es una regla de comportamiento en la conversación; no hay transcripciones de PR ni de sesiones en el repo. | Dejarla |

## Resumen

- Se cumple: 1 (regla 5).
- No se cumple: 0.
- No se puede comprobar: 7 (reglas 1, 2, 3, 4, 6, 7 y 8).

La mayoría de reglas son de proceso y no dejan huella en git. Por eso se propone convertir las reglas 2, 3, 5 y 7 en comprobaciones automáticas.


## Mis 3 lineas 

 1- El commit se hace por petición, usando la skill /commit: Creia que al estar en las intrucciones y ser un skill, lo hacia, pero evidentemente lo puede comprobabar.

 2- El pase de adversarial-reviewer sobre el PR va una sola vez y es lo último antes de dar la unidad por terminada: El subagente deberia dejar un registro de ejecucion dentro del PR, para fines de auditoria
    
 3- Nunca se commitea directo en main ni en una sN/*. Creo que esta regla no es necesaria, p[odria controlarse directamente desde los accesos del repo.