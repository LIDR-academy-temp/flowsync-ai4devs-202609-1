import { BaseSchema } from '@adonisjs/lucid/schema'

/**
 * Lleva a la base de datos la regla de que una tarea solo tiene uno de tres
 * estados. Hasta ahora la ponía solo el validador (`updateTaskStatusValidator`):
 * un INSERT o un UPDATE que no pasara por la API podía guardar cualquier texto.
 *
 * Es un `CHECK` y no un tipo `ENUM` de PostgreSQL a propósito: la columna sigue
 * siendo `varchar`, así que el esquema generado no cambia (el tipo estrecho ya lo
 * pone `database/schema_rules.ts`) y `down()` es un simple DROP CONSTRAINT, sin
 * convertir la columna de vuelta.
 *
 * Los tres valores van escritos aquí y no importados de `TASK_STATUSES`: una
 * migración es una foto de su momento, y si la lista cambiara en el modelo esta
 * migración no debe cambiar con ella.
 *
 * No modifica ninguna fila. Si alguna tuviera un estado fuera de los tres, el
 * ALTER fallaría entero y no se aplicaría nada.
 */
export default class extends BaseSchema {
  protected tableName = 'tasks'

  async up() {
    this.schema.raw(`
      ALTER TABLE tasks
      ADD CONSTRAINT tasks_status_check
      CHECK (status IN ('pending', 'in_progress', 'done'))
    `)
  }

  async down() {
    this.schema.raw('ALTER TABLE tasks DROP CONSTRAINT tasks_status_check')
  }
}
