#!/bin/bash

# Script to generate custom prompts for Junie
# Usage: ./scripts/generate-prompt.sh [type] [name] [template]

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to show help
show_help() {
    echo -e "${BLUE}=== Junie Prompt Generator ===${NC}"
    echo ""
    echo "Usage: ./scripts/generate-prompt.sh [type] [name] [templates]"
    echo ""
    echo "Available types:"
    echo "  feature     - New feature"
    echo "  component   - New UI component"
    echo "  hook        - Custom React hook"
    echo "  contract    - Smart contract (Solidity)"
    echo "  test        - Test suite"
    echo "  refactor    - Code refactoring"
    echo "  review      - Code review"
    echo "  fix         - Bug fix"
    echo ""
    echo "Available templates (can use multiple separated by commas):"
    echo "  nextjs      - Next.js patterns"
    echo "  typescript  - TypeScript best practices"
    echo "  web3        - Web3 & Smart contracts"
    echo "  database    - Database & API"
    echo "  ui-shadcn   - shadcn/ui components"
    echo "  ui-tailwind - Tailwind CSS"
    echo "  audit       - Security audit"
    echo ""
    echo "Examples:"
    echo "  ./scripts/generate-prompt.sh feature wallet-connection web3"
    echo "  ./scripts/generate-prompt.sh component Button ui-shadcn,typescript"
    echo "  ./scripts/generate-prompt.sh hook useTokenBalance web3,typescript"
    echo "  ./scripts/generate-prompt.sh feature auth-system nextjs,database,typescript"
    echo ""
    echo "Interactive mode (no arguments):"
    echo "  ./scripts/generate-prompt.sh"
}

# Function for interactive mode
interactive_mode() {
    echo -e "${BLUE}=== Interactive Mode ===${NC}"
    echo ""

    # Select type
    echo "Select prompt type:"
    echo "1) Feature (new feature)"
    echo "2) Component (UI component)"
    echo "3) Hook (custom React hook)"
    echo "4) Contract (smart contract)"
    echo "5) Test (test suite)"
    echo "6) Refactor (code refactoring)"
    echo "7) Review (code review)"
    echo "8) Fix (bug fix)"
    read -p "Option (1-8): " tipo_num

    case $tipo_num in
        1) TIPO="feature" ;;
        2) TIPO="component" ;;
        3) TIPO="hook" ;;
        4) TIPO="contract" ;;
        5) TIPO="test" ;;
        6) TIPO="refactor" ;;
        7) TIPO="review" ;;
        8) TIPO="fix" ;;
        *) echo "Invalid option"; exit 1 ;;
    esac

    # Name
    read -p "Name (e.g., wallet-connection, Button, useTokenBalance): " NOMBRE

    # Select templates (multiple allowed)
    echo ""
    echo "Select templates (you can select multiple):"
    echo "1) nextjs"
    echo "2) typescript"
    echo "3) web3"
    echo "4) database"
    echo "5) ui-shadcn"
    echo "6) ui-tailwind"
    echo "7) audit"
    echo ""
    read -p "Enter template numbers separated by commas (e.g., 1,2 or 1,3,5): " template_nums

    # Convert numbers to template names
    TEMPLATE=""
    IFS=',' read -ra NUMS <<< "$template_nums"
    for num in "${NUMS[@]}"; do
        num=$(echo "$num" | xargs) # trim whitespace
        case $num in
            1) TEMPLATE="${TEMPLATE}nextjs," ;;
            2) TEMPLATE="${TEMPLATE}typescript," ;;
            3) TEMPLATE="${TEMPLATE}web3," ;;
            4) TEMPLATE="${TEMPLATE}database," ;;
            5) TEMPLATE="${TEMPLATE}ui-shadcn," ;;
            6) TEMPLATE="${TEMPLATE}ui-tailwind," ;;
            7) TEMPLATE="${TEMPLATE}audit," ;;
            *) echo "Invalid option: $num"; exit 1 ;;
        esac
    done
    # Remove trailing comma
    TEMPLATE="${TEMPLATE%,}"

    if [ -z "$TEMPLATE" ]; then
        echo "No templates selected"
        exit 1
    fi
}

# Function to generate feature prompt
generate_feature_prompt() {
    local nombre=$1
    local templates=$2

    # Format templates for display
    local template_list=""
    IFS=',' read -ra TEMPS <<< "$templates"
    for temp in "${TEMPS[@]}"; do
        template_list="${template_list}- templates/${temp}/\n"
    done

    cat << EOF
## Context
- Project: ${templates}
- Follow: .junie/guidelines.md strictly
- Templates:
$(echo -e "$template_list")
## Task
Implement ${nombre}.

## Files to Create/Modify
- [ ] [file path 1]
- [ ] [file path 2]

## Constraints
- TypeScript strict mode
- Use existing patterns from the templates above
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

## Additional Context
[Add any specific requirements or context here]
EOF
}

