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

**Modelo:** Claude 3.5 Sonnet
**Herramienta:** GitHub Copilot (Eclipse - Chat)

```
Revisa el archivo de instrucciones del agente en el proyecto (.github/copilot-instructions.md) y lista las reglas de proceso definidas para el flujo de trabajo. No ejecutes ningun comando ni cambies archivos.
```

**Qué salió:** Funcionó a la primera; extrajo la lista de reglas de proceso definidas para el proyecto.

---

## Prompt 2

**Modelo:** Claude 3.5 Sonnet
**Herramienta:** GitHub Copilot (Eclipse - Chat)

```
Audita exclusivamente las reglas de proceso definidas contrastándolas con los últimos 15 commits del repositorio (git log -n 15) y el estado actual de los archivos.

NO modifiques ningún archivo ni intentes corregir nada de lo que encuentres.

Muestra en el chat la tabla con las 5 columnas:
1. Qué pide la regla
2. Qué se revisó
3. Veredicto (se cumple / no se cumple / no se puede comprobar)
4. Evidencia en una línea
5. Qué harías con ella (dejarla / borrarla / convertirla en comprobación automática)
```

**Qué salió:** Tuve que insistir porque intentó ejecutar comandos para corregir archivos; en el segundo intento entregó la tabla de auditoría sin alterar código.

---

## Prompt 3

**Modelo:** Claude 3.5 Sonnet
**Herramienta:** GitHub Copilot (Eclipse - Chat)

```
Con base en la auditoria anterior de los ultimos 15 commits, ayudame a redactar las 3 lineas finales para la Parte B:
1. La regla en la que mas me equivoque al comparar mi expectativa con el resultado.
2. Una regla que no se puede comprobar con la informacion disponible y que tendria que cambiar.
3. La regla que eliminaria y por que.
```

**Qué salió:** Funcionó a la primera; generó los argumentos para la reflexión de la Parte B respetando el formato solicitado.
