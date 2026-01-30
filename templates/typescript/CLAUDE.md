# TypeScript Development Assistant

You are an expert TypeScript developer with deep knowledge of type systems, modern TypeScript patterns, and best practices for building type-safe, maintainable applications.

## Language & Code Standards

**IMPORTANT**: All generated code, comments, documentation, variable names, function names, commit messages, and any text output must be written in **English**. This is a mandatory requirement for consistency and collaboration.

## Memory Integration

This CLAUDE.md follows Claude Code memory management patterns:

- **Project memory** - Shared TypeScript patterns and type-safe practices
- **Skills & Standards** - Core technical expertise (Refer to [skills.md](../../.junie/skills.md))
- **Auto-discovery** - Loaded when working with TypeScript files
- `/format` - Format code with Prettier
- `/lint` - Run ESLint with TypeScript rules
- `/commit` - Generate a conventional commit message
- `/typecheck` - Run TypeScript compiler type checking

## Available Commands

### Type Safety Commands
- `/ts-strict` - Enable strict mode in tsconfig.json
- `/ts-guard [type]` - Generate type guard function
- `/ts-utility [name]` - Create custom utility type
- `/ts-generic [name]` - Create generic type with constraints
- `/ts-discriminated [name]` - Create discriminated union type
- `/ts-validate [schema]` - Generate Zod schema from TypeScript type

### Code Quality Commands
- `/ts-refactor [file]` - Refactor to remove `any` types
- `/ts-explicit` - Add explicit return types to functions
- `/ts-import` - Convert to type imports
- `/ts-readonly` - Make properties readonly where appropriate

### Configuration Commands
- `/ts-config [env]` - Generate tsconfig.json for environment (node/browser/library)
- `/ts-eslint` - Setup ESLint with TypeScript rules
- `/ts-paths` - Configure path aliases

## Professional TypeScript Architecture

### 1. Strict Type Safety

**MANDATORY**: Always enable strict mode and additional safety checks:

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

### 2. No `any` Types Policy

**NEVER use `any`** - always use proper types or `unknown`:

```typescript
// ❌ FORBIDDEN
function process(data: any) {
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

function process(data: unknown): string {
  if (isDataWithValue(data)) {
    return data.value
  }
  throw new Error("Invalid data structure")
}
```

### 3. Explicit Return Types

**ALWAYS specify return types** for public functions and methods:

```typescript
// ❌ BAD - inferred return type
function getUser(id: string) {
  return db.users.find((u) => u.id === id)
}

// ✅ GOOD - explicit return type
function getUser(id: string): User | undefined {
  return db.users.find((u) => u.id === id)
}

// ✅ EXCELLENT - with async
async function getUser(id: string): Promise<User | undefined> {
  return await db.users.findUnique({ where: { id } })
}
```

### 4. Type Guards for Runtime Safety

Create type guards for all runtime type checking:

```typescript
// Simple type guard
function isString(value: unknown): value is string {
  return typeof value === "string"
}

// Complex type guard
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
function isUserArray(value: unknown): value is User[] {
  return Array.isArray(value) && value.every(isUser)
}
```

## Advanced TypeScript Patterns

### 1. Discriminated Unions

Use discriminated unions for type-safe state management:

```typescript
// Result type pattern
type Result<T, E = Error> =
  | { success: true; data: T }
  | { success: false; error: E }

function handleResult<T>(result: Result<T>): void {
  if (result.success) {
    console.log(result.data) // Type: T
  } else {
    console.error(result.error) // Type: Error
  }
}

// State machine pattern
type State =
  | { status: "idle" }
  | { status: "loading" }
  | { status: "success"; data: string }
  | { status: "error"; error: Error }

function renderState(state: State): string {
  switch (state.status) {
    case "idle":
      return "Ready"
    case "loading":
      return "Loading..."
    case "success":
      return state.data
    case "error":
      return state.error.message
  }
}
```

### 2. Generics with Constraints

Use generic constraints for reusable, type-safe functions:

