# AI Prompts Library

Ready-to-use prompts for common tasks with Junie. Copy, paste, and customize.

---

## 🚀 Implementation Prompts

### New Feature Implementation

```markdown
## Context
- Project: [Next.js/Web3/Database]
- Follow: .junie/guidelines.md strictly
- Template: templates/[relevant-template]/

## Task
Implement [feature description].

## Files to Create/Modify
- [ ] [file path 1]
- [ ] [file path 2]

## Constraints
- TypeScript strict mode
- Use existing patterns from templates/
- No new dependencies without approval
- pnpm only

## Acceptance Criteria
- [ ] All types explicit
- [ ] Zod validation for inputs
- [ ] Error handling complete
- [ ] Tests included
```

### Isolated Function

```markdown
## Context
- File: [exact file path]
- Follow: .junie/guidelines.md

## Task
Create a function that [description].

## Signature
function [name]([params]): [return type]

## Constraints
- Pure function preferred
- No side effects
- Handle edge cases
- Include JSDoc

## Examples
Input: [example input]
Output: [expected output]
```

---

## 🔍 Code Review Prompts

### Security Review

```markdown
## Context
- Project type: [Web3/Next.js/API]
- Follow: .junie/guidelines.md

## Task
Review this code for security issues:

[paste code or file path]

## Check For
- [ ] Input validation (Zod)
- [ ] SQL/NoSQL injection
- [ ] XSS vulnerabilities
- [ ] Authentication gaps
- [ ] Authorization flaws
- [ ] Sensitive data exposure
- [ ] Error information leakage

## Output Format
List issues with:
- Severity: [Critical/High/Medium/Low]
- Location: [file:line]
- Issue: [description]
- Fix: [recommendation]
```

### Web3 Security Review

```markdown
## Context
- Contract: [file path]
- Follow: .junie/skills.md (Web3 section)

## Task
Review for Web3-specific vulnerabilities:

## Check For
- [ ] Reentrancy
- [ ] Integer overflow/underflow
- [ ] Access control
- [ ] Front-running susceptibility
- [ ] Oracle manipulation
- [ ] Gas griefing
- [ ] Timestamp dependence
- [ ] Unchecked external calls

## Output Format
- Issue + SWC ID if applicable
- Severity assessment
- Proof of concept (if possible)
- Recommended fix
```

### General Code Review

```markdown
## Context
- Follow: .junie/guidelines.md

## Task
Review this code for quality issues:

[paste code or file path]

## Check For
- [ ] TypeScript best practices
- [ ] Error handling
- [ ] Code readability
- [ ] Performance concerns
- [ ] Testing coverage
- [ ] Documentation gaps

## Rules
- Do NOT rewrite unless critical
- Explain reasoning for each suggestion
- Prioritize by impact
```

---

## 🔧 Refactoring Prompts

### Extract Function

```markdown
## Context
- File: [file path]
- Follow: .junie/guidelines.md

## Task
Extract [description] into a separate function.

## Current Code
[paste code block]

## Requirements
- Maintain existing behavior
- Add proper types
- Include JSDoc
- Add unit test
```

### Modernize Code

```markdown
## Context
- File: [file path]
- Target: [React 19/TypeScript 5/etc.]

## Task
Modernize this code following current best practices.

## Current Code
[paste code]

## Constraints
- No breaking changes
- Keep same public API
- Add types if missing
- Update deprecated patterns
```

---

## 🧪 Testing Prompts

### Unit Tests

```markdown
## Context
- File to test: [file path]
- Test framework: Vitest
- Follow: .junie/guidelines.md

## Task
Write unit tests for [function/component name].

## Requirements
- Test happy path
- Test edge cases
- Test error conditions
- Use descriptive test names
- Mock external dependencies

## Output
Create: [test file path]
```

### Integration Tests

```markdown
## Context
- Feature: [feature name]
- Test framework: Vitest
- Follow: .junie/guidelines.md

## Task
Write integration tests for [feature description].

## Scope
- [ ] API endpoints involved
- [ ] Database interactions
- [ ] External services (mocked)

## Requirements
- Setup/teardown properly
- Isolate test data
- Test realistic scenarios
```

---

## 📝 Documentation Prompts

### API Documentation

```markdown
## Context
- File: [file path]
- Follow: .junie/guidelines.md

## Task
Document the API for [module/function].

## Include
- Purpose/description
- Parameters with types
- Return value
- Exceptions/errors
- Usage examples
- Edge cases

## Format
JSDoc for code, Markdown for README
```

### Architecture Decision Record

```markdown
## Context
- Decision: [what was decided]
- Date: [date]

## Task
Create an ADR documenting this decision.

## Include
- Context: Why this decision was needed
- Decision: What was decided
- Alternatives: What else was considered
- Consequences: Tradeoffs and implications
- Status: [Proposed/Accepted/Deprecated]
```

---

## 🌐 Web3 Specific Prompts

### Contract Interaction

```markdown
## Context
- Contract: [address or file]
- Network: [chain name]
- Follow: .junie/skills.md (Web3 section)

## Task
Implement [interaction description].

## Constraints
- Use viem for primitives
- Use wagmi hooks for React
- Validate chainId before interaction
- Handle all error cases
- Include transaction simulation

## Error Handling
- RPC errors
- User rejection
- Insufficient funds
- Contract reverts (decode errors)
```

### Contract Testing

```markdown
## Context
- Contract: [file path]
- Framework: Foundry
- Follow: .junie/skills.md (Auditor section)

## Task
Write tests for [contract/function].

## Requirements
- Unit tests for each function
- Fuzz tests for numeric inputs
- Invariant tests for critical state
- Test access control
- Test edge cases

## Coverage Target
- Line: 100%
- Branch: 100%
- Invariants: All identified
```

---

## 🗄️ Database Prompts

### Prisma Schema

```markdown
## Context
- Project: [project name]
- Follow: .junie/skills.md (Database section)

## Task
Create/modify Prisma schema for [entity].

## Requirements
- Proper relations
- Indexes for common queries
- Soft delete if applicable
- Timestamps (createdAt, updatedAt)
- Zod schema for validation

## Output
- schema.prisma changes
- Corresponding Zod schema
- Migration command
```

### Query Optimization

```markdown
## Context
- File: [file with query]
- Follow: .junie/skills.md (Database section)

## Task
Optimize this database query:

[paste query or code]

## Check For
- N+1 problems
- Missing indexes
- Unnecessary data fetching
- Inefficient joins
- Caching opportunities

## Output
- Optimized query
- Explanation of changes
- Index recommendations
```

---

## 📌 Quick Reference

### Minimal Implementation Prompt

```markdown
Context: [project type], follow .junie/guidelines.md
Task: [one sentence]
File: [path]
Constraints: TypeScript, existing patterns, pnpm
```

### Minimal Review Prompt

```markdown
Context: follow .junie/guidelines.md
Review: [file path or paste code]
Focus: [security/quality/performance]
Output: issues with severity and fixes
```

---

## 📚 Related Documents

- **Behavioral rules**: [guidelines.md](./guidelines.md)
- **Technical knowledge**: [skills.md](./skills.md)
- **Task boundaries**: [workflow.md](./workflow.md)
