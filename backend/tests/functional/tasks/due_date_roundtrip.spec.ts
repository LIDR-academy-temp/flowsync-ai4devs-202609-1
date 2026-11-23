import Task from '#models/task'
import User from '#models/user'
import { test } from '@japa/runner'
import testUtils from '@adonisjs/core/services/test_utils'

/**
 * La fecha de vencimiento sale de la base tal y como entró: un día del
 * calendario en texto `AAAA-MM-DD`, no un instante.
 *
 * Existe por el cambio de SQLite a PostgreSQL. SQLite guardaba y devolvía la
 * fecha como texto; el driver `pg`, por defecto, convierte cada columna `date`
 * en un `Date` de JavaScript. Con eso la API devolvía
 * `"2026-08-26T00:00:00.000Z"` (o el día anterior, según el huso del proceso) y
 * `isOverdueOn()` comparaba un `Date` con un texto, que da siempre `false`. La
 * suite seguía en verde porque ningún test leía una fecha de vuelta de la base:
 * la respuesta del PUT sale del modelo en memoria, no de una lectura.
 *
 * Por eso los dos tests leen la tarea **recién cargada de la base**, nunca la
 * instancia que se acaba de guardar.
 */
test.group('Tasks | la fecha de vencimiento vuelve de la base igual', (group) => {
  group.each.setup(() => testUtils.db().withGlobalTransaction())

  async function tareaVencidaAyer() {
    const user = await User.create({
      fullName: 'Ana Prueba',
      email: 'ana@example.com',
      password: 'secreto123',
    })
    const creada = await Task.create({
      title: 'Vencida ayer',
      status: 'pending',
      assigneeId: user.id,
      dueDate: '2026-08-26',
    })

    return { user, id: creada.id }
  }

  test('el modelo la lee como el mismo texto que se guardó', async ({ assert }) => {
    const { id } = await tareaVencidaAyer()

    const leida = await Task.findOrFail(id)

    assert.strictEqual(leida.dueDate, '2026-08-26')
    assert.isTrue(leida.isOverdueOn('2026-08-27'))
  })

  test('la API la devuelve sin hora y la tarea sale vencida', async ({ client, assert }) => {
    const { user, id } = await tareaVencidaAyer()

    const response = await client
      .get(`/api/v1/tasks/${id}`)
      .qs({ today: '2026-08-27' })
      .loginAs(user)

    response.assertStatus(200)
    assert.strictEqual(response.body().data.dueDate, '2026-08-26')
    assert.isTrue(response.body().data.isOverdue)
  })
})
