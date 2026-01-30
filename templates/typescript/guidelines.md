# TypeScript Development Guidelines

Comprehensive guidelines for building production-ready TypeScript applications with strict type safety, modern patterns, and best practices.

## Language & Code Standards

**MANDATORY**: All code, comments, documentation, variable names, function names, and commit messages must be in **English**.

## Core Principles

### 1. Strict Type Safety

**Enable all strict compiler options** in `tsconfig.json`:

```json
{
  "compilerOptions": {
    "strict": true,
    "noUncheckedIndexedAccess": true,
    "noImplicitOverride": true,
    "noPropertyAccessFromIndexSignature": true,
    "noFallthroughCasesInSwitch": true,
    "noImplicitReturns": true,
    "noUnusedLocals": true,
    "noUnusedParameters": true
  }
}
```

### 2. Zero Tolerance for `any`

**Never use `any` types** - always use proper types or `unknown`:

```typescript
// ❌ FORBIDDEN
function processData(data: any): any {
  return data.value
}

// ✅ CORRECT - with type guard
interface DataWithValue {
  value: string
}

function isDataWithValue(data: unknown): data is DataWithValue {
  return (
    typeof data === "object" &&
    data !== null &&
    "value" in data &&
    typeof (data as DataWithValue).value === "string"
  )
}

function processData(data: unknown): string {
  if (isDataWithValue(data)) {
    return data.value
  }
  throw new TypeError("Invalid data: expected object with string value")
}
```

### 3. Explicit Return Types

**Always specify return types** for public functions and exported functions:

```typescript
// ❌ BAD - inferred return type
export function calculateTotal(items: Item[]) {
  return items.reduce((sum, item) => sum + item.price, 0)
}

// ✅ GOOD - explicit return type
export function calculateTotal(items: Item[]): number {
  return items.reduce((sum, item) => sum + item.price, 0)
}

// ✅ EXCELLENT - with async
export async function fetchUser(id: string): Promise<User | null> {
  const user = await db.users.findUnique({ where: { id } })
  return user
}
```

### 4. Null Safety

**Use optional chaining and nullish coalescing** instead of manual checks:

```typescript
// ❌ BAD
const userName = user && user.profile && user.profile.name
const count = value !== null && value !== undefined ? value : 0

// ✅ GOOD
const userName = user?.profile?.name
const count = value ?? 0

// ✅ EXCELLENT - with default object
const profile = user?.profile ?? { name: "Anonymous", avatar: null }
```

## Type System Patterns

### 1. Discriminated Unions

Use discriminated unions for type-safe state management and error handling:

```typescript
// State machine pattern
type LoadingState<T> =
  | { status: "idle" }
  | { status: "loading" }
  | { status: "success"; data: T }
  | { status: "error"; error: Error }

function renderLoadingState<T>(state: LoadingState<T>): string {
  switch (state.status) {
    case "idle":
      return "Ready to load"
    case "loading":
      return "Loading..."
    case "success":
      return `Loaded: ${JSON.stringify(state.data)}`
    case "error":
      return `Error: ${state.error.message}`
  }
}

// Result pattern
type Result<T, E = Error> =
  | { ok: true; value: T }
  | { ok: false; error: E }

function divide(a: number, b: number): Result<number, string> {
  if (b === 0) {
    return { ok: false, error: "Division by zero" }
  }
  return { ok: true, value: a / b }
}

// Usage
const result = divide(10, 2)
if (result.ok) {
  console.log(result.value) // Type: number
} else {
  console.error(result.error) // Type: string
}
```

### 2. Generics with Constraints

Use generic constraints to create reusable, type-safe functions:

```typescript
// Basic constraint
function getProperty<T extends object, K extends keyof T>(
  obj: T,
  key: K
): T[K] {
  return obj[key]
}

const user = { name: "John", age: 30 }
const name = getProperty(user, "name") // Type: string
const age = getProperty(user, "age") // Type: number

// Multiple type parameters
function merge<T extends object, U extends object>(
  obj1: T,
  obj2: U
): T & U {
  return { ...obj1, ...obj2 }
}

// Conditional constraints
function filterNullable<T>(array: (T | null | undefined)[]): T[] {
  return array.filter((item): item is T => item != null)
}

const numbers = [1, null, 2, undefined, 3]
const filtered = filterNullable(numbers) // Type: number[]
```

### 3. Utility Types

Leverage built-in and custom utility types:

