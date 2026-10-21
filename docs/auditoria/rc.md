# Auditoría de las reglas de proceso de FlowSync (RC)

## Alcance

- **Rama:** `auditoria-rc` (sin commits propios; apunta al mismo commit que `s5/start`, `1980e20`).
- **Ventana:** los últimos 15 commits (`git log -15`), de `b955a72` a `1980e20`, y el estado actual de los archivos del repositorio.
- **Reglas auditadas:** solo las cinco de la sección «Reglas de proceso» de `CLAUDE.md`.
- **Método:** solo lectura. No se corrigió ni se modificó nada de lo auditado.

## Expectativas iniciales

Registradas antes de consultar el historial y sin modificar después.

| Regla | Expectativa |
|---|---|
| R01 Gestión de ramas | Ni idea |
| R02 Commits por petición | Sí |
| R03 Documentación sincronizada | No |
| R04 PR y revisión adversarial | Sí |
| R05 Respuesta final | Ni idea |

## Tabla de auditoría

| Regla | Qué pide la regla | Qué se revisó | Veredicto | Evidencia | Qué haría con ella |
|---|---|---|---|---|---|
| R01 | Seguir en la rama de trabajo si ya es una; crear rama solo desde `main` o `sN/*`; nunca commitear directo en `main` ni en `sN/*`. | `git branch -a`, `git branch -a --contains <sha>` de los 15 commits, `git log`. | No se puede comprobar con la información disponible | Los 15 commits son lineales y ya están dentro de `s5/start` y `origin/s5/start`; un fast-forward o un merge no deja rastro de la rama donde se hicieron. *Inferencia:* los tres commits de `LIDR*` (`b955a72`, `afc4b74`, `1980e20`) parecen preparación de la rama de partida, no un incumplimiento. | Convertirla en comprobación automática (hook `PreToolUse` sobre `git commit`/`git push` que falle en `main` o `sN/*`, o protección de rama). |
| R02 | Un commit por petición, usando la skill `/commit`. | `git log -15` (mensajes y trailers) y `.claude/skills/commit/SKILL.md`. | No se puede comprobar con la información disponible | Los 15 mensajes siguen `tipo(scope): …` y 12 llevan `Co-Authored-By: Claude`; los 3 de LIDR/humanos no (`b955a72`, `afc4b74`, `1980e20`). El formato lo puede producir la skill o una persona, y no hay registro de las peticiones ni de la invocación de `/commit`. | Dejarla (la skill ya la materializa; la granularidad «por petición» no se puede automatizar). |
| R03 | Si un cambio toca rutas, controladores, validadores o transformers, el mismo commit actualiza el OpenAPI (diff de `.adonisjs/`) y `docs/capabilities/<x>/README.md`. | `git log -15 --name-status`, `git show 160fbc7` (cuándo nace la regla), `git show --format=fuller --name-status cbe9617`, `docs/capabilities/tasks/README.md`. | No se puede comprobar con la información disponible | Solo `cbe9617` toca esos archivos después de `160fbc7`: modifica tres controladores, `backend/config/openapi.ts` y `docs/capabilities/tasks/README.md`, pero no cambia `.adonisjs/`; no se puede saber si debía regenerarse. `4e03d1f` y `ea5db1f` son anteriores a la regla. | Convertirla en comprobación automática (CI o hook: si el diff toca `routes`, `controllers`, `validators` o `transformers`, verificar que los artefactos generados siguen sincronizados con su fuente y que el README de la capability está actualizado). |
| R04 | `gh pr create` con descripción completa y pase de `adversarial-reviewer`, una sola vez al terminar la unidad; el review es lo último. | `gh pr list --state all`, `gh pr view 1`, `.claude/agents/adversarial-reviewer.md`, historial. | No se puede comprobar con la información disponible | El único PR del repo es el #1 (`pablom555`, `auditoria-prm` → `s5/start`), de otra auditoría y no de estos commits. El agente existe y es de solo lectura, pero un pase del revisor no deja rastro en Git; falta la sesión del agente o un registro del review. | Convertirla en comprobación automática (check de CI que exija PR con cuerpo no vacío y un registro del review, por ejemplo una etiqueta o un comentario). |
| R05 | Tras abrir el PR, responder en el chat solo con la URL. | Historial, PRs y archivos del repositorio. | No se puede comprobar con la información disponible | La respuesta del chat no se guarda en Git ni en archivos; sin transcript de la sesión no hay evidencia, y no hay ningún PR de esta unidad con el que contrastarla. | Borrarla (preferencia de comunicación que no aporta valor suficiente como control del proceso de desarrollo). |

### Evidencia verificada manualmente: `cbe9617`

Comando: `git show --format=fuller --name-status cbe9617`

```
commit cbe9617f3ad81d211f4f4fe2632ca2cac3d9e8b8
Author:     Earvin Saúl Pérez Ramos <earhackerdem@gmail.com>
AuthorDate: Thu Aug 27 12:23:19 2026 -0600
Commit:     LIDR Academy <direccion.ai4devs@lidr.co>
CommitDate: Thu Aug 27 12:23:19 2026 -0600

    docs(tasks): el documento OpenAPI recoge el contrato que la spec exige
    ...
    Co-Authored-By: Claude Opus 5 <noreply@anthropic.com>

M	backend/app/controllers/task_due_dates_controller.ts
M	backend/app/controllers/task_statuses_controller.ts
M	backend/app/controllers/tasks_controller.ts
A	backend/app/openapi/schemas.ts
M	backend/config/openapi.ts
M	backend/package.json
M	docs/capabilities/tasks/README.md
```

El mismo commit toca controladores, el documento OpenAPI (`config/openapi.ts`, `app/openapi/schemas.ts`) y el README de la capability, pero ningún archivo de `.adonisjs/`.

## Reflexiones finales

B1: R03 — Pensaba que no se cumplía la sincronización documental, pero al revisar cbe9617 comprobé que sí se actualizó el README y la documentación OpenAPI. No pude demostrar si los archivos generados debían modificarse. Mi expectativa de incumplimiento no quedó confirmada.

B2: R02 — No se puede comprobar que cada petición terminara con un commit utilizando /commit. Para verificarlo haría falta conservar un registro de las peticiones y de la invocación de la skill, vinculado a cada commit.

B3: R05 — Eliminaría la regla de responder únicamente con la URL del PR. La considero una preferencia de comunicación que no deja evidencia en Git y aporta poco valor como control del proceso de desarrollo.
