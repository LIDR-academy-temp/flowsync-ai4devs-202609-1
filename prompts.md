# Prompts

Aquí van **todos los prompts que lanzaste** para hacer el ejercicio, en el orden en que los
lanzaste, con el modelo y la herramienta de cada uno.

Esto no es papeleo. Lo que se revisa es **cómo pediste las cosas**, no solo lo que salió: un
resultado flojo con un prompt bueno y un resultado flojo con un prompt vago necesitan feedback
distinto, y sin este archivo no se distinguen.

## Cómo rellenarlo

- Un apartado `## Prompt N` por cada prompt.
- **Pega el prompt tal cual lo lanzaste**, dentro del bloque de código, aunque ocupe diez líneas
  y aunque tenga faltas. No lo reescribas para que quede bien: el que arreglaste mentalmente
  después no es el que lanzaste.
- Incluye también los que **no funcionaron**. Suelen ser los más útiles de leer.
- `Modelo` y `Herramienta` en todos. Si cambiaste de una a otra a mitad, se nota aquí.

Borra el ejemplo de abajo cuando escribas el primero.

---

## Prompt 1

**Modelo:** Opus 5.5 Medium
**Herramienta:** Claude Code

```
Necesito migrar el proyecto FlowSync de SQLite a PostgreSQL en Docker.

Actualmente estamos en la rama motor-rmm, creada desde upstream/s10/start. El proyecto original está instalado, las cuatro migraciones existentes se han ejecutado correctamente y las 23 pruebas funcionales del backend pasan sobre SQLite.

Antes de realizar ningún cambio, revisa las instrucciones del repositorio, la arquitectura existente, la configuración de persistencia, las dependencias, las migraciones, la configuración de pruebas y el Makefile.

La migración debe cumplir obligatoriamente las siguientes restricciones:

- El archivo de Docker Compose debe llamarse compose.yaml y definir dos servicios: db y db-test.
- Utilizar la imagen pgvector/pgvector:pg17.
- Utilizar el puerto 54410 para desarrollo y el 54411 para pruebas.
- La base de datos de pruebas debe funcionar en memoria, sin volumen persistente.
- Configurar healthchecks en ambos servicios y garantizar que las bases acepten conexiones antes de ejecutar las migraciones.
- No incluir la clave version en compose.yaml.
- Configurar el entorno de pruebas mediante su propio archivo de entorno para garantizar que los tests utilizan exclusivamente la base de datos de pruebas.
- Incorporar atajos en el Makefile para arrancar y detener las bases de datos, ejecutar las migraciones en ambas y lanzar las pruebas.
- Conservar intactas todas las migraciones existentes. Si detectas que alguna necesita modificarse, detente e informa del motivo antes de continuar.

Restricciones adicionales:

- Limita los cambios al alcance de la migración.
- No implementes funcionalidades vectoriales.
- No realices actualizaciones de dependencias ajenas a la migración.
- No elimines la base de datos SQLite original.
- No modifiques las pruebas existentes para conseguir que pasen.
- No realices commits, push ni operaciones sobre repositorios remotos.
- No corrijas anticipadamente posibles diferencias funcionales entre ambos motores sin informar de ellas.

Presenta un plan de implementación que incluya:

1. Resumen de la arquitectura de persistencia actual.
2. Archivos que necesitas crear o modificar y justificación.
3. Estrategia de configuración de PostgreSQL para desarrollo y pruebas.
4. Riesgos e incompatibilidades potenciales.
5. Estrategia de verificación de la migración y del aislamiento de las pruebas.

En esta primera fase realiza únicamente el análisis y la planificación. No modifiques archivos ni ejecutes operaciones que alteren el estado del proyecto o de las bases de datos. Espera mi aprobación antes de implementar.
```

**Qué salió:** (opcional, una línea) funcionó a la primera / tuve que insistir / me inventó una ruta que no existe.

---

## Prompt 2

**Modelo:** Opus 5.5 Medium
**Herramienta:** Claude Code

