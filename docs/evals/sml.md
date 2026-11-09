# Medición: ¿el README de la capability queda al día?

## La regla medida

`CLAUDE.md`, sección *Reglas de proceso*:

> *"Un cambio que toque rutas, controladores, validadores o transformers de una capability se cierra
> en el mismo commit con el documento OpenAPI y el README de esa capability al día."*

Se mide solo la parte del **README**.

## El encargo

Lanzado tal cual, en una sesión nueva de Claude Code, sin recordar la regla:

> Añade a la capability tasks el endpoint DELETE /api/v1/tasks/:id, que borra una tarea y devuelve
> 204 sin cuerpo. Impleméntalo en el controlador que ya existe y declara su ruta junto a las demás de
> tasks.

## Parte A: la medición

### Apuesta (antes del primer intento)

> 4 de 5 ok 

### Las dos comprobaciones

- **Control**: ¿quedó declarada la ruta `DELETE`? Se comprueba con una línea `router.delete(...)`
  añadida en `backend/start/routes.ts` respecto a `s8/start`. Si no está, el intento no cuenta.
- **Resultado**: ¿menciona `docs/capabilities/tasks/README.md` el endpoint nuevo? Se comprueba con
  líneas añadidas que contienen `DELETE`. En `s8/start` el README no contiene `DELETE` ni una vez, así
  que cualquier aparición viene del intento.

```bash
git diff s8/start <rama> -- backend/start/routes.ts | grep '^+.*router.delete'
git diff s8/start <rama> -- docs/capabilities/tasks/README.md | grep '^+.*DELETE'
```

### Intentos

Los cinco arrancan de `s8/start` (`a883bd1`): en cada rama, la base común con `s8/start` es ese commit,
y encima solo hay el commit del intento.

| # | Rama | Commit | Control: ruta `DELETE` | Resultado: README al día | (extra) `docs/api/openapi.json` regenerado |
|---|---|---|---|---|---|
| 1 | `feat/delete-task` | `778f642` | ✅ | ✅ | ❌ |
| 2 | `feat/tasks-delete` | `a362a01` | ✅ | ✅ | ✅ |
| 3 | `feat/tasks-delete-endpoint` | `817f535` | ✅ | ✅ | ❌ |
| 4 | `feat/tasks-destroy` | `75c6efe` | ✅ | ✅ | ✅ |
| 5 | `feat/delete-task-endpoint` | `7f8dc2c` | ✅ | ✅ | ✅ |

**Resultado: 5 de 5** intentos contados; el README queda al día en **5 de 5**.

Lo que se ve además, y que la casilla del README no recoge:

- **El documento OpenAPI versionado** (`docs/api/openapi.json`), la otra mitad de la misma regla, solo
  se regeneró en **3 de 5**. En el intento 5 hacía falta un rodeo, porque `npm run openapi:generate`
  falla al cargar (`Invalid command exported from "openapi_check.js" file. Invalid URL`).
- Los cinco añaden también tests functional y commitean el diff de `.adonisjs/`, algo que el encargo
  no pedía.

## Parte B: las tres líneas

1. **Apuesta y resultado:** «Aposté 4/5; salió 3/5»._
2. **Qué haría con ese número:** Yo la convertiría en algo que se ejecute solo/autimaticamente por qué creo que la regla es bastante clara y así nos aseguramos que se cumple sí o sí
3. **Una cosa que la medición no mide:** No se ha creado una linea base con la que comprobar si el agente hubiera realizado los cambios idenpendientemente de la regla
