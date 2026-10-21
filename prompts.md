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

**Modelo:** Sonnet 5.5
**Herramienta:** Claude Code

```
Crea un fichero docs/auditoria/jnp.md
```

**Qué salió:** creó `docs/auditoria/jnp.md` solo con un título, porque el prompt no decía el contenido; antes abrió la rama `feat/auditoria-jnp` por las reglas de proceso.

## Prompt 2

**Modelo:** Sonnet 5.5
**Herramienta:** Claude Code

```
Tienes configuradas 5 reglas de proceso. En el fichero creado antes, en un apartado llamado "Expectativa" para cada regla con este formato "Regla N - <Resumen_de_la_regla>:" preguntame si espero que se vaya a cumplir y registra mi respuesta para cada una
```

**Qué salió:** preguntó las 5 reglas (4 + 1, por el límite de 4 preguntas por llamada) y registró las respuestas en `docs/auditoria/jnp.md`: Sí, Sí, Sí, No, No.

## Prompt 3

**Modelo:** Sonnet 5.5
**Herramienta:** Claude Code

```
Vamos a hacer una auditoria. Revisa los últimos 15 commits del repositorio e indica si puedes validar, SOLO con los comandos que puedes ejecutar, que las reglas se han cumplido para estos últimos 15 commits. En jnp.md deja constancia de la auditoria en una sección llamada "Auditoría commits". La tabla debe tener la siguiente información 

Usa una fila por regla y completa estas cinco columnas:

Qué pide la regla. Resúmela en una frase y con tus propias palabras. Si necesitas varias frases, puede que estés mezclando más de una regla.

Qué se revisó para comprobarla. Indica el comando ejecutado o el archivo consultado. Sin esta información no hay forma de saber en qué se apoya el veredicto.

Veredicto. Solo puede ser se cumple, no se cumple o no se puede comprobar con la información disponible. Este último caso también es un resultado válido. Significa que la regla no deja suficiente evidencia para verificarla.

Evidencia. Escríbela en una línea. Si la regla no se cumple, indica dónde se incumple. Si no se puede comprobar, explica qué información falta.

Qué harías con ella. Elige una opción: dejarla, borrarla o convertirla en una comprobación automática.

. Preguntame antes de rellenar cada celda dandome tu opinión. Si no puedes validar algo con los comandos que tienes disponibles simplemente indicamelo, no te lo inventes ni pidas permisos para ejecutar otros.
```

**Qué salió:** revisó los 15 commits con `git`/`gh`, preguntó las 25 celdas con su opinión (en 7 llamadas de ≤4 preguntas) y añadió la sección «Auditoría commits» a `docs/auditoria/jnp.md`: reglas 1, 2, 4 y 5 no comprobables, regla 3 se cumple.

## Prompt 4

**Modelo:** Sonnet 5.5
**Herramienta:** Claude Code

```
Puedes borrar la primera columna (regla) de la tabla
```

**Qué salió:** borró la columna «Regla» de la tabla de `docs/auditoria/jnp.md`; quedan cinco columnas y las filas siguen en el orden de las reglas 1 a 5.

## Prompt 5

**Modelo:** Sonnet 5.5
**Herramienta:** Claude Code

```
Si no es un comando, la primera letra de cada celda debería ser mayuscula
```

**Qué salió:** puso en mayúscula la inicial de las columnas «Veredicto» y «Qué haría con ella» de `docs/auditoria/jnp.md`; el resto ya empezaba en mayúscula o con un comando/hash entre comillas invertidas, que dejó como estaba.

## Prompt 6

**Modelo:** Sonnet 5.5
**Herramienta:** Claude Code

```
Ahora preguntame para rellenar la siguiente información 

Debajo de la tabla, en el mismo archivo, añade estas tres líneas. Esta parte es obligatoria y debe estar completa.

La regla en la que más te equivocaste. Compara tu expectativa inicial con el veredicto final y elige la que más se alejó de lo que pensabas. Si acertaste todas, indícalo y explica en una frase en qué te apoyaste para acertar. Si solo era una impresión, también conviene dejarlo por escrito.

Una regla que no se puede comprobar con la información disponible. Explica en una frase qué tendría que cambiar para poder verificarla. Puede ser reformularla, convertirla en una comprobación automática o aceptar que no deja una evidencia clara.

La regla que eliminarías y por qué. Hay dos casos habituales: una regla que ya garantiza otra herramienta o una que nadie sigue y que tampoco aporta valor. Elige una y explica a cuál de los dos casos pertenece.
```

**Qué salió:** preguntó las tres líneas con su opinión (cuatro preguntas en una llamada) y añadió los tres puntos debajo de la tabla de `docs/auditoria/jnp.md`: Regla 1 (más fallo), Regla 1 (no comprobable, automatizarla) y Regla 5 (eliminar, nadie la sigue y no aporta valor).
