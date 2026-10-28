# Expectativas Iniciales
- Regla 1 (Inspección previa): Ni idea
- Regla 2 (Sin cambios invasivos): Sí
- Regla 3 (Commits atómicos): Sí
- Regla 4 (Mensajes convencionales): Sí
- Regla 5 (Verificación de pruebas): Ni idea
- Regla 6 (Documentación de prompts): Sí
- Regla 7 (Validación de trazabilidad): Sí
- Regla 8 (Pull Requests limpios): Sí

---

## Tabla de Auditoría (Reglas de Proceso vs. Historial)

| Qué pide la regla | Qué se revisó | Veredicto | Evidencia en una línea | Qué harías con ella |
| :--- | :--- | :--- | :--- | :--- |
| Leer la spec en `openspec/` y tests antes de tocar código funcional | Existencia de `openspec/` y reflog `.git/logs/HEAD` | No se puede comprobar | `openspec/` tiene specs, pero el reflog no muestra qué se leyó antes de cada cambio | Dejarla |
| No modificar archivos fuera del alcance del módulo o requisito | Reflog (1 solo commit en historial) | No se puede comprobar | Sin diff por commit ni un alcance definido, no hay referencia con la que comparar | Dejarla |
| Commits atómicos con una sola responsabilidad | Reflog (1 entrada registrada) | No se puede comprobar | Solo existe el commit inicial `1980e20`; no hay serie de commits para valorar | Convertirla en comprobación automática |
| Mensajes con prefijo convencional (`feat:`, `fix:`, `test:`, `docs:`, `trazabilidad:`) | Mensaje del commit en el reflog | No se puede comprobar | El mensaje del único commit aparece vacío en el reflog | Convertirla en comprobación automática |
| Ejecutar `npm test` o `node ace test` antes de confirmar cambios | Historial y archivos del repositorio | No se puede comprobar | Git no guarda si se ejecutaron los tests y no hay hooks/CI configurados en esta revisión | Convertirla en comprobación automática |
| Registrar todo prompt usado en `prompts.md` en la raíz | Archivo `prompts.md` | Se cumple parcialmente | Existe en la raíz con prompts guardados, pero mantenía secciones en blanco y plantilla de ejemplo | Dejarla |
| Documentar los resultados de auditoría o verificación en `docs/` | Carpeta `docs/` | Se cumple parcialmente | Existe `docs/auditoria/`, pero la evidencia está en proceso de redacción al momento de auditar | Dejarla |
| PR limpio, sin archivos temporales ni cambios accidentales | Archivo `.gitignore` y raíz del repositorio | No se puede comprobar | `.gitignore` cubre archivos temporales, pero no hay un PR abierto para verificar el diff final | Convertirla en comprobación automática |

---

## Parte B: Reflexión

1. **Regla en la que más me equivoqué:** "Documentación de prompts" (`prompts.md`). Esperaba que se cumpliera del todo y la auditoría la dejó como cumplimiento parcial: el Prompt 3 estaba incompleto, quedó una plantilla de ejemplo sin borrar y el archivo es el entregable manual del ejercicio, no un registro automático.
2. **Regla que no se puede comprobar y que cambiaría:** "Verificación de pruebas" (`npm test` o `node ace test` antes de confirmar). Git no guarda si se ejecutaron los tests, y con un solo commit en el historial no hay nada que contrastar. La cambiaría por un hook `pre-commit` o un paso de CI que ejecute los tests y bloquee el commit o el PR si fallan.
3. **Regla que eliminaría:** "Sin cambios invasivos". Es ambigua, porque no define qué es el "alcance del módulo", y no se puede comprobar con el historial ni con el estado de los archivos. Sería mejor sustituirla por una comprobación concreta, como una lista de rutas permitidas por tarea, que ya cubre la regla de "PR limpio".
