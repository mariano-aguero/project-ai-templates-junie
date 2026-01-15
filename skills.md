# Developer Skills & Professional Standards

This document centralizes the core expertise, architectural patterns, and professional standards for this project. It serves as the "source of truth" for the AI assistant's capabilities and decision-making process.

## 🌐 Language & Code Standards

**MANDATORY REQUIREMENT**: All generated code, comments, documentation, variable names, function names, commit messages, and any text output must be written in **English**. This is a non-negotiable standard for consistency, collaboration, and maintainability across all projects.

## 🧠 Expert Personas

### Modern Web Architect
- **Expertise**: Next.js 15 (App Router), React 19, TypeScript 5+.
- **Philosophy**: Server-first components, progressive enhancement, and modular scalability.
- **Decision Matrix**: Default to Server Components; use Client Components only for interactivity or browser APIs.

### UI/UX Engineer
- **Expertise**: Tailwind CSS v3.4+, shadcn/ui, Radix UI, Framer Motion.
- **Philosophy**: Utility-first styling, accessibility-first (a11y), and consistent design tokens.
- **Constraint**: Stick to 4-unit spacing scales and semantic color variables.

### Full-Stack Type-Safety Specialist
- **Expertise**: Zod, TypeScript, next-safe-action, TanStack Query.
- **Philosophy**: End-to-end type safety, runtime validation, and "making illegal states unrepresentable."

### Web3 & Smart Contract Engineer
- **Expertise**: Solidity, Foundry, Hardhat, OpenZeppelin, Viem, Wagmi, AppKit (Web3Modal), SIWE, ERC-4337 (AA), Blockscout MCP.
- **Philosophy**: Trustless interactions, gas efficiency, and asynchronous blockchain state management. Secure-by-design contracts using audited standards.
- **Advanced Patterns**: Transaction simulation, custom error decoding, account abstraction, fuzzing (Foundry), and real-time explorer data integration via MCP.
- **Constraint**: Always use `viem` for low-level primitives; prefer `wagmi` hooks for React integration. Use `Foundry` for contract testing and `Hardhat` for deployment scripts. Use `AppKit` as the primary connection library.

### Smart Contract Security Auditor
- **Expertise**: Static Analysis (Slither, Aderyn), Fuzzing (Foundry/Echidna), Manual Review, Vulnerability Research.
- **Philosophy**: "Don't trust, verify." Systematic hunting for edge cases, logic flaws, and architectural weaknesses.
- **Advanced Patterns**: Invariant-based testing, symbolic execution basics, gas griefing analysis, and complex DeFi attack vector modeling.
- **Constraint**: Follow the SWC Registry standards and the Check-Effects-Interactions pattern. Target 100% invariant coverage for critical state.

### Database & Data Architect
- **Expertise**: PostgreSQL, Redis, GraphQL (Pothos/Yoga), Prisma, Zod, BullMQ.
- **Philosophy**: Normalized relational schemas, multi-layer caching, background job processing, and code-first GraphQL APIs.
- **Advanced Patterns**: N+1 prevention (via Prisma/Pothos), cost-based query analysis, atomic transactions, application-level encryption (AES-256-GCM), and secure password hashing (Argon2).
- **Constraint**: Prefer Prisma for ORM; use Pothos for type-safe GraphQL schema building. Use BullMQ for all asynchronous background processing.

---

## 🏗️ Architectural Patterns

### 1. Feature-Based Architecture
Organize by business domain to ensure modularity:
```text
src/features/[feature-name]/
├── components/     # Feature-specific UI
├── actions.ts      # Server Actions (using next-safe-action)
├── queries.ts      # Data fetching logic
├── hooks.ts        # Feature-specific React hooks
├── types.ts        # Domain-specific TypeScript interfaces
└── api.ts          # API route handlers (if needed)
```

### 2. Compositional UI (Compound Components)
Build flexible components using the Radix UI/shadcn pattern:
- **Pattern**: `Parent`, `Parent.Trigger`, `Parent.Content`.
- **Benefit**: High customizability without prop-drilling or complex configuration objects.

---

## 🛠️ Technical Standards

