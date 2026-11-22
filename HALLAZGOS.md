# Parte B

**1 Ejecuta la comprobación de tipos**: La comprobación de tipos pasaba antes de hacer la migración
y sigue pasando ahora, después de esta.

**2 Compara el archivo de tipos generado**: No hay diferencias ni cambios. Las migraciones no cambian, por lo que
los tipos de las columnas son equivalentes en ambos motores. El schema se genera a partir de la base de datos, 
así que tampoco cambia. Lo que sí cambia es lo que entrega el driver en columnas de fecha, que antes era un 
string y ahora es un Date. En las columnas traducidas por defecto, da lo mismo porque se convierten a 
DateTime. En tasks.due_date, que está sobreescrito en schema_rules.ts, se declara un string, pero en realidad 
contendrá tal cual lo que entregue el driver en ejecución (un Date). Como el typecheck mira los tipos declarados,
el problema no salta. Tampoco parece haber pruebas con due_date.


**3 Busca cómo decide el proyecto si una tarea está vencida**: Se decide en `backend/app/models/task.ts` en 
`isOverdueOn` y el comentario ya no es correcto. Ahora, la comparación
con < compara string con Date, y siempre da `false`. Además, el Date ahora sí trae info de horas, minutos, segundos
y huso. Al intentar probarlo en la app, esta no me deja abrir los detalles de tarea (se queda en blanco por la fecha 
con hora); así que creo un test de backend que lee la tarea de vuelta de la base y exige `isOverdue: true`. Con 
el motor sqlite, el test pasa verde, mientras que con el nuevo no pasa porque tareas vencidas vienen como no 
vencidas. Lo probé con una tarea del día anterior a hoy (22 de nov) y con una de 2025. Con SQLite 25 de 25 en
verde, con PostgreSQL 23 en verde y 2 en rojo.



# Hallazgos

Aquí van **las tres líneas** del ejercicio, una por cada punto de abajo. Es lo único que hay que
traer hecho: un cambio de motor a medias con estas tres líneas escritas vale más que lo contrario,
porque lo que se discute en el directo es dónde te chocaste.

Escribe **una sola línea por punto**, con tus palabras y con lo que mediste, no con lo que suponías.

## 1. Las filas que cambian y la rama

Cuántas filas cambian de valor en tu cambio de esquema, medido con una consulta, y en qué rama del
árbol de reversibilidad cae. Si tu migración no toca datos, dilo tal cual: también es una respuesta.

- 0 filas cambian de valor (medido: SQLite de partida con 0 filas en users, auth_access_tokens y tasks; ninguna migración nueva ni modificada). Cae en la rama de no destruir datos y deshacerlo con otra migración.

## 2. Lo que la batería de pruebas no podía ver

Una cosa que la batería de pruebas no podía ver. Si no encontraste ninguna, escribe qué buscaste y dónde.

- Las tareas vencidas dejan de salir como vencidas: con PostgreSQL dueDate llega como Date, isOverdueOn lo compara con < contra un texto y da siempre false. Las 23 pruebas y el typecheck siguen en verde porque ninguna prueba toca due_date y schema_rules.ts lo declara string; hice un test nuevo para demostrarlo, que pasa verde con SQLite y falla con PostgreSQL. La pantalla en blanco en el detalle de tarea tampoco, supongo que porque en frontend no hay tests.

## 3. Tu duda

De qué dudaste, o qué no pudiste comprobar.

- Qué habría pasado si la base tuviera información. due_date en sqlite es string y podría tener fechas incorrectas. Y ahí, la conversión a Date habría sido problemática y habría caído en otro sitio del árbol de reversibilidad.
