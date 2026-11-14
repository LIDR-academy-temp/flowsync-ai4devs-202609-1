# Hallazgos

Aquí van **las tres líneas** del ejercicio, una por cada punto de abajo. Es lo único que hay que
traer hecho: una parte del hook a medias con estas tres líneas escritas vale más que lo contrario,
porque lo que se discute en el directo es dónde te chocaste.

Escribe **una sola línea por punto**, con tus palabras, y **sin el dato dentro**: si tu línea
repite el correo o el secreto, eso es otra copia del dato (y también es un hallazgo, de los buenos).

## 1. La regla que saltó

Cada `git commit` pasa por el hook `PreToolUse` `.claude/hooks/datos-que-no-salen.sh`, que bloquea tres cosas en lo que entra al commit: claves con forma reconocible (AWS, Anthropic, GitHub, Google, Slack, claves privadas o `APP_KEY=` con valor), correos con dominio distinto de `example.com`/`.org`/`.net` o `github.com`, y cualquier fichero llamado `.env`. Si bloquea, **no lo desactives ni lo esquives** (nada de tocar `settings.json`, `--no-verify` ni trocear el comando): sustituye el dato por uno inventado que cumpla las reglas (correo en `example.com`, clave sin forma real) o saca el `.env` del índice, y vuelve a intentarlo. El registro `docs/seguridad/registro-de-bloqueos.md` se commitea con el resto del trabajo: es la evidencia del bloqueo.

Las línea que dejarohn el registro en el fichero `regisro-de-bloqueos-md' fueron estas:
- 2026-11-14T18:08:20Z BLOQUEADO regla: 3.2 correo con dominio no permitido, archivo: docs/capabilities/tasks/README.md
- 2026-11-14T18:08:20Z BLOQUEADO regla: 3.2 correo con dominio no permitido, archivo: prompts.md

## 2. Lo que el hook no puede cazar

No hay ninguan barrera que impida leer la base de datos. Si un cambio lleva a hacerlo, su contenido sale de la máquina.

-

## 3. Tu duda

No llegué a comprobar lo que el hook no puede cazar pero viendo los resultados del la Parte A se indicó explicítamente `Lo que podría leer en un cambio de backend: config/*.ts, start/env.ts, app/**, tests, database/shema.ts y .adonisjs/
