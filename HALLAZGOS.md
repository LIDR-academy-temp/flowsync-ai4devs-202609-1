# Hallazgos

Aquí van **las tres líneas** del ejercicio, una por cada punto de abajo. Es lo único que hay que
traer hecho: una parte del hook a medias con estas tres líneas escritas vale más que lo contrario,
porque lo que se discute en el directo es dónde te chocaste.

Escribe **una sola línea por punto**, con tus palabras, y **sin el dato dentro**: si tu línea
repite el correo o el secreto, eso es otra copia del dato (y también es un hallazgo, de los buenos).

## 1. La regla que saltó

Qué regla saltó en tu prueba, y la línea literal que dejó el registro.

- Correo (Parte C, README de tasks): `2026-11-17T17:31:25Z BLOQUEADO correo docs/capabilities/tasks/README.md`

## 2. Lo que el hook no puede cazar

Un dato personal o un secreto de este proyecto que el hook NO puede cazar, y por qué.

- La contraseña de fixture `secreto123` (tests/docs) y el `APP_KEY` real en `backend/.env`: la primera no tiene forma de clave reconocida; el segundo no entra al diff porque `.env` está ignorado y el hook solo mira lo que va al commit.

## 3. Tu duda

De qué dudaste, o qué no pudiste comprobar.

- Si el `beforeShellExecution` de Cursor dispara igual que el `PreToolUse` de Claude Code en un `git commit` del agente, o si en la práctica solo quedó fiable el script invocado a mano / vía WSL (el auto-bloqueo del propio hook y de `prompts.md` al documentar el correo también quedó como zona gris).