```
He revisado el plan y estoy de acuerdo con el enfoque general. Antes de autorizar la implementación, incorpora los siguientes ajustes:

1. Utiliza un healthcheck que compruebe explícitamente la disponibilidad de PostgreSQL mediante TCP, evitando que el servidor temporal de inicialización pueda provocar un falso positivo.

2. Garantiza el aislamiento de la base de datos de pruebas tanto durante la ejecución de los tests como durante sus migraciones. Verifica que las variables de entorno exportadas desde la terminal no puedan provocar operaciones sobre la base de desarrollo.

3. Preserva la base de datos SQLite original. Revisa el comportamiento de make clean para evitar su eliminación accidental durante este ejercicio.

4. Incorpora una estrategia de comprobación mediante consultas que permita determinar el número exacto de filas cuyos valores cambian con el cambio de motor o esquema. Distingue entre recrear el esquema en PostgreSQL, trasladar datos existentes y cambiar la representación de los valores en tiempo de ejecución.

5. Mantén el posible problema de due_date como hipótesis pendiente de comprobación experimental. No implementes todavía setTypeParser ni ninguna otra corrección de este comportamiento. Necesitamos observar primero el resultado real de la migración.

6. Utiliza datos controlados para verificar las tareas vencidas. Distingue las operaciones de creación de datos de las consultas de solo lectura.

Mantén todas las restricciones anteriores y presenta el plan actualizado. No implementes todavía ningún cambio.
```

**Qué salió:** (opcional, una línea) funcionó a la primera / tuve que insistir / me inventó una ruta que no existe.

---

## Prompt 3

**Modelo:** Opus 5.5 Medium
**Herramienta:** Claude Code

```
Autorizo la creación de la copia de seguridad de SQLite y el cálculo y registro de las huellas SHA-256. Ejecuta esas operaciones sin mostrar el contenido del archivo .env. Si necesitas comprobar su configuración, muestra únicamente los nombres de las variables, sin sus valores.
```

**Qué salió:** (opcional, una línea) funcionó a la primera / tuve que insistir / me inventó una ruta que no existe.

---

## Prompt 4

**Modelo:** Opus 5.5 Medium
**Herramienta:** Claude Code

```
No modifiques la memoria persistente ni archivos de configuración externos al ejercicio. Mantén la restricción de no mostrar valores de archivos .env durante esta sesión y continúa con la implementación del plan aprobado.
```

**Qué salió:** (opcional, una línea) funcionó a la primera / tuve que insistir / me inventó una ruta que no existe.
---

## Prompt 5

**Modelo:** Opus 5.5 Medium
**Herramienta:** Claude Code

```
Realiza las comprobaciones de aislamiento previstas, pero elimina la ejecución de migration:rollback. Comprueba primero que la protección rechaza la conexión incorrecta mediante migration:status, que es una operación de consulta. Si la protección funciona correctamente, continúa con el resto de las comprobaciones. Registra los códigos de salida reales de los comandos, sin enmascararlos mediante tuberías.
```

**Qué salió:** (opcional, una línea) funcionó a la primera / tuve que insistir / me inventó una ruta que no existe.

## Prompt 6

**Modelo:** Opus 5.5 Medium
**Herramienta:** Claude Code

```
Doy por finalizadas la implementación de la migración y la investigación funcional.

Completa HALLAZGOS.md respetando exactamente la plantilla existente y añadiendo una línea debajo de cada uno de los tres puntos obligatorios.

Utiliza exclusivamente las evidencias obtenidas:

1. Cero filas de negocio modificadas por la recreación del esquema, acreditado mediante los recuentos SQL de SQLite y PostgreSQL. No se han trasladado datos existentes y SQLite permanece intacta, por lo que el cambio es reversible respecto a los datos originales. Distingue este resultado de las tres tareas de ensayo cuya representación de due_date cambia durante la lectura.

2. La batería de 23 pruebas no cubre la detección de una tarea vencida después de recuperarla de la base de datos. La tarea T1 devuelve isOverdue=true al guardar su fecha y false al recuperarla, aunque debería estar vencida. El esquema generado y typecheck no detectan el problema debido a la regla personalizada que declara dueDate como string.

3. La verificación se ha realizado con TZ=UTC. No se ha comprobado el comportamiento con otras zonas horarias ni con una migración de datos históricos reales.

Mantén las tres líneas concretas, sin ampliar innecesariamente el documento.

Además:

- Elimina únicamente el fichero de memoria persistente no-mostrar-valores-env.md que has creado durante esta sesión, sin modificar otros archivos de memoria.
- Invalida los tokens de autenticación del ensayo y elimina el archivo temporal que contiene el token, sin mostrar su contenido.
- Conserva el usuario ficticio y las cuatro tareas de ensayo para poder reproducir el hallazgo.
- No corrijas el defecto de due_date.
- No modifiques prompts.md.
- No realices commits ni push.

Finalmente, muestra el contenido de HALLAZGOS.md, git status --short, git diff --stat y git diff --check. Comprueba que las cuatro migraciones originales siguen intactas respecto a upstream/s10/start.
```

**Qué salió:** (opcional, una línea) funcionó a la primera / tuve que insistir / me inventó una ruta que no existe.