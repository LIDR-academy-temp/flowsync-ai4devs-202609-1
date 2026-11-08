# Evals: medición de la regla del README de capability

## Parte A: la medición

### La regla medida

En `CLAUDE.md`, en las reglas de proceso:

> "Un cambio que toque rutas, controladores, validadores o transformers de una capability se cierra en el mismo commit con el documento OpenAPI y el README de esa capability al día."

Se mide solo la parte del README.

### El encargo

Se lanzó tal cual, en una sesión nueva cada vez y sin recordar la regla:

> Añade a la capability `tasks` el endpoint `DELETE /api/v1/tasks/:id`, que borra una tarea y devuelve `204` sin cuerpo. Impleméntalo en el controlador que ya existe y declara su ruta junto a las demás de `tasks`.

### Mi apuesta (escrita antes del primer intento)

5 de 5. La regla es corta y parece bien especificada, así que mi apuesta es que se cumple el 100 % de las veces. Aun así, por cómo va la sesión, sospecho que me voy a equivocar.

### Las dos comprobaciones

- **Control:** ¿quedó declarada la ruta `DELETE`? Si no, el intento no cuenta.
- **Resultado:** ¿menciona `docs/capabilities/tasks/README.md` el endpoint nuevo?

Entre un intento y el siguiente, el proyecto se dejó como estaba (`git checkout -f s8/start`, `git reset --hard upstream/s8/start`, `git clean -fd`).

### Resultados

| Intento | Control (ruta `DELETE` declarada) | Resultado (README menciona el endpoint) | ¿Cuenta? |
|---|---|---|---|
| 1 | Sí | Sí | Sí |
| 2 | Sí | Sí | Sí |
| 3 | Sí | Sí | Sí |
| 4 | Sí | Sí | Sí |
| 5 | Sí | Sí | Sí |

**Total: 5 de 5** intentos válidos con el README al día (100 %).

## Parte B: las tres líneas

1. **Apuesta y resultado.** Aposté 5 de 5 y salió 5 de 5, en las cinco ejecuciones completas: la regla se cumplió el 100 % de las veces.
2. **Qué haría con ese número.** La regla se ha cumplido el 100 % de las veces, pero eso no garantiza que se cumpla siempre puesto que solo se verificó en 5 ejecuciones. De todas formas lo primero que haría es decidir si la dejo o la borro, falta saber qué pasa si la elimino.
3. **Algo que mi medición no está midiendo.** No mide si el README seguiría al día sin la regla, porque no hay línea base sin ella. Y con solo 5 sesiones no se puede garantizar que se cumpla el 100 % de las veces en más ejecuciones.
