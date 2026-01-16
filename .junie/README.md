# AI Assistant Configuration Guide 🤖

This directory contains the complete AI assistant configuration for this project, optimized for **Junie** (JetBrains AI Assistant) and other AI coding assistants.

## 📋 Overview

This configuration system separates concerns into two complementary files:

- **[guidelines.md](./guidelines.md)** - Behavioral rules, workflow standards, and decision-making processes
- **[skills.md](./skills.md)** - Technical capabilities, expert personas, and domain-specific knowledge

Together, these files provide AI assistants with the context needed to generate high-quality, consistent, and secure code.

---

## 📚 Documentation Files

### 1. `guidelines.md` - Behavioral Rules & Workflow

**Purpose**: Defines HOW the AI assistant should work and make decisions.

**Contains**:
- **Template-First Approach**: Mandatory rule to search `templates/` before writing new code
- **Package Management**: pnpm usage requirements and commands
- **Code Formatting**: Prettier configuration standards (`.prettierrc`)
- **Code Quality**: ESLint integration and TypeScript standards
- **Language Standards**: English-only requirement for all code and documentation
- **Git Standards**: Conventional Commits specification and tooling
- **Project Structure**: Feature-based architecture guidelines
- **Security Standards**: Input validation and environment variable handling
- **Workflow Guidelines**: Step-by-step processes for starting, writing, and completing tasks

**When to reference**: When you need to understand the project's behavioral expectations, coding standards, or workflow processes.

### 2. `skills.md` - Technical Capabilities

**Purpose**: Defines WHAT the AI assistant knows and can do.

**Contains**:
- **Expert Personas**: Specialized roles (Web Architect, Web3 Engineer, Security Auditor, Database Architect, UI/UX Engineer)
- **Architectural Patterns**: Feature-based architecture, compositional UI patterns
- **Technical Standards**: Data fetching, state management, security, validation
- **TypeScript Best Practices**: Configuration, type safety, null handling
- **Technical Quality Checklist**: Verification points for architecture, type safety, UI, data, and Web3

**When to reference**: When you need to understand the technical capabilities, architectural patterns, or domain-specific expertise available.

---

## 🗂️ Template Structure

The repository includes domain-specific templates in `../templates/`:

```
templates/
├── audit/          # Smart contract security auditing
├── database/       # PostgreSQL, Prisma, GraphQL, Redis, BullMQ
├── nextjs/         # Next.js 16, App Router, Server Components
├── ui/
│   ├── shadcn/     # shadcn/ui accessible components
│   └── tailwindcss/ # Tailwind CSS utility-first styling
└── web3/           # Solidity, Foundry, Viem, Wagmi, AppKit
```

Each template includes:
- `README.md` - Detailed documentation
- `CLAUDE.md` - AI assistant directives (Claude compatibility)
- `guidelines.md` - Domain-specific best practices
- `package.json` - Dependencies and scripts

---

## 🚀 How to Use This Configuration

### For Developers

**Setting up a new project**:

1. **Copy the `.junie/` folder** to your project root:
   ```bash
   cp -r .junie /path/to/your/project/
   ```

2. **Copy relevant templates**:
   ```bash
   cp -r templates/nextjs /path/to/your/project/
   cp -r templates/web3 /path/to/your/project/
   ```

3. **Copy formatting configuration**:
   ```bash
   cp .prettierrc /path/to/your/project/
   ```

4. **Reference in AI prompts**:
   ```
   "Follow the standards in .junie/guidelines.md and .junie/skills.md"
   ```

### For AI Assistants (Junie)

**Automatic detection**: Junie automatically detects and applies directives from `.junie/` when present in the project root.

**Manual reference**: You can explicitly reference specific files in issue descriptions:
```
Please follow the guidelines in .junie/guidelines.md and use the 
Next.js patterns from templates/nextjs/guidelines.md
```

**Decision flow**:
1. Read `guidelines.md` to understand behavioral expectations
2. Read `skills.md` to understand technical capabilities
3. Check `templates/` for existing patterns before writing new code
4. Apply the appropriate expert persona from `skills.md`
5. Follow the workflow from `guidelines.md`

---

## 🎯 Key Principles

### Template-First Development
Always search `templates/` directory before proposing new code. Reuse and adapt existing patterns.

### Separation of Concerns
- **Behavioral rules** → `guidelines.md`
- **Technical capabilities** → `skills.md`
- **Domain patterns** → `templates/*/guidelines.md`

### Consistency
- Use **pnpm** for package management
- Follow **Prettier** configuration (`.prettierrc`)
- Write all code in **English**
- Use **Conventional Commits** for git messages

### Quality
- Validate inputs with **Zod**
- Enable TypeScript **strict mode**
- Follow **feature-based architecture**
- Implement proper **error handling**

## 🛠️ Main Technologies

- **Frontend**: Next.js 16, React 19, Tailwind CSS, shadcn/ui.
- **Web3**: Solidity, Foundry, Hardhat, Viem, Wagmi, AppKit.
- **Backend**: PostgreSQL, Redis, GraphQL, Prisma, BullMQ.
- **Tools**: Zod, TypeScript 5, ESLint, Prettier, Slither, Aderyn, Commitlint, Husky.

## 👤 Author

**Mariano Aguero**
- Email: [mariano.aguero@gmail.com](mailto:mariano.aguero@gmail.com)
- GitHub: [@mariano-aguero](https://github.com/mariano-aguero)

---
*Generated with love for the developer community looking to boost their productivity with AI.*
