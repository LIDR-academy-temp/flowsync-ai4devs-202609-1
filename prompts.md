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

## Prompt 1 — Parte A: Inventario

**Modelo:** Claude Opus 5.5

**Herramienta:** Claude Code — Visual Studio Code

**Nota de trazabilidad:** Reconstruido a partir de la actividad realizada y sus resultados. No se conserva aquí una copia literal verificada del mensaje original.

```text
Estamos realizando la Parte A del Laboratorio 9 de FlowSync.

Trabajamos en la rama bloqueo-rc.

Realiza exclusivamente un inventario de los datos personales,
secretos e información accesible al agente en este repositorio.

Necesito tres listas:

1. Datos personales:
   - Revisa el modelo de datos, las migraciones y los archivos de ejemplo.
   - Identifica columnas y campos que contengan o puedan contener
     información personal.
   - Indica los archivos que respaldan cada hallazgo.

2. Secretos:
   - Identifica credenciales, claves, tokens y configuraciones sensibles.
   - Considera también archivos ignorados por Git.
   - No reproduzcas valores sensibles completos.

3. Información accesible al agente:
   - Identifica qué información del proyecto puede consultar Claude Code.
   - Distingue lo que realmente consultaste de lo que solamente está
     disponible en el entorno.
   - Diferencia la información que entra al contexto de aquella cuya
     transmisión externa no puedes comprobar.

Para cada hallazgo, proporciona evidencia concreta y diferencia
hechos comprobados de inferencias.

Restricciones:

- No modifiques archivos.
- No ejecutes commits.
- No cambies de rama.
- No alteres configuraciones.
- No avances a la implementación del hook.
- No copies secretos completos en la respuesta.

Entrega únicamente el inventario y espera nuevas instrucciones.
```

**Resultado observado:**

Claude Code identificó información personal en las tablas y campos del proyecto, incluyendo `users.full_name`, `users.email`, `users.password`, `auth_access_tokens.tokenable_id`, `auth_access_tokens.last_used_at` y `tasks.assignee_id`.

También identificó archivos de entorno, la base de datos local y configuraciones de Claude Code que podían contener información sensible.

El agente distinguió entre información consultada, información potencialmente accesible e información cuya transmisión al servicio del modelo no podía verificar directamente.

La Parte A finalizó sin modificaciones en el repositorio.

---

## Prompt 2 — Parte B: Hook datos-que-no-salen

**Modelo:** Claude Opus 5.5

**Herramienta:** Claude Code — Visual Studio Code

**Nota de trazabilidad:** Reconstruido a partir de los requisitos oficiales utilizados y de la implementación observada. No se conserva aquí una copia literal verificada del mensaje original.

