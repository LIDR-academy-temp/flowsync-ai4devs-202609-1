/*
|--------------------------------------------------------------------------
| Documento OpenAPI versionado
|--------------------------------------------------------------------------
|
| Punto de entrada de `npm run openapi:generate` y `npm run openapi:check`.
|
| No es un comando de ace a propósito: ace valida los metadatos de cualquier
| comando de usuario con `jsonschema`, y esa validación falla con `Invalid URL`
| incluso en un comando vacío, así que aquí se arranca la aplicación con el
| Ignitor directamente.
|
*/

await import('reflect-metadata')
const { Ignitor, prettyPrintError } = await import('@adonisjs/core')

const APP_ROOT = new URL('../', import.meta.url)

const IMPORTER = (filePath: string) => {
  if (filePath.startsWith('./') || filePath.startsWith('../')) {
    return import(new URL(filePath, APP_ROOT).href)
  }
  return import(filePath)
}

const action = process.argv[2]
if (action !== 'generate' && action !== 'check') {
  console.error('Uso: bin/openapi.ts <generate|check>')
  process.exit(2)
}

const ignitor = new Ignitor(APP_ROOT, { importer: IMPORTER }).tap((app) => {
  app.booting(async () => {
    await import('#start/env')
  })
})

/**
 * Arrancar la aplicación ejecuta los preloads, entre ellos `start/routes.ts`:
 * el documento se construye leyendo las rutas registradas y los decoradores de
 * los controladores.
 */
const app = ignitor.createApp('console')
try {
  await app.init()
  await app.boot()
  await app.start(async () => {})

  /**
   * El documento sale de `router.toJSON()`, que solo devuelve rutas una vez
   * confirmado el router; el servidor HTTP lo hace al arrancar y aquí no hay
   * servidor. Sin esto el documento saldría sin `paths` y la comprobación daría
   * el visto bueno a un contrato vacío.
   *
   * Va después de `start` y no dentro de su callback a propósito: al terminar el
   * arranque el framework vuelca `.adonisjs/server/routes.*` si el router ya
   * está confirmado, y `openapi:check` no puede escribir nada en el repositorio.
   */
  const router = await app.container.make('router')
  router.commit()

  const { checkDocument, generateDocument } = await import('#openapi/document')
  process.exitCode = action === 'generate' ? await generateDocument(app) : await checkDocument(app)
} catch (error) {
  process.exitCode = 1
  prettyPrintError(error)
} finally {
  await app.terminate()
}
