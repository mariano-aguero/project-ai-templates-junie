# Automation Scripts

This directory contains scripts to facilitate daily work with Junie.

---

## 📝 generate-prompt.sh

Custom prompt generator for Junie based on templates.

### 🚀 Quick Usage

#### Interactive Mode (Recommended)

```bash
./scripts/generate-prompt.sh
```

The script will guide you step by step:
1. Select the prompt type (feature, component, hook, etc.)
2. Enter the name
3. Select the template(s) (nextjs, web3, database, etc.). You can select multiple by separating numbers with commas (e.g., 1,2,5).
4. Copy the generated prompt and paste it into Junie

#### Direct Mode

```bash
./scripts/generate-prompt.sh [type] [name] [template1,template2,...]
```

**Examples**:

```bash
# Generate prompt for new Web3 feature using multiple templates
./scripts/generate-prompt.sh feature wallet-connection web3,typescript,ui-shadcn
```

# Generate prompt for UI component
./scripts/generate-prompt.sh component Button ui-shadcn

# Generate prompt for custom hook
./scripts/generate-prompt.sh hook useTokenBalance web3

# Generate prompt for smart contract
./scripts/generate-prompt.sh contract MyToken web3

# Generate prompt for tests
./scripts/generate-prompt.sh test useTokenBalance web3

# Generate prompt for refactoring
./scripts/generate-prompt.sh refactor auth-module nextjs

# Generate prompt for code review
./scripts/generate-prompt.sh review security-audit web3

# Generate prompt for bug fix
./scripts/generate-prompt.sh fix login-error nextjs
```

---

## 📋 Available Prompt Types

### 1. **feature** - New Feature

Generates a complete prompt to implement a new feature.

**Includes**:
- Project and template context
- List of files to create/modify
- Constraints (TypeScript, pnpm, Prettier)
- Acceptance criteria (types, validation, tests)

**Usage example**:
```bash
./scripts/generate-prompt.sh feature wallet-connection web3
```

**Output**:
```markdown
## Context
- Project: web3
- Follow: .junie/guidelines.md strictly
- Template: templates/web3/

## Task
Implement wallet-connection.

## Files to Create/Modify
- [ ] [file path 1]
- [ ] [file path 2]

## Constraints
- TypeScript strict mode
- Use existing patterns from templates/web3/
- No new dependencies without approval
- pnpm only
- Follow Prettier configuration (.prettierrc)

## Acceptance Criteria
- [ ] All types explicit
- [ ] Zod validation for inputs (if applicable)
- [ ] Error handling complete
- [ ] Tests included
- [ ] Code formatted with Prettier
- [ ] No ESLint errors
```

---

### 2. **component** - UI Component

Generates a prompt to create a React/UI component.

**Includes**:
- Props interface template
- Requirements (accessibility, responsive, dark mode)
- Compound component pattern (if applicable)

**Usage example**:
```bash
./scripts/generate-prompt.sh component Button ui-shadcn
```

---

### 3. **hook** - Custom React Hook

Generates a prompt to create a custom hook.

**Includes**:
- Hook signature
- Requirements (loading/error states, cleanup, memoization)
- React hooks rules

**Usage example**:
```bash
./scripts/generate-prompt.sh hook useTokenBalance web3
```

---

### 4. **contract** - Smart Contract

Generates a prompt to create a Solidity smart contract.

**Includes**:
- Security checklist (reentrancy, access control, etc.)
- OpenZeppelin standards
- Gas optimization
- NatSpec documentation

**Usage example**:
```bash
./scripts/generate-prompt.sh contract MyToken web3
```

---

### 5. **test** - Test Suite

Generates a prompt to create comprehensive tests.

**Includes**:
- Test cases (happy path, edge cases, errors)
- Coverage requirements (>80%)
- Arrange-Act-Assert pattern

**Usage example**:
```bash
./scripts/generate-prompt.sh test useTokenBalance web3
```

---

### 6. **refactor** - Refactoring

Generates a prompt to refactor existing code.

**Includes**:
- Goals (readability, complexity, type safety)
- Constraints (maintain functionality, don't break tests)

**Usage example**:
```bash
./scripts/generate-prompt.sh refactor auth-module nextjs
```

---

### 7. **review** - Code Review

Generates a prompt to review code.

**Includes**:
- Complete checklist (quality, security, performance)
- Structured output format (severity, location, issue, fix)

**Usage example**:
```bash
./scripts/generate-prompt.sh review security-audit web3
```

---

### 8. **fix** - Bug Fix

Generates a prompt to fix a bug.

**Includes**:
- Template to describe the bug
- Steps to reproduce
- Expected vs actual behavior
- Regression test requirement

**Usage example**:
```bash
./scripts/generate-prompt.sh fix login-error nextjs
```

---

## 🎯 Available Templates

| Template | Description | Use Case |
|----------|-------------|----------|
| `nextjs` | Next.js 16, App Router, Server Components | Modern web apps |
| `web3` | Solidity, Foundry, Viem, Wagmi, AppKit | dApps and smart contracts |
| `database` | PostgreSQL, Prisma, GraphQL, Redis | Data layer and APIs |
| `ui-shadcn` | shadcn/ui, Radix UI, accessible components | UI components |
| `ui-tailwind` | Tailwind CSS, utility-first styling | Styles and design |
| `audit` | Security auditing, Slither, Foundry fuzzing | Security audits |

---

## 💡 Recommended Workflow

### Step 1: Generate Prompt

```bash
# Interactive mode (easier)
./scripts/generate-prompt.sh

