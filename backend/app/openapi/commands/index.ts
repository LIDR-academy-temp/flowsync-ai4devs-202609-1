import type { CommandMetaData } from '@adonisjs/core/types/ace'

/**
 * Cargador de los comandos `openapi:*`, registrado en `adonisrc.ts`.
 *
 * No viven en `commands/`: ace valida cada fichero de ese directorio con
 * `jsonschema`, y `jsonschema@1.5.0` revienta con «Invalid URL» en Node 24.21
 * (`new URL(ref, 'thismessage::/')`) ante cualquier comando, sea cual sea.
 * Los cargadores declarados en `adonisrc.ts` no pasan por esa validación.
 */
const loaders = {
  'openapi:generate': () => import('./openapi_generate.js'),
  'openapi:check': () => import('./openapi_check.js'),
}

export async function getMetaData(): Promise<CommandMetaData[]> {
  const metaData: CommandMetaData[] = []
  for (const [name, load] of Object.entries(loaders)) {
    const { default: command } = await load()
    metaData.push({ ...command.serialize(), commandName: name })
  }
  return metaData
}

export async function getCommand(metaData: Pick<CommandMetaData, 'commandName'>) {
  const load = loaders[metaData.commandName as keyof typeof loaders]
  if (!load) return null
  const { default: command } = await load()
  return command
}