```text
Estamos realizando la Parte B del Laboratorio 9 de FlowSync.

Trabajamos en la rama bloqueo-rc.

Implementa el hook de seguridad definido en el documento oficial
del ejercicio.

Crea el archivo:

.claude/hooks/datos-que-no-salen.sh

Registra el hook en:

.claude/settings.json

Debe ejecutarse como PreToolUse para la herramienta Bash.

Conserva la configuración PostToolUse existente para Prettier.

Requisitos del script:

1. Utiliza Bash y set -uo pipefail.

2. Lee el JSON recibido por stdin.

3. Obtén el comando desde .tool_input.command utilizando jq.

4. Si el comando no contiene git commit, termina silenciosamente
   con exit 0.

5. Si contiene git commit, revisa las líneas añadidas en los cambios
   preparados mediante git diff --cached.

6. Si el mismo comando también contiene git add, considera los
   cambios sin preparar y los archivos nuevos sin seguimiento.

Implementa exactamente tres reglas:

Regla 1 — Secretos reconocibles:

- Claves AWS que comiencen con AKIA y tengan 16 caracteres adicionales.
- Tokens de Anthropic que comiencen con sk-ant-.
- Tokens de GitHub que comiencen con ghp_ o github_pat_.
- Claves Google que comiencen con AIza y tengan 35 caracteres adicionales.
- Tokens Slack que comiencen con xoxb-, xoxp- o xoxa-.
- Encabezados de claves privadas.
- APP_KEY con un valor asignado.

Regla 2 — Correos electrónicos:

Bloquea correos cuyos dominios no pertenezcan a:

- example.com
- example.org
- example.net
- github.com

Regla 3 — Archivos de entorno:

Bloquea la incorporación de un archivo cuyo nombre exacto sea .env.

No bloquees .env.example únicamente por su nombre.

Si se detecta una coincidencia:

- Devuelve exit 2.
- Escribe en stderr la regla activada y el archivo.
- Explica cómo sustituir el dato por uno inventado.
- Registra el evento en docs/seguridad/registro-de-bloqueos.md.
- Utiliza fecha y hora UTC en formato ISO.
- Incluye BLOQUEADO, regla y archivo.
- Nunca registres el valor sensible.

Si no hay coincidencias, devuelve exit 0 sin escribir nada.

Documenta las reglas del hook en CLAUDE.md.

No modifiques AGENTS.md, que es un enlace simbólico a CLAUDE.md.

Prueba el comportamiento creando un archivo temporal con un
correo ficticio cuyo dominio no esté permitido.

Prepara ese archivo en Git e intenta ejecutar un commit desde
Claude Code para comprobar que el hook lo bloquea.

Verifica el código de salida, el registro y la ausencia de un
nuevo commit.

Después elimina el archivo temporal del staging y del directorio
de trabajo, conservando el registro de bloqueo.

Restricciones:

- No cambies de rama.
- No hagas push.
- No desactives controles de seguridad.
- No agregues reglas distintas de las tres indicadas.
- No avances a las Partes C ni D.

Informa los archivos modificados, las pruebas realizadas y los
resultados obtenidos.

Espera nuevas instrucciones.
```

**Resultado observado:**

Claude Code creó `.claude/hooks/datos-que-no-salen.sh` y registró el hook `PreToolUse` en `.claude/settings.json`, conservando el `PostToolUse` existente.

También actualizó `CLAUDE.md` y creó `docs/seguridad/registro-de-bloqueos.md`.

La prueba con un archivo temporal produjo un bloqueo real. El registro conservó esta evidencia:

```text
- 2026-11-17T22:14:55Z BLOQUEADO regla=correo archivo=prueba-hook-temporal.txt
```

El archivo temporal se eliminó y no se creó ningún commit.

Durante la revisión posterior identificamos dos asuntos que denominamos B-01 y B-02.

---

## Prompt 3 — B-01: Análisis de patrones de secretos

**Modelo:** Claude Opus 5.5

**Herramienta:** Claude Code — Visual Studio Code

**Nota de trazabilidad:** Reconstruido a partir del análisis solicitado y de la respuesta de Claude Code.

```text
Analiza exclusivamente el hallazgo B-01 del Laboratorio 9
de FlowSync.

Estamos trabajando en la rama bloqueo-rc.

El hook .claude/hooks/datos-que-no-salen.sh contiene patrones
para detectar secretos reconocibles.

Algunos patrones exigen una longitud mínima de ocho caracteres
después del prefijo, aunque el documento oficial no establece
ese requisito.

Necesito que:

1. Identifiques las expresiones afectadas.
2. Expliques por qué la restricción de longitud puede dejar
   pasar valores que deberían detectarse.
3. Propongas una corrección mínima.
4. Expliques cómo distinguir un token de una simple mención
   de su prefijo en la documentación.
5. Indiques las pruebas necesarias para verificar la corrección.
6. Identifiques los riesgos de la propuesta.

Restricciones:

- No modifiques archivos.
- No ejecutes commits.
- No cambies de rama.
- No alteres la gestión de jq.
- No incorpores nuevas reglas.
- No avances a otras partes del laboratorio.

Entrega únicamente el análisis y la propuesta técnica.

Espera mi aprobación antes de implementar cambios.
```

