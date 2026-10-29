import app from '@adonisjs/core/services/app'
import router from '@adonisjs/core/services/router'

/**
 * Ruta del documento OpenAPI versionado. Vive en el `docs/` de la raíz del
 * monorepo, no dentro de `backend/`, junto al resto de la documentación.
 */
export const OPENAPI_DOCUMENT_PATH = app.makePath('..', 'docs', 'api', 'openapi.json')

/**
 * Construye el documento OpenAPI con la misma maquinaria que sirve `/api.json`
 * y lo serializa de forma estable: indentado y con salto de línea final, para
 * que el fichero versionado tenga diffs legibles y la comparación de
 * `openapi:check` sea byte a byte.
 */
export async function renderOpenApiDocument(): Promise<string> {
  // Fuera del servidor HTTP nadie hace commit del router, y sin él las rutas
  // de los grupos no tienen aún su patrón definitivo (prefijos, nombres).
  router.commit()

  const openapi = await app.container.make('openapi')
  const document = await openapi.buildDocument()
  return `${JSON.stringify(document, null, 2)}\n`
}

/**
 * Compara dos documentos y devuelve una línea por cada diferencia, con la
 * ruta JSON Pointer donde ocurre. Lista vacía si son iguales.
 */
export function diffOpenApiDocuments(expected: unknown, actual: unknown, pointer = ''): string[] {
  const where = pointer || '/'

  if (isObject(expected) && isObject(actual)) {
    const keys = new Set([...Object.keys(expected), ...Object.keys(actual)])
    return [...keys].flatMap((key) => {
      const child = `${pointer}/${key.replaceAll('~', '~0').replaceAll('/', '~1')}`
      if (!(key in actual)) return [`- ${child}: sobra en el versionado`]
      if (!(key in expected)) return [`+ ${child}: falta en el versionado`]
      return diffOpenApiDocuments(expected[key], actual[key], child)
    })
  }

  if (Array.isArray(expected) && Array.isArray(actual)) {
    const length = Math.max(expected.length, actual.length)
    return Array.from({ length }, (_, index) => {
      const child = `${pointer}/${index}`
      if (index >= actual.length) return [`- ${child}: sobra en el versionado`]
      if (index >= expected.length) return [`+ ${child}: falta en el versionado`]
      return diffOpenApiDocuments(expected[index], actual[index], child)
    }).flat()
  }

  if (JSON.stringify(expected) === JSON.stringify(actual)) return []
  return [`~ ${where}: versionado ${JSON.stringify(expected)}, generado ${JSON.stringify(actual)}`]
}

function isObject(value: unknown): value is Record<string, unknown> {
  return typeof value === 'object' && value !== null && !Array.isArray(value)
}
