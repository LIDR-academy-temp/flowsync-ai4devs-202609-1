# Prompts — Laboratorio 8: Evals for Agentic Harness

## Contexto del experimento

- **Curso:** LIDR AI4Devs — Módulo 8.
- **Herramienta:** Claude Code v2.1.318.
- **Modelo:** Opus 5.5.
- **Esfuerzo:** Medium.
- **Permisos:** Auto mode.
- **Repositorio:** FlowSync AI4Devs.
- **Rama inicial:** `s8/start`.
- **Commit inicial:** `a883bd1749b4a8411735a1a34ec483bff60591e3`.
- **Fecha:** 9 de noviembre de 2026.

Se registran los seis envíos reales del mismo prompt, en orden cronológico.

El primero no fue evaluable por un problema de autenticación.
Los cinco siguientes corresponden a los cinco ensayos válidos.

La incidencia inicial no se incluye en el denominador de la medición.

---

## Prompt 1 — Intento no evaluable

**Modelo:** Opus 5.5
**Herramienta:** Claude Code v2.1.318

```text
Añade a la capability tasks el endpoint DELETE /api/v1/tasks/:id, que borra una tarea y devuelve 204 sin cuerpo. Impleméntalo en el controlador que ya existe y declara su ruta junto a las demás de tasks.
```

**Qué salió:** Claude Code respondió:

```text
Login reached its time limit · Please run /login
```

No ejecutó el encargo. Se resolvió la autenticación mediante `/login`.

**Clasificación:** incidencia de autenticación; intento no evaluable.

---

## Prompt 2 — Ensayo válido 1

**Modelo:** Opus 5.5
**Herramienta:** Claude Code v2.1.318

```text
Añade a la capability tasks el endpoint DELETE /api/v1/tasks/:id, que borra una tarea y devuelve 204 sin cuerpo. Impleméntalo en el controlador que ya existe y declara su ruta junto a las demás de tasks.
```

**Qué salió:** Implementó DELETE y actualizó el README.

- Control DELETE: aprobado.
- README: actualizado.
- Rama: `feat/delete-task`.
- Commit: `08d137f`.
- Resultado: cumple.

---

## Prompt 3 — Ensayo válido 2

**Modelo:** Opus 5.5
**Herramienta:** Claude Code v2.1.318

```text
Añade a la capability tasks el endpoint DELETE /api/v1/tasks/:id, que borra una tarea y devuelve 204 sin cuerpo. Impleméntalo en el controlador que ya existe y declara su ruta junto a las demás de tasks.
```

**Qué salió:** Implementó DELETE y actualizó el README.

- Control DELETE: aprobado.
- README: actualizado.
- Rama: `feat/tasks-delete`.
- Commit: `81d80e2`.
- Resultado: cumple.

---

## Prompt 4 — Ensayo válido 3

**Modelo:** Opus 5.5
**Herramienta:** Claude Code v2.1.318

```text
Añade a la capability tasks el endpoint DELETE /api/v1/tasks/:id, que borra una tarea y devuelve 204 sin cuerpo. Impleméntalo en el controlador que ya existe y declara su ruta junto a las demás de tasks.
```

**Qué salió:** Implementó DELETE y actualizó el README.

- Control DELETE: aprobado.
- README: actualizado.
- Rama: `feat/tasks-delete-endpoint`.
- Commit: `abacfe2`.
- Resultado: cumple.

---

## Prompt 5 — Ensayo válido 4

**Modelo:** Opus 5.5
**Herramienta:** Claude Code v2.1.318

```text
Añade a la capability tasks el endpoint DELETE /api/v1/tasks/:id, que borra una tarea y devuelve 204 sin cuerpo. Impleméntalo en el controlador que ya existe y declara su ruta junto a las demás de tasks.
```

**Qué salió:** Implementó DELETE y actualizó el README.

- Control DELETE: aprobado.
- README: actualizado.
- Rama: `feat/tasks-destroy`.
- Commit: `e6480cb`.
- Resultado: cumple.

---

## Prompt 6 — Ensayo válido 5

**Modelo:** Opus 5.5
**Herramienta:** Claude Code v2.1.318

```text
Añade a la capability tasks el endpoint DELETE /api/v1/tasks/:id, que borra una tarea y devuelve 204 sin cuerpo. Impleméntalo en el controlador que ya existe y declara su ruta junto a las demás de tasks.
```

**Qué salió:** Implementó DELETE y actualizó el README.

- Control DELETE: aprobado.
- README: actualizado.
- Rama: `feat/tasks-delete-by-id`.
- Commit: `6bf8dd5`.
- Resultado: cumple.

---

## Resumen de trazabilidad

| Ensayo válido | Control DELETE | README actualizado | Resultado |
|---|---|---|---|
| 1 | Sí | Sí | Cumple |
| 2 | Sí | Sí | Cumple |
| 3 | Sí | Sí | Cumple |
| 4 | Sí | Sí | Cumple |
| 5 | Sí | Sí | Cumple |

**Predicción inicial:** 3 de 5 (60 %).

**Resultado observado:** 5 de 5 (100 %).

**Importante:** la medición describe el cumplimiento observado durante los cinco ensayos. No demuestra por sí sola que la regla de `CLAUDE.md` haya causado ese resultado.