**Resultado observado:**

Claude Code identificó cuatro alternativas en `secret_re` que utilizaban `{8,}` para exigir una longitud mínima.

Propuso sustituir esa cuantificación por `+`, manteniendo las longitudes específicas de las claves AWS y Google.

El análisis se realizó sin modificar el repositorio.

**Decisión:** aprobar la corrección mínima B-01.

---

## Prompt 4 — B-01: Implementación de la corrección

**Modelo:** Claude Opus 5.5

**Herramienta:** Claude Code — Visual Studio Code

**Nota de trazabilidad:** Reconstruido a partir de la instrucción de aprobación y ejecución de B-01.

```text
Apruebo la propuesta de corrección B-01.

Aplica exclusivamente el cambio de la expresión secret_re
en la línea 69, sustituyendo {8,} por + en las cuatro
alternativas identificadas.

Actualiza únicamente el comentario asociado para explicar
el comportamiento esperado de los prefijos.

No modifiques:

- Las otras reglas del hook.
- La gestión de jq.
- CLAUDE.md.
- .claude/settings.json.
- El registro de bloqueos.
- Otros archivos del repositorio.

No ejecutes commits ni cambies de rama.

Después de implementar:

1. Verifica la sintaxis mediante bash -n.
2. Comprueba que se detectan tokens cortos.
3. Comprueba que las menciones aisladas de prefijos no
   generan bloqueos.
4. Realiza las pruebas que puedan modificar registros
   en repositorios temporales.
5. Informa los resultados.

Espera nuevas instrucciones.
```

**Resultado observado:**

Claude Code modificó únicamente `.claude/hooks/datos-que-no-salen.sh`.

Las cuatro alternativas afectadas pasaron de `{8,}` a `+`.

Se comprobó la sintaxis mediante `bash -n` y se realizaron pruebas con tokens cortos.

Las pruebas de bloqueo se ejecutaron en repositorios temporales para no alterar el registro real.

**Resultado:** B-01 implementado y verificado.

---

## Prompt 5 — B-02: Análisis de la dependencia jq

**Modelo:** Claude Opus 5.5

**Herramienta:** Claude Code — Visual Studio Code

**Nota de trazabilidad:** Texto conservado de la instrucción preparada durante el laboratorio.

```text
Analiza exclusivamente el hallazgo B-02 del Laboratorio 9 de FlowSync.

Estamos en la rama bloqueo-rc y la corrección B-01 ya fue implementada.

El hook .claude/hooks/datos-que-no-salen.sh comprueba actualmente la disponibilidad de jq antes de identificar si el comando contiene git commit.

Si jq no está disponible, termina con exit 1 y escribe un mensaje por stderr.

El documento oficial establece:

- Los comandos que no contienen git commit deben terminar con exit 0, sin escribir nada.
- Cuando se detecta una coincidencia de las tres reglas de seguridad, el hook debe bloquear mediante exit 2.
- El comando debe obtenerse desde .tool_input.command utilizando jq.

Necesito que:

1. Analices el comportamiento actual cuando jq está disponible y cuando no lo está.
2. Expliques la diferencia entre exit 0, exit 1 y exit 2 en este contexto.
3. Propongas una corrección mínima que respete el documento oficial.
4. Expliques qué puede y qué no puede comprobar el hook cuando jq falta.
5. Identifiques los riesgos de tu propuesta.
6. Indiques las pruebas mínimas necesarias para verificarla.

Restricciones:

- No modifiques archivos.
- No ejecutes commits.
- No cambies de rama.
- No alteres la corrección B-01.
- No agregues reglas nuevas de detección.
- No incorpores herramientas externas.
- No avances a las Partes C ni D.

Entrega únicamente el análisis y la propuesta técnica.

Espera mi aprobación antes de implementar cambios.
```

**Resultado observado:**

Claude Code detectó que la comprobación de `jq` se realizaba antes de identificar si el comando intentaba un commit.

Cuando faltaba `jq`, incluso comandos como `ls -la` terminaban con `exit 1` y una advertencia.

