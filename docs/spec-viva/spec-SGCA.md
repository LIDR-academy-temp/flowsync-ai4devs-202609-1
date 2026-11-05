# Cuentas y acceso

## Purpose

Permitir que una persona cree una cuenta con email y contraseña, inicie y cierre sesión, y consulte su perfil, tanto a través de la API como desde las pantallas de acceso de la aplicación web.

## Requirements

### Requirement: Alta de cuenta

El sistema SHALL permitir crear una cuenta mediante `POST /api/v1/auth/signup` con `fullName`, `email`, `password` y `passwordConfirmation`, y SHALL dejar la sesión iniciada en la misma respuesta.

#### Scenario: Alta con datos válidos
- **WHEN** se envía una petición con un email que no existe, una contraseña de entre 8 y 32 caracteres y una confirmación idéntica
- **THEN** la respuesta es 200 y su cuerpo es `{ "data": { "user": { id, fullName, email, createdAt, updatedAt, initials }, "token": "<token opaco>" } }`, sin la contraseña en ningún campo

#### Scenario: El token del alta sirve de inmediato
- **WHEN** se llama a `GET /api/v1/account/profile` con el token recibido en el alta
- **THEN** la respuesta es 200 con los datos de la cuenta recién creada

### Requirement: Nombre completo en el alta

El sistema SHALL exigir que la clave `fullName` viaje en el alta, aunque su valor pueda ser nulo, y SHALL tratar un nombre vacío o formado solo por espacios como ausencia de nombre.

#### Scenario: Clave ausente
- **WHEN** se envía el alta sin la clave `fullName`
- **THEN** la respuesta es 422 con un error de regla `required` sobre el campo `fullName`

#### Scenario: Nombre nulo, vacío o en blanco
- **WHEN** se envía el alta con `fullName` a `null`, a `""` o a `"   "`
- **THEN** la cuenta se crea y su `fullName` devuelto es `null`

### Requirement: Email único en el alta

El sistema SHALL rechazar un alta cuyo email ya esté registrado.

#### Scenario: Email repetido tal cual
- **WHEN** se envía el alta con un email idéntico, carácter a carácter, al de una cuenta existente
- **THEN** la respuesta es 422 con un error de regla `database.unique` sobre el campo `email`

#### Scenario: Email que solo difiere en mayúsculas
- **WHEN** se envía el alta con un email que coincide con el de una cuenta existente salvo en las mayúsculas
- **THEN** la cuenta se crea como una cuenta distinta, y el email se devuelve y se guarda tal como se escribió

### Requirement: Contraseña en el alta

El sistema SHALL exigir que la contraseña tenga entre 8 y 32 caracteres y que la confirmación la repita exactamente.

#### Scenario: Contraseña demasiado corta
- **WHEN** se envía el alta con una contraseña de menos de 8 caracteres
- **THEN** la respuesta es 422 con un error `minLength` (mínimo 8) sobre `password`, y también sobre `passwordConfirmation` si esta es igual de corta

#### Scenario: Contraseña demasiado larga
- **WHEN** se envía el alta con una contraseña de 33 caracteres
- **THEN** la respuesta es 422 con un error `maxLength` (máximo 32) sobre `password`, y también sobre `passwordConfirmation` si esta es igual de larga

#### Scenario: Confirmación distinta
- **WHEN** se envía el alta con dos contraseñas de longitud válida pero diferentes
- **THEN** la respuesta es 422 con un único error de regla `sameAs` sobre `passwordConfirmation`

### Requirement: Inicio de sesión

El sistema SHALL permitir iniciar sesión mediante `POST /api/v1/auth/login` con `email` y `password`, y SHALL responder con el usuario y un token nuevo.

#### Scenario: Credenciales correctas
- **WHEN** se envía el email y la contraseña de una cuenta existente
- **THEN** la respuesta es 200 con `{ "data": { "user": {...}, "token": "<token opaco>" } }` y el token es distinto de los emitidos antes para esa cuenta

#### Scenario: El email distingue mayúsculas
- **WHEN** se inicia sesión con un email que solo difiere en mayúsculas del de una cuenta
- **THEN** se accede a la cuenta cuyo email coincide exactamente con lo escrito, y si no hay ninguna la respuesta es la de credenciales incorrectas

### Requirement: Credenciales incorrectas

El sistema SHALL responder igual cuando la contraseña es incorrecta y cuando el email no corresponde a ninguna cuenta.

#### Scenario: Contraseña incorrecta
- **WHEN** se envía un email existente con una contraseña que no corresponde
- **THEN** la respuesta es 400 con `{ "errors": [ { "message": "Invalid user credentials" } ] }`

#### Scenario: Email inexistente
- **WHEN** se envía un email que no está registrado
- **THEN** la respuesta es idéntica a la del escenario anterior (400 y el mismo cuerpo)

### Requirement: Validación del inicio de sesión

El sistema SHALL exigir en el inicio de sesión un email con formato válido y una contraseña presente, sin imponer a la contraseña límites de longitud.

