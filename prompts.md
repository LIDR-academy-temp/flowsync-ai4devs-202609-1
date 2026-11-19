# Prompts

Aquí van **todos los prompts que lanzaste** para hacer el ejercicio, en el orden en que los
lanzaste, con el modelo y la herramienta de cada uno.

Esto no es papeleo. Lo que se revisa es **cómo pediste las cosas**, no solo lo que salió: un
resultado flojo con un prompt bueno y un resultado flojo con un prompt vago necesitan feedback
distinto, y sin este archivo no se distinguen.

## Cómo rellenarlo

- Un apartado `## Prompt N` por cada prompt.
- **Pega el prompt tal cual lo lanzaste**, dentro del bloque de código, aunque ocupe diez líneas
  y aunque tenga faltas. No lo reescribas para que quede bien: el que arreglaste mentalmente
  después no es el que lanzaste.
- Incluye también los que **no funcionaron**. Suelen ser los más útiles de leer.
- `Modelo` y `Herramienta` en todos. Si cambiaste de una a otra a mitad, se nota aquí.

---

## Prompt 1

**Modelo:** Claude 5.5 Sonnet
**Herramienta:** GitHub Copilot (Eclipse - Chat)

```
Analiza el proyecto sin modificar ni crear ningún archivo. Entrega exactamente estas tres listas basadas en evidencia real del código (no supuestos):

1. Datos personales: tablas y columnas que almacenan información de una persona identificable comprobadas en las migraciones de base de datos, más los archivos del proyecto que contienen ejemplos de correos o nombres.
2. Secretos: archivos que contienen o pueden contener claves, tokens o contraseñas, estén o no rastreados por Git (revisa también .gitignore y los archivos de entorno).
3. Información que consultas: enumera qué archivos has leído y qué otros podrías leer al hacer un cambio en el backend (instrucciones del repositorio, configuración de la herramienta, archivos .env y base de datos local), indicando para cada elemento si su contenido sale de mi máquina hacia el modelo cuando trabajas conmigo.
```

**Qué salió:** Funcionó; entregó las tres listas comprobadas directamente en las migraciones (`users`, `tasks`, `auth_access_tokens`), los archivos `.env` rastreados/ignorados y el detalle de qué archivos salen al contexto del modelo.

---

## Prompt 2

**Modelo:** Claude 5.5 Sonnet
**Herramienta:** GitHub Copilot (Eclipse - Chat)

```
Necesito crear el hook datos-que-no-salen y documentarlo en el proyecto:

1. Crea el script .claude/hooks/datos-que-no-salen.sh y regístralo en .claude/settings.json como PreToolUse para Bash (sin borrar el hook que ya está).
- Debe leer el comando con jq y actuar solo cuando el comando tenga git commit (si lleva git add también revisa cambios sin preparar y archivos nuevos).
- Debe bloquear con exit 2 si encuentra: claves o tokens conocidos (AKIA, sk-ant-, ghp_, github_pat_, AIza, xoxb-/xoxp-/xoxa-, PRIVATE KEY o APP_KEY con valor), correos que no sean de example.com, example.org, example.net o github.com, o archivos llamados .env (sin contar .env.example).
- Si bloquea algo, muestra por error qué regla falló, en qué archivo y pide cambiarlo por un dato inventado. Además guarda una línea en docs/seguridad/registro-de-bloqueos.md con la fecha en UTC, BLOQUEADO, la regla y el archivo (sin guardar el dato real).

2. Agrega un párrafo corto en las reglas de proceso de CLAUDE.md explicando qué hace este hook, qué bloquea y que si salta hay que cambiar el dato por uno falso e incluir el archivo de registro en el commit. No toques AGENTS.md.
```

**Qué salió:** Funcionó; creó `.claude/hooks/datos-que-no-salen.sh`, lo registró en `.claude/settings.json` bajo `PreToolUse` sin alterar el hook existente de Prettier y agregó la regla en `CLAUDE.md` dejando `AGENTS.md` intacto.

---

## Prompt 3

**Modelo:** Claude 5.5 Sonnet
**Herramienta:** GitHub Copilot (Eclipse - Chat)

```
Prueba ahora el hook que acabas de crear:

1. Crea un archivo temporal con un correo de gmail.com (por ejemplo prueba@gmail.com), hazle git add e intenta hacer un git commit para verificar que el hook lo bloquee y escriba la línea en docs/seguridad/registro-de-bloqueos.md.
2. Después borra ese archivo temporal tanto de git como de la carpeta, dejando la línea del registro guardada.
```

**Qué salió:** No ejecutó la prueba automáticamente porque no tenía autorización de terminal y advirtió que un hook `PreToolUse` de Claude Code no se dispara solo en la terminal de Eclipse, sugiriendo simular el paso del JSON por entrada estándar al script.

---

## Prompt 4

**Modelo:** Claude 5.5 Sonnet
**Herramienta:** GitHub Copilot (Eclipse - Chat)

```
Usa la vía 1 que propones (simular el hook sin hacer commit real). Tienes permiso para ejecutar esos comandos en la terminal: crea el archivo temporal con prueba@gmail.com, haz git add, pásale el JSON al script para comprobar que devuelve exit 2 y escribe en docs/seguridad/registro-de-bloqueos.md, y luego limpia el archivo temporal.
```

**Qué salió:** No funcionó en ejecución; al abrir la terminal en Eclipse, Windows PowerShell bloqueó el script de integración de Copilot (`UnauthorizedAccess`) y se detectó que `jq` no está instalado en el PATH del sistema.