```typescript
interface User {
  id: string
  name: string
  email: string
  password: string
  role: "admin" | "user"
  createdAt: Date
  updatedAt: Date
}

// Built-in utilities
type UserPublic = Pick<User, "id" | "name" | "email" | "role">
type UserSafe = Omit<User, "password">
type UserPartial = Partial<User>
type UserRequired = Required<Partial<User>>
type UserReadonly = Readonly<User>

// Custom utilities
type Nullable<T> = {
  [K in keyof T]: T[K] | null
}

type DeepPartial<T> = {
  [K in keyof T]?: T[K] extends object ? DeepPartial<T[K]> : T[K]
}

type DeepReadonly<T> = {
  readonly [K in keyof T]: T[K] extends object ? DeepReadonly<T[K]> : T[K]
}

type RequireAtLeastOne<T, Keys extends keyof T = keyof T> = Pick<
  T,
  Exclude<keyof T, Keys>
> &
  {
    [K in Keys]-?: Required<Pick<T, K>> & Partial<Pick<T, Exclude<Keys, K>>>
  }[Keys]

// Usage
type UserUpdate = RequireAtLeastOne<
  Pick<User, "name" | "email" | "role">,
  "name" | "email" | "role"
>
// Must have at least one of: name, email, or role
```

### 4. Type Guards

Create type guards for runtime type checking:

```typescript
// Primitive type guards
function isString(value: unknown): value is string {
  return typeof value === "string"
}

function isNumber(value: unknown): value is number {
  return typeof value === "number" && !isNaN(value)
}

// Object type guard
interface User {
  id: string
  name: string
  email: string
}

function isUser(value: unknown): value is User {
  return (
    typeof value === "object" &&
    value !== null &&
    "id" in value &&
    typeof (value as User).id === "string" &&
    "name" in value &&
    typeof (value as User).name === "string" &&
    "email" in value &&
    typeof (value as User).email === "string"
  )
}

// Array type guard
function isStringArray(value: unknown): value is string[] {
  return Array.isArray(value) && value.every((item) => typeof item === "string")
}

// Generic array type guard
function isArrayOf<T>(
  value: unknown,
  guard: (item: unknown) => item is T
): value is T[] {
  return Array.isArray(value) && value.every(guard)
}

// Usage
const data: unknown = [{ id: "1", name: "John", email: "john@example.com" }]
if (isArrayOf(data, isUser)) {
  // data is now typed as User[]
  data.forEach((user) => console.log(user.name))
}
```

### 5. Conditional Types

Create dynamic types based on conditions:

```typescript
// Extract return type
type ReturnType<T> = T extends (...args: any[]) => infer R ? R : never

// Extract array element type
type ArrayElement<T> = T extends (infer E)[] ? E : never

// Extract promise type
type Awaited<T> = T extends Promise<infer U> ? U : T

// Flatten nested arrays
type Flatten<T> = T extends Array<infer U> ? Flatten<U> : T

// Function parameter types
type Parameters<T> = T extends (...args: infer P) => any ? P : never

// Make specific keys optional
type PartialBy<T, K extends keyof T> = Omit<T, K> & Partial<Pick<T, K>>

// Make specific keys required
type RequiredBy<T, K extends keyof T> = Omit<T, K> & Required<Pick<T, K>>

// Usage
interface CreateUserInput {
  name: string
  email: string
  password: string
  role?: "admin" | "user"
  avatar?: string
}

type UpdateUserInput = PartialBy<CreateUserInput, "password">
// name, email, role, avatar are optional; password is required
```

### 6. Template Literal Types

Use template literal types for string manipulation:

```typescript
// Event names
type EventName = "click" | "focus" | "blur" | "change"
type EventHandler = `on${Capitalize<EventName>}`
// "onClick" | "onFocus" | "onBlur" | "onChange"

// API routes
type HTTPMethod = "GET" | "POST" | "PUT" | "DELETE" | "PATCH"
type Resource = "users" | "posts" | "comments"
type APIRoute = `/${Resource}`
type APIEndpoint = `${HTTPMethod} ${APIRoute}`

// CSS properties
type CSSProperty = "color" | "background" | "border" | "padding" | "margin"
type CSSUnit = "px" | "rem" | "em" | "%"
type CSSValue = `${number}${CSSUnit}`

// Type-safe route builder
type Route = "/users" | "/posts" | "/comments"
type RouteWithId = `${Route}/${string}`

function navigateTo(route: Route | RouteWithId): void {
  console.log(`Navigating to ${route}`)
}

navigateTo("/users") // ✅
navigateTo("/users/123") // ✅
navigateTo("/invalid") // ❌ Type error
```

## Configuration Best Practices

### Recommended `tsconfig.json`

