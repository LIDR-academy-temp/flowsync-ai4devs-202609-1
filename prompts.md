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

**Modelo:** Sonnet 5.5
**Herramienta:** Claude Code

```
Comprueba que tienes acceso de lectura al historial Git de este repositorio.

Indica:
1. La rama actual.
2. El identificador y mensaje del commit más reciente.
3. Si puedes consultar correctamente el historial.

Utiliza únicamente comandos Git de lectura.

No modifiques archivos, no crees ramas, no ejecutes commits y no realices ninguna corrección.
```

**Qué salió:** funcionó a la primera: rama `s5/start`, commit `1980e20` e historial consultable.

## Prompt 2

**Modelo:** Sonnet 5.5
**Herramienta:** Claude Code

```
Estamos realizando el Laboratorio Práctico 5 — Agent Guardrails de FlowSync.

OBJETIVO

Audita exclusivamente las cinco reglas de la sección "Reglas de proceso" del archivo CLAUDE.md.

Contrasta cada regla con los últimos 15 commits de la rama actual y el estado presente de los archivos del repositorio.

CONTEXTO

- Rama de trabajo: auditoria-rc.
- El objetivo es auditar las reglas existentes, no corregirlas.
- No debes modificar código, configuraciones ni documentación existente.
- La auditoría debe basarse en evidencia verificable.
- La expectativa inicial ya fue registrada antes de consultar el historial y no debe modificarse.

EXPECTATIVAS INICIALES

R01 — Gestión de ramas: Ni idea.
R02 — Commits por petición: Sí.
R03 — Documentación sincronizada: No.
R04 — PR y revisión adversarial: Sí.
R05 — Respuesta final: Ni idea.

INSTRUCCIONES

1. Lee las cinco reglas de proceso de CLAUDE.md.
2. Consulta los últimos 15 commits mediante comandos Git de lectura.
3. Inspecciona los archivos actuales que sean relevantes para cada regla.
4. Determina qué evidencia existe para evaluar su cumplimiento.
5. No supongas que una regla se cumple porque está escrita.
6. No clasifiques como incumplimiento una regla cuya ejecución no puedas comprobar.
7. No inventes acciones del agente, prompts, commits, revisiones ni evidencias.
8. No realices correcciones ni modificaciones durante el análisis.

FORMATO DE RESULTADO

Para cada regla, entrega una fila con cinco columnas:

- Qué pide la regla.
- Qué se revisó para comprobarla (comando o archivo).
- Veredicto: "se cumple", "no se cumple" o "no se puede comprobar con la información disponible".
- Evidencia concreta, en una línea.
- Qué harías con ella: "dejarla", "borrarla" o "convertirla en una comprobación automática".

CRITERIOS DE CALIDAD

- Utiliza una fila por regla.
- Mantén la tabla breve y verificable.
- Identifica commits o archivos concretos cuando existan.
- Explica qué información falta cuando no sea posible comprobar una regla.
- Distingue la evidencia de las inferencias.
- No incluyas reglas que estén fuera de la sección "Reglas de proceso".
- No cambies las expectativas iniciales.

IMPORTANTE

En esta primera ejecución, presenta el resultado en el chat para revisión.

No crees ni modifiques todavía docs/auditoria/rc.md ni prompts.md.

Espera nuestra validación antes de escribir los entregables.
```

**Qué salió:** tabla de cinco filas, las cinco «no se puede comprobar»; se verificó `cbe9617` aparte.

## Prompt 3

**Modelo:** Sonnet 5.5
**Herramienta:** Claude Code

