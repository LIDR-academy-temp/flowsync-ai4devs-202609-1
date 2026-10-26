# Auditoría de las reglas de proceso

Contraste de las reglas de proceso de `CLAUDE.md` (líneas 130-134) contra los últimos 15 commits del repositorio (`b955a72` a `1980e20`) y el estado del árbol en la rama `auditoria-sml`.

| # | Qué pide la regla | Qué se revisó para comprobarla | Veredicto | Pruebas | ¿Qué harías con ella? |
|---|---|---|---|---|---|
| 1 | Cada unidad de trabajo va en su propia rama, que sale de `main` o de una `sN/*`, y nunca se commitea directamente sobre esas ramas base. | `git branch -a --contains <sha>` por commit; `git ls-remote --heads upstream`; `git log --merges`; `git reflog`; `git branch --show-current` | no se puede comprobar con la información disponible | Falta saber en qué rama se hizo cada commit: la historia se reescribió (`4427afc` es más antiguo que su padre `b955a72`, y `5cb8726`, citado en `4e03d1f`, ya no existe), no hay merges y no queda ninguna `feat/*`. | convertirla en una comprobación automática |
| 2 | Cada petición se cierra con su propio commit, generado con la skill `/commit`. | `git log -15 --format='%s'` contrastado con `.claude/skills/commit/SKILL.md`; `git log --format='%(trailers:key=Co-Authored-By)'` | no se puede comprobar con la información disponible | Git no guarda ni qué petición originó cada commit ni si se usó la skill; solo se ve el formato, que siguen 14 de 15 (`1980e20` no lleva scope). | convertirla en una comprobación automática |
| 3 | Si un commit toca rutas, controladores, validadores o transformers de una capability, ese mismo commit trae el `.adonisjs/` regenerado y el README de la capability actualizado. | `git log -15 --name-only`; `git log --diff-filter=A -- docs/capabilities/tasks/README.md`; `git log -S` sobre `CLAUDE.md`; `backend/.adonisjs/client/registry/schema.d.ts` | se cumple | El único commit posterior a la regla que toca controladores, `cbe9617`, actualiza en el mismo commit `docs/capabilities/tasks/README.md`; no trae diff de `.adonisjs/`, coherente con que el registro deduce los tipos de los métodos del controlador (`schema.d.ts:101-102`). | convertirla en una comprobación automática |
| 4 | Al terminar la unidad de trabajo se abre un único PR con una descripción completa, y lo último es pasarle el revisor adversarial. | `gh pr list --state all` en `upstream` y en `origin`; mensajes de los 15 commits | no se puede comprobar con la información disponible | Ningún PR ni mensaje de commit cubre estos 15 commits, y el pase del `adversarial-reviewer` no queda registrado ni en git ni en GitHub. | dejarla |
| 5 | Al abrir el PR, la respuesta en el chat es solo su URL, sin repetir el resumen. | Ninguno: no hay archivo ni comando que la recoja. | no se puede comprobar con la información disponible | La regla trata sobre la respuesta en el chat, que no deja rastro en el repositorio ni en GitHub. | dejarla |

## Justificación de la última columna

- **Regla 1:** un hook `PreToolUse` en `.claude/settings.json` o un `pre-commit` que rechace commitear en `main` o en una `sN/*`, más protección de esas ramas en GitHub. Hoy no deja rastro, y bloquearlo de forma automática es fácil.
- **Regla 2:** un hook `commit-msg` que valide el formato `tipo(scope): descripción`, que es la única parte de la regla que se puede ver. Que haya un commit por petición sigue sin poder comprobarse.
- **Regla 3:** un check en CI que, si el diff toca `start/routes.ts`, `app/controllers`, `app/validators` o `app/transformers`, exija cambios en `docs/capabilities/<x>/README.md`. Además, que regenere `.adonisjs/` y falle si queda diff pendiente. Hoy se cumple, pero depende de que nadie se olvide.
- **Reglas 4 y 5:** son instrucciones de flujo para el agente y tienen sentido: el PR es lo que queda cuando la sesión se pierde. Automatizarlas no compensa, porque sus partes clave (la revisión al final, lo que se responde en el chat) no dejan rastro que se pueda comprobar.

------------------------------------------------------------------------------------------------------------------
### La regla en la que más te equivocaste.
 En la mayoria
### Una regla que no se puede comprobar con la información disponible
En la segunda con la información del git no se puede saber si se utilizó la skill o se hizo de otra manera (manual o con claude)
### La regla que eliminarías y por qué.
La regla nro 3 la quitaría del Claude.md y la metería en la pipeline ya que se trata de una accion que siempre se ha de ejecutar. Y además tiene que ser visible a todo el equipo