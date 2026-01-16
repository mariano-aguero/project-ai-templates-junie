# AI Assistant Behavioral Guidelines

This document establishes the behavioral rules, workflow standards, and decision-making processes for AI assistants working on this project. These guidelines complement the technical capabilities defined in `skills.md`.

---

## 🎯 Core Principles

### 1. Template-First Approach

**MANDATORY RULE**: Before proposing or writing any new code, you MUST:

1. **Search the `templates/` directory first** to check if a relevant template, pattern, or configuration already exists.
2. **Reference existing templates** when they match the task requirements.
3. **Reuse and adapt** existing code patterns rather than creating new ones from scratch.
4. **Only create new code** when no suitable template exists or when explicitly requested.

### How to Navigate Templates

The `templates/` directory is organized by domain:

```
templates/
├── README.md                    # Overview of all templates
├── audit/                       # Smart contract security auditing
│   ├── README.md
│   ├── CLAUDE.md
│   ├── guidelines.md
│   └── package.json
├── database/                    # Database and data layer
│   ├── README.md
│   ├── CLAUDE.md
│   ├── guidelines.md
│   └── package.json
├── nextjs/                      # Next.js applications
│   ├── README.md
│   ├── CLAUDE.md
│   ├── guidelines.md
│   └── package.json
├── ui/
│   ├── shadcn/                  # shadcn/ui components
│   │   ├── README.md
│   │   ├── CLAUDE.md
│   │   ├── guidelines.md
│   │   └── package.json
│   └── tailwindcss/             # Tailwind CSS styling
│       ├── README.md
│       ├── CLAUDE.md
│       ├── guidelines.md
│       └── package.json
└── web3/                        # Web3 and smart contracts
    ├── README.md
    ├── CLAUDE.md
    ├── guidelines.md
    └── package.json
```

**Template Selection Process**:

1. **Identify the domain** of the task (e.g., UI, Web3, Database, Next.js).
2. **Open the relevant template's `README.md`** to understand its scope and capabilities.
3. **Review the `guidelines.md`** for domain-specific best practices and patterns.
4. **Check `package.json`** for available dependencies and scripts.
5. **Apply the template's patterns** to your implementation.

**Example Workflow**:
- Task: "Create a Web3 wallet connection component"
- Action: First check `templates/web3/guidelines.md` for Wagmi/AppKit patterns
- Action: Review `templates/ui/shadcn/guidelines.md` for UI component structure
- Action: Combine patterns from both templates in your implementation

---

## 📦 Package Management

### pnpm is Mandatory

**RULE**: Always use `pnpm` for dependency management. Never use `npm` or `yarn`.

**Commands**:
```bash
# Install dependencies
pnpm install

# Add a dependency
pnpm add <package-name>

# Add a dev dependency
pnpm add -D <package-name>

# Remove a dependency
pnpm remove <package-name>

# Run scripts
pnpm <script-name>
```

**Rationale**: Consistency across the project and all templates. pnpm provides fast, disk-efficient installs and excellent workspace support.

---

## 🎨 Code Formatting Standards

### Prettier Configuration

All code MUST follow the Prettier configuration defined in `.prettierrc`:

```json
{
  "semi": false,
  "singleQuote": false,
  "tabWidth": 2,
  "trailingComma": "es5",
  "printWidth": 80,
  "bracketSpacing": true,
  "arrowParens": "always"
}
```

**Key Rules**:
- ❌ **No semicolons** at the end of statements
- ✅ **Double quotes** for strings (not single quotes)
- ✅ **2 spaces** for indentation (never tabs)
- ✅ **80 characters** maximum line width
- ✅ **ES5 trailing commas** (in objects, arrays, etc.)
- ✅ **Spaces inside brackets** `{ foo: bar }`
- ✅ **Parentheses around arrow function parameters** `(x) => x * 2`

**Enforcement**:
- Run `pnpm format` or `prettier --write .` before committing
- Configure your IDE to format on save using this Prettier config
- All code must pass Prettier checks in CI/CD

---

## 🔍 Code Quality Standards

### ESLint Integration

- **Use ESLint** for code quality and logic rules
- **Use Prettier** for formatting and style
- **Install `eslint-config-prettier`** to prevent conflicts between ESLint and Prettier
- All ESLint errors must be resolved before committing

### TypeScript Standards

