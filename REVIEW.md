# Calibración del revisor

Solo para revisiones de código. La arquitectura está en `CLAUDE.md` y el comportamiento exigido, en
`openspec/specs/<capability>/spec.md`.

## Grave: solo esto

- Contradice un requirement o scenario de la spec. Cita el scenario por su título.
- Seguridad: una ruta sin `middleware.auth()` que debería tenerlo, datos de cuenta expuestos (email
  o cualquier cosa derivada de él), o leer o escribir algo sin el token que lo autoriza.
- Pérdida o corrupción silenciosa de datos: una escritura que borra o cambia algo que la petición no
  pedía.
- La respuesta no sigue el contrato: falta el envoltorio `{ data }`, un código de estado no es el de
  la spec, o se devuelve un modelo sin pasar por un transformer.

Todo lo demás es **sugerencia**: nombres, estilo, refactors, rendimiento sin un caso medido,
comentarios desalineados, tests que faltan. Si dudas entre grave y sugerencia, es sugerencia.

## Tope

Como mucho **3 sugerencias** por revisión, las de más valor. El resto no se describe: se cuenta en
una línea del resumen ("y N sugerencias menores más"). Los graves no tienen tope.

## Dónde no reportar

- Formato, lint y tipos: ya los vigilan Prettier, eslint, oxlint y `tsc`.
- Si `docs/api/openapi.json` coincide con el código: ya lo comprueba el workflow `openapi:check`.
- Archivos generados: `backend/.adonisjs/`, `backend/database/schema.ts`,
  `frontend/src/components/ui/` (shadcn) y los `package-lock.json`.
- Archivos que el cambio no toca, salvo que el cambio los rompa.
- Versiones de dependencias: el stack va adelantado a propósito (AdonisJS 7, VineJS 4, etc.).

## Evidencia

Cada afirmación sobre cómo se comporta algo cita el `archivo:línea` donde lo has leído. No deduzcas
el comportamiento del nombre de una función, de un comentario o de la documentación: un comentario
que dice "valida X" no es evidencia de que se valide X. Si no has podido leer el código que lo
decide, márcalo como **no verificado**, o no lo reportes.

Los hallazgos graves llevan además un caso concreto: petición → respuesta obtenida → respuesta que
exige la spec.
