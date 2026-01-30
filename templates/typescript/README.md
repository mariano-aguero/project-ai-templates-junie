# TypeScript Best Practices Template

A comprehensive template for building production-ready TypeScript applications with best practices, type safety, and modern development patterns.

## ✨ Features

This template provides:

- **Type Safety Best Practices** - Strict mode, no `any`, proper type guards
- **Modern TypeScript Patterns** - Generics, utility types, conditional types
- **Code Quality Standards** - ESLint, Prettier, and strict compiler options
- **Testing Patterns** - Type-safe testing with Vitest/Jest
- **Build Configuration** - Optimized tsconfig.json for different environments

## 📦 Installation

1. Copy the TypeScript configuration to your project:

```bash
cp -r templates/typescript/tsconfig.json your-project/
cp templates/typescript/.eslintrc.json your-project/
```

2. Install dependencies:

```bash
pnpm add -D typescript @types/node
pnpm add -D eslint @typescript-eslint/parser @typescript-eslint/eslint-plugin
pnpm add -D prettier eslint-config-prettier
```

## 🎯 Core Principles

### 1. Strict Type Safety

**Always enable strict mode** in `tsconfig.json`:

```json
{
  "compilerOptions": {
    "strict": true,
    "noUncheckedIndexedAccess": true,
    "noImplicitOverride": true,
    "noPropertyAccessFromIndexSignature": true
  }
}
```

### 2. No `any` Types

**Never use `any`** - use proper types or `unknown`:

```typescript
// ❌ Bad
function process(data: any) {
  return data.value
}

// ✅ Good
function process(data: unknown) {
  if (typeof data === "object" && data !== null && "value" in data) {
    return (data as { value: unknown }).value
  }
  throw new Error("Invalid data")
}

// ✅ Better - with type guard
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

function process(data: unknown) {
  if (isDataWithValue(data)) {
    return data.value // Type-safe!
  }
  throw new Error("Invalid data")
}
```

### 3. Explicit Return Types

**Always specify return types** for public functions:

```typescript
// ❌ Bad - inferred return type
function getUser(id: string) {
  return db.users.find((u) => u.id === id)
}

// ✅ Good - explicit return type
function getUser(id: string): User | undefined {
  return db.users.find((u) => u.id === id)
}

// ✅ Better - with async
async function getUser(id: string): Promise<User | undefined> {
  return await db.users.findUnique({ where: { id } })
}
```

### 4. Null Safety

**Use optional chaining and nullish coalescing**:

```typescript
// ❌ Bad
const name = user && user.profile && user.profile.name

// ✅ Good
const name = user?.profile?.name

// ❌ Bad
const count = value !== null && value !== undefined ? value : 0

// ✅ Good
const count = value ?? 0
```

## 🏗️ TypeScript Patterns

### 1. Discriminated Unions

Use discriminated unions for type-safe state management:

```typescript
type Result<T, E = Error> =
  | { success: true; data: T }
  | { success: false; error: E }

function handleResult<T>(result: Result<T>) {
  if (result.success) {
    console.log(result.data) // Type: T
  } else {
    console.error(result.error) // Type: Error
  }
}
```

### 2. Generics with Constraints

Use generic constraints for reusable, type-safe functions:

```typescript
// ❌ Bad - too generic
function getProperty<T>(obj: T, key: string) {
  return obj[key] // Error: Element implicitly has an 'any' type
}

// ✅ Good - with constraints
function getProperty<T extends object, K extends keyof T>(
  obj: T,
  key: K
): T[K] {
  return obj[key] // Type-safe!
}

const user = { name: "John", age: 30 }
const name = getProperty(user, "name") // Type: string
const age = getProperty(user, "age") // Type: number
```

### 3. Utility Types

Leverage TypeScript's built-in utility types:

```typescript
interface User {
  id: string
  name: string
  email: string
  password: string
  createdAt: Date
}

// Pick specific properties
type UserPublic = Pick<User, "id" | "name" | "email">

// Omit sensitive properties
type UserSafe = Omit<User, "password">

// Make all properties optional
type UserPartial = Partial<User>

// Make all properties required
type UserRequired = Required<UserPartial>

// Make all properties readonly
type UserReadonly = Readonly<User>

// Extract specific keys
type UserKeys = keyof User // "id" | "name" | "email" | "password" | "createdAt"
```

### 4. Conditional Types

Create dynamic types based on conditions:

