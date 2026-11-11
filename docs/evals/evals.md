# Medición de la Regla de Proceso (Evals)

## Predicción Inicial
- **Predicción:** 3 de 5 intentos (60%) actualizarán el README de la capability sin recordarle la regla explícitamente.

---

## Parte A: Registro de los 5 Intentos

| Intento | Control (¿Declaró la ruta DELETE?) | Resultado (¿Actualizó `README.md` de tasks?) | Estado del Intento |
| :---: | :---: | :---: | :---: |
| **1** | Sí | Sí | Válido (Regla cumplida) |
| **2** | Sí | Sí | Válido (Regla cumplida) |
| **3** | Sí | No | Válido (Regla no cumplida) |
| **4** | Sí | Sí | Válido (Regla cumplida) |
| **5** | Sí | Sí | Válido (Regla cumplida) |

- **Resumen:** 5 de 5 intentos pasaron la comprobación de control (100% de ejecución técnica). 4 de 5 intentos (80%) cumplieron la regla de actualizar el README de la capability.

---

## Parte B: Reflexión y Conclusiones

1. **Predicción vs. Resultado:**
   Mi predicción inicial fue que el agente cumpliría la regla en 3 de 5 intentos (60%). El resultado real fue de 4 de 5 intentos (80%). Sin embargo, la falla registrada en el Intento 3 confirma que confiar únicamente en reglas de proceso descritas en lenguaje natural dentro de la documentación no garantiza un comportamiento 100% determinista por parte de la IA.

2. **Decisión sobre la regla y justificación:**
   Convertiría la regla en una comprobación automática (hook de pre-commit o validación en CI/CD). Aunque un 80% de cumplimiento parece alto en una prueba corta, en un entorno corporativo un 20% de omisiones genera deuda técnica y desincronización de documentación. Una validación automatizada en el pipeline asegura el 100% de cumplimiento sin depender de la variabilidad contextual del agente.

3. **Limitación de la medición:**
   La medición comprueba únicamente la presencia visual o inclusión de texto sobre el nuevo endpoint en el README, pero no evalúa la calidad o precisión técnica del contenido escrito. Tampoco mide si el código implementado en el controlador cumple con la cobertura de pruebas unitarias ni si la especificación en OpenSpec quedó formalmente sincronizada.
