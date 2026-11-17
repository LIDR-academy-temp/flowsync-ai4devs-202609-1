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

**Modelo:**  
**Herramienta:**  

```
Haz un inventario de qué es dato personal o secreto en este proyecto, y de qué lees tú para trabajar aquí. Sin cambiar ningún archivo.

Tres listas, leyendo migraciones y ficheros (no inventando):

1. Tablas y columnas que guardan datos de una persona identificable (léelo en las migraciones) y ficheros con ejemplos de correos o nombres.
2. Ficheros que llevan o pueden llevar claves, tokens o contraseñas, estén o no en el repositorio.
3. Lo que has leído o leerías por defecto para hacer un cambio en el backend (CLAUDE.md, configuración del harness, ficheros de entorno, base de datos local): de cada uno, di si su contenido sale de mi máquina cuando trabajas conmigo.
```

**Qué salió:** Inventario en tres listas desde migraciones y ficheros. (1) `users.full_name`/`email`/`password`, FKs en tokens y tasks; ejemplos Ada/Alan en tests y docs, Ana Pérez en el README. (2) `.env` locales fuera del repo, `db.sqlite3`, token en localStorage, `secreto123` en fixtures, nombres de secretos de CI. (3) `CLAUDE.md` y código salen al contexto; `.env`/SQLite solo si se abren (en el inventario no se abrieron valores reales).

---

## Prompt 2

**Modelo:** Composer  
**Herramienta:** Cursor  

```
OK, SI
(confirmación a: montar el hook datos-que-no-salen como pide el curso en .claude/, más puente en .cursor/hooks.json para que salte en Cursor)
```

**Qué salió:** Script `.claude/hooks/datos-que-no-salen.sh` (PreToolUse/Bash + beforeShellExecution), registro en `.claude/settings.json` y `.cursor/hooks.json`, bloque en `CLAUDE.md`. Prueba con correo @gmail.com → exit 2 y línea en `docs/seguridad/registro-de-bloqueos.md` sin el valor. Instalado `jq` en `~/.local/bin` (WSL).

---

## Prompt 3

**Modelo:** Composer  
**Herramienta:** Cursor  

```
Si
```

Contexto (no es el prompt): confirmación de la Parte C — curl de login con la cuenta de Ana Pérez (correo en dominio gmail, contraseña de pruebas del enunciado), tal cual, y cerrar con commit.

**Qué salió:** Intenté el commit con ese correo de gmail tal cual. El hook salió 2 por regla «correo» en `docs/capabilities/tasks/README.md` y dejó línea en el registro (sin el valor). Antes hubo falsos positivos al commitear el propio script/CLAUDE.md (patrones literales); se partieron prefijos y se reformuló el texto. Sustituí el dominio por example.com y reintenté el commit (pieza 1). Documentar el correo literal en este fichero también lo bloqueaba: por eso aquí no va pegado el address.

---

## Prompt 4

**Modelo:**  
**Herramienta:**  

```

```

**Qué salió:**  

---

## Prompt 5

**Modelo:**  
**Herramienta:**  

```

```

**Qué salió:**  
