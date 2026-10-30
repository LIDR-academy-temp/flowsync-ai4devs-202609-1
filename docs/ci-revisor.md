# Revisor automático en CI

[`.github/workflows/claude-review.yml`](../.github/workflows/claude-review.yml) lanza Claude Code
sobre cada pull request (al abrirlo, al empujar commits nuevos, al reabrirlo o al sacarlo de
borrador). Claude publica un comentario en línea por hallazgo y un comentario de resumen en el propio
PR. No modifica archivos, no hace commits y no aprueba ni bloquea el merge: los comentarios son
información para quien revisa, no una puerta.

Su caja de herramientas es esta: `Read`, `Grep` y `Glob` para leer el repositorio, `gh pr diff` y
`gh pr view` para leer el cambio, y `gh pr comment` más el comentario en línea de la acción para
publicar. El prompt le prohíbe redirigir salida a ficheros, porque algo como
`gh pr diff > /tmp/x` no encaja con ninguna herramienta permitida y cada denegación le cuesta un
turno.

Lo primero que hace el revisor es leer [`REVIEW.md`](../REVIEW.md), el archivo de calibración. Ahí
está qué cuenta como grave, el tope de sugerencias, dónde no reportar y qué evidencia se le exige.
Para ajustar el revisor se edita ese archivo, no el prompt del workflow.

## Pasos manuales pendientes

Mientras no se hagan, el workflow existe pero no revisa nada.

1. **Crear el secreto con la credencial**, en *Settings → Secrets and variables → Actions →
   Repository secrets*. Cuál y con qué nombre se explica en [La credencial](#la-credencial). Si
   el secreto no existe, `${{ secrets.… }}` se evalúa a cadena vacía y la acción falla al arrancar
   por falta de credencial.
2. **Activar Actions si el repositorio es un fork.** GitHub desactiva los workflows en los forks
   hasta que alguien entra en la pestaña *Actions* y los habilita.
3. **Comprobar que el `GITHUB_TOKEN` puede escribir en PRs.** El job pide `pull-requests: write`.
   En una cuenta personal basta con declararlo. Si el repositorio pertenece a una organización que
   limita el token a solo lectura (*Settings → Actions → General → Workflow permissions*), ese
   permiso se ignora y los comentarios fallan.
4. **Abrir un PR de prueba y leer la primera ejecución.** Es la única forma de ver que credencial,
   permisos y comentarios funcionan juntos. Quien abre el PR necesita permiso de escritura en el
   repositorio: la acción se niega a ejecutarse para usuarios sin él.

No hace falta instalar la GitHub App de Claude. El workflow usa el `GITHUB_TOKEN` del propio job,
que caduca al terminar y no tiene más permisos que los que declara el job (`contents: read` y
`pull-requests: write`). Por eso los comentarios salen firmados por `github-actions[bot]` y no por
`claude[bot]`.

## La credencial

Hay dos caminos, y **no son intercambiables**: cada credencial va en su propia entrada de la acción
y bajo su propio nombre de secreto.

### 1. Suscripción: `claude setup-token`

- **Cómo se obtiene:** en local, con una suscripción Pro o Max, ejecuta `claude setup-token`. Abre
  el navegador para autorizar y escribe un token de larga duración en la terminal.
- **Nombre del secreto:** `CLAUDE_CODE_OAUTH_TOKEN`.
- **Entrada de la acción:** `claude_code_oauth_token`. Es la que el workflow trae configurada:
  ```yaml
  claude_code_oauth_token: ${{ secrets.CLAUDE_CODE_OAUTH_TOKEN }}
  ```
- **Qué se gasta:** no hay factura por token. Cada revisión consume de los límites de uso de tu
  plan, los mismos que gastas usando Claude Code a mano.

### 2. Clave de API de la consola

- **Cómo se obtiene:** en [console.anthropic.com](https://console.anthropic.com), *API keys →
  Create key*. Empieza por `sk-ant-`.
- **Nombre del secreto:** `ANTHROPIC_API_KEY`.
- **Entrada de la acción:** `anthropic_api_key`. Para usarla, sustituye en el workflow la línea de
  `claude_code_oauth_token` por:
  ```yaml
  anthropic_api_key: ${{ secrets.ANTHROPIC_API_KEY }}
  ```
- **Qué se gasta:** se factura por token a la organización de la consola dueña de la clave.

### No los cruces

Un token de `claude setup-token` metido en `anthropic_api_key`, o una clave `sk-ant-` en
`claude_code_oauth_token`, **falla en la primera llamada al modelo con un error de autenticación que
no dice que el problema sea el tipo de credencial**: el secreto existe, la acción arranca y la
llamada se rechaza. Si ves un fallo de autenticación con el secreto recién creado, lo primero que
hay que mirar es que el nombre del secreto y la entrada de la acción sean del mismo camino.

Deja configurada una sola de las dos entradas.

## En qué se va el dinero

Cada ejecución es una sesión de Claude Code que lee el diff, abre archivos y escribe comentarios.
El gasto depende del modelo, del esfuerzo y de cuántos turnos dure. Todo eso se fija en
`claude_args`:

```yaml
claude_args: >-
  --model sonnet --effort medium --max-turns 40
```

- **Modelo: `sonnet`.** Es el alias del Sonnet más reciente. Revisar un diff es sobre todo leer y
  juzgar, y Sonnet lo hace bien por bastante menos que Opus, y con más criterio que Haiku. Como se
  ejecuta en cada push de cada PR, el precio por ejecución es lo que más pesa.
- **Esfuerzo: `medium`.** Limita cuánto razona el modelo antes de responder, y el razonamiento
  también se paga en tokens.
- **Techos por ejecución:** `--max-turns 40` corta la sesión a los 40 turnos y
  `timeout-minutes: 10` corta el job a los 10 minutos, lo que llegue antes. Además, un push nuevo al
  mismo PR cancela la revisión en curso (`concurrency`), y los PRs desde forks no se ejecutan.

**Cómo cambiarlo:** edita `--model` (por ejemplo `opus`, `haiku` o un ID de modelo completo) y
`--effort` (`low`, `medium`, `high`) en `claude_args`. Subir de modelo o de esfuerzo encarece cada
ejecución. Bajar `--max-turns` abarata, pero puede dejar la revisión a medias en PRs grandes.

**Precios:** consulta la página oficial, <https://www.anthropic.com/pricing>, que distingue los
planes de suscripción de las tarifas por token de la API. Aquí no se citan cifras a propósito:
cambian, y una cifra escrita en este documento envejecería sin que nadie se enterase.

## Pull requests desde un fork en un repositorio público

Con el evento `pull_request`, GitHub **no entrega los secretos del repositorio** a un workflow
lanzado por un PR desde un fork, y le da un `GITHUB_TOKEN` de solo lectura. Así que el revisor no
podría autenticarse contra Claude ni publicar un comentario. Además, la acción rechaza a autores
sin permiso de escritura en el repositorio.

Por eso el job lleva `if: github.event.pull_request.head.repo.full_name == github.repository`: en
los PRs desde un fork **se salta** (aparece como *skipped*) en vez de fallar en rojo.

No lo "arregles" cambiando a `pull_request_target`. Ese evento sí entrega los secretos y un token
con escritura, pero el contenido del PR lo controla el autor del fork: un diff o un comentario
preparado puede intentar que el modelo filtre la credencial o escriba donde no debe. Si un PR
externo necesita revisión, un mantenedor puede traer la rama al repositorio y abrir el PR desde
ahí.
