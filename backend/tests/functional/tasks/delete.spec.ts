import Task from '#models/task'
import User from '#models/user'
import { test } from '@japa/runner'
import testUtils from '@adonisjs/core/services/test_utils'

/**
 * `DELETE /api/v1/tasks/:id`: borra la tarea y responde 204 sin cuerpo.
 */
test.group('Tasks | borrar', (group) => {
  group.each.setup(() => testUtils.db().withGlobalTransaction())

  async function sesion(client: any, email: string) {
    await User.create({ fullName: 'Ada Lovelace', email, password: 'secreto123' })
    const login = await client.post('/api/v1/auth/login').json({ email, password: 'secreto123' })
    return login.body().data.token as string
  }

  test('borra la tarea y responde 204 sin cuerpo', async ({ client, assert }) => {
    const token = await sesion(client, 'ada@example.com')
    const user = await User.findByOrFail('email', 'ada@example.com')
    const tarea = await Task.create({
      title: 'Revisar el informe',
      status: 'pending',
      assigneeId: user.id,
    })

    const respuesta = await client
      .delete(`/api/v1/tasks/${tarea.id}`)
      .header('Authorization', `Bearer ${token}`)

    respuesta.assertStatus(204)
    assert.equal(respuesta.text(), '')
    assert.isNull(await Task.find(tarea.id))
  })

  test('una tarea que no existe responde 404', async ({ client }) => {
    const token = await sesion(client, 'ada@example.com')

    const respuesta = await client
      .delete('/api/v1/tasks/999999')
      .header('Authorization', `Bearer ${token}`)

    respuesta.assertStatus(404)
  })

  test('sin sesión responde 401 y no borra nada', async ({ client, assert }) => {
    await sesion(client, 'ada@example.com')
    const user = await User.findByOrFail('email', 'ada@example.com')
    const tarea = await Task.create({
      title: 'Revisar el informe',
      status: 'pending',
      assigneeId: user.id,
    })

    const respuesta = await client.delete(`/api/v1/tasks/${tarea.id}`)

    respuesta.assertStatus(401)
    assert.isNotNull(await Task.find(tarea.id))
  })
})
