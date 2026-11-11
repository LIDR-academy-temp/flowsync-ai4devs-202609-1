# Auditoría de las reglas de proceso (CLAUDE.md)

Ventana: los últimos 15 commits (`git log -15`, de `b955a72` a `1980e20`, historia lineal) y el árbol actual (limpio). Solo lectura: no se ha modificado nada fuera de este archivo.

| # | Qué pide la regla | Qué se miró | Veredicto | Evidencia | Qué hacer |
|---|---|---|---|---|---|
| 1 | Antes de tocar código, mirar la rama y seguir en la de trabajo; crear una nueva solo desde `main` o `sN/*` | `git reflog`, `git branch -a --contains <sha>` | No se puede comprobar | Git no guarda en qué rama se hizo cada commit ni si el agente miró antes de tocar. El reflog local (`checkout: moving from s4/start to feat/tests-responsable-tarea`) es consistente, pero es local y caduca. Falta un hook que registre la rama o que bloquee la edición en `main`/`sN/*`. | Bajarla |
| 2 | Nunca commitear directo en `main` ni en una `sN/*` | `git branch -a --contains` de cada commit; `git log s5/start` | No se cumple | `afc4b74`, `21ce54d` y `1980e20` están directamente sobre `s5/start` (sin merge, sin rama de trabajo), y `b955a72` sobre `s4`. Son commits del staff del curso, no del alumno, pero la regla no distingue. Los 11 commits de trabajo también están dentro de `s5/start`, pero por traerse a la rama de partida, no se sabe si se hicieron allí. | Bajarla (protección de rama / hook `pre-commit`) |
| 3 | Un commit por petición, al cerrarla, usando la skill `/commit` | `git log -15 --format=%s`; `.claude/skills/commit/SKILL.md` | No se puede comprobar | 15/15 mensajes cumplen `tipo(scope): descripción` y 12/15 llevan `Co-Authored-By` de Claude, pero escribir el mismo formato a mano da igual resultado, y "por petición" no deja rastro. Falta algo que obligue a pasar por la skill (hook `commit-msg`). | Bajarla |
| 4 | Un cambio en rutas, controladores, validadores o transformers cierra en el mismo commit con OpenAPI, README de la capability y diff de `.adonisjs/` al día | `git show --stat` de `4e03d1f`, `ea5db1f`, `cbe9617`; `git show 160fbc7 -- CLAUDE.md` | No se cumple | Regla vigente solo desde `160fbc7`, y desde entonces solo `cbe9617` toca un controlador: actualiza README y anotaciones OpenAPI, pero **no incluye ningún diff de `.adonisjs/`**. `4e03d1f` (transformer, sin README) y `ea5db1f` (rutas, sin README) son anteriores a la regla. Si el `.adonisjs/` debía cambiar no se verificó: regenerarlo modificaría archivos. | Bajarla (comprobación en CI de contrato vs. código) |
| 5 | `gh pr create` con descripción completa, una sola vez, al terminar la unidad de trabajo | `gh pr list --state all --head <rama>`; `git branch -a` | No se puede comprobar | `feat/tests-responsable-tarea` (rama de trabajo de estos commits) no tiene PR en `gh`; no consta si la unidad está terminada. Las otras ramas sí tienen PR (p. ej. #18 de `harness-SGCA`, cuerpo de 1733 caracteres), pero fuera de la ventana. Falta una señal de "unidad terminada". | Dejarla |
| 6 | El pase de `adversarial-reviewer` va una sola vez sobre el PR, lo último antes de cerrar la unidad | `gh pr list ... --json comments`; `.claude/agents/adversarial-reviewer.md` | No se puede comprobar | El subagente es de solo lectura (Read/Grep/Glob) y no deja nada: el PR #18 tiene 0 comentarios. Falta que el hallazgo aterrice en el PR (workflow de CI que lo lance y publique). | Bajarla |
| 7 | Al abrir el PR, responder en el chat solo con la URL | Historial git y `gh` | No se puede comprobar | La conversación no se guarda en el repositorio. No hay rastro posible salvo la transcripción de la sesión. | Dejarla |

## Parte B

1. **La regla sobre la que me equivoqué:** Me equivoqué en todas.

2. **La regla que no se puede comprobar con lo que hay:** La 6, el pase del `adversarial-reviewer`. El subagente solo entrega sus hallazgos en el chat, sin dejar registro Dejaría rastro si se ejecutara en cada PR y publicara los hallazgos como comentario del PR: entonces «se pasó» y «qué encontró» quedan en GitHub.

3. **La regla que borraría, y por qué:**  No me queda claro si seda borrar alguna o más bien basta con ajustarlas.