- **Strict mode enabled**: `strict: true` in `tsconfig.json`
- **No `any` types**: Use `unknown` and type guards instead
- **Explicit return types** for public functions
- **Null safety**: Use optional chaining (`?.`) and nullish coalescing (`??`)

---

## 🌐 Language Standards

**MANDATORY**: All code, comments, documentation, variable names, function names, commit messages, and any text output MUST be written in **English**.

This is non-negotiable for:
- Consistency across the codebase
- International collaboration
- Maintainability and readability

---

## 📝 Git & Commit Standards

### Conventional Commits

**MANDATORY**: All commits MUST follow the [Conventional Commits](https://www.conventionalcommits.org/) specification.

**Format**:
```
<type>(<scope>): <description>

[optional body]

[optional footer]
```

**Types**:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, missing semicolons, etc.)
- `refactor`: Code refactoring without changing functionality
- `perf`: Performance improvements
- `test`: Adding or updating tests
- `chore`: Maintenance tasks (dependencies, build config, etc.)
- `ci`: CI/CD changes
- `build`: Build system changes

**Examples**:
```bash
feat(web3): add wallet connection with AppKit
fix(ui): resolve button hover state in dark mode
docs(readme): update installation instructions
refactor(database): optimize Prisma query performance
```

**Tooling**:
- Use **commitlint** to enforce rules
- Use **husky** for git hooks
- Use **commitizen** for interactive commit creation

### Atomic Commits

- Each commit should represent a **single, logical change**
- Don't mix unrelated changes in one commit
- Commit frequently with meaningful messages

---

## 🏗️ Project Structure Standards

### Feature-Based Architecture

Organize code by business domain, not by technical layer:

```
src/features/[feature-name]/
├── components/     # Feature-specific UI components
├── actions.ts      # Server Actions (using next-safe-action)
├── queries.ts      # Data fetching logic
├── hooks.ts        # Feature-specific React hooks
├── types.ts        # Domain-specific TypeScript interfaces
└── api.ts          # API route handlers (if needed)
```

**Benefits**:
- High cohesion within features
- Easy to locate and modify related code
- Clear boundaries between domains

---

## 🛡️ Security Standards

### Input Validation

**MANDATORY**: Every Server Action and API Route MUST validate input using **Zod** schemas.

**Example**:
```typescript
import { z } from "zod"

const createUserSchema = z.object({
  email: z.string().email(),
  name: z.string().min(2).max(100),
  age: z.number().int().positive().optional(),
})

// Use with next-safe-action
export const createUserAction = action(createUserSchema, async (input) => {
  // input is fully typed and validated
})
```

### Environment Variables

- Use **Zod-validated `env.ts`** to ensure config integrity at runtime
- Never commit `.env` files
- Document all required environment variables in `.env.example`

---

## ✅ Pre-Commit Checklist

Before submitting any code, verify:

- [ ] Searched `templates/` for existing patterns
- [ ] Used `pnpm` for all package management
- [ ] Code follows Prettier configuration (`.prettierrc`)
- [ ] All ESLint errors resolved
- [ ] TypeScript strict mode enabled and no errors
- [ ] All code and comments in English
- [ ] Commit message follows Conventional Commits
- [ ] Input validation with Zod for all Server Actions/API Routes
- [ ] Feature-based architecture followed
- [ ] No sensitive data or credentials in code

---

## 🤝 Workflow Guidelines

### When Starting a New Task

1. **Read the issue/task description carefully**
2. **Check `templates/` for relevant patterns**
3. **Review the appropriate template's `guidelines.md`**
4. **Plan your approach** before writing code
5. **Ask for clarification** if requirements are unclear

### When Writing Code

1. **Follow the template patterns** from `templates/`
2. **Apply Prettier formatting** (`.prettierrc`)
3. **Validate with TypeScript** (strict mode)
4. **Add appropriate error handling**
5. **Write clear, English comments** only when necessary

### When Completing a Task

1. **Run linters and formatters** (`pnpm lint`, `pnpm format`)
2. **Test your changes** (manual or automated)
3. **Review your code** against the checklist
4. **Write a Conventional Commit message**
5. **Document any new patterns** if they don't exist in templates

---

## 📚 Additional Resources

- **Technical Capabilities**: See [skills.md](./skills.md)
- **Template Documentation**: See [../templates/README.md](../templates/README.md)
- **Project Overview**: See [../README.md](../README.md)

---

*These guidelines ensure consistency, quality, and maintainability across all AI-assisted development in this project.*