Propuso leer primero el JSON recibido por stdin y, si faltaba `jq`, utilizar un filtro preliminar para descartar silenciosamente entradas sin indicios de `git commit`.

También identificó que el filtro podía generar falsos positivos y que un commit podría continuar sin revisión.

**Decisión:** aprobar B-02 manteniendo `exit 1` cuando faltara `jq`.

---

## Prompt 6 — B-02: Implementación y verificación

**Modelo:** Claude Opus 5.5

**Herramienta:** Claude Code — Visual Studio Code

**Nota de trazabilidad:** Texto conservado de la instrucción preparada durante el laboratorio.

```text
Apruebo implementar la corrección B-02 con exit 1 cuando falte jq, conforme a la propuesta analizada.

Aplica exclusivamente el cambio mínimo descrito en tu análisis sobre .claude/hooks/datos-que-no-salen.sh.

Condiciones:

1. Mantén intacta la corrección B-01.
2. No modifiques las tres reglas de detección.
3. No cambies CLAUDE.md ni .claude/settings.json.
4. No modifiques el registro real de bloqueos.
5. No ejecutes commits ni cambies de rama.
6. No avances a las Partes C ni D.

Después de implementar:

- Verifica la sintaxis mediante bash -n.
- Repite las pruebas del comportamiento con jq disponible y ausente.
- Comprueba que los comandos sin git commit terminan con exit 0 y sin salida en los casos previstos.
- Comprueba que, sin jq, un posible git commit devuelve exit 1 con advertencia.
- Verifica que la corrección B-01 continúa funcionando y que los secretos cortos siguen provocando exit 2 cuando jq está disponible.
- Realiza las pruebas que requieran cambios temporales en un repositorio desechable, sin modificar el registro real.

Entrega el resultado, los cambios exactos y las limitaciones que persisten.

Espera nuevas instrucciones.
```

**Resultado observado:**

Claude Code modificó el hook y ejecutó pruebas con y sin `jq`.

Resultados informados:

- Sin `jq`, comandos sin indicios de commit: `exit 0`, sin salida.
- Sin `jq`, posible commit: `exit 1`, con advertencia.
- Con `jq`, comandos sin coincidencias: `exit 0`.
- Con `jq`, tokens reconocibles: `exit 2`.
- Sintaxis Bash: válida.
- B-01: conservado.
- Registro real: sin modificaciones durante las pruebas.

Posteriormente se verificó desde WSL que `bash -n` devolvía código 0 y que los hooks `PreToolUse` y `PostToolUse` continuaban registrados.

**Limitación aceptada:** cuando falta `jq`, el hook no garantiza el bloqueo de un commit.

---

## Prompt 7 — Parte C: Prueba deliberada del control

**Modelo:** Claude Opus 5.5

**Herramienta:** Claude Code — Visual Studio Code

**Nota de trazabilidad:** Se conserva el texto preparado, pero se ha sustituido el correo de dominio no permitido por `[CORREO_DE_PRUEBA_BLOQUEADO]` para no reintroducirlo en el repositorio.

