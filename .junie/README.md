# AI Directives for Junie 🤖

This directory contains professional directives and standards designed to optimize the workflow with **Junie** and other AI coding assistants.

The goal is to provide AI assistants with rich context, senior-level technical standards, and modern architectural patterns to generate high-quality, secure, and scalable code.

## 📂 Project Structure

The repository is organized into specialized modules, each with its own memory configuration (`CLAUDE.md`) and standards:

- **[Next.js 15](../templates/nextjs)**: Feature-based architecture, App Router, Server Components, and strict validation.
- **[Web3 & dApps](../templates/web3)**: Smart contract development (Solidity), AppKit/Wagmi/Viem integration, and on-chain security.
- **[Database & API](../templates/database)**: Data layer with PostgreSQL, Prisma, GraphQL (Pothos), Redis, and BullMQ.
- **[UI & Styling](../templates/ui)**: Consistent components with **shadcn/ui** and **Tailwind CSS**.
- **[Security Audit](../templates/audit)**: Methodologies and tools for smart contract security auditing.

## 🧠 The Heart: `skills.md`

At the root of the project is the **[skills.md](./skills.md)** file. This file centralizes:
- **Expert Personas**: Defined roles for different domains (Web Architect, Security Auditor, etc.).
- **Technical Standards**: Rules on data fetching, security, validation, and performance.
- **Quality Checklist**: A verification list that the AI assistant follows before delivering any task.

## 🚀 How to use with Junie

To integrate these directives into your project:

1. **Copy the entire `.junie/` folder** to your project root - Junie will automatically detect and apply the directives.
2. **Copy specific templates** from `../templates/` (e.g., `nextjs/`, `web3/`) to your project as needed.
3. **Copy `.prettierrc`** from the project root for consistent code formatting.

Junie will automatically detect the `.junie/skills.md` file and adjust its behavior and code suggestions to the defined standards.

## 🛠️ Main Technologies

- **Frontend**: Next.js 15, React 19, Tailwind CSS, shadcn/ui.
- **Web3**: Solidity, Foundry, Hardhat, Viem, Wagmi, AppKit.
- **Backend**: PostgreSQL, Redis, GraphQL, Prisma, BullMQ.
- **Tools**: Zod, TypeScript 5, ESLint, Prettier, Slither, Aderyn, Commitlint, Husky.

## 👤 Author

**Mariano Aguero**
- Email: [mariano.aguero@gmail.com](mailto:mariano.aguero@gmail.com)
- GitHub: [@mariano-aguero](https://github.com/mariano-aguero)

---
*Generated with love for the developer community looking to boost their productivity with AI.*
