import { mkdir, mkdtemp, readFile, rm, writeFile } from 'node:fs/promises'
import { tmpdir } from 'node:os'
import { dirname, join } from 'node:path'
import openapi from '@foadonis/openapi/services/main'
import type { ApplicationService } from '@adonisjs/core/types'

/**
 * Generación y comprobación del documento OpenAPI versionado, que usan
 * `npm run openapi:generate` y `npm run openapi:check` (vía `bin/openapi.ts`).
 *
 * El documento versionado vive en `docs/api/openapi.json`, en la raíz del
 * repositorio y no en `backend/`, porque es el contrato de la API y no un
 * detalle de implementación del servidor.
 */

/**
 * Ruta absoluta del documento versionado.
 */
function versionedDocumentPath(app: ApplicationService) {
  return app.makePath('..', 'docs', 'api', 'openapi.json')
}

/**
 * Construye el documento con el mismo servicio que lo sirve por HTTP en
 * `/api.json` y lo serializa siempre igual (indentado y con salto de línea
 * final), para que comparar texto equivalga a comparar contenido.
 */
async function renderDocument() {
  const document = await openapi.buildDocument()
  return `${JSON.stringify(document, null, 2)}\n`
}

/**
 * Describe en qué se diferencian dos documentos, una línea por cambio y con la
 * ruta JSON de lo que cambia: `+` lo que solo está en el regenerado, `-` lo que
 * solo está en el versionado y `~` lo que está en los dos con distinto valor.
 */
function describeDifferences(versioned: string, generated: string) {
  const lines: string[] = []

  function walk(before: unknown, after: unknown, path: string) {
    if (JSON.stringify(before) === JSON.stringify(after)) return

    const bothObjects =
      typeof before === 'object' && typeof after === 'object' && before !== null && after !== null
    if (!bothObjects || Array.isArray(before) !== Array.isArray(after)) {
      lines.push(`~ ${path || '(raíz)'}: ${JSON.stringify(before)} -> ${JSON.stringify(after)}`)
      return
    }

    const left = before as Record<string, unknown>
    const right = after as Record<string, unknown>
    for (const key of new Set([...Object.keys(left), ...Object.keys(right)])) {
      const child = Array.isArray(before) ? `${path}[${key}]` : `${path}.${key}`
      if (!(key in left)) lines.push(`+ ${child}`)
      else if (!(key in right)) lines.push(`- ${child}`)
      else walk(left[key], right[key], child)
    }
  }

  walk(JSON.parse(versioned), JSON.parse(generated), '')
  return lines
}

/**
 * Escribe el documento en `docs/api/openapi.json`. Devuelve el código de salida.
 */
export async function generateDocument(app: ApplicationService) {
  const target = versionedDocumentPath(app)

  await mkdir(dirname(target), { recursive: true })
  await writeFile(target, await renderDocument())

  console.log(`Documento OpenAPI escrito en ${target}`)
  return 0
}

/**
 * Solo compara. Regenera el documento en un directorio temporal y lo coteja
 * con el versionado, que se abre únicamente para leerlo: arreglar la diferencia
 * es cosa de `openapi:generate`, y esa decisión la toma quien lo ejecuta
 * después de leer qué ha cambiado. Devuelve el código de salida: 0 si
 * coinciden y 1 si no.
 */
export async function checkDocument(app: ApplicationService) {
  const versionedPath = versionedDocumentPath(app)

  let versioned: string
  try {
    versioned = await readFile(versionedPath, 'utf8')
  } catch {
    console.error(`No existe ${versionedPath}. Ejecuta: npm run openapi:generate`)
    return 1
  }

  const directory = await mkdtemp(join(tmpdir(), 'flowsync-openapi-'))
  try {
    const generatedPath = join(directory, 'openapi.json')
    await writeFile(generatedPath, await renderDocument())
    const generated = await readFile(generatedPath, 'utf8')

    if (generated === versioned) {
      console.log('docs/api/openapi.json está al día con el código')
      return 0
    }

    console.error('docs/api/openapi.json no coincide con el documento que genera el código:')
    for (const line of describeDifferences(versioned, generated)) {
      console.error(`  ${line}`)
    }
    console.error('Si el cambio es intencionado, regenera el fichero: npm run openapi:generate')
    return 1
  } finally {
    await rm(directory, { recursive: true, force: true })
  }
}
