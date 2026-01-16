# Database & API Development Guidelines

Guidelines for building robust data layers with PostgreSQL, Prisma, GraphQL (Pothos), Redis caching, and BullMQ background job processing.

## Language & Code Standards

**MANDATORY**: All code, comments, documentation, variable names, function names, and commit messages must be in **English**.

## Core Principles

- **Type-safe data access** - Use Prisma for end-to-end type safety from database to application
- **Code-first GraphQL** - Use Pothos for type-safe GraphQL schema building
- **Multi-layer caching** - Implement Redis for hot data and expensive queries
- **Background processing** - Use BullMQ for reliable, distributed task processing
- **N+1 prevention** - Optimize queries with proper includes and dataloaders
- **Security first** - Validate inputs, encrypt sensitive data, use parameterized queries

## Database (PostgreSQL + Prisma)

### Prisma Schema

```prisma
// prisma/schema.prisma
generator client {
  provider = "prisma-client-js"
}

datasource db {
  provider = "postgresql"
  url      = env("DATABASE_URL")
}

model User {
  id        String   @id @default(cuid())
  email     String   @unique
  name      String?
  posts     Post[]
  createdAt DateTime @default(now())
  updatedAt DateTime @updatedAt

  @@index([email])
}

model Post {
  id        String   @id @default(cuid())
  title     String
  content   String?
  published Boolean  @default(false)
  author    User     @relation(fields: [authorId], references: [id])
  authorId  String
  createdAt DateTime @default(now())
  updatedAt DateTime @updatedAt

  @@index([authorId])
  @@index([published])
}
```

### Prisma Client Setup

```typescript
// lib/prisma.ts
import { PrismaClient } from '@prisma/client'

const globalForPrisma = globalThis as unknown as {
  prisma: PrismaClient | undefined
}

export const prisma = globalForPrisma.prisma ?? new PrismaClient({
  log: process.env.NODE_ENV === 'development' ? ['query', 'error', 'warn'] : ['error'],
})

if (process.env.NODE_ENV !== 'production') globalForPrisma.prisma = prisma
```

### Query Optimization

```typescript
// Avoid N+1 queries - BAD
const users = await prisma.user.findMany()
for (const user of users) {
  const posts = await prisma.post.findMany({ where: { authorId: user.id } })
}

// Use include - GOOD
const users = await prisma.user.findMany({
  include: {
    posts: true,
  },
})

// Use select for specific fields - BETTER
const users = await prisma.user.findMany({
  select: {
    id: true,
    name: true,
    posts: {
      select: {
        id: true,
        title: true,
      },
    },
  },
})
```

### Transactions

```typescript
// Atomic operations
const result = await prisma.$transaction(async (tx) => {
  const user = await tx.user.create({
    data: { email: 'user@example.com', name: 'User' },
  })
  
  const post = await tx.post.create({
    data: {
      title: 'First Post',
      authorId: user.id,
    },
  })
  
  return { user, post }
})
```

### Migrations

```bash
# Create migration
pnpm prisma migrate dev --name add_user_role

# Apply migrations in production
pnpm prisma migrate deploy

# Generate Prisma Client
pnpm prisma generate

# Reset database (development only)
pnpm prisma migrate reset
```

## GraphQL API (Pothos + Yoga)

### Pothos Schema Builder

```typescript
// lib/graphql/builder.ts
import SchemaBuilder from '@pothos/core'
import PrismaPlugin from '@pothos/plugin-prisma'
import type PrismaTypes from '@pothos/plugin-prisma/generated'
import { prisma } from '../prisma'

export const builder = new SchemaBuilder<{
  PrismaTypes: PrismaTypes
}>({
  plugins: [PrismaPlugin],
  prisma: {
    client: prisma,
  },
})

builder.queryType({})
builder.mutationType({})
```

### Type Definitions

```typescript
// lib/graphql/types/user.ts
import { builder } from '../builder'

builder.prismaObject('User', {
  fields: (t) => ({
    id: t.exposeID('id'),
    email: t.exposeString('email'),
    name: t.exposeString('name', { nullable: true }),
    posts: t.relation('posts'),
    createdAt: t.expose('createdAt', { type: 'DateTime' }),
  }),
})

builder.prismaObject('Post', {
  fields: (t) => ({
    id: t.exposeID('id'),
    title: t.exposeString('title'),
    content: t.exposeString('content', { nullable: true }),
    published: t.exposeBoolean('published'),
    author: t.relation('author'),
    createdAt: t.expose('createdAt', { type: 'DateTime' }),
  }),
})
```

