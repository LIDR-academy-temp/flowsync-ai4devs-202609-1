import env from '#start/env'
import app from '@adonisjs/core/services/app'
import { defineConfig } from '@adonisjs/lucid'

/**
 * Aislamiento entre la base de desarrollo y la de pruebas.
 *
 * Las variables exportadas en la shell tienen prioridad sobre `.env.test`, así
 * que un `export DB_PORT=54410` bastaría para que la suite (o sus migraciones)
 * escribiera en la base de desarrollo. Este fichero se carga tanto en
 * `node ace test` como en `node ace migration:*`, y aquí se corta antes de abrir
 * ninguna conexión. Y al revés: fuera de pruebas no se usa la base efímera.
 */
const TEST_DB_PORT = 54411
const TEST_DB_NAME = 'flowsync_test'

const apuntaALaBaseDePruebas =
  env.get('DB_PORT') === TEST_DB_PORT || env.get('DB_DATABASE') === TEST_DB_NAME

if (app.inTest) {
  if (env.get('DB_PORT') !== TEST_DB_PORT || env.get('DB_DATABASE') !== TEST_DB_NAME) {
    throw new Error(
      `Entorno de pruebas apuntando a ${env.get('DB_DATABASE')}:${env.get('DB_PORT')}. ` +
        `Solo se admite ${TEST_DB_NAME}:${TEST_DB_PORT}. ¿Hay variables DB_* exportadas en la shell?`
    )
  }
} else if (apuntaALaBaseDePruebas) {
  throw new Error(
    `NODE_ENV=${app.nodeEnvironment} apuntando a la base de pruebas (${TEST_DB_NAME}:${TEST_DB_PORT}). ` +
      `Esa base es efímera y solo es para la suite.`
  )
}

const dbConfig = defineConfig({
  /**
   * Default connection used for all queries.
   */
  connection: 'pg',

  connections: {
    /**
     * SQLite connection (motor anterior). Se conserva, junto con su fichero
     * `tmp/db.sqlite3`, pero ya no es la conexión por defecto.
     */
    sqlite: {
      client: 'better-sqlite3',

      connection: {
        filename: app.tmpPath('db.sqlite3'),
      },

      /**
       * Required by Knex for SQLite defaults.
       */
      useNullAsDefault: true,

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
    },

    /**
     * PostgreSQL connection (default). Desarrollo y pruebas usan esta misma
     * conexión; lo que cambia es el `.env` que se carga (`.env` / `.env.test`).
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
        naturalSort: true,
        paths: ['database/migrations'],
      },
      schemaGeneration: {
        enabled: true,
        rulesPaths: ['./database/schema_rules.js'],
      },
      debug: app.inDev,
    },

    /**
     * MySQL / MariaDB connection.
     * Install package to switch: npm install mysql2
     */
    // mysql: {
    //   client: 'mysql2',
    //   connection: {
    //     host: env.get('DB_HOST'),
    //     port: env.get('DB_PORT'),
    //     user: env.get('DB_USER'),
    //     password: env.get('DB_PASSWORD'),
    //     database: env.get('DB_DATABASE'),
    //   },
    //   migrations: {
    //     naturalSort: true,
    //     paths: ['database/migrations'],
    //   },
    //   debug: app.inDev,
    // },

    /**
     * Microsoft SQL Server connection.
     * Install package to switch: npm install tedious
     */
    // mssql: {
    //   client: 'mssql',
    //   connection: {
    //     server: env.get('DB_HOST'),
    //     port: env.get('DB_PORT'),
    //     user: env.get('DB_USER'),
    //     password: env.get('DB_PASSWORD'),
    //     database: env.get('DB_DATABASE'),
    //   },
    //   migrations: {
    //     naturalSort: true,
    //     paths: ['database/migrations'],
    //   },
    //   debug: app.inDev,
    // },

    /**
     * libSQL (Turso) connection.
     * Install package to switch: npm install @libsql/client
     */
    // libsql: {
    //   client: 'libsql',
    //   connection: {
    //     url: env.get('LIBSQL_URL'),
    //     authToken: env.get('LIBSQL_AUTH_TOKEN'),
    //   },
    //   useNullAsDefault: true,
    //   migrations: {
    //     naturalSort: true,
    //     paths: ['database/migrations'],
    //   },
    //   debug: app.inDev,
    // },
  },
})

export default dbConfig
