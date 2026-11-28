# Prompts

Todos los prompts, en orden y copiados tal cual de los registros de sesión de Claude Code. Las skills `/priority-ticket` y `/commit`, el subagente `adversarial-reviewer` y las reglas de proceso del `CLAUDE.md` no tienen prompt en los registros: se escribieron fuera del chat del agente.

---

# Copia con harness (`flowsync-ai4devs-202609-1`)

## Prompt 1

**Modelo:** Claude Opus 5.5
**Herramienta:** Claude Code

```
login
```

**Qué salió:** no era un prompt útil; luego probé con el siguiente.

## Prompt 2

**Modelo:** Claude Opus 5.5
**Herramienta:** Claude Code

```
run /login
```

## Prompt 3

**Modelo:** Claude Opus 5.5
**Herramienta:** Claude Code

```
/init
```

**Qué salió:** generó el `CLAUDE.md` (pieza 1).

## Prompt 4

**Modelo:** Claude Opus 5.5
**Herramienta:** Claude Code

```
claude mcp add
```

**Qué salió:** no funcionó; tuve que repetirlo varias veces (prompts 5 a 9).

## Prompt 5

**Modelo:** Claude Opus 5.5
**Herramienta:** Claude Code

```
claude mcp add --transport http --scope project atlassian
```

## Prompt 6

**Modelo:** Claude Opus 5.5
**Herramienta:** Claude Code

```
https://mcp.atlassian.com/v1/mcp/authv2
```

## Prompt 7

**Modelo:** Claude Opus 5.5
**Herramienta:** Claude Code

```
claude mcp add --transport http --scope project atlassian
```

## Prompt 8

**Modelo:** Claude Opus 5.5
**Herramienta:** Claude Code

```
claude mcp add --transport http --scope project atlassian https://mcp.atlassian.com/v1/mcp/authv2
```

## Prompt 9 (sesión nueva)

**Modelo:** Claude Opus 5.5
**Herramienta:** Claude Code

```
claude mcp add --transport http --scope project atlassian https://mcp.atlassian.com/v1/mcp/authv2
```

**Qué salió:** dejó configurado `.mcp.json` a nivel de proyecto (pieza 2).

## Prompt 10

**Modelo:** Claude Opus 5.5
**Herramienta:** Claude Code

```
ls -la
```

## Prompt 11 (sesión nueva)

**Modelo:** Claude Opus 5.5
**Herramienta:** Claude Code

```
ls -la
```

## Prompt 12 (sesión nueva)

**Modelo:** Claude Opus 5.5
**Herramienta:** Claude Code

```
run /mcp
```

## Prompt 13

**Modelo:** Claude Opus 5.5
**Herramienta:** Claude Code

```
run
```

**Qué salió:** levantó el backend e hizo un smoke test del signup.

## Prompt 14

**Modelo:** —
**Herramienta:** Claude Code (comando `/mcp`)

```
/mcp
```

**Qué salió:** autenticado y conectado a Atlassian.

## Prompt 15

**Modelo:** Claude Opus 5.5
**Herramienta:** Claude Code

```
Configura un hook que corra el formateador del frontend cada vez que se edite un archivo.Configura un hook que corra el formateador del frontend cada vez que se edite un archivo.
```

**Qué salió:** se pegó duplicado. Hizo falta aclarar que instalara Prettier (prompts 16 y 17).

## Prompt 16

**Modelo:** Claude Opus 5.5
**Herramienta:** Claude Code

```
instalar Prettier en el frontend
```

## Prompt 17

**Modelo:** Claude Opus 5.5
**Herramienta:** Claude Code

```
si
```

**Qué salió:** Prettier más el hook `.claude/hooks/format-frontend.mjs` (pieza 6), commit con `/commit`, PR #1 y revisión con `adversarial-reviewer`.

## Prompt 18

**Modelo:** Claude Opus 5.5
**Herramienta:** Claude Code

```
git add .claude CLAUDE.md AGENTS.md .mcp.json git commit -m "chore: configura el harness de Claude Code"
```

**Qué salió:** commit del harness a mano, antes de lanzar el ticket.

## Prompt 19 (el encargo)

**Modelo:** Claude Opus 5.5
**Herramienta:** Claude Code (skill `/priority-ticket`)

```
/priority-ticket
```

**Qué salió:** no encontró tickets asignados a mí (FLOW-1 estaba sin asignar) y me preguntó; respondí «Take FLOW-1». Propuso el plan, lo aprobé y **lo implementó** (PR #2), aunque el README pedía no aplicarlo.

## Prompt 20

**Modelo:** Claude Opus 5.5
**Herramienta:** Claude Code

```
git checkout -b feat/login-frontend
```

## Prompt 21

**Modelo:** Claude Opus 5.5
**Herramienta:** Claude Code (skill `/commit`)

```
/commit
```

## Prompt 22

**Modelo:** Claude Opus 5.5
**Herramienta:** Claude Code

```
gh pr create
```

**Qué salió:** la rama apuntaba al mismo commit que el PR #2. Me preguntó y respondí «Don't create it».

## Prompt 23

**Modelo:** Claude Opus 5.5
**Herramienta:** Claude Code

```
git branch
--show-current
```

---

# Copia sin harness (`flowsync-sin-harness`)

## Prompt 24 (el encargo)

**Modelo:** Claude Opus 5.5
**Herramienta:** Claude Code

```
Busca en Jira el ticket de mayor prioridad asignado a mí, resume sus criterios de aceptación, y entra en plan mode para implementarlo.
```

**Qué salió:** resumió FLOW-1 y propuso el plan. Lo aprobé y el agente preguntó si implementar, porque el README dice no aplicarlo; respondí «Quedarse en el plan».


