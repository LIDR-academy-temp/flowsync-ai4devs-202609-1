# Hallazgos

Aquí van **las tres líneas** del ejercicio, una por cada punto de abajo. Es lo único que hay que
traer hecho: una parte del hook a medias con estas tres líneas escritas vale más que lo contrario,
porque lo que se discute en el directo es dónde te chocaste.

Escribe **una sola línea por punto**, con tus palabras, y **sin el dato dentro**: si tu línea
repite el correo o el secreto, eso es otra copia del dato (y también es un hallazgo, de los buenos).

## 1. La regla que saltó

Qué regla saltó en tu prueba, y la línea literal que dejó el registro.

- Saltó la regla 2 (correo con un dominio que no es de ejemplo) al pedir el `curl` de la cuenta de pruebas tal cual: `- 2026-11-17T20:22:49Z BLOQUEADO regla 2 (correo con un dominio no reservado para ejemplos) docs/capabilities/tasks/README.md`. Antes de eso actuó la regla de `CLAUDE.md`, porque el agente preguntó en vez de escribirlo directamente.

## 2. Lo que el hook no puede cazar

Un dato personal o un secreto de este proyecto que el hook NO puede cazar, y por qué.

- La contraseña y el nombre completo de la cuenta de pruebas entraron en el README sin ningún bloqueo: el hook solo reconoce formas (prefijos de clave, correos, `.env`), y una contraseña o un nombre propio no tienen forma. Tampoco vería `backend/tmp/db.sqlite3` añadido con `git add -f`, porque es binario y se lo salta, ni un commit hecho desde la terminal fuera de Claude Code.

## 3. Tu duda

De qué dudaste, o qué no pudiste comprobar.

- No pude ver el código 2 desde la propia herramienta (solo se ve el bloqueo), así que ejecuté el hook a mano. Eso dejó en el registro una línea que no corresponde a ningún commit real, y dudo si el registro debería distinguir los intentos reales de las pruebas. Tampoco tengo claro cómo leer el comando sin un parser de shell: la detección de `.env` en los argumentos de `git add` no entiende las comillas, así que un mensaje de commit que diga "git add" seguido de ".env" en la misma línea sigue bloqueando sin motivo.