# Or direct mode
./scripts/generate-prompt.sh feature wallet-connection web3
```

### Step 2: Copy Output

The script generates the prompt in the terminal. Copy it completely.

### Step 3: Paste into Junie

Open Junie (JetBrains AI) and paste the prompt.

### Step 4: Customize (Optional)

Before sending to Junie, you can:
- Add specific files in "Files to Create/Modify"
- Add additional context in "Additional Context"
- Modify acceptance criteria as needed

### Step 5: Junie Generates Code

Junie reads the prompt and:
- Follows `.junie/guidelines.md`
- Uses patterns from `templates/[template]/`
- Generates consistent, quality code

### Step 6: Validate

```bash
pnpm lint
pnpm format
pnpm typecheck
pnpm test
```

---

## 🔧 Customization

### Add New Prompt Type

Edit `generate-prompt.sh` and add:

1. New function `generate_[type]_prompt()`:
```bash
generate_my_type_prompt() {
    local name=$1
    local template=$2
    
    cat << EOF
## Context
- [Your context]

## Task
[Your task]

## Constraints
- [Your constraints]

## Acceptance Criteria
- [ ] [Your criteria]
EOF
}
```

2. Add case in the switch:
```bash
case $TYPE in
    # ... other cases
    my-type)
        generate_my_type_prompt "$NAME" "$TEMPLATE"
        ;;
esac
```

3. Update help and interactive mode.

---

## 📚 Complete Examples

### Example 1: Complete Web3 Feature

```bash
./scripts/generate-prompt.sh feature wallet-connection web3
```

Then customize in Junie:
```markdown
## Files to Create/Modify
- [ ] lib/wagmi.ts
- [ ] components/ConnectButton.tsx
- [ ] app/layout.tsx (add provider)

## Additional Context
Use AppKit (formerly Web3Modal) for wallet connection.
Support Mainnet and Sepolia networks.
```

### Example 2: Complex UI Component

```bash
./scripts/generate-prompt.sh component DataTable ui-shadcn
```

Customize:
```markdown
## Props Interface
\`\`\`typescript
interface DataTableProps<T> {
  data: T[]
  columns: ColumnDef<T>[]
  onRowClick?: (row: T) => void
  pagination?: boolean
}
\`\`\`

## Additional Context
Use TanStack Table for table logic.
Support sorting, filtering, and pagination.
```

### Example 3: Smart Contract with Tests

```bash
# 1. Generate prompt for contract
./scripts/generate-prompt.sh contract MyToken web3

# 2. After Junie generates the contract, generate tests
./scripts/generate-prompt.sh test MyToken web3
```

---

## 🎓 Tips and Best Practices

### 1. Use Interactive Mode at First

If you're new, use interactive mode:
```bash
./scripts/generate-prompt.sh
```

It's easier and guides you step by step.

### 2. Customize Before Sending

The generated prompt is a template. Customize it:
- Add specific files
- Add business context
- Adjust acceptance criteria

### 3. Combine with .junie/prompts.md

For more complex cases, combine:
1. Generate base with the script
2. Consult `.junie/prompts.md` for additional details
3. Mix both in your final prompt

### 4. Create Aliases

Add to your `.bashrc` or `.zshrc`:
```bash
alias junie-prompt='./scripts/generate-prompt.sh'
alias jp='./scripts/generate-prompt.sh'
```

Usage:
```bash
jp feature wallet-connection web3
```

### 5. Use with pbcopy (macOS)

```bash
./scripts/generate-prompt.sh feature wallet-connection web3 | pbcopy
```

The prompt is automatically copied to clipboard.

---

## 🐛 Troubleshooting

### Script not executable

```bash
chmod +x scripts/generate-prompt.sh
```

### Colors not showing

If ANSI colors don't work in your terminal:
```bash
# Edit the script and comment out color lines
# Or use compatible terminal (iTerm2, Warp, etc.)
```

### Template not found

Verify the template exists:
```bash
ls templates/
```

Valid templates: `nextjs`, `web3`, `database`, `ui-shadcn`, `ui-tailwind`, `audit`

---

## 📞 Support

For issues or suggestions:
1. Review this documentation
2. Consult `.junie/prompts.md` for manual prompts
3. Review `AUTOMATION.md` for level 1 and 2 setup

---

## 🚀 Next Steps

After mastering the prompt generator:

1. **Setup Level 1**: Pre-commit hooks (see `AUTOMATION.md`)
2. **Setup Level 2**: CI/CD with GitHub Actions (see `AUTOMATION.md`)
3. **Explore Level 4**: Integration with Cursor AI or Aider

---

*This script is part of the automation system for Junie. See main `README.md` for more information.*
