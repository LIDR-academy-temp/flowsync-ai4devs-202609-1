# Prompts de la sesión

Prompts lanzados en esta sesión, en orden, tal cual. Rama de trabajo: `feat/openapi-generate-check`.

---

## Prompt 1

**Modelo:** Sonnet 5.5
**Herramienta:** Claude Code

```
Lee las reglas de proceso de `CLAUDE.md` y contrástalas contra los últimos 15 commits de este repositorio y el estado actual del árbol. Para cada regla, una fila: qué dice, qué evidencia has mirado, y si se ha cumplido, no se ha cumplido, o no se puede comprobar desde el historial. Usa solo lo que puedas verificar con comandos de git y leyendo archivos: si una regla no deja rastro comprobable, dilo en vez de suponer. No cambies ningún archivo: esto es una auditoría, no un arreglo.
```

**Qué salió:** tabla de 5 reglas: 1 cumplida, 1 parcial, 1 no cumplida (sin PR) y 2 sin rastro en git. Aclaró que los 15 commits de `s5/start` son del curso.

---

## Prompt 2

**Modelo:** Sonnet 5.5
**Herramienta:** Claude Code

```
Hoy el contrato de la API de este proyecto solo existe mientras el servidor corre: se construye en cada petición y se sirve por HTTP, y no hay ningún fichero en el repositorio. Haz dos cosas. Primero, añade un comando del proyecto que genere ese documento y lo escriba en un fichero versionado dentro de `docs/`. Segundo, añade una comprobación que regenere el documento en una ubicación temporal, lo compare con el versionado, y termine con código de salida distinto de cero explicando la diferencia si no coinciden. Llama `openapi:generate` al comando que genera y `openapi:check` a la comprobación, expón los dos como scripts del proyecto con esos mismos nombres, y escribe el documento en `docs/api/openapi.json`. La comprobación solo compara, no arregla: no toques las rutas ni dejes que reescriba el fichero versionado.
```

**Qué salió:** funcionó, commit `a3db1a1`. Los comandos no pudieron ir en `commands/`: ace los valida con `jsonschema@1.5.0`, que falla en Node 24.21; van en `app/openapi/commands/` con un cargador en `adonisrc.ts`.

---

## Prompt 3

**Modelo:** Sonnet 5.5
**Herramienta:** Claude Code

```
Crea un trabajo de integración continua en `.github/workflows/`vque ejecute esa comprobación sobre cada cambio propuesto y sobre cada push a la rama principal. Que instale las dependencias del backend y corra el script. Dale al trabajo únicamente los permisos que necesite y nada más, y pon un tiempo máximo de ejecución. Explícame en dos líneas qué hará y qué no.
```

**Qué salió:** funcionó, commit `f7c2f42`. Hubo que definir variables de entorno de relleno porque en CI no hay `.env`; probado en un clon limpio.

---

## Prompt 4

**Modelo:** Sonnet 5.5
**Herramienta:** Claude Code

```
Crea otro trabajo de integración continua en `.github/workflows/` que lance un revisor de código sobre cada cambio propuesto, usando la acción oficial de Claude Code para GitHub Actions. Que reciba su credencial desde un secreto del repositorio, y que publique los hallazgos como comentarios en el cambio propuesto en vez de dejarlos solo en el registro de ejecución. Dale herramientas de lectura sobre el repositorio (Read, Grep y Glob en su lista de herramientas permitidas): sin ellas no puede abrir ni el archivo de calibración ni un solo archivo del cambio, y cada intento denegado le cuesta un turno. Dile además que no redirija salida a ficheros, que lea la salida directa. Que use un modelo económico (--model sonnet --effort medium), acote el trabajo a 40 turnos (--max-turns 40) y el reloj a 10 minutos (timeout-minutes: 10), con esos valores exactos. Debajo del archivo, escríbeme en `docs/ci-revisor.md` qué pasos manuales quedan pendientes para que esto funcione de verdad, y en qué se va el dinero: qué modelo usa el revisor, por qué ese y cómo cambiarlo. Para el precio, enlaza la página oficial en vez de citar cifras: cambian, y una cifra escrita aquí envejece sin que nadie se entere. Sobre la credencial, documenta dos caminos y pon primero el de suscripción: el token que se genera en local con `Claude setup-token`, y solo después la clave de API de la consola. Di de cada uno qué entrada de la acción usa y con qué nombre se guarda el secreto, porque no son intercambiables, y avisa de que cruzarlos falla en la primera llamada sin explicar por qué. Incluye también qué ocurre con los cambios propuestos desde un fork en un repositorio público.
```

**Qué salió:** funcionó, commit `c3640de`. Verifiqué la acción en su documentación oficial; quedaron sin confirmar `--effort` en la acción, el alias `sonnet` y el permiso mínimo. El archivo de calibración que citaba no existía.

---

## Prompt 5

**Modelo:** Sonnet 5.5
**Herramienta:** Claude Code

```
Ejecuta ahora, en local, el mismo encargo que le hemos dado a ese revisor automático: pasa el subagente `adversarial-reviewer` sobre la capability de tareas, contrastando contra los scenarios de `openspec/specs/tasks/spec.md`. No arregles nada: hoy solo queremos ver el informe que habría aparecido en el cambio propuesto.
```

**Qué salió:** informe con 1 crítico, 3 altos y 5 medios. El subagente se contradijo sobre `isOverdueOn`; contrasté en el código los dos hallazgos principales (estado inventado y tarea `done`) y ambos eran reales.

---

## Prompt 6

**Modelo:** Sonnet 5.5
**Herramienta:** Claude Code

```
Escribe un archivo de instrucciones solo para revisiones, en la raíz del repositorio, que calibre a ese revisor para este proyecto. Cuatro cosas: define qué cuenta como hallazgo grave aquí y qué no pasa de sugerencia; pon un tope al número de sugerencias menores por revisión y di que el resto se resuma contadas; lista dónde no debe reportar, incluyendo cualquier cosa que otra comprobación del repositorio ya vigile; y exige que para afirmar que algo se comporta de una manera cite el archivo y la línea donde lo ha visto, en vez de deducirlo del nombre. Que quepa en una pantalla: un archivo largo diluye las reglas que importan.
```

**Qué salió:** funcionó, commit `4aade66`: `REVIEW.md` de 30 líneas, enlazado desde el prompt del workflow y desde `docs/ci-revisor.md`.

---

## Prompt 7

**Modelo:** Sonnet 5.5
**Herramienta:** Claude Code

```
Crea en la raíz `prompts-sesion.md` tomando como referencia `prompts.md` y agrega los prompts de esta sesión de acuerdo a los lineamientos en `prompts.md`
```

**Qué salió:** este archivo.
