# Hallazgos

Aquí van **las tres líneas** del ejercicio, una por cada punto de abajo. Es lo único que hay que
traer hecho: una parte del hook a medias con estas tres líneas escritas vale más que lo contrario,
porque lo que se discute en el directo es dónde te chocaste.

Escribe **una sola línea por punto**, con tus palabras, y **sin el dato dentro**: si tu línea
repite el correo o el secreto, eso es otra copia del dato (y también es un hallazgo, de los buenos).

## 1. La regla que saltó

Qué regla saltó en tu prueba, y la línea literal que dejó el registro.

- Se activó la regla 2 al intentar incorporar al README un correo de un dominio no permitido. La evidencia fue: - 2026-11-18T17:12:09Z BLOQUEADO Regla 2 (correo de un dominio no permitido) — docs/capabilities/tasks/README.md.



## 2. Lo que el hook no puede cazar

Un dato personal o un secreto de este proyecto que el hook NO puede cazar, y por qué.

- El nombre completo de un usuario, almacenado en users.full_name, es un dato personal que podría incorporarse a la documentación sin que el hook lo detectase, puesto que ninguna de sus tres reglas identifica nombres de personas.

## 3. Tu duda

De qué dudaste, o qué no pudiste comprobar.

- Aunque comprobé que el hook bloqueaba los commits con correos no permitidos, no pude observar directamente el código de salida 2 ni verifiqué mediante pruebas de ejecución las reglas de detección de secretos y archivos .env.
