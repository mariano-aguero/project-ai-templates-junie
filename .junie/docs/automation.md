# Automation Guide

This document covers the automation layer that enforces code quality regardless of whether code comes from humans or AI.

> **Key principle**: The AI can generate code, but it cannot break CI. The system enforces correctness.

---

## 🎯 Philosophy

```
┌─────────────────────────────────────────────────────────────┐
│                     QUALITY GATES                           │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│   Developer/AI  →  Pre-commit  →  CI/CD  →  Production     │
│                                                             │
│   Writes code      Local check    Full check   Deployed    │
│                    (fast)         (thorough)   (safe)      │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

**This creates a safety net**: Even if Junie generates suboptimal code, automated checks catch issues before they reach production.

---

## 🚀 Quick Setup Guide

### Automation Levels

This system offers 3 automation levels that you can implement progressively:

| Level | Name | What It Does | Setup Time | Where It Runs |
|-------|------|--------------|------------|---------------|
| **1** | Pre-commit Hooks | Validates code before commit | 10 min | Local |
| **2** | CI/CD Pipeline | Validates code on every push | 20 min | GitHub Actions |
| **3** | Prompt Generator | Generates prompts for Junie | 0 min | Already included |

### Level 1: Pre-commit Hooks (Recommended to Start)

**What it does**: Automatically formats and validates your code before each commit.

**Quick setup**:

```bash
# 1. In your project (not in this repo)
cd /path/to/your/project

# 2. Install dependencies
pnpm add -D husky lint-staged prettier eslint

# 3. Initialize husky
pnpm exec husky init

# 4. Create pre-commit hook
echo "pnpm lint-staged" > .husky/pre-commit

# 5. Configure lint-staged in package.json
```

Add to your `package.json`:
```json
{
  "lint-staged": {
    "*.{ts,tsx,js,jsx}": [
      "eslint --fix",
      "prettier --write"
    ],
    "*.{json,md,yml,yaml}": [
      "prettier --write"
    ]
  }
}
```

**Result**: Each commit automatically:
- ✅ Formats code with Prettier
- ✅ Fixes ESLint errors
- ✅ Blocks commit if there are critical errors

### Level 2: CI/CD with GitHub Actions

**What it does**: Validates code on every push and pull request.

**Quick setup**:

```bash
# 1. Create directory for workflows
mkdir -p .github/workflows

# 2. Create CI file
# See "GitHub Actions CI/CD" section below for complete content
```

**Result**: Each push automatically:
- ✅ Runs linter
- ✅ Verifies TypeScript types
- ✅ Executes tests
- ✅ Blocks merge if something fails

### Level 3: Prompt Generator (Already Included)

**What it does**: Generates custom prompts for Junie based on templates.

**Usage**:

```bash
# Copy script to your project
cp scripts/generate-prompt.sh /path/to/your/project/scripts/
chmod +x /path/to/your/project/scripts/generate-prompt.sh

# Use interactive mode
./scripts/generate-prompt.sh

# Or direct mode
./scripts/generate-prompt.sh feature wallet-connection web3
```

See [`../../scripts/README.md`](../../scripts/README.md) for complete documentation.

---

## 🛠️ Required Tooling

### Core Dependencies

```bash
pnpm add -D \
  typescript \
  eslint \
  prettier \
  husky \
  lint-staged \
  vitest \
  @types/node
```

### package.json Scripts

```json
{
  "scripts": {
    "dev": "next dev",
    "build": "next build",
    "start": "next start",
    "lint": "eslint . --ext .ts,.tsx",
    "lint:fix": "eslint . --ext .ts,.tsx --fix",
    "format": "prettier --write .",
    "format:check": "prettier --check .",
    "typecheck": "tsc --noEmit",
    "test": "vitest run",
    "test:watch": "vitest",
    "test:coverage": "vitest run --coverage",
    "validate": "pnpm lint && pnpm format:check && pnpm typecheck && pnpm test",
    "prepare": "husky"
  }
}
```

---

## 🪝 Pre-commit Hooks (Husky + lint-staged)

### Setup

```bash
# Initialize husky
pnpm exec husky init