### Queries

```typescript
// lib/graphql/queries/user.ts
import { builder } from '../builder'

builder.queryField('user', (t) =>
  t.prismaField({
    type: 'User',
    nullable: true,
    args: {
      id: t.arg.string({ required: true }),
    },
    resolve: async (query, _parent, args, _ctx) =>
      prisma.user.findUnique({
        ...query,
        where: { id: args.id },
      }),
  })
)

builder.queryField('users', (t) =>
  t.prismaField({
    type: ['User'],
    resolve: async (query) =>
      prisma.user.findMany({ ...query }),
  })
)
```

### Mutations

```typescript
// lib/graphql/mutations/user.ts
import { builder } from '../builder'
import { z } from 'zod'

const CreateUserInput = builder.inputType('CreateUserInput', {
  fields: (t) => ({
    email: t.string({ required: true }),
    name: t.string(),
  }),
})

builder.mutationField('createUser', (t) =>
  t.prismaField({
    type: 'User',
    args: {
      input: t.arg({ type: CreateUserInput, required: true }),
    },
    resolve: async (query, _parent, args, _ctx) => {
      // Validate with Zod
      const schema = z.object({
        email: z.string().email(),
        name: z.string().optional(),
      })
      
      const validated = schema.parse(args.input)
      
      return prisma.user.create({
        ...query,
        data: validated,
      })
    },
  })
)
```

### GraphQL Yoga Server

```typescript
// app/api/graphql/route.ts
import { createYoga } from 'graphql-yoga'
import { schema } from '@/lib/graphql/schema'

const { handleRequest } = createYoga({
  schema,
  graphqlEndpoint: '/api/graphql',
  fetchAPI: { Response },
})

export { handleRequest as GET, handleRequest as POST }
```

## Caching (Redis)

### Redis Client Setup

```typescript
// lib/redis.ts
import { Redis } from 'ioredis'

const globalForRedis = globalThis as unknown as {
  redis: Redis | undefined
}

export const redis = globalForRedis.redis ?? new Redis(process.env.REDIS_URL!)

if (process.env.NODE_ENV !== 'production') globalForRedis.redis = redis
```

### Caching Patterns

```typescript
// Cache expensive queries
async function getUserWithCache(userId: string) {
  const cacheKey = `user:${userId}`
  
  // Try cache first
  const cached = await redis.get(cacheKey)
  if (cached) {
    return JSON.parse(cached)
  }
  
  // Fetch from database
  const user = await prisma.user.findUnique({
    where: { id: userId },
    include: { posts: true },
  })
  
  // Store in cache (1 hour TTL)
  await redis.setex(cacheKey, 3600, JSON.stringify(user))
  
  return user
}

// Invalidate cache on update
async function updateUser(userId: string, data: any) {
  const user = await prisma.user.update({
    where: { id: userId },
    data,
  })
  
  // Invalidate cache
  await redis.del(`user:${userId}`)
  
  return user
}
```

### Cache Patterns

```typescript
// Cache-aside pattern
async function getCachedData<T>(
  key: string,
  fetcher: () => Promise<T>,
  ttl: number = 3600
): Promise<T> {
  const cached = await redis.get(key)
  if (cached) return JSON.parse(cached)
  
  const data = await fetcher()
  await redis.setex(key, ttl, JSON.stringify(data))
  return data
}

// Usage
const posts = await getCachedData(
  'posts:published',
  () => prisma.post.findMany({ where: { published: true } }),
  1800 // 30 minutes
)
```

## Background Jobs (BullMQ)

### Queue Setup

```typescript
// lib/queue.ts
import { Queue, Worker } from 'bullmq'
import { redis } from './redis'

const connection = {
  host: process.env.REDIS_HOST,
  port: parseInt(process.env.REDIS_PORT || '6379'),
}

export const emailQueue = new Queue('email', { connection })

// Worker
export const emailWorker = new Worker(
  'email',
  async (job) => {
    const { to, subject, body } = job.data
    
    // Send email logic
    console.log(`Sending email to ${to}: ${subject}`)
    
    // Simulate async work
    await new Promise((resolve) => setTimeout(resolve, 1000))
    
    return { sent: true }
  },
  { connection }
)

emailWorker.on('completed', (job) => {
  console.log(`Job ${job.id} completed`)
})

emailWorker.on('failed', (job, err) => {
  console.error(`Job ${job?.id} failed:`, err)
})
```

### Adding Jobs

