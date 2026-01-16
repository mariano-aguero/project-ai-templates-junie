# 🤖 AI-Powered Development Templates

> **A curated collection of production-ready templates and AI assistant configurations for modern web development**

This repository is an **AI-enhanced template library** designed to supercharge your development workflow with intelligent code generation, consistent patterns, and best practices built-in.

**What makes it special?** All AI behavior, technical standards, and architectural patterns are defined in the [`.junie/`](.junie/) directory, creating a self-documenting, AI-ready development environment.

---

## ✨ Why This Repository?

### 🎯 AI-First Development
- **Pre-configured AI assistants** with expert-level knowledge in multiple domains
- **Template-first approach** that encourages code reuse and consistency
- **Behavioral guidelines** that ensure AI generates production-quality code
- **Technical capabilities** spanning modern web, Web3, databases, and security

### 🏗️ Production-Ready Templates
- **Battle-tested patterns** for Next.js, Web3, databases, and UI components
- **Complete configurations** including TypeScript, ESLint, Prettier, and more
- **Domain-specific guidelines** optimized for each technology stack
- **Copy-paste ready** - use entire templates or cherry-pick what you need

### 📚 Self-Documenting Architecture
- **Clear separation** between behavioral rules and technical capabilities
- **Comprehensive documentation** for both humans and AI assistants
- **Consistent standards** across all templates and projects
- **Easy to extend** with your own templates and guidelines

---

## 🧠 The AI Configuration System

All AI assistant behavior and knowledge is centralized in the **`.junie/`** directory:

### Core Configuration Files

| File | Purpose | Contains |
|------|---------|----------|
| **[`.junie/guidelines.md`](.junie/guidelines.md)** | Behavioral Rules | How AI should work: template-first approach, code standards, workflows |
| **[`.junie/skills.md`](.junie/skills.md)** | Technical Capabilities | What AI knows: expert personas, architectural patterns, tech standards |
| **[`.junie/README.md`](.junie/README.md)** | Configuration Guide | How to use the AI configuration system |

**Key Features**:
- 🔍 **Template-First Mandate**: AI always searches existing templates before writing new code
- 📦 **pnpm-Only Policy**: Consistent package management across all projects
- 🎨 **Prettier Standards**: Automated code formatting with project-wide configuration
- 🔒 **Security-First**: Mandatory input validation, type safety, and best practices
- 🌐 **English-Only**: All code, comments, and documentation in English for global collaboration

---

## 📦 Available Templates

### ⚛️ [Next.js 16](./templates/nextjs/)
Modern React applications with App Router, Server Components, and type-safe Server Actions.

**Includes**: Feature-based architecture, React 19, TypeScript 5+, next-safe-action, TanStack Query

### 🔗 [Web3 & Smart Contracts](./templates/web3/)
Complete Web3 development stack for dApps and smart contracts.

**Includes**: Solidity, Foundry, Hardhat, Viem, Wagmi, AppKit, OpenZeppelin, SIWE, Account Abstraction

### 🗄️ [Database & API](./templates/database/)
Full-stack data layer with PostgreSQL, GraphQL, and caching.

**Includes**: Prisma ORM, Pothos GraphQL, Redis, BullMQ, Zod validation

### 🎨 [UI Components](./templates/ui/)
Accessible, composable UI component systems.

**Includes**: 
- **[shadcn/ui](./templates/ui/shadcn/)** - Radix UI-based accessible components
- **[Tailwind CSS](./templates/ui/tailwindcss/)** - Utility-first styling system

### 🔍 [Security Audit](./templates/audit/)
Smart contract security auditing tools and methodologies.

**Includes**: Slither, Aderyn, Foundry fuzzing, Echidna, manual review checklists

---

## 🚀 Quick Start

### Option 1: Use with AI Assistants (Recommended)

