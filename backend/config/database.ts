import app from '@adonisjs/core/services/app'
import env from '#start/env'
import { defineConfig } from '@adonisjs/lucid'
import pg from 'pg'

/**
 * Las columnas `date` (como `tasks.due_date`) llegan como el texto `AAAA-MM-DD` que
 * manda PostgreSQL, sin convertir. Por defecto el driver `pg` las convierte en un
 * `Date` de JavaScript a medianoche **del huso del proceso**, y con eso:
 *
 * - la API devolvería `"2026-08-26T00:00:00.000Z"` en vez de `"2026-08-26"`, y con
 *   un huso al este de UTC, el día anterior;
 * - `Task.isOverdueOn()` compararía un `Date` con un texto, que con `<` da siempre
 *   `false`: ninguna tarea saldría nunca vencida.
 *
 * Con SQLite no hacía falta porque la fecha ya se guardaba y se leía como texto. Es
 * lo que hace que siga siendo verdad lo que promete `database/schema_rules.ts`
 * (`dueDate: string`). Afecta a todo el proceso, que es lo que se quiere: no hay
 * otra lectura de fechas en el sistema.
 */
pg.types.setTypeParser(pg.types.builtins.DATE, (value) => value)

const dbConfig = defineConfig({
  /**
   * Default connection used for all queries.
   */
  connection: 'pg',

  connections: {
    /**
     * PostgreSQL de `compose.yaml`. Desarrollo y pruebas comparten esta conexión:
     * lo que cambia es el fichero de entorno (`.env` apunta a `db` en el 54410,
     * `.env.test` a `db-test` en el 54411).
     */
    pg: {
      client: 'pg',
      connection: {
        host: env.get('DB_HOST'),
        port: env.get('DB_PORT'),
        user: env.get('DB_USER'),
        password: env.get('DB_PASSWORD'),
        database: env.get('DB_DATABASE'),
      },

      migrations: {
        /**
         * Sort migration files naturally by filename.
         */
        naturalSort: true,

        /**
         * Paths containing migration files.
         */
        paths: ['database/migrations'],
      },

      schemaGeneration: {
        /**
         * Enable schema generation from Lucid models.
         */
        enabled: true,

        /**
         * Custom schema rules file paths.
         */
        rulesPaths: ['./database/schema_rules.js'],
      },

      debug: app.inDev,
    },
  },
})

export default dbConfig
