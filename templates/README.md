# Templates Collection

This directory contains reusable templates and configurations for different technology stacks and use cases. Each template is self-contained and includes its own documentation, dependencies, and directives optimized for AI coding assistants like Junie.

## 📦 Available Templates

### 🔍 Audit
**Path**: `templates/audit/`  
**Purpose**: Smart contract security audit tools and methodologies  
**Includes**:
- Static analysis tools configuration (Slither, Aderyn)
- Fuzzing setup (Foundry/Echidna)
- Manual review checklists
- Vulnerability research guidelines

**Documentation**: See [audit/README.md](./audit/README.md)

---

### 🗄️ Database
**Path**: `templates/database/`  
**Purpose**: Database architecture and data layer setup  
**Includes**:
- PostgreSQL configuration
- Prisma ORM setup
- GraphQL API (Pothos/Yoga)
- Redis caching
- BullMQ job processing

**Documentation**: See [database/README.md](./database/README.md)

---

### ⚛️ Next.js
**Path**: `templates/nextjs/`  
**Purpose**: Modern Next.js application architecture  
**Includes**:
- Next.js 16 + App Router
- React 19 + Server Components
- Feature-based architecture
- TypeScript configuration
- Server Actions with next-safe-action

**Documentation**: See [nextjs/README.md](./nextjs/README.md)

---

### 🎨 UI
**Path**: `templates/ui/`  
**Purpose**: UI component libraries and styling systems  
**Includes**:
- **shadcn/ui**: Accessible component library
- **Tailwind CSS**: Utility-first styling

**Subdirectories**:
- `ui/shadcn/` - shadcn/ui components and configuration
- `ui/tailwindcss/` - Tailwind CSS setup and customization

---

### 🔗 Web3
**Path**: `templates/web3/`  
**Purpose**: Web3 and smart contract development  
**Includes**:
- Solidity smart contracts
- Foundry/Hardhat setup
- OpenZeppelin standards
- Viem + Wagmi + AppKit integration
- SIWE (Sign-In with Ethereum)
- Account Abstraction (ERC-4337)

**Documentation**: See [web3/README.md](./web3/README.md)

---

## 🚀 How to Use Templates

### Option 1: Copy Entire Template
```bash
# Copy a complete template to your project
cp -r templates/nextjs/* /path/to/your/project/
```

### Option 2: Cherry-Pick Files
```bash
# Copy specific files or configurations
cp templates/database/prisma.schema /path/to/your/project/
cp templates/ui/tailwindcss/tailwind.config.ts /path/to/your/project/
```

### Option 3: Reference in Prompts with AI Assistants
When working with Junie or other AI assistants, you can reference specific templates:
```
"Use the Next.js template from templates/nextjs/ as a base for this feature"
```

---

## 📋 Template Structure

Each template typically includes:

- **`README.md`**: Detailed documentation and usage instructions
- **`CLAUDE.md`**: AI assistant directives and guidelines
- **`package.json`**: Dependencies and scripts (when applicable)
- **Configuration files**: ESLint, TypeScript, Prettier, etc.
- **Example code**: Sample implementations and patterns

---

## 🔧 Configuration Files

### Global Configuration (Project Root)
- **`.prettierrc`**: Base Prettier configuration (applies to all templates)
- **`.junie/skills.md`**: Core skills and standards for AI assistants

### Template-Specific Configuration
Each template may include its own specific configurations and directives.

---

## 🤝 Contributing

When adding new templates:

1. Create a new directory under `templates/`
2. Include a comprehensive `README.md`
3. Add a `CLAUDE.md` with AI assistant directives
4. Document all dependencies in `package.json`
5. Follow the existing template structure
6. Update this main `templates/README.md`

---

## 📚 Related Documentation

- **Main Project**: See [../README.md](../README.md)
- **AI Directives**: See [../.junie/README.md](../.junie/README.md)
- **Skills & Standards**: See [../.junie/skills.md](../.junie/skills.md)

---

## 📞 Support

For questions or issues with templates, please refer to the individual template's README or the main project documentation.
