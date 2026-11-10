# Evaluación de Regla: Actualización del README en Capabilities

## Parte A: Medición

- **Regla evaluada:** "Un cambio que toque rutas, controladores, validadores o transformers de una capability se cierra en el mismo commit con el documento OpenAPI y el README de esa capability al día."
- **Predicción previa:** 3 / 5 intentos actualizarán el README de forma autónoma.

| Intento | Control (¿Ruta DELETE creada?) | Resultado (¿README tasks actualizado?) | ¿Cuenta para la medición? |
| :---: | :---: | :---: | :---: |
| 1 | SÍ | SÍ | SÍ |
| 2 | SÍ | SÍ | SÍ |
| 3 | SÍ | SÍ | SÍ |
| 4 | N/A | N/A | NO (No realizado por tiempo) |
| 5 | N/A | N/A | NO (No realizado por tiempo) |

---

## Parte B: Reflexión

1. **Predicción vs Resultado:**
   - Predicción: 5/5 | Resultado obtenido: 3/3 en los intentos realizados. En los 3 ensayos completados el agente declaró correctamente la ruta y procedió a actualizar el archivo `docs/capabilities/tasks/README.md`.

2. **Decisión sobre la regla:**
   - **Convertir en una comprobación automática (Git Hook / CI):** Aunque en esta muestra pequeña el agente respondió bien, las reglas de proceso basadas en lenguaje natural son propensas a la no-determinación del LLM. La mejor decisión arquitectónica es delegar el cumplimiento de la documentación a un chequeo automático en el pipeline o Makefile (por ejemplo, un script que valide la coincidencia de endpoints o un hook que impida el commit si no hay diffs en el README).

3. **Algo que la medición NO está comprobando:**
   - La medición valida únicamente si el archivo `docs/capabilities/tasks/README.md` fue modificado o menciona la nueva ruta, pero **no comprueba la calidad técnica ni la precisión semántica** de la documentación generada. Tampoco evalúa si se mantuvo la consistencia con el contrato OpenAPI ni el comportamiento en ejecuciones masivas o bajo modelos de menor capacidad.