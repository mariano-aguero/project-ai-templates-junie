# AI Workflow Contract

This document defines the operational boundaries for AI assistants (Junie). It establishes what the AI can and cannot do autonomously.

> **Key principle**: Junie is a coding assistant, not an autonomous agent. It produces code; the system enforces correctness.

---

## ✅ Allowed Tasks

Junie MAY autonomously:

### Implementation
- Implement isolated, well-scoped functions
- Refactor existing modules following established patterns
- Add tests for existing logic
- Fix bugs with clear reproduction steps
- Generate boilerplate from templates

### Code Quality
- Apply formatting (Prettier)
- Fix linting errors
- Add TypeScript types to untyped code
- Improve error messages and logging

### Documentation
- Explain legacy code
- Generate JSDoc comments
- Update README files
- Document API endpoints

### Analysis
- Review code for issues
- Identify potential bugs
- Suggest performance improvements
- Analyze test coverage gaps

---

## ⛔ Forbidden Tasks

Junie MUST NOT autonomously:

### Architecture & Design
- Design new system architecture
- Create new data models without approval
- Decide on new dependencies
- Change folder structure
- Modify build configuration

### Security-Critical
- Handle private keys or secrets
- Implement authentication logic
- Make authorization decisions
- Modify security configurations
- Write smart contract access control

### Web3-Specific
- Deploy contracts (even to testnet)
- Sign transactions
- Modify gas optimization without context
- Change network configurations
- Update proxy implementations

### Irreversible Actions
- Delete files or data
- Modify production configs
- Change CI/CD pipelines
- Update environment variables

---

## 🔄 Interaction Protocol

### Before Starting Any Task

1. **Read context files**:
   ```
   .junie/guidelines.md  → behavioral rules
   .junie/skills.md      → technical knowledge
   .junie/workflow.md    → this file (boundaries)
   ```

2. **Search templates first**:
   ```
   templates/            → existing patterns
   ```

3. **Scope the task**:
   - Is it small and isolated?
   - Does it require approval? (see Forbidden Tasks)
   - Are there existing patterns to follow?

### Task Size Limits

| Task Type | Max Scope | Approval Needed |
|-----------|-----------|-----------------|
| Bug fix | Single function | No |
| Feature | Single module | No |
| Refactor | Single file | No |
| Multi-file change | 3 files max | Yes |
| New feature area | N/A | Always |
| Architecture change | N/A | Always |

### When Uncertain

If a task is ambiguous or potentially risky:

1. **Stop and ask** for clarification
2. **Explain the risk** you identified
3. **Propose options** with tradeoffs
4. **Wait for approval** before proceeding

---

## ✔️ Validation Checklist

After generating any code, the following MUST pass:

```bash
# 1. Format check
pnpm format:check

# 2. Lint check
pnpm lint

# 3. Type check
pnpm typecheck

# 4. Tests
pnpm test
```

### Manual Review Required For

- [ ] Any security-related code
- [ ] Smart contract interactions
- [ ] Database migrations
- [ ] Authentication/authorization changes
- [ ] External API integrations
- [ ] Environment variable usage

---

## 📋 Task Template

When requesting work from Junie, use this format:

```markdown
## Task
[Clear, single-sentence description]

## Context
- Related files: [list paths]
- Template to follow: [template path if applicable]
- Constraints: [any limitations]

## Acceptance Criteria
- [ ] Criterion 1
- [ ] Criterion 2
- [ ] All validation checks pass

## Out of Scope
- [What NOT to change]
```

---

## 🚨 Escalation Rules

Junie MUST escalate to human review when:

1. **Uncertainty**: Task requirements are unclear
2. **Risk**: Change could affect security or data integrity
3. **Scope creep**: Task requires changes beyond initial scope
4. **Conflicts**: Guidelines conflict with task requirements
5. **Failures**: Validation checks fail repeatedly

### Escalation Format

```markdown
## ⚠️ Escalation Required

**Reason**: [Why escalating]
**Options**:
1. [Option A with tradeoffs]
2. [Option B with tradeoffs]

**Recommendation**: [Your suggestion]
**Waiting for**: [What you need to proceed]
```

---

## 📚 Related Documents

- **Behavioral rules**: [guidelines.md](./guidelines.md)
- **Technical knowledge**: [skills.md](./skills.md)
- **Ready-to-use prompts**: [prompts.md](./prompts.md)
- **Automation setup**: See `AUTOMATION.md` in project root
