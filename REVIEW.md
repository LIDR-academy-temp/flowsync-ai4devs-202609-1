# REVIEW.md — instrucciones solo para el revisor de código

Calibración para FlowSync. La spec viva (`openspec/specs/`) manda sobre el código y sobre sus comentarios.

## Grave (lo único que bloquea)
Solo esto es un hallazgo grave; lo demás es sugerencia.
- Un **scenario de `openspec/specs/` que el cambio rompe**: nómbralo (requirement y scenario).
- **Fuga de datos o de seguridad**: el email del responsable en una respuesta, tokens o secretos, una ruta sin `middleware.auth()`, datos asignables por el cliente que debía poner el servidor.
- **Pérdida o corrupción de datos**, o un resultado incorrecto en silencio (p. ej. 200 vacío donde la spec exige 422).
- **Contrato que miente**: `docs/api/openapi.json` o el README de la capability describen un comportamiento que el código no tiene. Que coincidan entre sí no basta.

## Sugerencia (nunca grave)
Nombres, estructura, refactors, rendimiento sin impacto demostrado, y scenarios sin test que el cambio no toca. Un cambio sin tests es grave solo si cambia un comportamiento que la spec fija.

## Tope
Máximo **5 sugerencias menores** por revisión, las de más valor. El resto, en una sola línea: «y N sugerencias menores más», sin detallarlas. Los graves no cuentan para el tope.

## No reportar
- Formato y lint: los vigilan Prettier, ESLint (backend) y oxlint (frontend).
- Errores de tipos: los vigila `tsc` (`npm run typecheck` / `npm run build`).
- `docs/api/openapi.json` desfasado respecto al código: lo vigila `openapi:check`.
- Ficheros generados: `backend/database/schema.ts`, `backend/.adonisjs/`, `frontend/src/components/ui/` (shadcn), lockfiles.
- `eslint` 9 y `@adonisjs/eslint-config` 2 en `backend/package.json`: el downgrade es intencional.
- Rutas, estilos o textos de `docs/` que no afirmen un comportamiento de la API.

## Evidencia
- Para afirmar que algo **se comporta** de una manera, cita `archivo:línea` del código que has leído. No lo deduzcas del nombre de una función, de un docblock ni del README: aquí hay comentarios que dicen lo contrario de lo que hace el código.
- Si no has abierto el fichero, no afirmes: di «no verificado».
- Un hallazgo sin `archivo:línea` y sin el scenario o la regla que rompe no se publica.
- Lee la salida de `gh pr diff` directamente; no la redirijas a ficheros.
