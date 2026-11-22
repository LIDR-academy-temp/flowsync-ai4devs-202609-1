import User from '#models/user'
import { test } from '@japa/runner'
import testUtils from '@adonisjs/core/services/test_utils'

/**
 * Cuándo una tarea está vencida, leída de vuelta de la base. Cubre el scenario
 * «Fecha del día anterior» del requisito «Cuándo una tarea está vencida» de
 * `openspec/specs/tasks/spec.md`, más un caso de una fecha muy pasada.
 *
 * Lo que importa es el camino: la fecha se guarda con `PUT .../due-date` y la
 * condición se lee después con `GET /api/v1/tasks/:id`, que trae la tarea de la
 * base. La respuesta del propio `PUT` no sirve para esto: compara la fecha
 * recién asignada, que es texto, y no lo que devuelve el driver al leerla.
 *
 * Con SQLite el driver devolvía la columna `date` como el texto `AAAA-MM-DD` y
 * `Task.isOverdueOn` comparaba texto con texto. Con PostgreSQL el driver `pg`
 * la devuelve como un `Date`, y `Date < 'AAAA-MM-DD'` es siempre `false`: el
 * texto se convierte a `NaN`. Estos tests fallan mientras eso siga así.
 */
test.group('Tasks | vencida al leerla de la base', (group) => {
  group.each.setup(() => testUtils.db().withGlobalTransaction())

  const DIA_DE_REFERENCIA = '2026-11-22'

  /** Crea una cuenta y una tarea suya con la fecha de vencimiento indicada. */
  async function tareaConFecha(client: any, dueDate: string) {
    await User.create({
      fullName: 'Ada Lovelace',
      email: 'ada@example.com',
      password: 'secreto123',
    })

    const login = await client
      .post('/api/v1/auth/login')
      .json({ email: 'ada@example.com', password: 'secreto123' })
    const token = login.body().data.token as string

    const creada = await client
      .post('/api/v1/tasks')
      .header('Authorization', `Bearer ${token}`)
      .json({ title: 'Revisar el informe' })
    creada.assertStatus(201)
    const id = creada.body().data.id as number

    const conFecha = await client
      .put(`/api/v1/tasks/${id}/due-date`)
      .header('Authorization', `Bearer ${token}`)
      .json({ dueDate, today: DIA_DE_REFERENCIA })
    conFecha.assertStatus(200)

    return { token, id }
  }

  /** La tarea tal y como llega al pedirla, es decir, leída de la base. */
  async function leer(client: any, token: string, id: number) {
    const respuesta = await client
      .get(`/api/v1/tasks/${id}`)
      .qs({ today: DIA_DE_REFERENCIA })
      .header('Authorization', `Bearer ${token}`)
    respuesta.assertStatus(200)

    return respuesta.body().data
  }

  test('una tarea con fecha del día anterior llega vencida', async ({ client, assert }) => {
    const { token, id } = await tareaConFecha(client, '2026-11-21')

    const tarea = await leer(client, token, id)

    assert.equal(tarea.status, 'pending')
    assert.isTrue(tarea.isOverdue)
  })

  test('una tarea que venció en 2025 llega vencida', async ({ client, assert }) => {
    const { token, id } = await tareaConFecha(client, '2025-06-15')

    const tarea = await leer(client, token, id)

    assert.equal(tarea.status, 'pending')
    assert.isTrue(tarea.isOverdue)
  })
})
