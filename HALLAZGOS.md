# Hallazgos

Aquí van **las tres líneas** del ejercicio, una por cada punto de abajo. Es lo único que hay que
traer hecho: una parte del hook a medias con estas tres líneas escritas vale más que lo contrario,
porque lo que se discute en el directo es dónde te chocaste.

Escribe **una sola línea por punto**, con tus palabras, y **sin el dato dentro**: si tu línea
repite el correo o el secreto, eso es otra copia del dato (y también es un hallazgo, de los buenos).

## 1. La regla que saltó

Qué regla saltó en tu prueba, y la línea literal que dejó el registro.

La regla que saltó fue el hook, posteriormente, el agente valido sus reglas y ofreció opciones.
La linea del registro fue: 2026-11-21T19:51:48Z BLOQUEADO regla-2-correo-real docs/capabilities/tasks/README.md

-

## 2. Lo que el hook no puede cazar

Un dato personal o un secreto de este proyecto que el hook NO puede cazar, y por qué.

Yo considero siempre el tema de los correos, debido a que se tendría que poner todos los posibles casos o algun regex que incluyera la mayoria de correos, aunque siempre pueden existir excepciones.

De igual forma, faltaría detectar las credenciales hasheadas de los usuarios. Sigue siendo un dato secreto que no se debe compartir, actualmente no lo detecta porque no está incluido en el listado. E igual habría una limitante dependiendo del formato del hash.
-

## 3. Tu duda

De qué dudaste, o qué no pudiste comprobar.

Tuve problema con la ejecución del hook en la primera parte. El agente me indico que si todo se realiza de forma seguida, por la forma de uso del hook pretools pudieran haber situaciones en donde no detecte los cambios. Por ejemplo, para que funcione me indicaba que primero debía crearse el archivo temporal y luego usar el git add para detectarlo pero si se ejecuta al mismo tiempo podria fallar. Esta es la duda que me quedo, para saber si es una limitante de pretools o fue un tema del agente porque después mande prompts donde tenía la instrucción de crear el archivo y el git commit y el hook se ejecuto correctamente.
-