```json
{
  "compilerOptions": {
    // Type Checking
    "strict": true,
    "noUncheckedIndexedAccess": true,
    "noImplicitOverride": true,
    "noPropertyAccessFromIndexSignature": true,
    "noFallthroughCasesInSwitch": true,
    "noImplicitReturns": true,
    "noUnusedLocals": true,
    "noUnusedParameters": true,
    "exactOptionalPropertyTypes": true,
    "noUncheckedSideEffectImports": true,

    // Modules
    "module": "ESNext",
    "moduleResolution": "bundler",
    "resolveJsonModule": true,
    "allowImportingTsExtensions": true,

    // Emit
    "noEmit": true,
    "declaration": true,
    "declarationMap": true,
    "sourceMap": true,
    "removeComments": false,

    // Interop
    "esModuleInterop": true,
    "allowSyntheticDefaultImports": true,
    "forceConsistentCasingInFileNames": true,
    "isolatedModules": true,
    "verbatimModuleSyntax": true,

    // Language
    "target": "ES2022",
    "lib": ["ES2022"],
    "useDefineForClassFields": true,

    // Performance
    "skipLibCheck": true,
    "incremental": true
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules", "dist", "build", "**/*.spec.ts", "**/*.test.ts"]
}
```

### ESLint Configuration

```json
{
  "parser": "@typescript-eslint/parser",
  "parserOptions": {
    "ecmaVersion": 2022,
    "sourceType": "module",
    "project": "./tsconfig.json"
  },
  "plugins": ["@typescript-eslint"],
  "extends": [
    "eslint:recommended",
    "plugin:@typescript-eslint/recommended",
    "plugin:@typescript-eslint/recommended-requiring-type-checking",
    "plugin:@typescript-eslint/strict",
    "prettier"
  ],
  "rules": {
    "@typescript-eslint/no-explicit-any": "error",
    "@typescript-eslint/explicit-function-return-type": [
      "warn",
      {
        "allowExpressions": true,
        "allowTypedFunctionExpressions": true
      }
    ],
    "@typescript-eslint/no-unused-vars": [
      "error",
      {
        "argsIgnorePattern": "^_",
        "varsIgnorePattern": "^_"
      }
    ],
    "@typescript-eslint/consistent-type-imports": [
      "error",
      {
        "prefer": "type-imports",
        "fixStyle": "inline-type-imports"
      }
    ],
    "@typescript-eslint/no-non-null-assertion": "error",
    "@typescript-eslint/prefer-nullish-coalescing": "warn",
    "@typescript-eslint/prefer-optional-chain": "warn",
    "@typescript-eslint/strict-boolean-expressions": "warn",
    "@typescript-eslint/no-floating-promises": "error",
    "@typescript-eslint/no-misused-promises": "error",
    "@typescript-eslint/await-thenable": "error"
  }
}
```

## Code Organization

### File Structure

```
src/
├── types/              # Shared type definitions
│   ├── index.ts
│   ├── user.ts
│   ├── api.ts
│   └── utils.ts
├── utils/              # Utility functions
│   ├── guards.ts       # Type guards
│   ├── validators.ts   # Validation functions
│   └── helpers.ts      # Helper functions
├── features/           # Feature modules
│   ├── auth/
│   │   ├── types.ts
│   │   ├── guards.ts
│   │   └── index.ts
│   └── users/
└── index.ts
```

### Type Definition Files

```typescript
// types/user.ts
export interface User {
  id: string
  name: string
  email: string
  role: UserRole
  createdAt: Date
}

export type UserRole = "admin" | "user" | "guest"

export type UserPublic = Omit<User, "email">

export type CreateUserInput = Omit<User, "id" | "createdAt">

export type UpdateUserInput = Partial<CreateUserInput>
```

### Type Guards File

```typescript
// utils/guards.ts
import type { User, UserRole } from "../types/user"

export function isUser(value: unknown): value is User {
  return (
    typeof value === "object" &&
    value !== null &&
    "id" in value &&
    typeof (value as User).id === "string" &&
    "name" in value &&
    typeof (value as User).name === "string" &&
    "email" in value &&
    typeof (value as User).email === "string" &&
    "role" in value &&
    isUserRole((value as User).role) &&
    "createdAt" in value &&
    (value as User).createdAt instanceof Date
  )
}

export function isUserRole(value: unknown): value is UserRole {
  return value === "admin" || value === "user" || value === "guest"
}
```

## Testing Patterns

### Type-Safe Tests with Vitest

```typescript
import { describe, it, expect, expectTypeOf } from "vitest"
import { createUser, type User } from "./user"

describe("User functions", () => {
  it("should create a user with correct types", () => {
    const input = {
      name: "John Doe",
      email: "john@example.com",
      role: "user" as const,
    }

    const user = createUser(input)

    // Runtime assertions
    expect(user).toHaveProperty("id")
    expect(user.name).toBe("John Doe")
    expect(user.email).toBe("john@example.com")
    expect(user.role).toBe("user")

    // Type assertions
    expectTypeOf(user).toMatchTypeOf<User>()
    expectTypeOf(user.id).toBeString()
    expectTypeOf(user.name).toBeString()
    expectTypeOf(user.email).toBeString()
    expectTypeOf(user.role).toEqualTypeOf<"admin" | "user" | "guest">()
  })

  it("should validate user with type guard", () => {
    const validData = {
      id: "1",
      name: "John",
      email: "john@example.com",
      role: "user",
      createdAt: new Date(),
    }

    const invalidData = {
      id: "1",
      name: "John",
      // missing email
    }

    expect(isUser(validData)).toBe(true)
    expect(isUser(invalidData)).toBe(false)

    if (isUser(validData)) {
      expectTypeOf(validData).toMatchTypeOf<User>()
    }
  })
})
```