# Create pre-commit hook
echo "pnpm lint-staged" > .husky/pre-commit
```

### lint-staged Configuration

Add to `package.json`:

```json
{
  "lint-staged": {
    "*.{ts,tsx}": [
      "eslint --fix",
      "prettier --write"
    ],
    "*.{json,md,yml,yaml}": [
      "prettier --write"
    ],
    "*.sol": [
      "forge fmt"
    ]
  }
}
```

### What This Does

On every commit:
1. **ESLint** fixes auto-fixable issues
2. **Prettier** formats code
3. Commit **only proceeds** if all checks pass

---

## 🔄 GitHub Actions CI/CD

### Basic CI Pipeline

Create `.github/workflows/ci.yml`:

```yaml
name: CI

on:
  pull_request:
  push:
    branches: [main, develop]

concurrency:
  group: ${{ github.workflow }}-${{ github.ref }}
  cancel-in-progress: true

jobs:
  validate:
    name: Validate
    runs-on: ubuntu-latest
    
    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Setup pnpm
        uses: pnpm/action-setup@v4
        with:
          version: 9

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: 20
          cache: "pnpm"

      - name: Install dependencies
        run: pnpm install --frozen-lockfile

      - name: Lint
        run: pnpm lint

      - name: Format check
        run: pnpm format:check

      - name: Type check
        run: pnpm typecheck

      - name: Test
        run: pnpm test

      - name: Build
        run: pnpm build
```

### Web3 CI Pipeline (with Foundry)

Create `.github/workflows/contracts.yml`:

```yaml
name: Contracts CI

on:
  pull_request:
    paths:
      - "contracts/**"
      - "foundry.toml"
  push:
    branches: [main]
    paths:
      - "contracts/**"
      - "foundry.toml"

jobs:
  test:
    name: Foundry Tests
    runs-on: ubuntu-latest
    
    steps:
      - name: Checkout
        uses: actions/checkout@v4
        with:
          submodules: recursive

      - name: Install Foundry
        uses: foundry-rs/foundry-toolchain@v1
        with:
          version: nightly

      - name: Run Forge build
        run: forge build
        working-directory: ./contracts

      - name: Run Forge tests
        run: forge test -vvv
        working-directory: ./contracts

      - name: Run Forge coverage
        run: forge coverage --report summary
        working-directory: ./contracts

      - name: Run Slither
        uses: crytic/slither-action@v0.4.0
        with:
          target: "./contracts"
          fail-on: medium
```

---

## 📋 ESLint Configuration

Create `eslint.config.mjs` (flat config):

```javascript
import js from "@eslint/js"
import typescript from "@typescript-eslint/eslint-plugin"
import typescriptParser from "@typescript-eslint/parser"
import react from "eslint-plugin-react"
import reactHooks from "eslint-plugin-react-hooks"
import prettier from "eslint-config-prettier"

