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

**Modelo:** Sonnet 5 High
**Herramienta:** Claude Code

```
Audita las reglas de proceso de la sección «Reglas de proceso» de CLAUDE.md usando los últimos 15 commits de la rama actual y el estado actual de los archivos relevantes.

Completa la tabla de `docs/auditoria/jaba.md`, preservando exactamente la sección «Expectativa inicial». Usa las seis reglas que ya aparecen allí para organizar las filas. Para cada una, indica:
- Qué pide la regla, resumido en una frase.
- Qué comando ejecutaste o qué archivo consultaste.
- Un veredicto exacto: «se cumple», «no se cumple» o «no se puede comprobar con la información disponible».
- Una línea de evidencia concreta. Si no se puede comprobar, explica qué información falta.
- Una acción: «dejarla», «borrarla» o «convertirla en una comprobación automática».

No infieras cumplimiento sin evidencia. Distingue lo que puede probar el historial de lo que requeriría información que no aparece en commits o archivos. Si inspeccionas un cambio, señala el commit o archivo concreto.

No corrijas ningún incumplimiento ni modifiques código, documentación del producto, instrucciones u otros archivos. Puedes modificar únicamente `docs/auditoria/jaba.md`, completando la tabla de la Parte A. No completes todavía la Parte B de las tres líneas.
```

**Qué salió:** hubo que corregir la primera auditoría


## Prompt 2

**Modelo:** Sonnet 5 High
**Herramienta:** Claude Code

```
Revisa la Parte A de docs/auditoria/jaba.md usando como alcance exactamente los últimos 15 commits de la rama actual y las reglas vigentes en CLAUDE.md.

Usa evidencia concreta por fila: comandos, archivos y, cuando corresponda, el commit exacto. No uses git log --all, reflog ni commits anteriores a esos 15. Comprueba también si la regla ya existía cuando ocurrió el cambio que estás evaluando; no la apliques retroactivamente.

No atribuyas automáticamente a Jose commits escritos por otras personas. Distingue entre lo que demuestra el historial del repositorio y lo que permite afirmar sobre el proceso personal de Jose. Si no se puede verificar una conducta con la evidencia disponible, usa el veredicto exacto “no se puede comprobar con la información disponible”.

Para la regla 5, ten en cuenta esta evidencia: 160fbc7 añade la regla; cbe9617 es posterior, modifica tres controladores y archivos de OpenAPI, y actualiza el README de tasks; la lista de archivos de ese commit no muestra cambios en backend/.adonisjs/. Verifica si eso incumple el texto de la regla.

Conserva intacta la tabla de expectativa inicial. No cambies código ni otros archivos. Actualiza la tabla de auditoría y completa la Parte B solo con conclusiones que se desprendan de la evidencia. Si una conclusión no se puede sostener, indícalo en vez de inventar una.

```

**Qué salió:** la Parte A funcionó a la primera, pero la Parte B necesitó una revisión posterior: la reflexión 3 usaba la ausencia de PRs abiertos como prueba de que la regla 6 nunca se ejecuta, lo que no era coherente con el veredicto "no se puede comprobar" de esa misma fila en la Parte A.

## Prompt 3

**Modelo:** Sonnet 5 High
**Herramienta:** Claude Code

```
Revisa las instrucciones del ejercicio para la Parte B y corrige únicamente esa sección de docs/auditoria/jaba.md.

La Parte B debe responder a sus tres reflexiones concretas: qué regla se apartó más de mi expectativa inicial, qué regla no se pudo comprobar y qué evidencia permitiría comprobarla, y qué regla eliminaría y por qué. En la expectativa inicial puse “Ni idea” para las seis reglas; no inventes ahora una expectativa previa. Exprésalo con honestidad en la primera respuesta. Para la regla que eliminaría, presenta una propuesta razonada y explícitamente como propuesta para que yo pueda validarla; no afirmes que es una preferencia personal mía.

No cambies la Parte A ni ningún otro archivo. No reescribas el contenido literal de los prompts en prompts.md. Déjame una nota si detectas texto de prompts que podría no coincidir exactamente con lo que lancé.

```

**Qué salió:** funcionó a la primera

## Prompt 4

**Modelo:** Sonnet 5 High
**Herramienta:** Claude Code

```
Revisa solo la coherencia entre la fila 6 de la Parte A y la reflexión 3 de la Parte B en docs/auditoria/jaba.md.

La Parte A marca la regla 6 como “no se puede comprobar” y recomienda “convertirla en una comprobación automática”; la Parte B propone borrarla basándose en que no se encontraron PRs abiertos en una exploración anterior. No presentes la ausencia de PRs abiertos como prueba de que la regla nunca se ejecuta. Alinea ambas conclusiones o explica con evidencia verificable por qué deberían diferir. No cambies otras filas ni completes hechos que no estén comprobados.

En prompts.md, cambia solo el “Qué salió” de Prompt 2 para reflejar que la Parte B necesitó una revisión posterior. No modifiques los textos literales de los prompts ni el resto del archivo.

```

**Qué salió:** funcionó a la primera

## Prompt 5

**Modelo:** Sonnet 5 High
**Herramienta:** Claude Code

```
Haz una última corrección acotada en docs/auditoria/jaba.md:

- En la fila 6 y en la reflexión 3, no digas que PRs y revisiones no dejan rastro “en ningún sentido”. Sí dejan rastro en GitHub; lo preciso es que esa evidencia quedó fuera del alcance consultado.
- La reflexión 3 debe nombrar explícitamente una regla que propondría borrar. Usa como propuesta la regla 4: eliminar la obligación de invocar específicamente /commit en cada petición y conservar controles verificables sobre el resultado del commit. Preséntalo como propuesta para que Jose la valide, no como preferencia personal suya.
- Para mantener coherencia, cambia la acción de la fila 4 a “borrarla”. Mantén la fila 6 como “convertirla en una comprobación automática”, aclarando que la protección de rama puede exigir PR y revisión, pero no demuestra por sí sola que haya un único PR por unidad ni que la revisión sea el último paso.

No modifiques las demás filas ni la expectativa inicial. No cambies el texto literal de los prompts. En prompts.md registra este prompt como Prompt 5 y el resultado de Prompt 4, si todavía no aparece. Modelo: Sonnet 5 High. Herramienta: Claude Code.
```

**Qué salió:** (pendiente de valorar)