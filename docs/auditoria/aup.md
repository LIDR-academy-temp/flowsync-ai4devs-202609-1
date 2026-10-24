## Parte A

# Expectativa

- La rama es por unidad de trabajo, no por petición. Antes de tocar código, mira en qué rama estás: si ya es una rama de trabajo —cualquiera que no sea `main` ni una `sN/*`—, sigue en ella en vez de crear otra. Solo desde `main` o desde una `sN/*` se crea una nueva (`git checkout -b feat/<slug>`). Nunca commitear directo en `main` ni en una `sN/*`. SI SE CUMPLE
- El commit sí es por petición: al cerrar cada una, usar la skill `/commit`.SI SE CUMPLE
- Un cambio que toque rutas, controladores, validadores o transformers de una capability se cierra en el mismo commit con el documento OpenAPI y el README de esa capability al día. El documento se construye en cada petición y no hay fichero que generar, así que lo que se commitea es el diff regenerado de `.adonisjs/`; el README es `docs/capabilities/<nombre>/README.md`. NO SE CUMPLE
- `gh pr create` (con una descripción completa de los cambios en el cuerpo del PR) y el pase del subagente `adversarial-reviewer` sobre ese PR van **una sola vez, al terminar la unidad de trabajo**, no al cerrar cada petición. El review adversarial es lo último, antes de dar la unidad por terminada. SI SE CUMPLE
- Cuando abras el PR, no repitas ese resumen en el chat: la sesión se va a perder, el PR no. Responde solo con la URL del PR. SI SE CUMPLE


# Auditoría de las reglas de proceso (CLAUDE.md)

Alcance: los 15 últimos commits (`b955a72`..`1980e20`), rama `auditoria-aup`. Solo análisis: no se ha modificado código.

| # | QUE PIDE LA REGLA | QUE SE REVISO PARA COMPROBAR | VEREDICTO | EVIDENCIA | QUE SE HARÍA CON ELLA |
|---|---|---|---|---|---|
| 1 | Antes de tocar código, seguir en la rama de trabajo actual y crear `feat/<slug>` solo desde `main` o `sN/*`. | `git branch -a --contains HEAD`, `git log --graph -15`, `git branch --show-current` | NO SE PUEDE COMPROBAR CON LA INFORMACIÓN ACTUAL | Git no guarda en qué rama se hizo cada commit; falta el reflog/historial de ramas de quien los hizo (hoy solo consta `auditoria-aup`, rama válida). | Convertirla en comprobación automática (hook que avise si se edita estando en `main` o `sN/*`). |
| 2 | Nunca commitear directo en `main` ni en una `sN/*`. | `git log --first-parent -15`, `git log --graph -15` | NO SE PUEDE COMPROBAR CON LA INFORMACIÓN ACTUAL | Los 15 commits son lineales sobre `s5/start` sin merges, pero un fast-forward es indistinguible de un commit directo; falta el registro de la rama original. | Convertirla en comprobación automática (pre-commit/pre-push que rechace `main` y `sN/*`). |
| 3 | Cerrar cada petición con un commit hecho con la skill `/commit`. | `git log -15 --format=%B`, `.claude/skills/commit/SKILL.md` | NO SE PUEDE COMPROBAR CON LA INFORMACIÓN ACTUAL | Los 15 siguen `tipo(scope): descripción`, pero nada en el commit prueba que se usó la skill; falta el transcript de sesión. | Convertirla en comprobación automática (commitlint sobre el formato; el uso de la skill no es verificable). |
| 4 | Si un cambio toca rutas, controladores, validadores o transformers, cerrar en el mismo commit con OpenAPI y README de la capability al día. | `git show --stat` de cada commit; la regla nace en `160fbc7` | SE CUMPLE | Tras `160fbc7`, solo `cbe9617` toca controladores y actualiza `docs/capabilities/tasks/README.md`; `4e03d1f` y `ea5db1f` son anteriores a la regla. | Convertirla en comprobación automática (CI que exija el README si el diff toca `backend/app/{controllers,validators,transformers}` o `start/routes.ts`). |
| 5 | Abrir el PR con `gh pr create` y descripción completa una sola vez, al terminar la unidad de trabajo. | `gh pr list --state all`, `git log --graph` | NO SE PUEDE COMPROBAR CON LA INFORMACIÓN ACTUAL | `gh` solo lista 6 PRs "auditoria: reglas de proceso + prompts" de alumnos; ninguno corresponde a estos commits y falta el historial de PRs del repo del que vienen. | Convertirla en comprobación automática (plantilla de PR + check que exija descripción). |
| 6 | Pasar el subagente `adversarial-reviewer` sobre el PR al terminar la unidad, como último paso. | `.claude/agents/adversarial-reviewer.md`, `gh pr list`, mensajes de commit | NO SE PUEDE COMPROBAR CON LA INFORMACIÓN ACTUAL | El revisor es de solo lectura y no deja rastro en git ni en los PRs; falta el log de la sesión o un comentario de PR con su informe. | Conservarla (el orden "último paso" no es automatizable); opcional exigir su informe como comentario del PR. |
| 7 | Al abrir el PR, responder en el chat solo con la URL. | Commits y `gh pr list` (no existe ninguna fuente del chat) | NO SE PUEDE COMPROBAR CON LA INFORMACIÓN ACTUAL | Es una regla sobre la conversación; falta el transcript de la sesión que abrió el PR. | Conservarla (conducta, no verificable por automatismo). |

## Notas

- La regla 4 solo es exigible desde `160fbc7`; antes de ella `4e03d1f` (transformer) y `ea5db1f` (rutas) no tenían obligación de tocar el README.
- En el árbol de trabajo hay cambios sin commitear en `backend/.adonisjs/`, `backend/.env.example` y `backend/database/schema.ts`; no afectan al veredicto de los 15 commits, pero conviene commitearlos o descartarlos.
- La regla de PR/review/URL se dividió en 3 filas (5, 6, 7) y la de rama en 2 (1, 2) para no mezclar reglas en una sola fila.


## Parte B

1. Realmente me equivoque en todas, las que creí que se estarían cumpliendo finalmente no lo hicieron y la que pensé que no se cumpliría al final si se cumple.
2. La regla del revisor adversarial, de momento no deja rastro de su ejecución más que posible texto en el chat. Como tal, habría que facultarlo para subir comentarios al PR y de esa forma se podría verificar su ejecución.
3. La regla de evitar el resumen del PR. Realmente, no aporta valor para todo los desarrollodores. Puede que alguno vea bien recibir el resumen y otro no, pero a fin de cuentas no es algo relevante en el proceso. Entonces la regla carece de valor y se debería eliminar.