```
Estamos completando el Laboratorio 5 — Agent Guardrails de FlowSync.

OBJETIVO

Preparar exclusivamente los dos entregables oficiales:

1. docs/auditoria/rc.md
2. prompts.md

No modificar ningún otro archivo.

ARCHIVO 1 — docs/auditoria/rc.md

Incluye, en este orden:

1. Título de la auditoría.
2. Identificación de la rama auditoria-rc y alcance de los últimos 15 commits.
3. Expectativas iniciales, conservando exactamente estos valores:
   - R01 Gestión de ramas: Ni idea
   - R02 Commits por petición: Sí
   - R03 Documentación sincronizada: No
   - R04 PR y revisión adversarial: Sí
   - R05 Respuesta final: Ni idea
4. Tabla de auditoría con las cinco columnas exigidas por el curso:
   - Qué pide la regla.
   - Qué se revisó.
   - Veredicto.
   - Evidencia.
   - Qué harías con ella.
5. Las tres reflexiones finales aprobadas.

Utiliza los resultados de la auditoría realizada anteriormente en esta misma sesión.

Conserva los cinco veredictos: "no se puede comprobar con la información disponible".

Incluye la evidencia del commit cbe9617, que verificamos manualmente con git show --format=fuller --name-status cbe9617.

Las tres reflexiones finales deben aparecer exactamente así:

B1: R03 — Pensaba que no se cumplía la sincronización documental, pero al revisar cbe9617 comprobé que sí se actualizó el README y la documentación OpenAPI. No pude demostrar si los archivos generados debían modificarse. Mi expectativa de incumplimiento no quedó confirmada.

B2: R02 — No se puede comprobar que cada petición terminara con un commit utilizando /commit. Para verificarlo haría falta conservar un registro de las peticiones y de la invocación de la skill, vinculado a cada commit.

B3: R05 — Eliminaría la regla de responder únicamente con la URL del PR. La considero una preferencia de comunicación que no deja evidencia en Git y aporta poco valor como control del proceso de desarrollo.

ARCHIVO 2 — prompts.md

Respeta la estructura de la plantilla oficial.

Registra los prompts que realmente envié durante este ejercicio, en su orden original.

Para cada uno:

- Modelo: Sonnet 5.5.
- Herramienta: Claude Code.
- Texto original exacto, incluidos saltos de línea.
- Resultado opcional, en una línea.

Debes incluir el prompt inicial de comprobación de Git, el prompt completo de auditoría y este prompt de preparación de entregables.

Recupera los textos originales de esta sesión. No reconstruyas ni reformules un prompt si no puedes recuperar su contenido literal.

Si no tienes acceso al texto exacto de alguno, indícalo y solicita que lo proporcione antes de completar esa sección. No inventes contenido.

RESTRICCIONES

- No modificar CLAUDE.md.
- No modificar código ni configuraciones.
- No ejecutar npm, tests ni comandos de generación.
- No corregir los hallazgos de la auditoría.
- No crear commits.
- No ejecutar git push.
- No abrir Pull Requests.
- No modificar las expectativas iniciales.
- No inventar evidencia.

Al finalizar, informa qué archivos creaste o modificaste y qué contenido quedó pendiente de verificar.

Espera nuestra revisión antes de continuar.
```

**Qué salió:** generó `docs/auditoria/rc.md` y rellenó `prompts.md`, con dos puntos señalados para revisión.

## Prompt 4

**Modelo:** Sonnet 5.5
**Herramienta:** Claude Code

```
Estamos en LAB5-16.2 del Laboratorio 5 — Agent Guardrails.

Realiza únicamente estas correcciones documentales:

1. En docs/auditoria/rc.md, fila R05 de la tabla, cambia la última columna de "Dejarla" a "Borrarla (preferencia de comunicación que no aporta valor suficiente como control del proceso de desarrollo)".

2. En la fila R03, ajusta exclusivamente la recomendación de automatización para que proponga verificar que los artefactos generados siguen sincronizados con su fuente y que el README de la capability está actualizado. No debe exigir cambios en .adonisjs/ cuando no sean necesarios.

3. Añade este prompt íntegro, exactamente como fue enviado, a prompts.md como Prompt 4, indicando:
   - Modelo: Sonnet 5.5
   - Herramienta: Claude Code
   - Resultado: corrección documental de coherencia y precisión.

RESTRICCIONES:
- No modifiques las expectativas iniciales.
- No cambies los cinco veredictos.
- No modifiques las reflexiones B1, B2 y B3.
- No alteres las evidencias ni los comandos registrados.
- No modifiques código, configuraciones ni otros archivos.
- No ejecutes commits, push ni abras PR.

Al finalizar, muestra un resumen exacto de los cambios y el resultado de git status --short.
```

**Qué salió:** corrección documental de coherencia y precisión.

## Prompt 5

**Modelo:** Sonnet 5.5
**Herramienta:** Claude Code

```
Estamos en LAB5-17.2 del Laboratorio 5 — Agent Guardrails.

Los dos entregables oficiales ya fueron revisados y preparados en el índice de Git:
- docs/auditoria/rc.md
- prompts.md

OBJETIVO

Crear un único commit con el mensaje exacto:

auditoria: reglas de proceso + prompts

INSTRUCCIONES

1. Antes del commit, registra este mensaje íntegro en prompts.md como Prompt 5, con Modelo: Sonnet 5.5 y Herramienta: Claude Code.
2. Conserva sin modificaciones los cuatro prompts anteriores.
3. Utiliza la skill /commit definida en el repositorio para realizar el commit.
4. Incluye únicamente docs/auditoria/rc.md y prompts.md.
5. Actualiza el índice de Git para incorporar el nuevo registro de prompts.md.
6. Comprueba que git diff --cached --check no presenta errores antes del commit.
7. No modifiques otros archivos.
8. No ejecutes git push.
9. No abras Pull Requests.
10. No invoques todavía adversarial-reviewer.

Al finalizar, muestra:
- Hash y mensaje del commit.
- Archivos incluidos.
- Resultado de git status --short.

Si la skill /commit exige alguna acción incompatible con estas restricciones, detente y explica el conflicto antes de continuar.
```

**Qué salió:** se detuvo ante un conflicto entre el mensaje exacto y el formato de la skill; con la opción A se hizo el commit.
