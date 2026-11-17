# Parte A

## Intento 1

Control: ¿quedó declarada la ruta DELETE? Si, se genero la funcionalidad requerida.

Resultado: ¿el archivo docs/capabilities/tasks/README.md menciona el endpoint nuevo? Si, se actualizó. Pero no actualizo la documentación de OpenAPI.

Resultado: FALLIDO.

## Intento 2

Control: ¿quedó declarada la ruta DELETE? Si, se genero la funcionalidad requerida.

Resultado: ¿el archivo docs/capabilities/tasks/README.md menciona el endpoint nuevo? Si, se actualizó y, adicionalmente, si actualizo OpenAPI.

Resultado: CORRECTO. 

## Intento 3

Control: ¿quedó declarada la ruta DELETE? Si, se genero la funcionalidad requerida.

Resultado: ¿el archivo docs/capabilities/tasks/README.md menciona el endpoint nuevo? Si, se actualizó. Pero no actualizo la documentación de Open API.

Resultado: FALLIDO.

## Intento 4

Control: ¿quedó declarada la ruta DELETE? Si, se genero la funcionalidad requerida.

Resultado: ¿el archivo docs/capabilities/tasks/README.md menciona el endpoint nuevo? Si, se actualizo el README e igual el OpenAPI.

Resultado: CORRECTO.

## Intento 5

Control: ¿quedó declarada la ruta DELETE? Si, se genero la funcionalidad requerida.

Resultado: ¿el archivo docs/capabilities/tasks/README.md menciona el endpoint nuevo? Si, se actualizó. Pero no actualizo la documentación de OpenAPI.

Resultado: FALLIDO.


# Parte B

1. Yo predije que acertaría en 3 de los 5 intentos. La realidad fue que solo acertó en 2. En mi evaluación se obtuvo un 40% de cumplimiento de la regla.
2. Por lo que pude ver, la regla no se cumple porque faltaría modificar e indicar la regeneración del archivo OpenAPI con los comandos correspondientes.
3. Lo que pude ver, es que no se valida la generación de pruebas para la nueva funcionalidad.