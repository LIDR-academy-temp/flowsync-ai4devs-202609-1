import { mkdir, writeFile } from 'node:fs/promises'
import { dirname } from 'node:path'
import app from '@adonisjs/core/services/app'

/**
 * Dónde vive el contrato versionado: `docs/api/openapi.json`, en la raíz del
 * repositorio (el backend cuelga de `backend/`, de ahí el `..`).
 */
export function versionedDocumentPath() {
  return app.makePath('..', 'docs', 'api', 'openapi.json')
}

/**
 * Construye el documento y lo serializa como lo escribe `openapi:generate`:
 * JSON con sangría de dos espacios y salto de línea final. Es la única fuente
 * del formato, así que lo que compara `openapi:check` y lo que escribe
 * `openapi:generate` no pueden divergir por un detalle de serialización.
 *
 * Las rutas se confirman aquí porque en un comando de ace nadie arranca el
 * servidor HTTP, que es quien normalmente lo hace. Los servicios se importan
 * dentro de la función, no arriba: esos módulos esperan al arranque de la
 * aplicación y el cargador de comandos importa este fichero antes de que ocurra.
 */
export async function renderDocument() {
  const { default: router } = await import('@adonisjs/core/services/router')
  const { default: openapi } = await import('@foadonis/openapi/services/main')
  router.commit()
  const document = await openapi.buildDocument()
  return JSON.stringify(document, null, 2) + '\n'
}

/**
 * Escribe el documento en `path`, creando los directorios que falten.
 */
export async function writeDocument(path: string) {
  const content = await renderDocument()
  await mkdir(dirname(path), { recursive: true })
  await writeFile(path, content)
}
