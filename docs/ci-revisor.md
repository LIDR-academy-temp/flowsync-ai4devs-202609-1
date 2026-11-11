# Revisor de código en CI

El trabajo `review` de [`.github/workflows/claude-review.yml`](../.github/workflows/claude-review.yml)
lanza la [acción oficial de Claude Code](https://github.com/anthropics/claude-code-action) sobre cada
cambio propuesto (`opened`, `synchronize`, `ready_for_review`, `reopened`) y publica los hallazgos como
comentarios del PR. Limites fijos: `--max-turns 40` y `timeout-minutes: 10`.

El workflow **no funciona todavía**: faltan los pasos de abajo, que no se pueden hacer desde el repositorio.

## Pasos manuales pendientes

1. **Instalar la Claude GitHub App** en el repositorio (desde Claude Code, `/install-github-app`, o
   desde <https://github.com/apps/claude>). La autenticación por defecto de la acción pasa por ella, y
   por eso el job lleva `id-token: write`.
2. **Crear el secreto del repositorio** (Settings → Secrets and variables → Actions → New repository
   secret) con el nombre exacto del camino elegido (ver [Credencial](#credencial)).
3. **Probar con un PR desde una rama del mismo repositorio**, no desde un fork. Mira que aparezcan
   comentarios en el PR y no solo en el log.
4. **Comprobar en esa primera ejecución lo que la documentación de la acción no confirma**:
   - que `--effort medium` lo acepta la acción (está documentado en el CLI de Claude Code, no en la
     acción, que solo reenvía `claude_args`);
   - que el alias `--model sonnet` se resuelve (los ejemplos oficiales usan nombres completos);
   - que `pull-requests: write` basta para comentar (los ejemplos oficiales no coinciden entre sí).
5. **Pendiente de tu parte: el archivo de calibración.** No existe ninguno en el repositorio, así que
   el prompt apunta a `CLAUDE.md`, `openspec/specs/` y `docs/adr/`. Si hay uno, añade su ruta al prompt.
6. Opcional: marcar el check como requerido en la protección de `main`. Se configura en GitHub.

No verificado en esta sesión: si la acción exige que el workflow ya exista en la rama por defecto
para ejecutarse en un PR, el PR que lo introduce podría no ejecutarlo. Se comprobará al abrirlo.

## En qué se va el dinero

- **Modelo:** `--model sonnet` con `--effort medium`. Es un alias: apunta al Sonnet vigente, no a una
  versión fija.
- **Por qué ese:** revisar un cambio es leer y razonar sobre un diff acotado, y no hace falta el modelo
  más caro para ello. `medium` y 40 turnos son el techo de trabajo por revisión; 10 minutos, el techo de
  reloj.
- **Cómo cambiarlo:** editar `--model` y `--effort` en `claude_args` del workflow. `--effort` admite
  `low`, `medium`, `high`, `xhigh`, `max` (según el modelo). Más esfuerzo o un modelo mayor encarece
  cada revisión; menos turnos la acota.
- **Qué más cuenta:** cada `synchronize` lanza una revisión nueva (la anterior se cancela, pero ya ha
  gastado). Por eso el job se omite en borradores. Los minutos de GitHub Actions se facturan aparte,
  y la acción usa además un modelo pequeño para clasificar comentarios en línea.
- **Precio:** no se copian cifras aquí, cambian.
  - API, por token: <https://platform.claude.com/docs/en/about-claude/pricing>
  - Suscripciones: <https://claude.com/pricing>

## Credencial

Hay dos caminos. Usa **uno**, no los dos. Cada uno tiene su entrada de la acción y su nombre de
secreto, y **no son intercambiables**: meter el token de suscripción en `anthropic_api_key` (o la clave
de API en `claude_code_oauth_token`) falla en la primera llamada sin explicar por qué. La documentación
oficial no recoge el mensaje, así que no se cita.

### 1. Suscripción (el que usa el workflow)

| | |
|---|---|
| Se genera | En local, con `claude setup-token` (abre el login en el navegador, imprime el token y no lo guarda) |
| Entrada de la acción | `claude_code_oauth_token` |
| Nombre del secreto | `CLAUDE_CODE_OAUTH_TOKEN` |

Consume la cuota de la suscripción de **la persona que lo generó**, no se factura por tokens. Dura un
año. Requiere un plan con Claude Code (Pro, Max, Ultra, Team o Enterprise según la documentación
actual; el `setup.md` del repositorio de la acción aún dice solo Pro y Max). Para compartir entre
repositorios la documentación recomienda la clave de API.

### 2. Clave de API de la consola

| | |
|---|---|
| Se genera | En la consola de Anthropic |
| Entrada de la acción | `anthropic_api_key` |
| Nombre del secreto | `ANTHROPIC_API_KEY` |

Se factura por tokens. Para usarla, cambia en el workflow la línea
`claude_code_oauth_token: ${{ secrets.CLAUDE_CODE_OAUTH_TOKEN }}` por
`anthropic_api_key: ${{ secrets.ANTHROPIC_API_KEY }}`.

## Cambios propuestos desde un fork

En un repositorio público, GitHub **no entrega los secretos** a las ejecuciones lanzadas por un PR de
fork. El revisor no puede autenticarse, así que el workflow omite esos PR (`if` sobre el repositorio de
origen): el job aparece como *skipped*, no en rojo, y esos cambios **no reciben revisión automática**.

- No lo "arregles" cambiando a `pull_request_target`: corre con los secretos del repositorio base, y
  combinado con un checkout del código del fork permite que un contribuyente externo ejecute lo que
  quiera con ellos. La propia documentación de la acción lo desaconseja.
- La acción además solo admite que la lancen usuarios con permiso de escritura. `allowed_non_write_users`
  lo salta, y la documentación lo marca como arriesgado: no lo uses en un repositorio público.
- Revisión de un fork: un mantenedor lo revisa a mano, o sube el cambio a una rama del propio
  repositorio, donde sí corre.
- En repositorios públicos el log de la ejecución también es público. La acción no vuelca la salida
  completa por defecto (`show_full_output`); déjalo así.
