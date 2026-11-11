# Prompts

Registro de los prompts utilizados en el ejercicio del **Módulo 08 — Evals for Agentic Harness**, sobre el proyecto FlowSync.

Los cinco intentos se realizaron en sesiones independientes de Claude Code, partiendo de la rama `s8/start` y utilizando el mismo encargo, sin recordar al agente la regla de actualización de documentación establecida en `CLAUDE.md`.

**Entorno de ejecución:**
- Herramienta: Claude Code, extensión de VS Code v2.1.318.
- Modelo: Opus 5.5 Medium.
- Sistema: WSL Ubuntu.
- Rama inicial: `s8/start`.
- Commit inicial: `a883bd1`.

---

## Prompt 1

**Modelo:** Opus 5.5 Medium
**Herramienta:** Claude Code (VS Code)

```
Añade a la capability `tasks` el endpoint `DELETE /api/v1/tasks/:id`, que borra una tarea y devuelve `204` sin cuerpo. Impleméntalo en el controlador que ya existe y declara su ruta junto a las demás de `tasks`.
```

**Qué salió:** Declaró la ruta DELETE y actualizó el README de la capability. No actualizó el archivo OpenAPI versionado.

**Rama:** `feat/delete-task`
**Commit:** `27ad9b3`
**Resultado de la evaluación:** Cumple.

---

## Prompt 2

**Modelo:** Opus 5.5 Medium
**Herramienta:** Claude Code (VS Code)

```
Añade a la capability `tasks` el endpoint `DELETE /api/v1/tasks/:id`, que borra una tarea y devuelve `204` sin cuerpo. Impleméntalo en el controlador que ya existe y declara su ruta junto a las demás de `tasks`.
```

**Qué salió:** Declaró la ruta DELETE, actualizó el README y regeneró el archivo OpenAPI versionado.

**Rama:** `feat/delete-task-endpoint`
**Commit:** `a405531`
**Resultado de la evaluación:** Cumple.

---

## Prompt 3

**Modelo:** Opus 5.5 Medium
**Herramienta:** Claude Code (VS Code)

```
Añade a la capability `tasks` el endpoint `DELETE /api/v1/tasks/:id`, que borra una tarea y devuelve `204` sin cuerpo. Impleméntalo en el controlador que ya existe y declara su ruta junto a las demás de `tasks`.
```

**Qué salió:** Declaró la ruta DELETE y actualizó el README. No actualizó el archivo OpenAPI versionado.

**Rama:** `feat/delete-task-3`
**Commit:** `67524da`
**Resultado de la evaluación:** Cumple.

---

## Prompt 4

**Modelo:** Opus 5.5 Medium
**Herramienta:** Claude Code (VS Code)

```
Añade a la capability `tasks` el endpoint `DELETE /api/v1/tasks/:id`, que borra una tarea y devuelve `204` sin cuerpo. Impleméntalo en el controlador que ya existe y declara su ruta junto a las demás de `tasks`.
```

**Qué salió:** Declaró la ruta DELETE y actualizó el README. No actualizó el archivo OpenAPI versionado.

**Rama:** `feat/tasks-delete-endpoint`
**Commit:** `f439ca9`
**Resultado de la evaluación:** Cumple.

---

## Prompt 5

**Modelo:** Opus 5.5 Medium
**Herramienta:** Claude Code (VS Code)

```
Añade a la capability `tasks` el endpoint `DELETE /api/v1/tasks/:id`, que borra una tarea y devuelve `204` sin cuerpo. Impleméntalo en el controlador que ya existe y declara su ruta junto a las demás de `tasks`.
```

**Qué salió:** Declaró la ruta DELETE, actualizó el README y regeneró el archivo OpenAPI versionado.

**Rama:** `feat/delete-task-4`
**Commit:** `6fd1bfd`
**Resultado de la evaluación:** Cumple.

---

## Resumen de la ejecución

- **Predicción inicial:** 2 de 5 intentos (40 %).
- **Resultado observado:** 5 de 5 intentos válidos actualizaron el README (100 %).
- **Procedimiento:** se utilizó el mismo prompt en cinco sesiones independientes de Claude Code.
- **Restauración:** entre intentos se recuperó el estado inicial mediante `git checkout -f s8/start`, `git reset --hard upstream/s8/start` y `git clean -fd`.
- **Verificación:** se comprobó directamente la declaración de la ruta DELETE, el contenido de `docs/capabilities/tasks/README.md` y los archivos incluidos en cada commit.
- **Observación adicional:** el archivo `docs/api/openapi.json` solo se actualizó en los intentos 2 y 5.

El resultado constituye una medición inicial del cumplimiento de la regla del README. No permite demostrar que la regla de `CLAUDE.md` sea la causa del comportamiento observado, ya que no se realizaron intentos de comparación sin ella.
