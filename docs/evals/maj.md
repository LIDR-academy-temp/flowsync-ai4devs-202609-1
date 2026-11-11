Parte A

Mi predicción: 4 de 5 intentos.

Iteración 1

* Control: ¿quedó declarada la ruta DELETE? Si no, el agente no completó el encargo y ese intento no cuenta para medir el cumplimiento del README.
SI

* Resultado: ¿el archivo docs/capabilities/tasks/README.md menciona el endpoint nuevo?
NO

Iteración 2

* Control: ¿quedó declarada la ruta DELETE? Si no, el agente no completó el encargo y ese intento no cuenta para medir el cumplimiento del README.
Si

* Resultado: ¿el archivo docs/capabilities/tasks/README.md menciona el endpoint nuevo?
No

Iteración 3

* Control: ¿quedó declarada la ruta DELETE? Si no, el agente no completó el encargo y ese intento no cuenta para medir el cumplimiento del README.
SI

* Resultado: ¿el archivo docs/capabilities/tasks/README.md menciona el endpoint nuevo?
NO

Iteración 4

* Control: ¿quedó declarada la ruta DELETE? Si no, el agente no completó el encargo y ese intento no cuenta para medir el cumplimiento del README.
SI

* Resultado: ¿el archivo docs/capabilities/tasks/README.md menciona el endpoint nuevo?
SI

Iteración 5

* Control: ¿quedó declarada la ruta DELETE? Si no, el agente no completó el encargo y ese intento no cuenta para medir el cumplimiento del README.
SI

* Resultado: ¿el archivo docs/capabilities/tasks/README.md menciona el endpoint nuevo?
SI

Resultado: 2 de 5 intentos.

Paerte B

Tu predicción y el resultado obtenido.

Predije que el agente actualizaba 4 veces de 5 el archivo README.md con el nuevo endpoint, lo hizo únicamente en dos ocasiones, la implemnetación del nuevo endpoint fue correcta en todas las iteracioens.

Qué harías con ese resultado.

Reescribiría la regla. Una regla que se cumple el 40% de las veces no hace bien su trabajo, es más bien una sugerencia, además pide actualizar OpenAPI junto con el README. Dejaría una regla más sencilla y especifica para el fichero README y otra para OpenAPI, Por ejemplo:

README:

Si tocas una ruta, un controlador, un validador o un transformer de una capability, actualiza `docs/capabilities/<capability>/README.md` en el mismo commit con el endpoint (método, ruta, respuesta).

OpenAPI:

Si tocas una ruta, un controlador, un validador o un transformer, corre `npm run openapi:generate` desde `backend/` y commitea `docs/api/openapi.json`. `npm run openapi:check` tiene que salir con 0.

Ventajas:

- Separadas: antes el README iba al final de una frase centrada en OpenAPI. Así cada una se puede medir por su lado.
- Ruta exacta del fichero y qué tiene que contener: el agente no tiene que deducir qué significa "al día".
- Un comando que verifica: la de OpenAPI ya tiene openapi:check, que sale con 1 si el fichero no coincide con lo regenerado. Es la que más fácil se convierte en hook o check de CI.
- Quita la contradicción: el repo sí tiene docs/api/openapi.json y un script que lo genera, así que la frase "no hay fichero que generar" de la regla original sobra.

Algo que tu medición no está comprobando.

solo compruebo que el README *menciona* el endpoint, no que lo describa bien (204, sin cuerpo, auth), ni que vaya en el *mismo commit*, ni la otra mitad de la regla (OpenAPI). Tampoco mide un solo encargo frente a otros: un endpoint más grande o en otra capability podría dar otro número. Y con 5 intentos el margen es enorme (2/5 es compatible con un cumplimiento real de ~5 % a ~85 %).





