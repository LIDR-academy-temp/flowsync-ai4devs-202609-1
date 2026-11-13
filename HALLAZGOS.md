# Hallazgos

Aquí van **las tres líneas** del ejercicio, una por cada punto de abajo. Es lo único que hay que
traer hecho: una parte del hook a medias con estas tres líneas escritas vale más que lo contrario,
porque lo que se discute en el directo es dónde te chocaste.

Escribe **una sola línea por punto**, con tus palabras, y **sin el dato dentro**: si tu línea
repite el correo o el secreto, eso es otra copia del dato (y también es un hallazgo, de los buenos).

## 1. La regla que saltó

Qué regla saltó en tu prueba, y la línea literal que dejó el registro.

Saltó "correo-no-permitido" 2 veces y "clave-reconocible". "correo-no-permitido" salta 2 veces porque le estoy pidiendo que guarde los prompts automáticamente.

Esta es la linea:

2026-11-13T13:21:24Z BLOQUEADO correo-no-permitido tmp-prueba-gmail.txt 2026-11-13T13:21:35Z BLOQUEADO clave-reconocible prompts.md 2026-11-13T13:24:41Z BLOQUEADO correo-no-permitido docs/capabilities/tasks/README.md

## 2. Lo que el hook no puede cazar

Un dato personal o un secreto de este proyecto que el hook NO puede cazar, y por qué.

Parece que en el segundo intento de commit dejó "secreto123", el password de la cuenta de pruebas. Esto deberíamos haberlo bloqueado.

## 3. Tu duda

De qué dudaste, o qué no pudiste comprobar.

Dudo de si es correcto que haya guardado el correo de la cuenta de pruebas en prompts.md ya que el hook ha saltado, pero lo ha registrado allí de todas formas. ¿Es porque le he indicado que guarde los prompts tal cual?
