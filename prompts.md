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

---

## Prompt 1

**Modelo:** Opus 5.5 High
**Herramienta:** Claude Code

```
Vamos a migrar FlowSync de SQLite a PostgreSQL como parte del ejercicio del Módulo 10 de AI4Devs.

Estamos en la rama `motor-jaba`, creada desde `s10/start`. Antes de realizar ningún cambio hemos comprobado que las 23 pruebas del backend pasan y que el typecheck termina correctamente.

El objetivo es utilizar PostgreSQL en Docker con dos bases de datos independientes, una para desarrollo y otra para pruebas.

Las restricciones del ejercicio son:

- El archivo de Compose debe llamarse `compose.yaml` y definir dos servicios, `db` y `db-test`.
- Ambos servicios deben utilizar la imagen `pgvector/pgvector:pg17`.
- Los puertos deben ser 54410 para desarrollo y 54411 para pruebas.
- La base de datos de pruebas debe estar en memoria, sin volumen persistente.
- Ambos servicios deben tener una comprobación de salud y el arranque debe esperar a que estén preparados para aceptar conexiones.
- El archivo `compose.yaml` no debe incluir la clave `version:`.
- Las pruebas deben utilizar su propia base de datos mediante el archivo de entorno que el framework carga automáticamente en ese entorno.
- El Makefile debe incorporar atajos para arrancar y detener las bases de datos, ejecutar las migraciones en ambas y lanzar las pruebas.
- Las migraciones existentes deben permanecer intactas. Si consideras necesario modificar alguna, detente y explica el motivo.

Antes de implementar nada, revisa `CLAUDE.md` y analiza la configuración actual del proyecto.

Quiero que me indiques:

1. Cómo se configura actualmente la conexión a SQLite para desarrollo y pruebas.
2. Qué archivos y dependencias habría que modificar para realizar la migración.
3. Qué opciones de configuración existentes debemos conservar y por qué.
4. Qué plan de implementación propones para cumplir todas las restricciones.
5. Cómo verificarías que la migración se ha realizado correctamente.

Justifica tus conclusiones con referencias a los archivos reales del repositorio. No asumas APIs de versiones anteriores de AdonisJS o Lucid.

En esta primera fase no modifiques ningún archivo, no instales dependencias, no ejecutes migraciones y no hagas commits. Limítate a inspeccionar el proyecto y presentar el diagnóstico y el plan para que pueda revisarlos.
```

**Qué salió:** El agente inspeccionó el repositorio sin modificar archivos, propuso un plan que cumplía las restricciones e identificó una posible incompatibilidad entre el tipo declarado de dueDate y el valor devuelto por PostgreSQL. Dejamos esa hipótesis pendiente de comprobar.

---

## Prompt 2

**Modelo:** Opus 5.5 High
**Herramienta:** Claude Code

```
He revisado tu diagnóstico y apruebo el plan de migración, con los siguientes ajustes:

- Elimina la dependencia better-sqlite3 cuando hayas comprobado que PostgreSQL funciona correctamente.
- No transfieras los datos existentes de SQLite a PostgreSQL, ya que no forma parte del ejercicio. Conserva el fichero SQLite original para posibles comprobaciones posteriores.
- No añadas el target db-reset. Limítate a los atajos necesarios para cumplir el enunciado.
- Actualiza únicamente la documentación que quede desactualizada como consecuencia del cambio de motor.

Implementa ahora la Parte A siguiendo el plan que has propuesto y respetando todas las restricciones del prompt anterior.

Presta especial atención a las siguientes condiciones:

1. Conserva intactas las cuatro migraciones existentes. Si alguna no funciona en PostgreSQL, detente e informa del problema antes de modificarla.
2. Conserva las opciones de configuración que deban seguir funcionando con PostgreSQL, incluyendo las reglas de generación del esquema.
3. No edites manualmente database/schema.ts ni modifiques schema_rules.ts para ocultar posibles incompatibilidades.
4. No modifiques la lógica de negocio, incluida la lógica de vencimiento de las tareas. Investigaremos las posibles regresiones en la Parte B.
5. No modifiques las pruebas existentes para conseguir que pasen.
6. Utiliza exclusivamente credenciales ficticias de desarrollo y respeta el hook de protección de datos del proyecto.
7. Mantén los cambios en la rama motor-jaba.

Una vez implementado, verifica:

- Que los dos servicios de PostgreSQL arrancan correctamente y alcanzan el estado healthy.
- Que la base de pruebas utiliza tmpfs y no tiene almacenamiento persistente.
- Que las migraciones originales se ejecutan correctamente en ambas bases de datos.
- Que los tests utilizan la base de pruebas y no la de desarrollo.
- Que las 23 pruebas originales siguen pasando, o informa de cuáles fallan y por qué.
- Que las migraciones existentes no presentan diferencias respecto a s10/start.

Presenta un resumen de los archivos modificados, las decisiones tomadas, los comandos ejecutados y sus resultados reales. Distingue entre lo que has comprobado y lo que queda pendiente.

No resuelvas todavía la Parte B ni redactes HALLAZGOS.md. No hagas commits, push ni abras ningún pull request. Quiero revisar la implementación antes de continuar.
```

**Qué salió:** El agente completó la migración a PostgreSQL respetando las restricciones. Las 23 pruebas pasaron, las migraciones originales quedaron intactas y se verificó el aislamiento de las bases de desarrollo y pruebas. Posteriormente comprobé de forma independiente los resultados y reproduje manualmente la regresión en la lógica de vencimiento mediante el REPL de AdonisJS y una consulta SQL.
