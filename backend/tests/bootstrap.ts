import { assert } from '@japa/assert'
import { apiClient } from '@japa/api-client'
import app from '@adonisjs/core/services/app'
import type { Config } from '@japa/runner/types'
import { pluginAdonisJS } from '@japa/plugin-adonisjs'
import { dbAssertions } from '@adonisjs/lucid/plugins/db'
import { MigrationRunner } from '@adonisjs/lucid/migration'
import testUtils from '@adonisjs/core/services/test_utils'
import { authApiClient } from '@adonisjs/auth/plugins/api_client'
import { sessionApiClient } from '@adonisjs/session/plugins/api_client'
import type { Registry } from '../.adonisjs/client/registry/schema.d.ts'

/**
 * This file is imported by the "bin/test.ts" entrypoint file
 */
declare module '@japa/api-client/types' {
  interface RoutesRegistry extends Registry {}
}

/**
 * This file is imported by the "bin/test.ts" entrypoint file
 */

/**
 * Configure Japa plugins in the plugins array.
 * Learn more - https://japa.dev/docs/runner-config#plugins-optional
 */
export const plugins: Config['plugins'] = [
  assert(),
  pluginAdonisJS(app),
  dbAssertions(app),
  apiClient(),
  sessionApiClient(app),
  authApiClient(app),
]

/**
 * Migra la base de pruebas (`db-test`, vía `.env.test`) antes de la suite y la
 * deja vacía al terminar, para que ninguna ejecución herede filas de la anterior
 * aunque el contenedor siga levantado.
 *
 * Es lo mismo que `testUtils.db().migrate()`, pero sin pasar por Ace: esa vía
 * arranca el kernel de Ace, que valida los comandos de `commands/` con
 * jsonschema 1.5, y en Node 24.21 esa validación revienta con «Invalid URL»
 * (`new URL('/…', 'thismessage::/')` ya no se resuelve). El runner de Lucid
 * hace el mismo trabajo sin cargar comandos.
 */
async function migrarBaseDePruebas() {
  const db = await app.container.make('lucid.db')

  async function ejecutar(options: ConstructorParameters<typeof MigrationRunner>[2]) {
    const runner = new MigrationRunner(db, app, options)
    await runner.run()
    if (runner.error) throw runner.error
  }

  await ejecutar({ direction: 'up' })
  return () => ejecutar({ direction: 'down', batch: 0 })
}

/**
 * Configure lifecycle function to run before and after all the
 * tests.
 *
 * The setup functions are executed before all the tests
 * The teardown functions are executed after all the tests
 */
export const runnerHooks: Required<Pick<Config, 'setup' | 'teardown'>> = {
  setup: [migrarBaseDePruebas],
  teardown: [],
}

/**
 * Configure suites by tapping into the test suite instance.
 * Learn more - https://japa.dev/docs/test-suites#lifecycle-hooks
 */
export const configureSuite: Config['configureSuite'] = (suite) => {
  if (['browser', 'functional', 'e2e'].includes(suite.name)) {
    return suite.setup(() => testUtils.httpServer().start())
  }
}
