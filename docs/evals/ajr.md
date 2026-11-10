# Medición: ¿se cumple la regla del README de la capability?

## La regla medida

`CLAUDE.md`, sección «Reglas de proceso»:

> *"Un cambio que toque rutas, controladores, validadores o transformers de una capability se cierra en el mismo commit con el documento OpenAPI y el README de esa capability al día."*

Se mide solo la parte del README: ¿acaba `docs/capabilities/tasks/README.md` mencionando el endpoint nuevo?

## El encargo (idéntico en cada intento, sesión nueva, sin recordar la regla)

```
Añade a la capability `tasks` el endpoint `DELETE /api/v1/tasks/:id`, que borra una tarea y devuelve `204` sin cuerpo. Impleméntalo en el controlador que ya existe y declara su ruta junto a las demás de `tasks`.
```

## Parte A

### Apuesta (escrita antes del primer intento)

**2 de 5**: creo que el README de la capability quedará al día en 2 de los 5 intentos.

### Comprobaciones, desde donde haya quedado el agente

```bash
# Control: ¿se declaró la ruta DELETE? Si no, el intento no cuenta.
git diff s8/start -- backend/start/routes.ts | grep -i '^+.*delete'

# Resultado: ¿menciona el README el endpoint nuevo? (revisar el diff entero para confirmar)
git diff s8/start -- docs/capabilities/tasks/README.md
```

### Limpieza entre intentos

```bash
git checkout -f s8/start
git reset --hard upstream/s8/start
git clean -fd
git status -sb   # tiene que salir solo: ## s8/start...upstream/s8/start
```

### Resultados

| Intento | Control: ruta `DELETE` declarada | ¿Cuenta? | Resultado: README al día |
|---|---|---|---|---|
| 1 | sí | sí | sí |
| 2 | sí | sí | sí |
| 3 | sí | sí | sí |
| 4 | sí | sí | sí |
| 5 | sí | sí | sí |

**Resultado:** 5 de 5 intentos válidos con el README al día.

## Parte B

1. **Apuesta y resultado:** 2 vs 5

2. **Qué haría con ese número** (borrar la regla, reescribirla o convertirla en algo que se ejecute solo), y por qué:

  - borrar la regla: No puedo tomar esta decisión sin antes medir el cumplimiento con 5 ensayos **sin la regla en el fichero de instrucciones**. Si se cumple aun sin tener la regla escrita, sí la borraría.
  - reescribirla: Con 5 aciertos de 5, ni me planteo esto.
  - convertirla en algo que se ejecute solo: aun con pleno de aciertos, sigue sin ser una garantía. Al sexto intento podría fallar. Por tanto, haría esto, convertirlo en algo que se ejecute solo.

3. **Una cosa que mi medición no está midiendo:** No está midiendo si el README se actualizaría igualmente si no estuviera escrita la regla en el fichero de instrucciones. Es decir, si es realmente necesaria la regla escrita.
