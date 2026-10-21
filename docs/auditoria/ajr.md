# Auditoría de las reglas de proceso

Esta auditoría compara las reglas de la sección «Reglas de proceso» de `CLAUDE.md` con los 15 últimos commits (`b955a72`..`1980e20`) y con el estado del repositorio el 2026-10-21, en la rama `auditoria-ajr`, creada desde `s5/start`.

Hay una fila por regla. Si una parte de la regla no se cumple, la regla entera no se cumple. Si no es así pero alguna parte no se puede comprobar, la regla entera no se puede comprobar.

| # | Qué pide la regla | Qué se revisó para comprobarla | Veredicto | Evidencia | Qué harías con ella |
|---|---|---|---|---|---|
| 1 | Se trabaja en una rama por unidad de trabajo. Si ya estás en una rama de trabajo, sigues en ella. Si no, creas una `feat/<slug>` desde `main` o desde una `sN/*`. Nunca se commitea directamente en `main` ni en una `sN/*`. | `git log --graph --oneline -15` y `git log --merges`, que muestran si la historia tiene ramas y merges. `git branch -a --contains <sha>`, que dice en qué ramas está cada commit. `git branch -a` y `git reflog`, que muestran las ramas y los cambios de rama. | no se cumple | Los 15 commits entraron directamente en `s4/end` y `s5/start`, sin merges y con la historia lineal. `afc4b74` y `b955a72` lo dicen en su propio mensaje: van «en la rama de partida». | ~~Borrarla. Ni un solo commit lo cumple; no parece que el equipo quiera esto demasiado.~~ Después de pedir opinión, automatizarla, porque es valiosa y fácil de automatizar. |
| 2 | Al cerrar cada petición se hace un commit, y se hace con la skill `/commit`. | `git log -15 --stat` muestra el contenido de cada commit. `.claude/skills/commit/SKILL.md` muestra qué hace la skill. Los asuntos de `git log -15 --format=%s` y sus trailers `Co-Authored-By` muestran cómo se hizo cada commit. | no se puede comprobar con la información disponible | Los commits no dicen de qué petición salen ni si se usó la skill. Haría falta el registro de las peticiones y de las sesiones. | Dejarla. Aunque a posteriori no se pueda comprobar, durante la petición sí tiene sentido. ~~No veo forma de automatizarla~~. |
| 3 | Si un cambio toca rutas, controladores, validadores o transformers de una capability, el mismo commit lleva el diff regenerado de `.adonisjs/` y el README de `docs/capabilities/<nombre>/` al día. | `git show --stat` de los commits que tocan `backend/start/routes.ts`, `app/controllers`, `app/validators` o `app/transformers`. `backend/.adonisjs/client/data.d.ts`, para ver si los tipos de los transformers se infieren. | no se cumple | `4e03d1f` cambia `backend/app/transformers/task_transformer.ts` y no actualiza el README de `tasks`. | Dejarla + automatizarla. La regla para intentar adelantarse. La automatización al pipeline para verificar de forma determinista si se cumplió o detectar pronto si hay desviación. |
| 4 | Al terminar la unidad de trabajo, y solo una vez, se abre el PR con `gh pr create` y una descripción completa. Lo último antes de darla por terminada es pasar el subagente `adversarial-reviewer` sobre ese PR. | `gh pr list --state all` en `origin` y en `upstream` lista los PRs. `git log --merges` busca merges de PR. `.claude/agents/adversarial-reviewer.md` muestra cómo trabaja el agente. | no se puede comprobar con la información disponible | Ningún PR de este repo corresponde a los 15 commits, y el revisor, que es de solo lectura, no deja rastro. Los PR originales podrían estar en otro repo del que este es copia. | Automatizar el pase del revisor comentando en el PR. |
| 5 | Después de abrir el PR, en el chat solo se responde con su URL, sin repetir el resumen. | Nada en el repo: la regla trata de cómo responde el asistente. | no se puede comprobar con la información disponible | Haría falta el historial de las sesiones de Claude, que no está en el repositorio. | Dejarla. Tiene sentido durante la sesión, pero no es posible comprobarlo después. No es tan importante como para intentar automatizarla y no veo forma de hacerlo tampoco. |

## Notas al margen

Estas notas no son reglas de proceso, pero salieron durante la revisión.

- `CLAUDE.md` dice que la capability `tasks` «no tiene ni un test». Ya no es verdad: `4427afc` añadió `backend/tests/functional/tasks/assignee.spec.ts`.
- La tabla de rutas de `CLAUDE.md` solo lista las de `auth`. No recoge las de `tasks` ni la del documento OpenAPI que añadió `ea5db1f`.
- Sobre la regla 3:
  - `4e03d1f` y `ea5db1f` son anteriores a la regla (`160fbc7`). El único commit posterior que toca código de una capability, `cbe9617`, sí la cumple.
  - Es correcto que `cbe9617` no traiga diff de `.adonisjs/`. Solo añade decoradores OpenAPI, y `data.d.ts` infiere los tipos de los transformers (`InferData<...>`).

## Parte B

**La regla en la que más te equivocaste**

La primera, que dije que sí se cumplía porque no contaba con los commits de la academia. Fue solo una impresión.

**Una regla que no se puede comprobar con la información disponible**

La 4, si cambiamos a que el revisor sea automatizado mediante un job de CI o en pipeline, entonces podrá dejar rastro y evidencia y escribir comentarios en el PR.

**La regla que eliminarías y por qué**

La 3 si ya está automatizada. Es una regla que ya garantiza la automatización.
