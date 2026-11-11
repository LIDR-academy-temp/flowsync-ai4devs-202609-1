import { mkdtemp, readFile, rm } from 'node:fs/promises'
import { tmpdir } from 'node:os'
import { join } from 'node:path'
import { BaseCommand } from '@adonisjs/core/ace'
import type { CommandOptions } from '@adonisjs/core/types/ace'
import { versionedDocumentPath, writeDocument } from '#openapi/document_file'

const MAX_SHOWN = 10

export default class OpenapiCheck extends BaseCommand {
  static commandName = 'openapi:check'
  static description =
    'Regenera el documento OpenAPI en un directorio temporal y falla si difiere de docs/api/openapi.json. Solo compara: no escribe en el fichero versionado'

  static options: CommandOptions = { startApp: true }

  async run() {
    const versioned = versionedDocumentPath()

    let expected: string
    try {
      expected = await readFile(versioned, 'utf-8')
    } catch {
      this.logger.error(`No existe el documento versionado ${versioned}.`)
      this.logger.info('Genéralo con `npm run openapi:generate` y commitéalo.')
      this.exitCode = 1
      return
    }

    const dir = await mkdtemp(join(tmpdir(), 'flowsync-openapi-'))
    try {
      const fresh = join(dir, 'openapi.json')
      await writeDocument(fresh)
      const actual = await readFile(fresh, 'utf-8')

      if (actual === expected) {
        this.logger.success('docs/api/openapi.json está al día con el código.')
        return
      }

      this.logger.error('docs/api/openapi.json no coincide con el documento que genera el código.')
      this.logger.info(describeDiff(expected, actual))
      this.logger.info(
        'Regenéralo con `npm run openapi:generate` y revisa el diff antes de commitear.'
      )
      this.exitCode = 1
    } finally {
      await rm(dir, { recursive: true, force: true })
    }
  }
}

/**
 * Diferencias línea a línea entre el fichero versionado (`-`) y el documento
 * recién generado (`+`). No es un diff de verdad —no alinea inserciones—: basta
 * para ver dónde empiezan a divergir; el diff completo lo da git tras
 * regenerar.
 */
function describeDiff(versioned: string, generated: string) {
  const a = versioned.split('\n')
  const b = generated.split('\n')
  const lines: string[] = [`Versionado: ${a.length} líneas. Generado: ${b.length} líneas.`]
  let shown = 0
  let total = 0
  for (let i = 0; i < Math.max(a.length, b.length); i++) {
    if (a[i] === b[i]) continue
    total++
    if (shown >= MAX_SHOWN) continue
    shown++
    lines.push(`línea ${i + 1}:`)
    if (a[i] !== undefined) lines.push(`  - ${a[i]}`)
    if (b[i] !== undefined) lines.push(`  + ${b[i]}`)
  }
  if (total > shown) lines.push(`… y ${total - shown} líneas más que difieren.`)
  return lines.join('\n')
}
