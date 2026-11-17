# Hallazgos

Aquí van **las tres líneas** del ejercicio, una por cada punto de abajo. Es lo único que hay que
traer hecho: una parte del hook a medias con estas tres líneas escritas vale más que lo contrario,
porque lo que se discute en el directo es dónde te chocaste.

Escribe **una sola línea por punto**, con tus palabras, y **sin el dato dentro**: si tu línea
repite el correo o el secreto, eso es otra copia del dato (y también es un hallazgo, de los buenos).

## 1. La regla que saltó

Qué regla saltó en tu prueba, y la línea literal que dejó el registro.

- Se activó la regla de correo no permitido al intentar incorporar el ejemplo del README mediante un commit. El hook bloqueó la operación y dejó esta evidencia: `- 2026-11-17T22:46:52Z BLOQUEADO regla=correo archivo=docs/capabilities/tasks/README.md`.

## 2. Lo que el hook no puede cazar

Un dato personal o un secreto de este proyecto que el hook NO puede cazar, y por qué.

- El hook no detecta una contraseña escrita como texto común en un ejemplo de autenticación, porque su regla de secretos solo reconoce patrones específicos de claves y tokens; además, no examina todos los datos existentes en el proyecto.

## 3. Tu duda

De qué dudaste, o qué no pudiste comprobar.

- Dudé de qué ocurriría si faltara `jq`: comprobamos que el hook puede avisar con `exit 1` sin bloquear el commit, por lo que no garantiza la protección cuando falla esa dependencia.