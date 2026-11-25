# Hallazgos

## Parte B

1. Se ejecuto npm run typecheck, finalizo sin errores pero no mostró ningun diagnostico.

2. No existieron cambios. Se determina que la razón es que Lucid genera el archivo schema.ts a partir de las migraciones, generando un mapeo interno de tipos y luego genera las equivalencias con el motor de BD en turno. Existe incluso un archivo llamado schema_rules.ts que mantiene definiciones de tipos como el caso de due_date que se mantiene como tipo string a pesar que en la BD es de tipo Date.

3. La validación ya no funciona porque al recibir el due_date de PG ya se tiene un objeto DATE y la regla que lo mantuvo como string en schema.ts solo agrega un decorador y evita algun error de compilación. Pero ahora para la regla de tarea vencida ya no se comparán textos (lo cual comparaba el día), ahora se compara un DATE con un string y eso siempre da false.

## Parte C

Aquí van **las tres líneas** del ejercicio, una por cada punto de abajo. Es lo único que hay que
traer hecho: un cambio de motor a medias con estas tres líneas escritas vale más que lo contrario,
porque lo que se discute en el directo es dónde te chocaste.

Escribe **una sola línea por punto**, con tus palabras y con lo que mediste, no con lo que suponías.

## 1. Las filas que cambian y la rama

Cuántas filas cambian de valor en tu cambio de esquema, medido con una consulta, y en qué rama del
árbol de reversibilidad cae. Si tu migración no toca datos, dilo tal cual: también es una respuesta.

R: No cambió ninguna fila del esquema. Esto por lo ya mencionado en el apartado de la parte B (Arriba en este mismo archivo). Y según el arbol de reversibilidad, aunque como tal el dato de due_date no se perdió pero si sufrio un cambio por su nueva forma de almacenamiento (lo que impacta en su consulta), consideraría que se debe tener un copia de seguridad de la BD. Y esto se sustenta considerando que el nuevo motor no marcó algún error.

## 2. Lo que la batería de pruebas no podía ver

Una cosa que la batería de pruebas no podía ver. Si no encontraste ninguna, escribe qué buscaste y dónde.

R: Justo la validación de la tarea vencida. De hecho, se verificó con el agente que no existen pruebas para la capability de tasks.

## 3. Tu duda

De qué dudaste, o qué no pudiste comprobar.

R: Lo que me genero duda en un principio fue la regla que hacia que due_date mantuviera string, llegue a pensar que la validación de tarea vencida seguía siendo valida. Pero ya con la prueba lo corroboré. No me quedo alguna duda adicional.
