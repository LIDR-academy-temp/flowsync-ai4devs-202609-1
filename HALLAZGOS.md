# Hallazgos

Aquí van **las tres líneas** del ejercicio, una por cada punto de abajo. Es lo único que hay que
traer hecho: una parte del hook a medias con estas tres líneas escritas vale más que lo contrario,
porque lo que se discute en el directo es dónde te chocaste.

Escribe **una sola línea por punto**, con tus palabras, y **sin el dato dentro**: si tu línea
repite el correo o el secreto, eso es otra copia del dato (y también es un hallazgo, de los buenos).

## 1. La regla que saltó

Qué regla saltó en tu prueba, y la línea literal que dejó el registro.

- La regla 2 de dominio no permitido: `- 2026-11-15T19:53:11Z BLOQUEADO regla 2 (correo de una persona) archivo docs/capabilities/tasks/README.md`

## 2. Lo que el hook no puede cazar

Un dato personal o un secreto de este proyecto que el hook NO puede cazar, y por qué.

- `backend/.env` contiene un APP_KEY. No llega al commit porque git lo ignora; si llegara por algún uso de 'git add -f', el hook lo pararía. Pero nada impide que el agente lea el fichero, lo incorpore al contexto y salga hacia el proveedor, porque el hook solo interviene en lo que pasa por un commit.

## 3. Tu duda

De qué dudaste, o qué no pudiste comprobar.

- dudé de si el hook aplicaba solamente con crearlo; recordé un módulo anterior sobre gobernanza, que los hooks se cargaban en el arranque 
  de la sesión si están en el directorio de trabajo, salí e hice `claude --continue` para continuar; no probé sin reiniciar la sesión.