```typescript
// Extract return type of a function
type ReturnType<T> = T extends (...args: any[]) => infer R ? R : never

// Extract array element type
type ArrayElement<T> = T extends (infer E)[] ? E : never

// Make properties nullable
type Nullable<T> = {
  [K in keyof T]: T[K] | null
}

// Deep partial
type DeepPartial<T> = {
  [K in keyof T]?: T[K] extends object ? DeepPartial<T[K]> : T[K]
}
```

### 5. Type Guards

Create custom type guards for runtime type checking:

```typescript
// Simple type guard
function isString(value: unknown): value is string {
  return typeof value === "string"
}

// Object type guard
interface User {
  id: string
  name: string
}

function isUser(value: unknown): value is User {
  return (
    typeof value === "object" &&
    value !== null &&
    "id" in value &&
    typeof (value as User).id === "string" &&
    "name" in value &&
    typeof (value as User).name === "string"
  )
}

// Array type guard
function isStringArray(value: unknown): value is string[] {
  return Array.isArray(value) && value.every((item) => typeof item === "string")
}
```

## 🔧 Configuration

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

    // Interop
    "esModuleInterop": true,
    "allowSyntheticDefaultImports": true,
    "forceConsistentCasingInFileNames": true,
    "isolatedModules": true,

    // Language
    "target": "ES2022",
    "lib": ["ES2022"],
    "useDefineForClassFields": true,

    // Skip type checking of declaration files
    "skipLibCheck": true
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules", "dist", "build"]
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
    "prettier"
  ],
  "rules": {
    "@typescript-eslint/no-explicit-any": "error",
    "@typescript-eslint/explicit-function-return-type": "warn",
    "@typescript-eslint/no-unused-vars": [
      "error",
      { "argsIgnorePattern": "^_" }
    ],
    "@typescript-eslint/consistent-type-imports": "error"
  }
}
```

## 🧪 Testing Patterns

### Type-Safe Tests with Vitest

```typescript
import { describe, it, expect } from "vitest"

describe("User functions", () => {
  it("should create a user with correct types", () => {
    const user = createUser({ name: "John", email: "john@example.com" })

    // Type assertions
    expect(user).toHaveProperty("id")
    expect(user.name).toBe("John")
    expect(user.email).toBe("john@example.com")

    // Type guard in test
    if (isUser(user)) {
      expect(user.id).toBeTypeOf("string")
    }
  })
})
```

## 📚 Best Practices Checklist

- [ ] `strict: true` enabled in tsconfig.json
- [ ] No `any` types in codebase
- [ ] Explicit return types for all public functions
- [ ] Type guards for runtime type checking
- [ ] Utility types used where appropriate
- [ ] Discriminated unions for complex state
- [ ] Optional chaining (`?.`) and nullish coalescing (`??`) used
- [ ] ESLint with TypeScript rules configured
- [ ] All imports use type imports where possible
- [ ] No unused variables or parameters

## 🔗 Resources

- [TypeScript Handbook](https://www.typescriptlang.org/docs/handbook/intro.html)
- [TypeScript Deep Dive](https://basarat.gitbook.io/typescript/)
- [Type Challenges](https://github.com/type-challenges/type-challenges)
- [Total TypeScript](https://www.totaltypescript.com/)
- [TypeScript ESLint](https://typescript-eslint.io/)

## 📝 Common Patterns

### API Response Types

```typescript
type ApiResponse<T> =
  | { status: "success"; data: T }
  | { status: "error"; error: string }

async function fetchUser(id: string): Promise<ApiResponse<User>> {
  try {
    const response = await fetch(`/api/users/${id}`)
    const data = await response.json()
    return { status: "success", data }
  } catch (error) {
    return { status: "error", error: String(error) }
  }
}
```

### Form Validation Types

```typescript
type ValidationResult<T> =
  | { valid: true; data: T }
  | { valid: false; errors: Record<keyof T, string> }

function validateUser(input: unknown): ValidationResult<User> {
  const errors: Partial<Record<keyof User, string>> = {}

  if (!isUser(input)) {
    return { valid: false, errors: { id: "Invalid user data" } as any }
  }

  if (input.name.length < 2) {
    errors.name = "Name must be at least 2 characters"
  }

  if (!input.email.includes("@")) {
    errors.email = "Invalid email format"
  }

  if (Object.keys(errors).length > 0) {
    return { valid: false, errors: errors as Record<keyof User, string> }
  }

  return { valid: true, data: input }
}
```

---

*This template ensures type safety, maintainability, and follows TypeScript best practices for production applications.*