#### Scenario: Cuerpo vacío
- **WHEN** se envía `{}`
- **THEN** la respuesta es 422 con errores `required` sobre `email` y sobre `password`

#### Scenario: Email con formato inválido
- **WHEN** se envía `email` con un valor que no es una dirección de email
- **THEN** la respuesta es 422 con un error de regla `email` sobre `email`, y no la respuesta de credenciales incorrectas

### Requirement: Sesiones independientes

El sistema SHALL permitir iniciar sesión aunque ya haya una sesión abierta, y SHALL mantener cada token válido de forma independiente.

#### Scenario: Login con un token ya en la cabecera
- **WHEN** se envía una petición de login válida incluyendo un token válido en la cabecera `Authorization`
- **THEN** la respuesta es 200 con un token nuevo y el anterior sigue siendo válido

#### Scenario: Cerrar una sesión no cierra las demás
- **WHEN** una cuenta tiene dos tokens válidos y se cierra sesión con uno de ellos
- **THEN** ese token pasa a devolver 401 y el otro sigue devolviendo 200 en el perfil

### Requirement: Consulta del perfil

El sistema SHALL devolver los datos de la cuenta autenticada mediante `GET /api/v1/account/profile`.

#### Scenario: Con token válido
- **WHEN** se envía la petición con `Authorization: Bearer <token válido>`
- **THEN** la respuesta es 200 con `{ "data": { id, fullName, email, createdAt, updatedAt, initials } }`

#### Scenario: Sin token, vacío o inválido
- **WHEN** se envía la petición sin cabecera, con `Bearer` sin valor o con un token que no existe
- **THEN** la respuesta es 401 con `{ "errors": [ { "message": "Unauthorized access" } ] }`

### Requirement: Cierre de sesión en la API

El sistema SHALL invalidar el token usado al llamar a `POST /api/v1/account/logout`.

#### Scenario: Con token válido
- **WHEN** se llama al endpoint con un token válido
- **THEN** la respuesta es 200 con `{ "message": "Logged out successfully" }` (sin el envoltorio `data`) y desde ese momento el perfil con ese token devuelve 401

#### Scenario: Sin token
- **WHEN** se llama al endpoint sin token o con uno inválido
- **THEN** la respuesta es 401, igual que en el perfil

### Requirement: Iniciales del usuario

El sistema SHALL devolver en cada usuario un campo `initials` de dos letras en mayúsculas.

#### Scenario: Nombre con dos palabras
- **WHEN** el `fullName` es "Ada Lovelace"
- **THEN** `initials` es "AL"

#### Scenario: Nombre de una palabra
- **WHEN** el `fullName` es "ada"
- **THEN** `initials` es "AD" (sus dos primeras letras)

#### Scenario: Nombre de tres palabras
- **WHEN** el `fullName` es "Ana María López"
- **THEN** `initials` es "AM" (primera y segunda palabra, no la última)

#### Scenario: Nombre con espacios dobles
- **WHEN** el `fullName` es "Ada  Lovelace" (dos espacios entre las palabras)
- **THEN** `initials` es "AD", no "AL"

#### Scenario: Sin nombre
- **WHEN** el `fullName` es nulo y el email es `probe@example.test`
- **THEN** `initials` es "PE": la primera letra de lo que hay antes de la `@` y la primera letra de lo que hay después

### Requirement: Forma de las respuestas

El sistema SHALL responder siempre en JSON; las respuestas con datos van envueltas en `data` y los errores en `errors`.

#### Scenario: Respuesta correcta con datos
- **WHEN** una petición de alta, login o perfil tiene éxito
- **THEN** el cuerpo es `{ "data": ... }`

#### Scenario: Error de validación
- **WHEN** una petición no supera la validación
- **THEN** la respuesta es 422 y el cuerpo es `{ "errors": [ { message, rule, field, meta? } ] }` con los textos de `message` en inglés

#### Scenario: Petición desde la web de desarrollo
- **WHEN** el navegador envía una petición previa (`OPTIONS`) a la API con origen `http://localhost:5173`
- **THEN** la respuesta es 204

### Requirement: Pantalla de registro

La aplicación SHALL ofrecer en `/register` un formulario para crear una cuenta con nombre (opcional), email, contraseña y repetición de la contraseña.

#### Scenario: Registro correcto
- **WHEN** una persona sin sesión rellena email y contraseñas válidas e iguales y pulsa "Crear cuenta"
- **THEN** el botón muestra "Creando cuenta…" y queda deshabilitado mientras dura la petición, y al terminar la persona entra con sesión iniciada en `/profile`

#### Scenario: Nombre en blanco
- **WHEN** la persona deja el nombre vacío o en blanco
- **THEN** la cuenta se crea sin nombre

#### Scenario: Contraseñas distintas
- **WHEN** las dos contraseñas no coinciden al enviar
- **THEN** aparece "Las contraseñas no coinciden." bajo el campo de repetición y no se llama a la API

#### Scenario: Pista de contraseña
- **WHEN** no hay error en el campo de contraseña
- **THEN** bajo él se lee "Entre 8 y 32 caracteres."