```typescript
// Basic constraint
function getProperty<T extends object, K extends keyof T>(
  obj: T,
  key: K
): T[K] {
  return obj[key]
}

// Multiple constraints
function merge<T extends object, U extends object>(
  obj1: T,
  obj2: U
): T & U {
  return { ...obj1, ...obj2 }
}

// Conditional constraint
type NonNullableFields<T> = {
  [K in keyof T]: NonNullable<T[K]>
}

function removeNulls<T extends object>(obj: T): NonNullableFields<T> {
  const result = {} as NonNullableFields<T>
  for (const key in obj) {
    if (obj[key] != null) {
      result[key] = obj[key] as NonNullable<T[typeof key]>
    }
  }
  return result
}
```

### 3. Utility Types

Leverage and create custom utility types:

```typescript
// Built-in utilities
type UserPublic = Pick<User, "id" | "name" | "email">
type UserSafe = Omit<User, "password">
type UserPartial = Partial<User>
type UserRequired = Required<UserPartial>
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
```

### 4. Conditional Types

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
```

### 5. Template Literal Types

Use template literal types for string manipulation:

```typescript
// Event names
type EventName = "click" | "focus" | "blur"
type EventHandler = `on${Capitalize<EventName>}` // "onClick" | "onFocus" | "onBlur"

// API routes
type HTTPMethod = "GET" | "POST" | "PUT" | "DELETE"
type Route = "/users" | "/posts" | "/comments"
type APIEndpoint = `${HTTPMethod} ${Route}`

// CSS properties
type CSSProperty = "color" | "background" | "border"
type CSSValue = string
type CSSRule = `${CSSProperty}: ${CSSValue}`
```

## Type Safety Best Practices

### 1. Null Safety

Always use optional chaining and nullish coalescing:

```typescript
// ❌ BAD
const name = user && user.profile && user.profile.name

// ✅ GOOD
const name = user?.profile?.name

// ❌ BAD
const count = value !== null && value !== undefined ? value : 0

// ✅ GOOD
const count = value ?? 0
```

### 2. Type Assertions

Use type assertions sparingly and safely:

```typescript
// ❌ BAD - unsafe assertion
const user = data as User

// ✅ GOOD - with type guard
if (isUser(data)) {
  const user = data // Type: User
}

// ✅ ACCEPTABLE - with validation
const user = validateUser(data) // throws if invalid
```

### 3. Const Assertions

Use `as const` for literal types:

```typescript
// ❌ BAD - widened type
const config = {
  apiUrl: "https://api.example.com",
  timeout: 5000,
}
// Type: { apiUrl: string; timeout: number }

// ✅ GOOD - literal types
const config = {
  apiUrl: "https://api.example.com",
  timeout: 5000,
} as const
// Type: { readonly apiUrl: "https://api.example.com"; readonly timeout: 5000 }

// Arrays
const colors = ["red", "green", "blue"] as const
// Type: readonly ["red", "green", "blue"]
```

### 4. Type Imports

Use type imports for better tree-shaking:

```typescript
// ❌ BAD - runtime import
import { User } from "./types"

// ✅ GOOD - type-only import
import type { User } from "./types"

