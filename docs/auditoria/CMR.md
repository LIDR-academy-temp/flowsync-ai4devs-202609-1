# Auditoría de las reglas de proceso de `CLAUDE.md`

| # | Qué pide la regla | Qué se revisó | Veredicto | Evidencia | Qué harías con ella |
|---|---|---|---|---|---|
| 1 | Una rama nueva solo se crea desde `main` o una `sN/*` y se llama `feat/<slug>`. | `git branch -a`; `git reflog show auditoria-CMR` | no se cumple | `auditoria-CMR` no llevan el prefijo `feat/`. | dejarla (solo para cuándo la rama es creada por la IA) |
| 2 | Si ya estás en una rama de trabajo, sigues en ella en vez de crear otra. | `git reflog -n 15`; `git branch -a` | no se puede comprobar con la información disponible | Git no registra qué "unidad de trabajo" originó cada rama, así que no se puede saber si una rama nueva debería haber sido la misma. | dejarla |
| 3 | Nunca se commitea directamente en `main` ni en una `sN/*`. | `git reflog show s5/start-win`; `git branch -a --contains 3f65b8a` | no se cumple | `3f65b8a` se commiteó directamente en `s5/start-win` (reflog: "commit: chore(make)…"); los commits del 2026-10-27 se hicieron en `s4/end-hecho-por-mi`, que también encaja en `sN/*`. | dejarla (su no cumplimiento se debe a acciones personales por fuera del IDE) |
| 4 | Cada petición se cierra con un commit hecho con la skill `/commit`. | `git log -15 --format=%s` (comprobación del formato convencional); `.claude/skills/commit/SKILL.md` | no se puede comprobar con la información disponible | Los 15 mensajes cumplen `tipo(scope): …`, pero la skill no deja ninguna marca en el commit y git no sabe qué petición corresponde a cada commit. | dejarla |
| 5 | Si un cambio toca rutas, controladores, validadores o transformers, el OpenAPI (`.adonisjs/` regenerado) y `docs/capabilities/<nombre>/README.md` van en el mismo commit. | `git show --name-only` de los 15 commits; `git diff --ignore-cr-at-eol --stat` | se cumple | Desde que se introdujo la regla (`160fbc7`), el único commit que la activa es `cbe9617`, que incluye `docs/capabilities/tasks/README.md`; el `.adonisjs/` modificado del árbol solo cambia finales de línea, sin cambios de contenido. | dejarla |
| 6 | `gh pr create` se ejecuta una sola vez, al terminar la unidad, con una descripción completa de los cambios. | `gh pr list --state all`; `gh pr view 13 --json body,commits` | no se cumple | El cuerpo del PR #13 (`trazabilidad-CMR`) es solo "Ejercicio realizado por… Modulo4 – Ejercicio FlowSync", sin descripción de los cambios. | dejarla (su no cumplimiento se debe a acciones personales por fuera del IDE) |
| 7 | El subagente `adversarial-reviewer` revisa el PR como último paso antes de cerrar la unidad. | `gh pr view 13 --json comments,reviews`; `git log -15 --format=%b \| grep -i adversarial`; `.claude/agents/adversarial-reviewer.md` | no se puede comprobar con la información disponible | El subagente es de solo lectura y no publica nada: el PR #13 tiene 0 comentarios y 0 reviews, y los commits solo lo mencionan al configurarlo (`8f9e715`). | convertirla en una comprobación automática |
| 8 | Al abrir el PR, la respuesta en el chat es solo la URL del PR. | No hay artefacto en git ni en GitHub que registre las respuestas del chat. | no se puede comprobar con la información disponible | Las sesiones de Claude no se versionan, así que no hay rastro de lo que se respondió. | borrarla |

---

# Parte B: las 3 lineas

1. La regla en la que más te equivocaste. Compara tu expectativa inicial con el veredicto final y elige la que más se alejó de lo que pensabas. Si acertaste todas, indícalo y explica en una frase en qué te apoyaste para acertar. Si solo era una impresión, también conviene dejarlo por escrito.
	Rta: La #1 y la #3. Las acciones sobre el repositorio realizadas por fuera del IDE (por CLI) pueden llevar a cabo acciones que rompen las reglas dejadas en el harness.
2. Una regla que no se puede comprobar con la información disponible. Explica en una frase qué tendría que cambiar para poder verificarla. Puede ser reformularla, convertirla en una comprobación automática o aceptar que no deja una evidencia clara.
	Rta: La #4. Se podría reformular la skill para que deje una marca en el commit y detectar que el mismo fue realizado por este. 
3. La regla que eliminarías y por qué. Hay dos casos habituales: una regla que ya garantiza otra herramienta o una que nadie sigue y que tampoco aporta valor. Elige una y explica a cuál de los dos casos pertenece.	
	Rta: la #8. No aporta valor.	