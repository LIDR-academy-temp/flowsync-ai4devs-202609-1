import Task from '#models/task'
import User from '#models/user'
import { test } from '@japa/runner'
import testUtils from '@adonisjs/core/services/test_utils'

/**
 * Lo que cada tarea muestra de su responsable. Cubre los tres scenarios del
 * requisito «Lo que cada tarea muestra de su responsable» de
 * `openspec/specs/tasks/spec.md`: responsable identificable, la tarea no filtra
 * datos de cuenta, y responsable sin nombre.
 *
 * Cada scenario se comprueba en las dos lecturas que devuelven tareas: la tarea
 * suelta (`GET /api/v1/tasks/:id`) y la lista (`GET /api/v1/tasks`). Quien mira
 * es una cuenta distinta del responsable, que es el caso en el que mostrar de
 * más le importa a alguien.
 *
 * Mismo aislamiento que en `auth`: transacción global, porque la suite pega
 * contra el mismo SQLite que el servidor de desarrollo.
 */
test.group('Tasks | responsable', (group) => {
  group.each.setup(() => testUtils.db().withGlobalTransaction())

  /**
   * La tarea suelta exige el día de quien mira; cualquier día válido sirve,
   * porque aquí no se comprueba el vencimiento.
   */
  const today = '2026-11-09'

  async function sesion(client: any) {
    await User.create({
      fullName: 'Alan Turing',
      email: 'alan@example.com',
      password: 'secreto123',
    })

    const response = await client
      .post('/api/v1/auth/login')
      .json({ email: 'alan@example.com', password: 'secreto123' })

    return response.body().data.token as string
  }

  async function tareaDe(responsable: User) {
    return Task.create({
      title: 'Revisar el informe',
      status: 'pending',
      assigneeId: responsable.id,
    })
  }

  /**
   * El `assignee` de la tarea tal y como sale en cada lectura: suelta y dentro
   * de la lista.
   */
  async function assigneeEnCadaLectura(client: any, token: string, task: Task) {
    const suelta = await client
      .get(`/api/v1/tasks/${task.id}`)
      .qs({ today })
      .header('Authorization', `Bearer ${token}`)
    suelta.assertStatus(200)

    const lista = await client.get('/api/v1/tasks').header('Authorization', `Bearer ${token}`)
    lista.assertStatus(200)
    const enLista = lista.body().data.find((t: { id: number }) => t.id === task.id)

    return {
      suelta: suelta.body().data.assignee,
      lista: enLista?.assignee,
    }
  }

  test('el responsable se identifica por su nombre y sus iniciales', async ({ client, assert }) => {
    const token = await sesion(client)
    const ada = await User.create({
      fullName: 'Ada Lovelace',
      email: 'ada@example.com',
      password: 'secreto123',
    })
    const task = await tareaDe(ada)

    const lecturas = await assigneeEnCadaLectura(client, token, task)

    for (const [lectura, assignee] of Object.entries(lecturas)) {
      assert.isObject(assignee, `${lectura}: la tarea no trae assignee`)
      assert.equal(assignee.fullName, 'Ada Lovelace', `${lectura}: nombre`)
      assert.equal(assignee.initials, 'AL', `${lectura}: iniciales`)
    }
  })

  test('la tarea no filtra el email ni datos de acceso de su responsable', async ({
    client,
    assert,
  }) => {
    const token = await sesion(client)
    const ada = await User.create({
      fullName: 'Ada Lovelace',
      email: 'ada@example.com',
      password: 'secreto123',
    })
    const task = await tareaDe(ada)

    const lecturas = await assigneeEnCadaLectura(client, token, task)

    for (const [lectura, assignee] of Object.entries(lecturas)) {
      // Sin esto, un assignee ausente pasaría todas las comprobaciones de abajo.
      assert.isObject(assignee, `${lectura}: la tarea no trae assignee`)

      assert.notProperty(assignee, 'email', `${lectura}: expone el campo email`)
      assert.notProperty(assignee, 'password', `${lectura}: expone el campo password`)

      const serialized = JSON.stringify(assignee)
      assert.notInclude(
        serialized,
        'ada@example.com',
        `${lectura}: el email aparece en el assignee`
      )
      assert.notInclude(
        serialized,
        'secreto123',
        `${lectura}: la contraseña aparece en el assignee`
      )
    }
  })

  test('un responsable sin nombre llega con nombre nulo y con iniciales', async ({
    client,
    assert,
  }) => {
    const token = await sesion(client)
    const sinNombre = await User.create({
      fullName: null,
      email: 'ada@example.com',
      password: 'secreto123',
    })
    const task = await tareaDe(sinNombre)

    const lecturas = await assigneeEnCadaLectura(client, token, task)

    for (const [lectura, assignee] of Object.entries(lecturas)) {
      assert.isObject(assignee, `${lectura}: la tarea no trae assignee`)
      // `isNull` es estricto: un campo ausente (undefined) no lo satisface.
      assert.isNull(assignee.fullName, `${lectura}: el nombre no llega nulo`)
      // El valor sale del requisito «Iniciales de la cuenta» de la spec de auth.
      assert.equal(assignee.initials, 'AE', `${lectura}: iniciales`)
    }
  })
})