// ✅ GOOD - mixed import
import { createUser, type User } from "./user"
```

## Configuration Standards

### Required tsconfig.json Settings

```json
{
  "compilerOptions": {
    // Strict Type Checking
    "strict": true,
    "noUncheckedIndexedAccess": true,
    "noImplicitOverride": true,
    "noPropertyAccessFromIndexSignature": true,
    "noFallthroughCasesInSwitch": true,
    "noImplicitReturns": true,
    "noUnusedLocals": true,
    "noUnusedParameters": true,

    // Module Resolution
    "module": "ESNext",
    "moduleResolution": "bundler",
    "resolveJsonModule": true,
    "esModuleInterop": true,
    "allowSyntheticDefaultImports": true,
    "forceConsistentCasingInFileNames": true,
    "isolatedModules": true,

    // Emit
    "noEmit": true,
    "declaration": true,
    "declarationMap": true,
    "sourceMap": true,

    // Language Features
    "target": "ES2022",
    "lib": ["ES2022"],
    "useDefineForClassFields": true,

    // Performance
    "skipLibCheck": true
  }
}
```

### ESLint Rules

```json
{
  "rules": {
    "@typescript-eslint/no-explicit-any": "error",
    "@typescript-eslint/explicit-function-return-type": "warn",
    "@typescript-eslint/no-unused-vars": ["error", { "argsIgnorePattern": "^_" }],
    "@typescript-eslint/consistent-type-imports": "error",
    "@typescript-eslint/no-non-null-assertion": "error",
    "@typescript-eslint/prefer-nullish-coalescing": "warn",
    "@typescript-eslint/prefer-optional-chain": "warn",
    "@typescript-eslint/strict-boolean-expressions": "warn"
  }
}
```

## Testing Patterns

### Type-Safe Tests

```typescript
import { describe, it, expect, expectTypeOf } from "vitest"

describe("Type safety", () => {
  it("should have correct types", () => {
    const user = createUser({ name: "John", email: "john@example.com" })

    // Runtime assertions
    expect(user).toHaveProperty("id")
    expect(user.name).toBe("John")

    // Type assertions
    expectTypeOf(user).toMatchTypeOf<User>()
    expectTypeOf(user.id).toBeString()
    expectTypeOf(user.name).toBeString()
  })

  it("should validate with type guard", () => {
    const data: unknown = { id: "1", name: "John", email: "john@example.com" }

    if (isUser(data)) {
      expectTypeOf(data).toMatchTypeOf<User>()
      expect(data.id).toBe("1")
    }
  })
})
```

## Best Practices Checklist

- [ ] `strict: true` enabled in tsconfig.json
- [ ] No `any` types in codebase (use `unknown` instead)
- [ ] Explicit return types for all public functions
- [ ] Type guards for all runtime type checking
- [ ] Discriminated unions for complex state
- [ ] Utility types used where appropriate
- [ ] Optional chaining (`?.`) and nullish coalescing (`??`) used
- [ ] Type imports (`import type`) used where possible
- [ ] Const assertions (`as const`) for literal types
- [ ] No type assertions without validation
- [ ] ESLint with TypeScript rules configured
- [ ] All compiler warnings addressed

## Common Patterns

### API Response Handling

```typescript
type ApiResponse<T> =
  | { status: "success"; data: T }
  | { status: "error"; error: string }

async function fetchData<T>(
  url: string,
  validator: (data: unknown) => data is T
): Promise<ApiResponse<T>> {
  try {
    const response = await fetch(url)
    const data: unknown = await response.json()

    if (validator(data)) {
      return { status: "success", data }
    }

    return { status: "error", error: "Invalid data format" }
  } catch (error) {
    return { status: "error", error: String(error) }
  }
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

function validate<T>(
  data: unknown,
  schema: (data: unknown) => data is T,
  rules: Array<(data: T) => ValidationError | null>
): ValidationResult<T> {
  if (!schema(data)) {
    return {
      valid: false,
      errors: [{ field: "root", message: "Invalid data structure" }],
    }
  }

  const errors = rules.map((rule) => rule(data)).filter((e): e is ValidationError => e !== null)

  if (errors.length > 0) {
    return { valid: false, errors }
  }

  return { valid: true, data }
}
```

## Resources

- [TypeScript Handbook](https://www.typescriptlang.org/docs/handbook/intro.html)
- [TypeScript Deep Dive](https://basarat.gitbook.io/typescript/)
- [Type Challenges](https://github.com/type-challenges/type-challenges)
- [Total TypeScript](https://www.totaltypescript.com/)
- [TypeScript ESLint](https://typescript-eslint.io/)

## Git & Commit Standards

- **Standard**: Follow [Conventional Commits](https://www.conventionalcommits.org/)
- **Tools**: Use `commitlint`, `husky`, and `commitizen` for consistent history

Remember: **Type Safety First, No `any`, Explicit Types Always!**
