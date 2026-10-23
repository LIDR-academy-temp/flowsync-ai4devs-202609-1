# Auditoría de las reglas de proceso

Contraste de las «Reglas de proceso» de `CLAUDE.md` con los últimos 15 commits (`b955a72`..`1980e20`) y con el estado del repo en la rama `auditoria-MAJ` a 2026-10-23.

| Qué pide la regla | Qué se miró | Veredicto | Evidencia | Qué haría |
|---|---|---|---|---|
| Cada unidad de trabajo va en su rama; solo si se parte de `main` o `sN/*` se crea una nueva, llamada `feat/<slug>`. | `git branch -a`; `git branch -a --contains <sha>`; `gh pr list --state all` (upstream) | no se cumple | `auditoria-MAJ` y las 5 PR `auditoria-*` salen de `s5/start` sin `feat/`; de los 15 commits no queda ninguna rama `feat/*`. | bajarla |
| Nunca se commitea directo en `main` ni en `sN/*`. | `git log main --first-parent`; `git log -15 --format='%h %p'`; `git log -15 --merges` | no se puede comprobar con lo que hay | `main` solo tiene `df31be3`; los 15 commits están en `s5/start` y `upstream/s4/end` con historia lineal, y un commit directo no se distingue de un fast-forward. | bajarla |
| Cada petición se cierra con su propio commit, hecho con `/commit`. | `git log -15`; `.claude/skills/commit/SKILL.md` | no se puede comprobar con lo que hay | Ni git ni el mensaje registran la petición de origen ni si se usó `/commit`. | bajarla |
| Si se tocan rutas, controladores, validadores o transformers, el mismo commit actualiza el OpenAPI (`.adonisjs/`) y el README de la capability. | `git log -15 --stat`; `git show --stat cbe9617`; `git log -- backend/.adonisjs` | se cumple | Tras `160fbc7` solo `cbe9617` toca controladores: trae decoradores y `docs/capabilities/tasks/README.md`, y no `.adonisjs/` porque no cambia rutas (`4e03d1f` es anterior a la regla). | bajarla |
| Al cerrar la unidad: una PR con descripción completa y, al final, el `adversarial-reviewer`. | `gh pr list` (upstream y fork); `.claude/agents/adversarial-reviewer.md` | no se puede comprobar con lo que hay | No hay PRs de estos commits y el revisor, de solo lectura, no deja rastro. | bajarla |
| Al abrir la PR, en el chat solo la URL. | `CLAUDE.md` (Reglas de proceso) | no se puede comprobar con lo que hay | Afecta solo al chat, que no queda guardado en el repo ni en la PR. | dejarla |

## Parte B: las tres líneas

**La regla en la que más te equivocaste.**

**Expectativa VS Veredicto**

> Cada unidad de trabajo va en su propia rama, que se crea como feat/<slug> solo cuando se parte de main o de una sN/*.
 
Expectativa: Si se cumple.
Realidad: No se cumple.

> No se commitea nunca directamente en main ni en una rama sN/*.

Expectativa: Si se cumple.
Realidad: No se puede comprobar.

> Cada petición se cierra con su propio commit, hecho con la skill /commit.

Expectativa: Si se cumple.
Realidad: No se puede comprobar.

> Si un commit toca rutas, controladores, validadores o transformers de una capability, ese mismo commit actualiza su OpenAPI (el diff de .adonisjs/) y docs/capabilities/<nombre>/README.md.

Expectativa: No lo se.
Realidad: Si se cumple.

> Al terminar la unidad de trabajo se abre una sola PR con descripción completa y, como último paso, se pasa sobre ella el subagente adversarial-reviewer.

Expectativa: Si se cumple.
Realidad: No se puede comprobar.

> Al abrir la PR, la respuesta en el chat es solo la URL, sin repetir el resumen.

Expectativa: Si se cumple.
Realidad: No se puede comprobar.

**la que más se alejó de lo que pensabas.**

> Cada unidad de trabajo va en su propia rama, que se crea como feat/<slug> solo cuando se parte de main o de una sN/*.

Es tan común añadir feat/ o feature/ al nombrar una rama que ni siquiera me había puesto a pensar en ello. Para mí es algo evidente.

**Una regla que no se puede comprobar con la información disponible.**

> Cada petición se cierra con su propio commit, hecho con la skill /commit.

Para poder verificarla podríamos decir a la skill que añadiese algún indicador identificativo en el commit, un prefijo o sufijo en el comentario, con otro nombre de usuario diferente o cualquier otra alternativa.

Para este caso en particular, Claude propondría lo siguiente:

- **Separar la regla en dos comprobaciones:** que cada petición tenga su propio commit, y que ese commit se haga con `/commit`.
- **Que el commit lo diga:** la skill `/commit` añade al mensaje los *trailers* `Request-Id: <id>` y `Committed-With: /commit`.
- **Que el harness registre las peticiones**, con hooks en `.claude/settings.json`:
  - `UserPromptSubmit` asigna un `Request-Id` a cada petición y la anota en un registro (`.claude/requests.log`).
  - `PreToolUse` sobre `git commit` bloquea los commits que no llevan esos *trailers*.
  - `Stop` impide cerrar un turno que ha modificado ficheros sin un commit con el `Request-Id` actual.
- **Verificar después:** un script o un job de CI cruza `git log --format='%(trailers:key=Request-Id,valueonly)'` con el registro. Si falta el *trailer*, el commit no se hizo con `/commit`; si un id se repite, una petición se partió en varios commits; si una petición con cambios no tiene id en git, quedó sin commit.
- **Límites:**
  - Los *trailers* se pueden escribir a mano fuera de Claude.
  - El registro es local, así que hay que publicarlo para poder auditar a otras personas.
  - Hay que definir «petición» como la que modifica ficheros.

**La regla que eliminarías y por qué.**

> El commit sí es por petición: al cerrar cada una, usar la skill /commit.

Hacer commit no es una tarea compleja que tenga asociado un coste grande. Una petición podría considerarse cerrada al aprovarse el PR y mergear el código a la rama principal.

