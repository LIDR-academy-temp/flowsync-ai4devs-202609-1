# Auditoría de reglas de proceso

## Expectativa inicial

Escrita antes de revisar el historial. No se modifica después.

| # | Regla | ¿Se cumple? |
|---|-------|-------------|
| 1 | Rama por unidad de trabajo; nunca commitear en `main` ni en `sN/*` | sí |
| 2 | Un commit por petición con la skill `/commit` | ni idea |
| 3 | Cambio en rutas/controladores/validadores/transformers → mismo commit con `.adonisjs/` y README de la capability | sí |
| 4 | `gh pr create` y `adversarial-reviewer` una sola vez, al terminar la unidad de trabajo | ni idea |
| 5 | Tras abrir el PR, responder solo con la URL | sí |

## Resultado de la auditoría

Contrastado con `git log -15` (de `4427afc` a `1980e20`, más `b955a72`) y con el estado actual del repo. Los 15 commits llegan por `upstream` y son alcanzables desde `s5/start` y `upstream/s4/end`, en historia lineal y sin merges.

| # | Qué pide la regla | Qué se revisó | Veredicto | Evidencia | Qué harías con ella |
|---|---|---|---|---|---|
| 1 | Trabajar en una sola rama por unidad de trabajo: seguir en la rama de trabajo actual y crear `feat/<slug>` solo si estás en `main` o en una `sN/*`. | `git branch -a --contains <hash>` para cada uno de los 15 commits; `git log -15 --format='%h P:%p'` | no se puede comprobar con la información disponible | Los 15 commits solo aparecen en `s5/start`, `upstream/s4/end` y `upstream/s5/start`, con historia lineal: falta saber en qué rama se creó cada commit antes de integrarse. | dejarla |
| 2 | No commitear nunca directamente en `main` ni en una rama `sN/*`. | `git branch -a --contains <hash>`; `git log -15 --format='%h P:%p'`; `ls .git/hooks`, `.husky`, `.github` | no se puede comprobar con la información disponible | De `4427afc` a `1980e20` todo está en `upstream/s4/end` sin merge commits: falta saber si se commiteó ahí o si llegó por fast-forward o rebase desde otra rama. Ningún hook ni CI lo impide. | convertirla en una comprobación automática |
| 3 | Hacer un commit al cerrar cada petición. | `git log -15 --stat` | no se puede comprobar con la información disponible | Las peticiones no quedan registradas en git: falta la relación entre petición y commit. | dejarla |
| 4 | Hacer los commits con la skill `/commit`. | `.claude/skills/commit/SKILL.md`; `git log -15 --format='%h %s'` | no se puede comprobar con la información disponible | La skill no deja ninguna marca propia en el commit. Además, `1980e20` (`docs: …`) no lleva el `(scope)` que pide la skill: falta un registro de qué commits se hicieron con ella. | convertirla en una comprobación automática |
| 5 | Si un commit toca rutas, controladores, validadores o transformers de una capability, debe incluir en ese mismo commit el `.adonisjs/` regenerado y el README de la capability actualizado. | `git show --stat cbe9617`; `git diff cbe9617^ cbe9617 --stat -- backend/.adonisjs`; `backend/.adonisjs/client/registry/schema.d.ts`; `git status --short backend/.adonisjs` | se cumple | `cbe9617` (el único commit posterior a la regla, `160fbc7`, que toca controladores) actualiza `docs/capabilities/tasks/README.md`. No le tocaba cambiar `.adonisjs/`, porque `schema.d.ts` referencia los controladores con `import(...)` y ese árbol está limpio. | convertirla en una comprobación automática |
| 6 | Abrir el PR con `gh pr create` y una descripción completa, una sola vez, al terminar la unidad de trabajo. | `gh pr list --repo LIDR-academy-temp/flowsync-ai4devs-202609-1 --state all`; `gh pr list --repo pablom555/flowsync-ai4devs-202609-1 --state all` | no se puede comprobar con la información disponible | `upstream` no devuelve PR y en `origin` solo están el #1 y el #2, de ramas ajenas a estos commits: falta el historial de PR del repo donde se crearon `4427afc`…`1980e20`. | dejarla |
| 7 | Pasar el subagente `adversarial-reviewer` sobre el PR una sola vez, como último paso antes de dar la unidad por terminada. | `.claude/agents/adversarial-reviewer.md`; `git log -15 --stat` | no se puede comprobar con la información disponible | El subagente existe y se actualizó en `8f9e715`, pero su ejecución no deja nada en git ni en los ficheros: falta un registro de sus pases. | dejarla |
| 8 | Después de abrir el PR, responder en el chat solo con su URL. | `git log -15`; ficheros del repo | no se puede comprobar con la información disponible | Ocurre en el chat, que no queda en git ni en los ficheros: falta la transcripción de las sesiones. | dejarla |

## Las tres líneas

1. **Donde más me equivoqué:** en la regla de la rama por unidad de trabajo (filas 1 y 2), donde puse "sí" y el historial no permite confirmarlo: los 15 commits son una historia lineal sin merges ni PRs, así que git no guarda en qué rama se hizo cada commit; mi "sí" era una suposición, no algo que supiera.
2. **Una regla que no se puede comprobar:** "no commitear directo en `main` ni en `sN/*`" (fila 2) se volvería comprobable si se convirtiera en una protección de rama en GitHub o en un hook que rechace el commit o el push desde esas ramas, porque hoy no existe ningún hook ni CI (`.git/hooks`, `.husky`, `.github`) y la regla solo se sostiene por buena voluntad.
3. **La regla que eliminaría:** "hacer los commits con la skill `/commit`" (fila 4), porque la skill no deja ninguna marca en el commit y lo que importa de ella, el formato `tipo(scope): descripción`, lo garantizaría mejor un hook `commit-msg` (caso "lo garantiza otra herramienta", aunque hoy ese hook todavía no existe, así que la quitaría del `CLAUDE.md` cuando exista).