```typescript
// Add job to queue
await emailQueue.add('welcome-email', {
  to: 'user@example.com',
  subject: 'Welcome!',
  body: 'Welcome to our platform',
})

// Add job with options
await emailQueue.add(
  'reminder-email',
  { to: 'user@example.com', subject: 'Reminder' },
  {
    delay: 3600000, // 1 hour delay
    attempts: 3,
    backoff: {
      type: 'exponential',
      delay: 1000,
    },
  }
)
```

## Security Best Practices

### Input Validation

```typescript
import { z } from 'zod'

const userSchema = z.object({
  email: z.string().email(),
  name: z.string().min(2).max(100),
  age: z.number().int().positive().optional(),
})

// Validate before database operations
const validated = userSchema.parse(input)
```

### Sensitive Data Encryption

```typescript
import crypto from 'crypto'

const algorithm = 'aes-256-gcm'
const key = Buffer.from(process.env.ENCRYPTION_KEY!, 'hex')

export function encrypt(text: string): string {
  const iv = crypto.randomBytes(16)
  const cipher = crypto.createCipheriv(algorithm, key, iv)
  
  let encrypted = cipher.update(text, 'utf8', 'hex')
  encrypted += cipher.final('hex')
  
  const authTag = cipher.getAuthTag()
  
  return `${iv.toString('hex')}:${authTag.toString('hex')}:${encrypted}`
}

export function decrypt(encrypted: string): string {
  const [ivHex, authTagHex, encryptedText] = encrypted.split(':')
  
  const iv = Buffer.from(ivHex, 'hex')
  const authTag = Buffer.from(authTagHex, 'hex')
  const decipher = crypto.createDecipheriv(algorithm, key, iv)
  
  decipher.setAuthTag(authTag)
  
  let decrypted = decipher.update(encryptedText, 'hex', 'utf8')
  decrypted += decipher.final('utf8')
  
  return decrypted
}
```

### Password Hashing

```typescript
import { hash, verify } from '@node-rs/argon2'

export async function hashPassword(password: string): Promise<string> {
  return hash(password, {
    memoryCost: 19456,
    timeCost: 2,
    outputLen: 32,
    parallelism: 1,
  })
}

export async function verifyPassword(
  hash: string,
  password: string
): Promise<boolean> {
  return verify(hash, password)
}
```

### SQL Injection Prevention

Prisma automatically prevents SQL injection through parameterized queries. Never use raw SQL unless absolutely necessary.

```typescript
// Safe - Prisma parameterizes automatically
const user = await prisma.user.findUnique({
  where: { email: userInput },
})

// Unsafe - Only use raw SQL when necessary and with proper escaping
const users = await prisma.$queryRaw`
  SELECT * FROM "User" WHERE email = ${userInput}
`
```

## Testing

### Unit Tests

```typescript
import { prisma } from '@/lib/prisma'
import { beforeEach, describe, expect, it } from 'vitest'

describe('User CRUD', () => {
  beforeEach(async () => {
    await prisma.user.deleteMany()
  })
  
  it('should create a user', async () => {
    const user = await prisma.user.create({
      data: {
        email: 'test@example.com',
        name: 'Test User',
      },
    })
    
    expect(user.email).toBe('test@example.com')
    expect(user.name).toBe('Test User')
  })
  
  it('should find user by email', async () => {
    await prisma.user.create({
      data: { email: 'test@example.com', name: 'Test' },
    })
    
    const user = await prisma.user.findUnique({
      where: { email: 'test@example.com' },
    })
    
    expect(user).not.toBeNull()
    expect(user?.name).toBe('Test')
  })
})
```

## Performance Optimization

### Database Indexes

```prisma
model User {
  id    String @id @default(cuid())
  email String @unique
  name  String
  
  @@index([email])
  @@index([name])
}
```

### Connection Pooling

```typescript
// Prisma handles connection pooling automatically
// Configure in DATABASE_URL
// postgresql://user:password@localhost:5432/db?connection_limit=10
```

### Query Analysis

```typescript
// Enable query logging in development
const prisma = new PrismaClient({
  log: ['query', 'info', 'warn', 'error'],
})

// Analyze slow queries and add indexes
```

## Resources

- [Prisma Documentation](https://www.prisma.io/docs)
- [Pothos GraphQL](https://pothos-graphql.dev/)
- [GraphQL Yoga](https://the-guild.dev/graphql/yoga-server)
- [Redis Documentation](https://redis.io/docs/)
- [BullMQ Documentation](https://docs.bullmq.io/)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)

---

**Remember: Type-safe, Cached, Optimized, and Secure!**