## Common Patterns

### API Response Handling

```typescript
type ApiResponse<T> =
  | { success: true; data: T }
  | { success: false; error: string; code?: number }

async function fetchData<T>(
  url: string,
  validator: (data: unknown) => data is T
): Promise<ApiResponse<T>> {
  try {
    const response = await fetch(url)

    if (!response.ok) {
      return {
        success: false,
        error: `HTTP ${response.status}: ${response.statusText}`,
        code: response.status,
      }
    }

    const data: unknown = await response.json()

    if (validator(data)) {
      return { success: true, data }
    }

    return {
      success: false,
      error: "Invalid response format",
    }
  } catch (error) {
    return {
      success: false,
      error: error instanceof Error ? error.message : String(error),
    }
  }
}

// Usage
const response = await fetchData("/api/users", isUserArray)

if (response.success) {
  console.log(response.data) // Type: User[]
} else {
  console.error(response.error) // Type: string
}
```

### Form Validation

```typescript
type ValidationError = {
  field: string
  message: string
}

type ValidationResult<T> =
  | { valid: true; data: T }
  | { valid: false; errors: ValidationError[] }

type ValidationRule<T> = (data: T) => ValidationError | null

function validate<T>(
  data: unknown,
  schema: (data: unknown) => data is T,
  rules: ValidationRule<T>[]
): ValidationResult<T> {
  if (!schema(data)) {
    return {
      valid: false,
      errors: [{ field: "root", message: "Invalid data structure" }],
    }
  }

  const errors = rules
    .map((rule) => rule(data))
    .filter((error): error is ValidationError => error !== null)

  if (errors.length > 0) {
    return { valid: false, errors }
  }

  return { valid: true, data }
}

// Usage
const userRules: ValidationRule<User>[] = [
  (user) =>
    user.name.length < 2
      ? { field: "name", message: "Name must be at least 2 characters" }
      : null,
  (user) =>
    !user.email.includes("@")
      ? { field: "email", message: "Invalid email format" }
      : null,
]

const result = validate(inputData, isUser, userRules)

if (result.valid) {
  console.log("Valid user:", result.data)
} else {
  console.error("Validation errors:", result.errors)
}
```

### Builder Pattern

```typescript
class UserBuilder {
  private user: Partial<User> = {}

  setName(name: string): this {
    this.user.name = name
    return this
  }

  setEmail(email: string): this {
    this.user.email = email
    return this
  }

  setRole(role: UserRole): this {
    this.user.role = role
    return this
  }

  build(): User {
    if (!this.user.name || !this.user.email || !this.user.role) {
      throw new Error("Missing required fields")
    }

    return {
      id: crypto.randomUUID(),
      name: this.user.name,
      email: this.user.email,
      role: this.user.role,
      createdAt: new Date(),
    }
  }
}

// Usage
const user = new UserBuilder()
  .setName("John Doe")
  .setEmail("john@example.com")
  .setRole("user")
  .build()
```

## Best Practices Checklist

- [ ] `strict: true` enabled in tsconfig.json
- [ ] All additional strict flags enabled
- [ ] No `any` types in codebase
- [ ] Explicit return types for all public/exported functions
- [ ] Type guards for all runtime type checking
- [ ] Discriminated unions for complex state
- [ ] Utility types used where appropriate
- [ ] Optional chaining (`?.`) and nullish coalescing (`??`) used
- [ ] Type imports (`import type`) used where possible
- [ ] Const assertions (`as const`) for literal types
- [ ] No type assertions without validation
- [ ] ESLint with TypeScript rules configured
- [ ] All compiler warnings addressed
- [ ] Tests include type assertions
- [ ] Documentation includes type information

## Resources

- [TypeScript Handbook](https://www.typescriptlang.org/docs/handbook/intro.html)
- [TypeScript Deep Dive](https://basarat.gitbook.io/typescript/)
- [Type Challenges](https://github.com/type-challenges/type-challenges)
- [Total TypeScript](https://www.totaltypescript.com/)
- [TypeScript ESLint](https://typescript-eslint.io/)
- [Effective TypeScript](https://effectivetypescript.com/)

---

*These guidelines ensure type safety, maintainability, and follow TypeScript best practices for production applications.*
