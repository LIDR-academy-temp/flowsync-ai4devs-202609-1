# Auditoría — jnp

## Expectativa

Regla 1 - Rama por unidad de trabajo, nunca commitear en `main` ni en `sN/*`: Sí

Regla 2 - Commit por petición con la skill `/commit`: Sí

Regla 3 - Cambios en una capability se cierran en el mismo commit con OpenAPI y README al día: Sí

Regla 4 - PR y `adversarial-reviewer` una sola vez, al terminar la unidad de trabajo: No

Regla 5 - Al abrir el PR, responder solo con la URL: No

## Auditoría commits

Últimos 15 commits (`b955a72`..`1980e20`), comprobados solo con `git` y `gh` de lectura.

| Qué pide la regla | Qué se revisó | Veredicto | Evidencia | Qué haría con ella |
|---|---|---|---|---|
| Cada unidad de trabajo va en su propia rama de trabajo (nueva desde `main` o `sN/*` solo si hace falta) y nunca se commitea directo en `main` ni en `sN/*`. | `git log -15 --format='%h %p'`; `git branch -a --contains <hash>` (por cada commit); `git reflog` | No se puede comprobar con la información disponible | Historial lineal sin merges y los 15 commits están en `s5/start`, pero git no guarda la rama de origen de cada commit y el reflog solo cubre el clone de hoy. | Convertirla en una comprobación automática |
| Cada petición que se cierra termina en un commit hecho con la skill `/commit`. | `git log -15 --format=%s` y los trailers Co-Authored-By (`git log --format='%h %(trailers:key=Co-Authored-By,valueonly)'`); `ls .claude/skills` | No se puede comprobar con la información disponible | 15/15 asuntos con formato `tipo(scope): …`, pero git no registra la skill usada ni las peticiones; 3 commits (`b955a72`, `afc4b74`, `1980e20`) sin Co-Authored-By. | Convertirla en una comprobación automática |
| Si un cambio toca rutas, controladores, validadores o transformers de una capability, el mismo commit deja al día el documento OpenAPI (diff de `.adonisjs/`) y el README de esa capability. | `git log -15 --name-only --format='--- %h %s'` (ficheros de cada commit) y el orden del historial para ver en qué commit entra la regla (`160fbc7`) | Se cumple | `cbe9617` toca 3 controladores y actualiza `docs/capabilities/tasks/README.md`; `4e03d1f` (transformer sin README) y `ea5db1f` (`routes.ts` sin README) son anteriores a la regla (`160fbc7`). | Convertirla en una comprobación automática |
| El PR (con descripción completa) y el pase del `adversarial-reviewer` se hacen una sola vez, al terminar la unidad de trabajo, con el review como último paso. | `git log -15 --format='%h %p'` (merges de PR); `gh pr list --state all`; `ls .claude/agents` | No se puede comprobar con la información disponible | `gh pr list` solo muestra 3 PRs de otros alumnos (`auditoria-*`) y ninguno incluye estos commits; el pase del `adversarial-reviewer` no deja rastro en git ni en GitHub. | Convertirla en una comprobación automática |
| Tras abrir el PR, la respuesta en el chat es solo su URL, sin repetir el resumen de cambios. | Ningún comando aplicable: es comportamiento del chat. Solo `gh pr list --state all` para ver si hay un PR de estos commits cuyo cuerpo comparar. | No se puede comprobar con la información disponible | Las respuestas del chat no se guardan en git ni en el PR, y no existe ningún PR de estos commits; falta la transcripción de la sesión que abrió el PR. | Dejarla |


- **La regla en la que más me equivoqué:** Regla 1: esperaba que se cumpliera y el veredicto es que no deja evidencia, porque git no guarda en qué rama se hizo cada commit.
- **Una regla que no se puede comprobar con la información disponible:** Regla 1: habría que convertirla en una comprobación automática (protección de rama en GitHub o un hook pre-commit que bloquee commits en `main` y `sN/*`) para que el incumplimiento deje evidencia.
- **La regla que eliminaría y por qué:** Regla 5: es de las que nadie sigue y no aportan valor, una instrucción de estilo del chat que no deja ninguna evidencia comprobable.
