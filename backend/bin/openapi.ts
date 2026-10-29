/*
|--------------------------------------------------------------------------
| OpenAPI entrypoint
|--------------------------------------------------------------------------
|
| Genera o comprueba el documento OpenAPI versionado en `docs/api/openapi.json`:
|
|   npm run openapi:generate   escribe el documento
|   npm run openapi:check      lo regenera en un directorio temporal, lo compara
|                              con el versionado y sale con código 1 si difieren
|
| No es un comando de ace a propósito: `@adonisjs/ace` valida los comandos
| locales con `jsonschema@1.5.0`, que en Node 24 lanza `Invalid URL` al
| resolver el `$ref` del esquema, así que hoy ningún comando de `commands/`
| llega a cargarse. Este fichero arranca la app igual que `bin/test.ts`.
|
*/

import 'reflect-metadata'
import { mkdir, mkdtemp, readFile, rm, writeFile } from 'node:fs/promises'
import { tmpdir } from 'node:os'
import { dirname, join, relative } from 'node:path'
import { Ignitor, prettyPrintError } from '@adonisjs/core'

const APP_ROOT = new URL('../', import.meta.url)

const IMPORTER = (filePath: string) => {
  if (filePath.startsWith('./') || filePath.startsWith('../')) {
    return import(new URL(filePath, APP_ROOT).href)
  }
  return import(filePath)
}

const USAGE = 'Uso: node --import=@poppinss/ts-exec bin/openapi.ts <generate|check>'

async function generate(documentPath: string, render: () => Promise<string>) {
  await mkdir(dirname(documentPath), { recursive: true })
  await writeFile(documentPath, await render())
  console.log(`Documento OpenAPI escrito en ${relative(process.cwd(), documentPath)}`)
}

/**
 * Solo compara: el documento se regenera en un directorio temporal y el
 * versionado nunca se escribe. Devuelve el código de salida.
 */
async function check(
  documentPath: string,
  render: () => Promise<string>,
  diff: (expected: unknown, actual: unknown) => string[]
): Promise<number> {
  const versionedPath = relative(process.cwd(), documentPath)
  const tempDir = await mkdtemp(join(tmpdir(), 'flowsync-openapi-'))

  const fail = (message: string) => {
    console.error(message)
    console.error('Regenéralo con `npm run openapi:generate` y commitea el resultado.')
    return 1
  }

  try {
    const generatedPath = join(tempDir, 'openapi.json')
    await writeFile(generatedPath, await render())
    const generated = await readFile(generatedPath, 'utf-8')

    let raw: string
    try {
      raw = await readFile(documentPath, 'utf-8')
    } catch {
      return fail(`No existe ${versionedPath}.`)
    }
    // Con `core.autocrlf` el checkout en Windows trae CRLF; el generado
    // siempre usa LF, y eso no es una diferencia de contrato.
    const versioned = raw.replaceAll('\r\n', '\n')

    if (versioned === generated) {
      console.log(`${versionedPath} está al día.`)
      return 0
    }

    let differences: string[]
    try {
      differences = diff(JSON.parse(versioned), JSON.parse(generated))
    } catch {
      return fail(`${versionedPath} no es JSON válido.`)
    }

    if (differences.length === 0) {
      return fail(`${versionedPath} tiene el mismo contenido que el generado, pero otro formato.`)
    }

    return fail(
      [
        `${versionedPath} no coincide con el documento generado (${differences.length} diferencias):`,
        ...differences.map((line) => `  ${line}`),
      ].join('\n')
    )
  } finally {
    await rm(tempDir, { recursive: true, force: true })
  }
}

const action = process.argv[2]
if (action !== 'generate' && action !== 'check') {
  console.error(USAGE)
  process.exit(2)
}

const app = new Ignitor(APP_ROOT, { importer: IMPORTER })
  .tap((application) => {
    application.booting(async () => {
      await import('#start/env')
    })
  })
  .createApp('console')

try {
  await app.init()
  await app.boot()
  // El trabajo va después de `start()` y no en su callback: el hook `ready`
  // del app provider vuelca `.adonisjs/server/routes.{d.ts,json}` si el router
  // ya está confirmado, y aquí no queremos ese efecto lateral.
  await app.start(() => {})

  const { OPENAPI_DOCUMENT_PATH, renderOpenApiDocument, diffOpenApiDocuments } =
    await import('#services/openapi_document')

  if (action === 'generate') {
    await generate(OPENAPI_DOCUMENT_PATH, renderOpenApiDocument)
  } else {
    process.exitCode = await check(
      OPENAPI_DOCUMENT_PATH,
      renderOpenApiDocument,
      diffOpenApiDocuments
    )
  }
} catch (error) {
  process.exitCode = 1
  prettyPrintError(error)
} finally {
  await app.terminate()
}