### 🚀 Data Fetching & State
- **Server State**: Use **TanStack Query** for client-side fetching/polling.
- **Stale Management**: Default `staleTime: 60000` (1 min) and `gcTime: 300000` (5 min).
- **Streaming**: Always wrap data-dependent components in `<Suspense fallback={<Skeleton />}>`.
- **Global UI State**: Use **Zustand** only when React Context or State Lifting isn't sufficient.
- **Data Persistence**: Use **Prisma** with PostgreSQL for relational data.
- **Caching**: Use **Redis** for expensive query results and session management.
- **Background Jobs**: Use **BullMQ** for reliable, distributed task processing.
- **API Protocol**: Use **GraphQL** with a code-first approach (Pothos) for data exposure.

### 🛡️ Security & Validation
- **Input Validation**: Mandatory **Zod** schemas for every Server Action and API Route.
- **Safe Actions**: Use `next-safe-action` to standardize error handling and input parsing.
- **Environment Variables**: Use a Zod-validated `env.ts` to ensure config integrity at runtime.
- **Authentication**: Prefer multi-factor and session-based auth (NextAuth/Auth.js or Clerk). For Web3, use SIWE.
- **CSRF/XSS**: Implement strict CSP headers, use React's default escaping, and sanitize HTML if dangerouslySetInnerHTML is required (using DOMPurify).
- **Web3 Security**: Always simulate transactions, use access control (Ownable/AccessControl), and implement reentrancy guards in contracts.
- **Rate Limiting**: Implement rate limiting on API routes to prevent brute force and DoS.

### 🎨 Styling, Layout, Formatting & Linting
- **Formatting & Linting**: Mandatory use of **ESLint** combined with **Prettier**. ESLint handles code quality and logic rules, while Prettier handles formatting and indentation (2 spaces).
- **Integration**: Use `eslint-config-prettier` to disable ESLint rules that might conflict with Prettier. All style issues should be surfaced through the linter.
- **Responsiveness**: Mobile-first approach. Use **Container Queries** (`@container`) for component-level layouts.
- **I18n-Ready**: Use Logical Properties (`ms-*`, `me-*`, `ps-*`, `pe-*`) instead of physical ones (`ml-*`, `mr-*`).
- **Icons**: Standardize on **Lucide React**.

### 📝 Git & Commit Standards
- **Conventional Commits**: Mandatory use of the [Conventional Commits](https://www.conventionalcommits.org/) specification (e.g., `feat:`, `fix:`, `docs:`, `refactor:`, `chore:`).
- **Tooling**: Use **commitlint** to enforce rules, **husky** for git hooks, and **commitizen** for interactive commit creation.
- **Atomic Commits**: Each commit should represent a single, logical change.

---

## ✅ Best Practices Checklist

- [ ] Is this a Server Component by default?
- [ ] Does this Server Action validate input with Zod?
- [ ] Are we using semantic colors (e.g., `text-muted-foreground`)?
- [ ] Is the loading state handled with Suspense + Skeleton?
- [ ] Is the component accessible (ARIA, Keyboard)?
- [ ] Is the folder structure following the Feature-based pattern?
- [ ] Is the code formatted with Prettier and linted with ESLint?
- [ ] Are database queries optimized (no N+1)?
- [ ] Is Redis caching implemented for hot data?
- [ ] Is the GraphQL schema type-safe and validated?
- [ ] Are smart contracts tested with Foundry/Hardhat (high coverage)?
- [ ] Have all smart contract invariants been identified and tested?
- [ ] Is there a formal audit report for critical security findings?
- [ ] Does the code strictly follow the Check-Effects-Interactions pattern?
- [ ] Are we using audited standards (OpenZeppelin) for Web3?
- [ ] Does the commit message follow Conventional Commits?
- [ ] Are all linter errors resolved?

---

## 📚 Core Libraries Reference
- **Framework**: Next.js 15, React 19.
- **UI**: Tailwind CSS, shadcn/ui, Radix UI.
- **Logic/Data**: Zod, TanStack Query, Zustand, Prisma, Pothos, ioredis.
- **Utility**: clsx, tailwind-merge, next-safe-action.
