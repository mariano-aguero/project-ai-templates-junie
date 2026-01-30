# AI Configuration System

This directory contains the complete configuration for AI assistants (Junie).

---

## 📁 File Structure

```
.junie/
├── README.md        ← You are here (system overview)
├── guidelines.md    ← HOW: Behavioral rules, code standards, workflow
├── skills.md        ← WHAT: Technical knowledge, patterns, expertise
├── workflow.md      ← BOUNDARIES: Allowed/forbidden tasks, escalation
└── prompts.md       ← TEMPLATES: Ready-to-use prompts for common tasks

AUTOMATION.md        ← ENFORCEMENT: CI/CD, pre-commit hooks, tooling
```

---

## 🎯 Purpose of Each File

| File | Question It Answers | Read When |
|------|---------------------|-----------|
| **guidelines.md** | "How should I work?" | Every task |
| **skills.md** | "What do I know?" | Technical decisions |
| **workflow.md** | "What can I do?" | Before starting any task |
| **prompts.md** | "How do I ask for X?" | Requesting specific work |
| **AUTOMATION.md** | "How is quality enforced?" | Setting up projects |

---

## 🔄 How They Work Together

```
┌─────────────────────────────────────────────────────────────┐
│                    AI ASSISTANT (Junie)                     │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  1. Read workflow.md     → Know what you CAN/CANNOT do     │
│  2. Read guidelines.md   → Know HOW to do it               │
│  3. Read skills.md       → Know WHAT tech patterns to use  │
│  4. Use prompts.md       → Get task templates              │
│                                                             │
│  5. Generate code                                           │
│                                                             │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                   AUTOMATION LAYER                          │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  Pre-commit hooks  →  Lint + Format (fast, local)          │
│  CI/CD pipeline    →  Full validation (thorough, remote)   │
│                                                             │
│  ❌ Bad code? → Rejected automatically                     │
│  ✅ Good code? → Merged safely                             │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## 📋 File Summaries

### guidelines.md (Behavioral Rules)

- Template-first approach (always check templates/ first)
- pnpm only (never npm or yarn)
- Prettier formatting (no semicolons, double quotes)
- Conventional Commits
- English only
- Feature-based architecture
- Zod validation for all inputs

### skills.md (Technical Knowledge)

- Expert personas (Web Architect, Web3 Engineer, etc.)
- Architectural patterns (Feature-based, Compound Components)
- Technical standards (TypeScript, Prisma, TanStack Query)
- Quality checklists

### workflow.md (Task Boundaries)

- Allowed tasks (implementation, refactoring, testing)
- Forbidden tasks (architecture, security decisions, deployments)
- Task size limits
- Escalation rules

### prompts.md (Ready Templates)

- Implementation prompts
- Code review prompts
- Refactoring prompts
- Testing prompts
- Web3-specific prompts
- Database prompts

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

## 🚀 Quick Start for AI Assistants

### At the Start of Every Session

```markdown
1. Read .junie/workflow.md    → Understand your boundaries
2. Read .junie/guidelines.md  → Understand the rules
3. Check templates/           → Find existing patterns
```

### Before Writing Code

```markdown
1. Is this task allowed? (check workflow.md)
2. Is there a template? (check templates/)
3. What patterns apply? (check skills.md)
```

### After Writing Code

```markdown
1. Run: pnpm lint
2. Run: pnpm format:check
3. Run: pnpm typecheck
4. Run: pnpm test
```

---

## 🚀 How to Use This Configuration

### For Developers

**Setting up a new project**:

1. **Copy the `.junie/` folder** to your project root:
   ```bash
   cp -r .junie /path/to/your/project/
   ```

2. **Copy AUTOMATION.md** for CI/CD setup:
   ```bash
   cp AUTOMATION.md /path/to/your/project/
   ```

3. **Copy relevant templates**:
   ```bash
   cp -r templates/nextjs /path/to/your/project/
   cp -r templates/web3 /path/to/your/project/
   ```

4. **Use prompts from `.junie/prompts.md`**:
   - Copy-paste ready-to-use prompts for common tasks
   - Customize with your specific requirements

### For AI Assistants (Junie)

**Decision flow**:
1. Read `workflow.md` to understand what you CAN/CANNOT do
2. Read `guidelines.md` to understand HOW to do it
3. Read `skills.md` to understand WHAT tech patterns to use
4. Use `prompts.md` to get task templates
5. Check `templates/` for existing patterns before writing new code

---

## 🔑 Key Principles

1. **AI is an assistant, not an agent**
   - Humans make decisions
   - AI executes well-scoped tasks

2. **Templates before code**
   - Reuse existing patterns
   - Maintain consistency

3. **Automation enforces quality**
   - Pre-commit catches issues early
   - CI/CD prevents bad merges

4. **Explicit boundaries**
   - Clear allowed/forbidden tasks
   - Escalation when uncertain

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
