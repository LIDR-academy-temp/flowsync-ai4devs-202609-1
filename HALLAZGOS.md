# Hallazgos

Aquí van **las tres líneas** del ejercicio, una por cada punto de abajo. Es lo único que hay que
traer hecho: una parte del hook a medias con estas tres líneas escritas vale más que lo contrario,
porque lo que se discute en el directo es dónde te chocaste.

Escribe **una sola línea por punto**, con tus palabras, y **sin el dato dentro**: si tu línea
repite el correo o el secreto, eso es otra copia del dato (y también es un hallazgo, de los buenos).

## 1. La regla que saltó

Qué regla saltó en tu prueba, y la línea literal que dejó el registro.

- Saltó la regla 2  al pedir el `curl` de la cuenta de pruebas tal cual: `- 2026-11-17T20:22:49Z BLOQUEADO regla 2 (correo con un dominio no reservado para ejemplos) docs/capabilities/tasks/README.md`. Antes de eso actuó la regla de `CLAUDE.md`, porque el agente me preguntó como actuar.

## 2. Lo que el hook no puede cazar

Un dato personal o un secreto de este proyecto que el hook NO puede cazar, y por qué.

- La contraseña y el nombre completo de la cuenta de pruebas se escribieron en el README del modulo de tasks sin ningún bloqueo: el hook solo reconoce formas (prefijos de clave, correos, `.env`), y una contraseña o un nombre propio no tienen forma.

## 3. Tu duda

De qué dudaste, o qué no pudiste comprobar.

- No pude ver el código 2 desde la propia herramienta (solo se ve el bloqueo y que dejó registro en el fichero de bloqueos),