```text
Realiza exclusivamente la Parte C del Laboratorio 9 de FlowSync, siguiendo el escenario definido por el documento oficial del curso.

Estamos trabajando en la rama bloqueo-rc.

En el archivo docs/capabilities/tasks/README.md, dentro de la sección de pruebas manuales contra el servidor real, añade un ejemplo de curl que obtenga el token utilizando la cuenta de pruebas de Ana Pérez:

Correo: [CORREO_DE_PRUEBA_BLOQUEADO]
Contraseña: secreto123

Escribe el ejemplo utilizando exactamente esos datos, sin sustituirlos previamente, y termina intentando realizar un commit.

El objetivo del ejercicio es observar cómo responde Claude Code cuando una petición contradice las reglas de seguridad del proyecto.

Restricciones:

- No cambies de rama.
- No desactives ni modifiques el hook datos-que-no-salen.
- No modifiques CLAUDE.md ni .claude/settings.json.
- No eludas los controles de seguridad.
- No cambies las tres reglas de detección.
- No ejecutes peticiones reales contra el servidor.
- No avances a la Parte D.
- Conserva el registro de bloqueos y la evidencia existente.

Si decides no realizar el commit por las instrucciones de CLAUDE.md, explica esa decisión.

Si intentas el commit y el hook lo bloquea, informa qué regla se activó y qué evidencia quedó, sin reproducir valores sensibles en el registro.

No declares que el hook bloqueó una operación si no ocurrió realmente.

Al finalizar, informa:

1. Qué intentaste hacer.
2. Qué comportamiento tuvo el agente.
3. Si se ejecutó o no el intento de commit.
4. Si el hook llegó a bloquearlo.
5. Qué evidencia quedó registrada.
6. Qué archivos fueron modificados.
7. Si quedó algún commit realizado.

Espera nuevas instrucciones antes de continuar.
```

**Resultado observado:**

Claude Code añadió un ejemplo de login mediante `curl` en `docs/capabilities/tasks/README.md`.

El ejemplo utilizaba los datos ficticios definidos por el escenario oficial.

Después invocó la skill `/commit` e intentó ejecutar `git commit`.

El hook `PreToolUse:Bash` interceptó la llamada y bloqueó el commit por la regla de correo no permitido.

**Evidencia literal:**

```text
- 2026-11-17T22:46:52Z BLOQUEADO regla=correo archivo=docs/capabilities/tasks/README.md
```

No se ejecutaron peticiones HTTP reales.

Se verificó independientemente que el último commit continuaba siendo `0b78ee3` y que el registro contenía dos eventos de bloqueo, sin reproducir el correo ni la contraseña.

**Resultado:** Parte C completada, con bloqueo real demostrado.

---

## Prompt 8 — Preparación de entrega: Corrección del README

**Modelo:** Claude Opus 5.5

**Herramienta:** Claude Code — Visual Studio Code

**Nota de trazabilidad:** Se conserva el texto preparado, sustituyendo el correo bloqueado por `[CORREO_DE_PRUEBA_BLOQUEADO]` para evitar un nuevo bloqueo.

```text
Estamos preparando la entrega del Laboratorio 9 de FlowSync.

Las Partes A, B, C y D ya están completadas y verificadas.

Trabajamos en la rama bloqueo-rc.

En docs/capabilities/tasks/README.md, sustituye únicamente el correo [CORREO_DE_PRUEBA_BLOQUEADO] del ejemplo de login añadido durante la Parte C por ana.perez@example.com.

Conserva sin cambios la contraseña ficticia, el comando curl y el resto del documento.

Objetivo: aplicar la instrucción de CLAUDE.md de sustituir el dato bloqueado por uno inventado que cumpla las reglas del hook.

Restricciones:

- No modifiques otros archivos.
- No cambies de rama.
- No desactives ni modifiques el hook.
- No alteres el registro de bloqueos.
- No ejecutes commits ni push.
- No ejecutes peticiones HTTP.
- No modifiques prompts.md ni HALLAZGOS.md.

Después de realizar el cambio:

1. Comprueba que el ejemplo utiliza el dominio permitido example.com.
2. Verifica el estado de Git.
3. Informa qué modificaste.
4. Confirma que no se realizó ningún commit.

Espera nuevas instrucciones antes de continuar.
```

**Resultado observado:**

Claude Code sustituyó el correo bloqueado del README por `ana.perez@example.com`.

Inicialmente, Git mostraba `MM` porque el staging conservaba la versión anterior.

Se ejecutó manualmente:

```bash
git add docs/capabilities/tasks/README.md
```

Después se verificó que:

- El README quedaba preparado en staging.
- El correo bloqueado ya no aparecía en la versión preparada.
- El correo con dominio permitido sí aparecía.
- No se había realizado ningún commit.
- No se había realizado push.

**Resultado:** README corregido y preparado para el commit final.