**For Junie (JetBrains AI)**:
1. Copy `.junie/` to your project root
2. Junie automatically detects and applies the configuration
3. Reference templates in your prompts:
   ```
   "Use the Next.js template from templates/nextjs/ and follow .junie/guidelines.md"
   ```

**For other AI assistants**:
- Reference `.junie/guidelines.md` for behavioral rules
- Reference `.junie/skills.md` for technical capabilities
- Point to specific templates for domain patterns

### Option 2: Manual Template Usage

```bash
# Copy AI configuration
cp -r .junie /path/to/your/project/

# Copy code formatting standards
cp .prettierrc /path/to/your/project/

# Copy specific templates
cp -r templates/nextjs /path/to/your/project/
cp -r templates/web3 /path/to/your/project/

# Install dependencies (always use pnpm)
cd /path/to/your/project/
pnpm install
```

### Option 3: Cherry-Pick Components

```bash
# Copy specific configurations or patterns
cp templates/nextjs/tsconfig.json /path/to/your/project/
cp templates/ui/tailwindcss/tailwind.config.ts /path/to/your/project/
```

---

## 🎓 How It Works

### The Template-First Philosophy

1. **AI checks templates first** - Before generating new code, AI searches `templates/` for existing patterns
2. **Reuse over reinvention** - Adapt proven patterns rather than creating from scratch
3. **Consistency by default** - All generated code follows the same standards and patterns
4. **Quality assurance** - Built-in checklists ensure production-ready output

### The Configuration Hierarchy

```
.junie/
├── guidelines.md    # HOW AI should work (behavior, workflow, standards)
├── skills.md        # WHAT AI knows (capabilities, patterns, expertise)
└── README.md        # Guide for developers and AI assistants

templates/
├── nextjs/          # Next.js-specific patterns and guidelines
├── web3/            # Web3-specific patterns and guidelines
├── database/        # Database-specific patterns and guidelines
├── ui/              # UI-specific patterns and guidelines
└── audit/           # Security audit patterns and guidelines

.prettierrc          # Code formatting standards (project-wide)
```

---

## 🛠️ Technology Stack

### Frontend
- **Framework**: Next.js 16, React 19
- **Styling**: Tailwind CSS, shadcn/ui, Radix UI
- **State**: TanStack Query, Zustand
- **Validation**: Zod, next-safe-action

### Web3
- **Smart Contracts**: Solidity, OpenZeppelin
- **Development**: Foundry, Hardhat
- **Frontend**: Viem, Wagmi, AppKit (Web3Modal)
- **Auth**: SIWE (Sign-In with Ethereum)

### Backend & Data
- **Database**: PostgreSQL, Prisma ORM
- **API**: GraphQL (Pothos/Yoga)
- **Caching**: Redis, ioredis
- **Jobs**: BullMQ

### DevOps & Quality
- **Language**: TypeScript 5+
- **Formatting**: Prettier
- **Linting**: ESLint
- **Git**: Conventional Commits, Commitlint, Husky
- **Security**: Slither, Aderyn, Foundry fuzzing

---

## 📖 Documentation

- **[AI Configuration Guide](.junie/README.md)** - Complete guide to the AI system
- **[Behavioral Guidelines](.junie/guidelines.md)** - How AI should work
- **[Technical Capabilities](.junie/skills.md)** - What AI knows
- **[Templates Overview](./templates/README.md)** - All available templates

---

## 🤝 Contributing

Want to add your own templates or improve existing ones?

1. Follow the existing template structure
2. Include `README.md`, `guidelines.md`, and `package.json`
3. Update the main `templates/README.md`
4. Ensure consistency with `.junie/guidelines.md` standards
5. Test with AI assistants to verify behavior

---

---

## 👤 Author

**Mariano Aguero**
- Email: [mariano.aguero@gmail.com](mailto:mariano.aguero@gmail.com)
- GitHub: [@mariano-aguero](https://github.com/mariano-aguero)

---

## 📄 License

MIT
