# Verificación · «Lo que cada tarea muestra de su responsable»

- **Scenarios del requisito:** 3

## Matriz de trazabilidad

| # | Scenario (qué se espera y en qué situación) | Prueba que lo cubre | Estado | Si «No lo sé», qué faltó |
|---|---|---|---|---|
| 1 | Al obtener una tarea cuyo responsable es "Ada Lovelace", su `assignee` trae ese nombre y sus iniciales | Ninguna¹ | No cubierto | |
| 2 | Al obtener cualquier tarea, suelta o en la lista, su `assignee` no incluye el email ni otros datos de acceso | Ninguna² | No cubierto | |
| 3 | Si el responsable se registró sin nombre, el `assignee` trae el nombre nulo y las iniciales igualmente | Ninguna³ | No cubierto | |

Ningún archivo de `backend/tests/` llama a `/api/v1/tasks` ni comprueba un `assignee`. Las pruebas que se le parecen son todas de `auth` y comprueban la cuenta, no lo que muestra una tarea:

1. `Auth | iniciales › un nombre de dos palabras da la inicial de cada una` comprueba `initials = "AL"` para "Ada Lovelace", pero en la respuesta de `POST /auth/login`.
2. `Auth | registro › la contraseña nunca sale en la respuesta` comprueba que el `user` del registro no lleva la contraseña. El email no lo excluye, y tampoco mira ninguna tarea.
3. `Auth | registro › una cuenta puede quedarse sin nombre` y `Auth | iniciales › sin nombre, las iniciales salen del email` comprueban el nombre nulo y las iniciales `"AE"`, pero sobre la cuenta en el registro y el login.


## Parte B: las tres líneas

1. **Cuántos scenarios creías cubiertos antes de mirar, y cuántos lo estaban** -Scenarios creía cubiertos: 1 -Scenarios cubiertos: 0.
2. **El scenario del que no supiste si era un hueco de test o un hueco de spec** Scenario: Responsable sin nombre. Hueco de spec, como obtener las iniciales sin tener el nombre.
3. **Algo que el scenario no decidía por ti y tuviste que decidir al escribir el test** Iniciales exactas en el scenario 3. Exijo "AE", un valor que no sale de la spec de tasks sino del requisito «Iniciales de la cuenta» de auth. El scenario solo dice que las iniciales "siguen llegando".
