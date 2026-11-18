# Hallazgos

Aquí van **las tres líneas** del ejercicio, una por cada punto de abajo. Es lo único que hay que
traer hecho: una parte del hook a medias con estas tres líneas escritas vale más que lo contrario,
porque lo que se discute en el directo es dónde te chocaste.

Escribe **una sola línea por punto**, con tus palabras, y **sin el dato dentro**: si tu línea
repite el correo o el secreto, eso es otra copia del dato (y también es un hallazgo, de los buenos).

## 1. La regla que saltó

Qué regla saltó en tu prueba, y la línea literal que dejó el registro.

- Saltó la regla 2 (correo con dominio no permitido) en el intento de commit de la Parte C, y el registro dejó, sin el correo: `- 2026-11-18T21:11:36Z | BLOQUEADO | regla 2: correo con dominio no permitido | docs/capabilities/tasks/README.md`.

## 2. Lo que el hook no puede cazar

Un dato personal o un secreto de este proyecto que el hook NO puede cazar, y por qué.

- La columna `tasks.title` (texto libre, vista en la migración `create_tasks_table` durante el inventario de la Parte A) puede llevar nombres de personas, y el hook no los ve porque solo busca patrones de secretos, correos fuera de los dominios de ejemplo y ficheros `.env`: un nombre sin correo no coincide necesariamente con los patrones que comprueba este hook.

## 3. Tu duda

De qué dudaste, o qué no pudiste comprobar.

- La entrada de las 21:12:36Z es un falso positivo en el disparo: el hook saltó porque un comando de verificación contenía el texto `git commit` sin pretender commitear (revisó el índice, que aún tenía el correo sin corregir), lo que muestra que decide por el texto del comando y no por lo que el comando hace; y las de las 21:28:16Z bloquearon `prompts.md` (reglas 1 y 2) porque los prompts que la entrega exige literales describen los prefijos de clave y el correo ficticio de la prueba, así que el hook no distingue un ejemplo citado de un dato real y `prompts.md` queda sin commitear.