# Function to generate component prompt
generate_component_prompt() {
    local nombre=$1
    local templates=$2

    # Format templates for display
    local template_list=""
    IFS=',' read -ra TEMPS <<< "$templates"
    for temp in "${TEMPS[@]}"; do
        template_list="${template_list}- templates/${temp}/\n"
    done

    cat << EOF
## Context
- Component: ${nombre}
- Follow: .junie/guidelines.md
- Templates:
$(echo -e "$template_list")
## Task
Create a ${nombre} component.

## Requirements
- [ ] TypeScript with explicit types
- [ ] Accessible (ARIA attributes)
- [ ] Responsive design
- [ ] Dark mode support (if applicable)
- [ ] Compound component pattern (if complex)

## Props Interface
\`\`\`typescript
interface ${nombre}Props {
  // Define props here
}
\`\`\`

## Constraints
- Use patterns from the templates above
- Follow Prettier configuration
- No inline styles (use Tailwind/CSS modules)

## Acceptance Criteria
- [ ] Component renders correctly
- [ ] Props properly typed
- [ ] Accessible
- [ ] Responsive
- [ ] Tests included
EOF
}

# Function to generate hook prompt
generate_hook_prompt() {
    local nombre=$1
    local templates=$2

    # Format templates for display
    local template_list=""
    IFS=',' read -ra TEMPS <<< "$templates"
    for temp in "${TEMPS[@]}"; do
        template_list="${template_list}- templates/${temp}/\n"
    done

    cat << EOF
## Context
- Hook: ${nombre}
- Follow: .junie/guidelines.md
- Templates:
$(echo -e "$template_list")
## Task
Create a custom React hook ${nombre}.

## Signature
\`\`\`typescript
export function ${nombre}(/* params */): {
  // return type
}
\`\`\`

## Requirements
- [ ] TypeScript with explicit types
- [ ] Handle loading states
- [ ] Handle error states
- [ ] Cleanup on unmount (if needed)
- [ ] Memoization where appropriate

## Constraints
- Follow React hooks rules
- Use patterns from the templates above
- No side effects in render

## Acceptance Criteria
- [ ] Hook works correctly
- [ ] Proper TypeScript types
- [ ] Error handling
- [ ] Tests included
- [ ] JSDoc comments
EOF
}

# Function to generate contract prompt
generate_contract_prompt() {
    local nombre=$1

    cat << EOF
## Context
- Contract: ${nombre}
- Follow: .junie/guidelines.md
- Template: templates/web3/

## Task
Create a Solidity smart contract ${nombre}.

## Requirements
- [ ] Solidity ^0.8.24
- [ ] OpenZeppelin standards (if applicable)
- [ ] Check-Effects-Interactions pattern
- [ ] Gas optimized
- [ ] NatSpec comments

## Security Checklist
- [ ] Reentrancy protection
- [ ] Access control
- [ ] Integer overflow/underflow handled
- [ ] No timestamp dependence
- [ ] Events for state changes

## Constraints
- Use OpenZeppelin contracts
- Follow patterns from templates/web3/
- Foundry for testing

## Acceptance Criteria
- [ ] Contract compiles
- [ ] Foundry tests with high coverage
- [ ] Gas optimized
- [ ] Security best practices followed
- [ ] NatSpec documentation complete
EOF
}

# Function to generate test prompt
generate_test_prompt() {
    local nombre=$1
    local templates=$2

    # Format templates for display
    local template_list=""
    IFS=',' read -ra TEMPS <<< "$templates"
    for temp in "${TEMPS[@]}"; do
        template_list="${template_list}- templates/${temp}/\n"
    done

    cat << EOF
## Context
- Test for: ${nombre}
- Follow: .junie/guidelines.md
- Templates:
$(echo -e "$template_list")
## Task
Create comprehensive tests for ${nombre}.

## Test Cases to Cover
- [ ] Happy path
- [ ] Edge cases
- [ ] Error cases
- [ ] Boundary conditions

## Requirements
- [ ] High coverage (>80%)
- [ ] Clear test descriptions
- [ ] Arrange-Act-Assert pattern
- [ ] Mock external dependencies

## Constraints
- Use Vitest (or Foundry for contracts)
- Follow patterns from the templates above

## Acceptance Criteria
- [ ] All tests pass
- [ ] Coverage >80%
- [ ] Clear test names
- [ ] No flaky tests
EOF
}

# Function to generate refactor prompt
generate_refactor_prompt() {
    local nombre=$1
    local templates=$2

    # Format templates for display
    local template_list=""
    IFS=',' read -ra TEMPS <<< "$templates"
    for temp in "${TEMPS[@]}"; do
        template_list="${template_list}- templates/${temp}/\n"
    done

    cat << EOF
## Context
- Target: ${nombre}
- Follow: .junie/guidelines.md
- Templates:
$(echo -e "$template_list")
## Task
Refactor ${nombre} to improve code quality.

## Goals
- [ ] Improve readability
- [ ] Reduce complexity
- [ ] Better type safety
- [ ] Follow established patterns

## Constraints
- Maintain existing functionality
- Don't break existing tests
- Use patterns from the templates above
- No new dependencies

## Acceptance Criteria
- [ ] All existing tests still pass
- [ ] Code is more readable
- [ ] Better TypeScript types
- [ ] Follows project patterns
- [ ] No regressions
EOF
}

# Function to generate review prompt
generate_review_prompt() {
    local nombre=$1
    local templates=$2

    # Format templates for display
    local template_list=""
    IFS=',' read -ra TEMPS <<< "$templates"
    for temp in "${TEMPS[@]}"; do
        template_list="${template_list}- templates/${temp}/\n"
    done

    cat << EOF
## Context
- Review: ${nombre}
- Follow: .junie/guidelines.md
- Templates:
$(echo -e "$template_list")
## Task
Review code for quality and security issues.

## Check For
- [ ] Code quality (readability, maintainability)
- [ ] TypeScript types (no any, proper types)
- [ ] Security issues (input validation, XSS, etc.)
- [ ] Performance issues
- [ ] Pattern consistency with the templates above
- [ ] Error handling
- [ ] Test coverage

## Output Format
List issues with:
- Severity: [Critical/High/Medium/Low]
- Location: [file:line]
- Issue: [description]
- Fix: [recommendation]

## Additional Checks
- [ ] Follows .prettierrc formatting
- [ ] No ESLint errors
- [ ] Follows Conventional Commits (if reviewing commits)
EOF
}

# Function to generate fix prompt
generate_fix_prompt() {
    local nombre=$1
    local templates=$2

    # Format templates for display
    local template_list=""
    IFS=',' read -ra TEMPS <<< "$templates"
    for temp in "${TEMPS[@]}"; do
        template_list="${template_list}- templates/${temp}/\n"
    done

    cat << EOF
## Context
- Bug: ${nombre}
- Follow: .junie/guidelines.md
- Templates:
$(echo -e "$template_list")
## Bug Description
[Describe the bug here]

## Steps to Reproduce
1. [Step 1]
2. [Step 2]
3. [Step 3]

## Expected Behavior
[What should happen]

## Actual Behavior
[What actually happens]

## Constraints
- Fix root cause, not symptoms
- Add test to prevent regression
- Use patterns from the templates above

## Acceptance Criteria
- [ ] Bug is fixed
- [ ] Root cause addressed
- [ ] Regression test added
- [ ] No new bugs introduced
- [ ] All tests pass
EOF
}

# Main script
main() {
    # If no arguments, interactive mode
    if [ $# -eq 0 ]; then
        interactive_mode
    elif [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
        show_help
        exit 0
    else
        TIPO=$1
        NOMBRE=$2
        TEMPLATE=$3

        if [ -z "$NOMBRE" ] || [ -z "$TEMPLATE" ]; then
            echo -e "${YELLOW}Error: Missing arguments${NC}"
            show_help
            exit 1
        fi
    fi

    echo -e "${GREEN}Generating prompt...${NC}"
    echo ""

    # Generate prompt by type
    case $TIPO in
        feature)
            generate_feature_prompt "$NOMBRE" "$TEMPLATE"
            ;;
        component)
            generate_component_prompt "$NOMBRE" "$TEMPLATE"
            ;;
        hook)
            generate_hook_prompt "$NOMBRE" "$TEMPLATE"
            ;;
        contract)
            generate_contract_prompt "$NOMBRE"
            ;;
        test)
            generate_test_prompt "$NOMBRE" "$TEMPLATE"
            ;;
        refactor)
            generate_refactor_prompt "$NOMBRE" "$TEMPLATE"
            ;;
        review)
            generate_review_prompt "$NOMBRE" "$TEMPLATE"
            ;;
        fix)
            generate_fix_prompt "$NOMBRE" "$TEMPLATE"
            ;;
        *)
            echo -e "${YELLOW}Unknown type: $TIPO${NC}"
            show_help
            exit 1
            ;;
    esac

    echo ""
    echo -e "${GREEN}✅ Prompt generated successfully${NC}"
    echo -e "${BLUE}Copy the text above and paste it into Junie${NC}"
}

# Execute main
main "$@"