export default [
  js.configs.recommended,
  {
    files: ["**/*.{ts,tsx}"],
    languageOptions: {
      parser: typescriptParser,
      parserOptions: {
        ecmaVersion: "latest",
        sourceType: "module",
        ecmaFeatures: { jsx: true },
      },
    },
    plugins: {
      "@typescript-eslint": typescript,
      react,
      "react-hooks": reactHooks,
    },
    rules: {
      // TypeScript
      "@typescript-eslint/no-explicit-any": "error",
      "@typescript-eslint/explicit-function-return-type": "warn",
      "@typescript-eslint/no-unused-vars": ["error", { argsIgnorePattern: "^_" }],
      
      // React
      "react/react-in-jsx-scope": "off",
      "react-hooks/rules-of-hooks": "error",
      "react-hooks/exhaustive-deps": "warn",
      
      // General
      "no-console": ["warn", { allow: ["warn", "error"] }],
      "prefer-const": "error",
    },
  },
  prettier, // Must be last to override other configs
]
```

---

## 🎨 Prettier Configuration

Create `.prettierrc`:

```json
{
  "semi": false,
  "singleQuote": false,
  "tabWidth": 2,
  "trailingComma": "es5",
  "printWidth": 80,
  "bracketSpacing": true,
  "arrowParens": "always",
  "plugins": ["prettier-plugin-tailwindcss"]
}
```

Create `.prettierignore`:

```
node_modules
.next
dist
build
coverage
*.min.js
pnpm-lock.yaml
```

---

## 📝 TypeScript Configuration

Ensure `tsconfig.json` has strict mode:

```json
{
  "compilerOptions": {
    "strict": true,
    "noEmit": true,
    "esModuleInterop": true,
    "module": "esnext",
    "moduleResolution": "bundler",
    "resolveJsonModule": true,
    "isolatedModules": true,
    "jsx": "preserve",
    "incremental": true,
    "skipLibCheck": true,
    "paths": {
      "@/*": ["./src/*"]
    }
  },
  "include": ["next-env.d.ts", "**/*.ts", "**/*.tsx"],
  "exclude": ["node_modules"]
}
```

---

## 🧪 Vitest Configuration

Create `vitest.config.ts`:

```typescript
import { defineConfig } from "vitest/config"
import react from "@vitejs/plugin-react"
import path from "path"

export default defineConfig({
  plugins: [react()],
  test: {
    environment: "jsdom",
    globals: true,
    setupFiles: ["./src/test/setup.ts"],
    coverage: {
      provider: "v8",
      reporter: ["text", "json", "html"],
      exclude: [
        "node_modules/",
        "src/test/",
        "**/*.d.ts",
        "**/*.config.*",
      ],
    },
  },
  resolve: {
    alias: {
      "@": path.resolve(__dirname, "./src"),
    },
  },
})
```

---

## 📊 Quality Gates Summary

| Gate | Tool | When | Blocks |
|------|------|------|--------|
| Format | Prettier | Pre-commit | Commit |
| Lint | ESLint | Pre-commit + CI | Commit + PR |
| Types | TypeScript | CI | PR |
| Tests | Vitest | CI | PR |
| Build | Next.js | CI | PR |
| Security | Slither | CI (contracts) | PR |

---

## 🚀 Quick Setup Script

Create `scripts/setup-automation.sh`:

```bash
#!/bin/bash
set -e

echo "🔧 Setting up automation..."

# Install dependencies
pnpm add -D \
  typescript \
  eslint \
  @eslint/js \
  @typescript-eslint/eslint-plugin \
  @typescript-eslint/parser \
  eslint-plugin-react \
  eslint-plugin-react-hooks \
  eslint-config-prettier \
  prettier \
  prettier-plugin-tailwindcss \
  husky \
  lint-staged \
  vitest \
  @vitejs/plugin-react \
  jsdom \
  @vitest/coverage-v8

# Initialize husky
pnpm exec husky init
echo "pnpm lint-staged" > .husky/pre-commit

echo "✅ Automation setup complete!"
echo ""
echo "Next steps:"
echo "1. Copy ESLint config to eslint.config.mjs"
echo "2. Copy Prettier config to .prettierrc"
echo "3. Add lint-staged config to package.json"
echo "4. Add scripts to package.json"
echo "5. Copy CI workflow to .github/workflows/ci.yml"
```

---

## 📚 Related Documents

- **AI behavioral rules**: [../guidelines.md](../guidelines.md)
- **AI technical knowledge**: [../skills.md](../skills.md)
- **AI task boundaries**: [../workflow.md](../workflow.md)
- **Ready-to-use prompts**: [../prompts.md](../prompts.md)
- **Complete Workflow Guide**: [workflow-guide.md](workflow-guide.md)
- **Project Overview**: [../../README.md](../../README.md)
