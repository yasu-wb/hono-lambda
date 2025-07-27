import { Hono } from 'hono'
import { handle } from 'hono/aws-lambda'
import type { LambdaEvent, LambdaContext } from 'hono/aws-lambda'

type Bindings = {
  event: LambdaEvent
  context: LambdaContext
}

const app = new Hono<{ Bindings: Bindings }>()

app.get('/', (c) => {
  return c.text('Hello Hono!')
})
app.post('/hono-lambda', async (c) => {
  const request = await c.req.json()

  return c.json({
    message: 'Hello from Hono Lambda!',
    request: request,
  })
})

export const handler = handle(app)
