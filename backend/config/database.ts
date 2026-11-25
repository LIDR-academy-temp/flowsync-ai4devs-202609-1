import env from '#start/env'
import app from '@adonisjs/core/services/app'
import { defineConfig } from '@adonisjs/lucid'

/**
 * PostgreSQL 17 en Docker (ver `compose.yaml` en la raíz). La misma conexión
 * sirve para desarrollo y para pruebas: lo que cambia es a qué base apunta, y
 * eso lo deciden las variables `DB_*`. En pruebas, `.env.test` (que el framework
 * solo carga con `NODE_ENV=test`) la redirige al servicio `db-test`.
 */
const dbConfig = defineConfig({
  connection: 'pg',

  connections: {
    pg: {
      client: 'pg',
      connection: {
        host: env.get('DB_HOST'),
        port: env.get('DB_PORT'),
        user: env.get('DB_USER'),
        password: env.get('DB_PASSWORD').release(),
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
         * `database/schema.ts` se genera al migrar la base de desarrollo. Al
         * migrar la de pruebas no se regenera, para que correr la suite no
         * reescriba un fichero versionado.
         */
        enabled: !app.inTest,

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
