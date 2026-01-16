# AI Templates for Junie 🤖

Professional templates and AI directives optimized for use with **Junie** and other AI coding assistants.

> **Note**: This is a collection of reusable templates and conventions. This project serves as a template library, not a standalone application.

---

## 📚 Documentation

### For Junie (JetBrains AI Assistant)

This project includes comprehensive guidelines optimized for **Junie** to ensure consistent, high-quality code generation:

- **[Junie Guidelines](.junie/README.md)** - Overview and how to use guidelines with Junie
- **[Technical Standards](.junie/skills.md)** - Core technical standards and best practices
- **[Templates](./templates/)** - Domain-specific guidelines for different technology stacks

### Available Templates

Each template provides detailed guidelines that Junie can reference:

- **[Next.js 15](./templates/nextjs/guidelines.md)** - App Router, Server Components, React 19, type-safe actions
- **[Web3 & dApps](./templates/web3/guidelines.md)** - Solidity, Foundry, Viem, Wagmi, AppKit, smart contract security
- **[Database & API](./templates/database/guidelines.md)** - PostgreSQL, Prisma, GraphQL (Pothos), Redis, BullMQ
- **[shadcn/ui](./templates/ui/shadcn/guidelines.md)** - Accessible, composable UI components
- **[Tailwind CSS](./templates/ui/tailwindcss/guidelines.md)** - Utility-first styling and responsive design
- **[Security Audit](./templates/audit/guidelines.md)** - Smart contract auditing methodologies and tools

### How to Use with Junie

When working with Junie, reference the relevant guidelines in your issue description:

```
Please follow the standards in .junie/skills.md and templates/nextjs/guidelines.md
for this Next.js 15 project.
```

---

## 🚀 Quick Start

### Using with Junie

1. Copy the `.junie/` folder to your project root
2. Select the templates you need from `templates/`
3. Reference the guidelines in your Junie issue descriptions

### Manual Integration

```bash
# Copy AI directives to your project
cp -r .junie /path/to/your/project/

# Copy specific templates
cp -r templates/nextjs /path/to/your/project/
```

---

## 📦 Available Templates

- **Next.js 15** - Modern React applications with App Router
- **Web3** - Smart contracts and dApp development
- **Database** - PostgreSQL, Prisma, GraphQL, Redis
- **UI** - shadcn/ui and Tailwind CSS components
- **Audit** - Smart contract security auditing tools

See [templates/](./templates/) for detailed documentation.

---

## 👤 Author

**Mariano Aguero**
- Email: [mariano.aguero@gmail.com](mailto:mariano.aguero@gmail.com)
- GitHub: [@mariano-aguero](https://github.com/mariano-aguero)

---

## 📄 License

MIT
