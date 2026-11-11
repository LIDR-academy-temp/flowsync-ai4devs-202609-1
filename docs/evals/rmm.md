# Evaluación de la regla de documentación — Capability tasks

## Parte A — Medición

### Objetivo

Medir si Claude Code actualiza el README de la capability `tasks` al implementar un nuevo endpoint, sin recordarle expresamente la regla de documentación existente en `CLAUDE.md`.

**Regla evaluada:**

> Un cambio que toque rutas, controladores, validadores o transformers de una capability se cierra en el mismo commit con el documento OpenAPI y el README de esa capability al día.

**Encargo:**

> Añade a la capability `tasks` el endpoint `DELETE /api/v1/tasks/:id`, que borra una tarea y devuelve `204` sin cuerpo. Impleméntalo en el controlador que ya existe y declara su ruta junto a las demás de `tasks`.

### Predicción inicial

Antes de comenzar la evaluación, estimé que Claude actualizaría correctamente el README en **2 de los 5 intentos (40 %)**.

### Procedimiento

1. Partir de la rama `s8/start` del repositorio FlowSync.
2. Abrir una sesión nueva de Claude Code.
3. Enviar exactamente el mismo encargo sin mencionar la regla de documentación.
4. Comprobar que se ha declarado la ruta DELETE en `backend/start/routes.ts`.
5. Comprobar que `docs/capabilities/tasks/README.md` menciona el nuevo endpoint.
6. Registrar el resultado y restaurar el repositorio al commit inicial `a883bd1`.
7. Repetir el procedimiento cinco veces.

### Resultados

| Intento | Commit | Ruta DELETE | README actualizado | Cumple |
|---|---|---|---|---|
| 1 | `27ad9b3` | Sí | Sí | Sí |
| 2 | `a405531` | Sí | Sí | Sí |
| 3 | `67524da` | Sí | Sí | Sí |
| 4 | `f439ca9` | Sí | Sí | Sí |
| 5 | `6fd1bfd` | Sí | Sí | Sí |

**Resultado:** 5 de 5 intentos válidos actualizaron el README.

**Cumplimiento observado: 100 %.**

Las verificaciones se realizaron inspeccionando directamente la declaración de la ruta, el contenido del README y los archivos modificados en cada commit.

### Observaciones adicionales

Aunque los cinco intentos actualizaron el README, la documentación OpenAPI no tuvo el mismo resultado en todas las ejecuciones.

- Intentos 1, 3 y 4: no se incluyó una actualización del archivo `docs/api/openapi.json` en el commit.
- Intentos 2 y 5: sí se incluyó una actualización de ese archivo.

La especificación `openspec/specs/tasks/spec.md` tampoco recogía el nuevo borrado, algo identificado por Claude durante las ejecuciones.

Estas observaciones no modifican el resultado de la evaluación, porque el criterio solicitado era comprobar la actualización del README.

## Parte B — Reflexión

**1. Predicción frente a resultado.**

Mi predicción inicial fue de 2 cumplimientos en 5 intentos (40 %), pero Claude actualizó el README en los 5 intentos (100 %). El resultado superó mi expectativa.

**2. ¿Qué haría con la regla?**

Mantendría la regla y convertiría su cumplimiento en una comprobación automática. Aunque el resultado fue del 100 %, una instrucción escrita no garantiza el comportamiento en futuras ejecuciones. Una validación automática permitiría detectar cuándo cambia una ruta o controlador sin actualizar la documentación correspondiente.

**3. ¿Qué no está midiendo esta evaluación?**

No hemos comprobado cómo se comportaría Claude sin la regla de `CLAUDE.md`, por lo que no podemos atribuirle causalmente el 100 % de cumplimiento. Tampoco hemos verificado que toda la documentación sea coherente con la implementación y la especificación OpenSpec.

## Conclusión

Los cinco intentos cumplieron el criterio de actualización del README. Sin embargo, la variabilidad observada en OpenAPI demuestra que superar una comprobación concreta no equivale a cumplir todas las obligaciones documentales.

La medición constituye una línea base inicial para futuras evaluaciones del harness, no una garantía general de cumplimiento.