### Requirement: Pantalla de inicio de sesión

La aplicación SHALL ofrecer en `/login` un formulario con email y contraseña, y enlaces cruzados con el registro.

#### Scenario: Acceso correcto
- **WHEN** la persona envía credenciales correctas
- **THEN** el botón muestra "Entrando…" mientras dura la petición y después se entra en `/profile`

#### Scenario: Credenciales incorrectas
- **WHEN** el email o la contraseña no son correctos
- **THEN** aparece en un aviso general "El email o la contraseña no son correctos."

#### Scenario: Enlace al registro
- **WHEN** la persona pulsa "Crea una"
- **THEN** navega a `/register`; y desde el registro "Inicia sesión" lleva a `/login`

### Requirement: Errores en castellano

La aplicación SHALL mostrar los errores de la API traducidos al castellano, bajo el campo afectado cuando el campo está en pantalla y en un aviso general cuando no.

#### Scenario: Email ya registrado
- **WHEN** el alta falla por email repetido
- **THEN** bajo el email se lee "Ese email ya está registrado. Inicia sesión en su lugar."

#### Scenario: Otros errores de campo
- **WHEN** la API devuelve errores de formato, longitud, campo ausente o contraseñas distintas
- **THEN** se muestran frases como "Introduce una dirección de email válida.", "la contraseña debe tener al menos 8 caracteres.", "Falta rellenar el email." y "Las contraseñas no coinciden."

#### Scenario: Sin conexión
- **WHEN** no se puede contactar con el servidor
- **THEN** aparece "No se pudo conectar con el servidor. Comprueba que el backend está arrancado."

#### Scenario: Fallo del servidor
- **WHEN** el servidor responde con un error no previsto
- **THEN** aparece "Algo ha ido mal en el servidor. Inténtalo de nuevo en un momento."

### Requirement: Protección de rutas

La aplicación SHALL permitir ver el perfil solo con sesión y ver el login y el registro solo sin ella.

#### Scenario: Perfil sin sesión
- **WHEN** una persona sin sesión abre `/profile`
- **THEN** es redirigida a `/login`

#### Scenario: Login o registro con sesión
- **WHEN** una persona con sesión abre `/login` o `/register`
- **THEN** es redirigida a `/profile`

#### Scenario: Ruta desconocida
- **WHEN** se abre cualquier otra dirección
- **THEN** se redirige a `/profile`, y de ahí a `/login` si no hay sesión

#### Scenario: Comprobación en curso
- **WHEN** la aplicación arranca con una sesión guardada y aún está comprobándola con el servidor
- **THEN** se muestra un indicador de carga a pantalla completa y no se redirige a ninguna parte

### Requirement: Persistencia de la sesión

La aplicación SHALL conservar la sesión entre recargas del navegador y SHALL comprobarla con el servidor al arrancar.

#### Scenario: Recarga con sesión válida
- **WHEN** la persona recarga la página con la sesión iniciada
- **THEN** sigue en `/profile` con sus datos

#### Scenario: Token rechazado
- **WHEN** al arrancar el servidor responde 401 a la sesión guardada
- **THEN** la sesión se descarta, se envía a `/login` y se muestra "Tu sesión ha caducado. Vuelve a iniciar sesión."

#### Scenario: Servidor caído al arrancar
- **WHEN** al arrancar el servidor no responde o falla
- **THEN** se envía a `/login` con el aviso del error, y la sesión guardada no se borra, de modo que al recargar con el servidor de nuevo disponible la persona entra sin volver a escribir sus datos

### Requirement: Pantalla de perfil y cierre de sesión

La aplicación SHALL mostrar en `/profile` las iniciales, el nombre, el email y la fecha de alta, y SHALL permitir cerrar la sesión.

#### Scenario: Datos mostrados
- **WHEN** una persona con sesión abre `/profile`
- **THEN** ve sus iniciales en un círculo, su nombre (o "Sin nombre" si no tiene), su email y "Miembro desde" con la fecha de alta en formato largo en español

#### Scenario: Cerrar sesión
- **WHEN** pulsa "Cerrar sesión"
- **THEN** el botón muestra "Cerrando sesión…", la sesión local se borra y la persona acaba en `/login` sin aviso de error

#### Scenario: Cierre con el servidor inalcanzable
- **WHEN** pulsa "Cerrar sesión" y la API no responde o rechaza el token
- **THEN** la persona acaba igualmente en `/login` y no se le muestra ningún error


Parte B: las tres listas
1. **Cuántos requisitos escribió el agente, y cuántos comprobaste tú abriendo el código**. 18 escritos por el agente y 2 comprobados por mi.

2. **Las incoherencias que aparecieron al escribirla**. 
- Scenario: Email que solo difiere en mayúsculas.
- Scenario: Nombre nulo, vacío o en blanco.
- Se acabó el tiempo y no pude continuar revisando.

3. **Lo que no supiste decidir si era un bug o el contrato**. 
- En alta permitir con nombre nulo, vacío o en blanco. Para mi no debería permitirse pero no se si fue adrede y porque.