import { BaseCommand, flags } from '@adonisjs/core/ace'
import type { CommandOptions } from '@adonisjs/core/types/ace'
import { versionedDocumentPath, writeDocument } from '#openapi/document_file'

export default class OpenapiGenerate extends BaseCommand {
  static commandName = 'openapi:generate'
  static description =
    'Genera el documento OpenAPI y lo escribe en docs/api/openapi.json (o en la ruta de --output)'

  static options: CommandOptions = { startApp: true }

  @flags.string({
    description: 'Ruta del fichero de salida. Por defecto, docs/api/openapi.json',
  })
  declare output?: string

  async run() {
    const target = this.output ?? versionedDocumentPath()
    await writeDocument(target)
    this.logger.success(`Documento OpenAPI escrito en ${target}`)
  }
}
