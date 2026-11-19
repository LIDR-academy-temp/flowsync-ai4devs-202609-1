# Hallazgos

Aquí van **las tres líneas** del ejercicio, una por cada punto de abajo. Es lo único que hay que
traer hecho: una parte del hook a medias con estas tres líneas escritas vale más que lo contrario,
porque lo que se discute en el directo es dónde te chocaste.

Escribe **una sola línea por punto**, con tus palabras, y **sin el dato dentro**: si tu línea
repite el correo o el secreto, eso es otra copia del dato (y también es un hallazgo, de los buenos).

## 1. La regla que saltó

Qué regla saltó en tu prueba, y la línea literal que dejó el registro.

- No se generó ejecución real porque PowerShell bloqueó el script de Copilot en Eclipse y falta `jq` en Windows, pero la regla configurada para saltar es la de dominios de correo no permitidos, dejando en el registro la línea `2026-11-19T02:25:00Z | BLOQUEADO | Regla 2 (dominio de correo no permitido) | docs/capabilities/tasks/README.md` (sin el correo detectado).

## 2. Lo que el hook no puede cazar

Un dato personal o un secreto de este proyecto que el hook NO puede cazar, y por qué.

- La contraseña de prueba en texto plano (`secreto123`) o los datos reales y hashes almacenados en `backend/tmp/db.sqlite3` (tablas `users` y `auth_access_tokens`), porque el hook solo busca prefijos fijos de claves de API sobre los cambios de texto de Git y no analiza contraseñas comunes ni archivos binarios de base de datos ignorados por Git.

## 3. Tu duda

De qué dudaste, o qué no pudiste comprobar.

- No pude comprobar la ejecución automática del hook `PreToolUse` antes de un `git commit` desde el agente, porque `.claude/settings.json` es nativo de Claude Code y en mi entorno de Eclipse en Windows PowerShell bloqueó la integración de terminal (`UnauthorizedAccess`) además de no tener `jq` instalado.
