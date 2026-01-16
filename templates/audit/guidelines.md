# Smart Contract Security Audit Guidelines

Guidelines for conducting comprehensive security audits of smart contracts using static analysis, fuzzing, manual review, and vulnerability research.

## Language & Code Standards

**MANDATORY**: All code, comments, documentation, variable names, function names, and commit messages must be in **English**.

## Core Principles

- **Don't trust, verify** - Systematic hunting for edge cases, logic flaws, and architectural weaknesses
- **Defense in depth** - Multiple layers of security controls
- **Fail securely** - Ensure failures don't compromise security
- **Least privilege** - Grant minimum necessary permissions
- **Complete coverage** - Test all code paths and edge cases

## Audit Methodology

### 1. Reconnaissance Phase

- **Understand the protocol** - Read documentation, whitepaper, and specifications
- **Identify critical functions** - Focus on value transfer, access control, and state changes
- **Map attack surface** - External functions, user inputs, external calls
- **Review previous audits** - Learn from past findings

### 2. Automated Analysis

#### Static Analysis Tools

**Slither** - Python-based static analyzer
```bash
slither . --print human-summary
slither . --detect all
slither . --print inheritance-graph
```

**Aderyn** - Rust-based static analyzer
```bash
aderyn .
```

**Mythril** - Symbolic execution tool
```bash
myth analyze contracts/MyContract.sol
```

#### Common Vulnerabilities to Check

- Reentrancy attacks
- Integer overflow/underflow
- Access control issues
- Unprotected functions
- Denial of service vectors
- Front-running vulnerabilities
- Oracle manipulation
- Flash loan attacks

### 3. Fuzzing & Property Testing

#### Foundry Fuzzing

```solidity
// test/MyContract.t.sol
import "forge-std/Test.sol";

contract MyContractTest is Test {
    // Fuzz test with random inputs
    function testFuzz_Transfer(address to, uint256 amount) public {
        vm.assume(to != address(0));
        vm.assume(amount <= token.balanceOf(address(this)));
        
        token.transfer(to, amount);
        assertEq(token.balanceOf(to), amount);
    }
    
    // Invariant test
    function invariant_TotalSupplyConstant() public {
        assertEq(token.totalSupply(), INITIAL_SUPPLY);
    }
}
```

#### Echidna Property Testing

```solidity
contract EchidnaTest {
    MyContract target;
    
    constructor() {
        target = new MyContract();
    }
    
    // Property: balance should never exceed total supply
    function echidna_balance_not_exceed_supply() public view returns (bool) {
        return target.balanceOf(address(this)) <= target.totalSupply();
    }
}
```

### 4. Manual Code Review

#### Security Checklist

**Access Control**
- [ ] Are all privileged functions properly protected?
- [ ] Is role-based access control implemented correctly?
- [ ] Can ownership be transferred safely?
- [ ] Are there any unprotected initialization functions?

**Reentrancy**
- [ ] Does the contract follow Check-Effects-Interactions pattern?
- [ ] Are reentrancy guards used where needed?
- [ ] Are external calls made after state changes?

**Integer Arithmetic**
- [ ] Is Solidity 0.8+ used (built-in overflow checks)?
- [ ] Are SafeMath operations used if on older versions?
- [ ] Are there any unchecked blocks that could overflow?

**External Calls**
- [ ] Are return values of external calls checked?
- [ ] Is gas forwarding handled correctly?
- [ ] Are delegatecall targets validated?

**Gas Optimization vs Security**
- [ ] Do gas optimizations compromise security?
- [ ] Are there any gas griefing vectors?
- [ ] Can transactions be DOS'd by gas limits?

**Oracle & Price Manipulation**
- [ ] Are price oracles manipulation-resistant?
- [ ] Is there protection against flash loan attacks?
- [ ] Are time-weighted average prices (TWAP) used?

**Front-Running**
- [ ] Are there front-running vulnerabilities?
- [ ] Is commit-reveal scheme used where needed?
- [ ] Are slippage protections in place?

### 5. Invariant Testing

Define and test system invariants:

```solidity
contract InvariantTest is Test {
    MyContract target;
    
    function setUp() public {
        target = new MyContract();
    }
    
    // Invariant: Total supply should never change
    function invariant_totalSupply() public {
        assertEq(target.totalSupply(), INITIAL_SUPPLY);
    }
    
    // Invariant: Sum of all balances equals total supply
    function invariant_balanceSum() public {
        uint256 sum = 0;
        for (uint i = 0; i < users.length; i++) {
            sum += target.balanceOf(users[i]);
        }
        assertEq(sum, target.totalSupply());
    }
}
```

## Common Vulnerability Patterns

### Reentrancy

```solidity
// VULNERABLE
function withdraw(uint256 amount) external {
    require(balances[msg.sender] >= amount);
    (bool success, ) = msg.sender.call{value: amount}("");
    require(success);
    balances[msg.sender] -= amount; // State change after external call
}

// SECURE
function withdraw(uint256 amount) external nonReentrant {
    require(balances[msg.sender] >= amount);
    balances[msg.sender] -= amount; // State change before external call
    (bool success, ) = msg.sender.call{value: amount}("");
    require(success);
}
```

### Access Control

```solidity
// VULNERABLE
function setOwner(address newOwner) external {
    owner = newOwner; // Anyone can call
}

// SECURE
function setOwner(address newOwner) external onlyOwner {
    require(newOwner != address(0), "Invalid address");
    owner = newOwner;
}
```

### Unchecked External Calls

```solidity
// VULNERABLE
function transferTokens(address token, address to, uint256 amount) external {
    IERC20(token).transfer(to, amount); // Return value not checked
}

// SECURE
function transferTokens(address token, address to, uint256 amount) external {
    bool success = IERC20(token).transfer(to, amount);
    require(success, "Transfer failed");
}
```

### Oracle Manipulation

```solidity
// VULNERABLE
function getPrice() public view returns (uint256) {
    return token.balanceOf(pool) / eth.balanceOf(pool); // Spot price
}

// SECURE
function getPrice() public view returns (uint256) {
    return priceOracle.getTWAP(token, 3600); // Time-weighted average
}
```

## Testing Strategy

### Coverage Goals

- **Line coverage**: 100% for critical contracts
- **Branch coverage**: 100% for critical paths
- **Function coverage**: 100%
- **Invariant coverage**: 100% for critical state

### Test Types

1. **Unit tests** - Test individual functions
2. **Integration tests** - Test contract interactions
3. **Fuzz tests** - Random input testing
4. **Invariant tests** - System-wide properties
5. **Scenario tests** - Real-world use cases
6. **Stress tests** - Edge cases and limits

## Audit Report Structure

### Executive Summary
- Project overview
- Audit scope
- Methodology
- Key findings summary
- Risk assessment

### Detailed Findings

For each finding:
- **Severity**: Critical / High / Medium / Low / Informational
- **Title**: Brief description
- **Description**: Detailed explanation
- **Impact**: Potential consequences
- **Location**: File and line numbers
- **Recommendation**: How to fix
- **Status**: Fixed / Acknowledged / Disputed

### Severity Classification

**Critical**
- Direct loss of funds
- Unauthorized access to funds
- Protocol insolvency

**High**
- Indirect loss of funds
- Privilege escalation
- State corruption

**Medium**
- Temporary DOS
- Griefing attacks
- Information disclosure

**Low**
- Best practice violations
- Code quality issues
- Gas optimizations

**Informational**
- Code style
- Documentation
- Suggestions

## Tools & Resources

### Static Analysis
- [Slither](https://github.com/crytic/slither)
- [Aderyn](https://github.com/Cyfrin/aderyn)
- [Mythril](https://github.com/ConsenSys/mythril)

### Fuzzing
- [Foundry](https://book.getfoundry.sh/forge/fuzz-testing)
- [Echidna](https://github.com/crytic/echidna)

### References
- [SWC Registry](https://swcregistry.io/)
- [Smart Contract Weakness Classification](https://github.com/SmartContractSecurity/SWC-registry)
- [Consensys Best Practices](https://consensys.github.io/smart-contract-best-practices/)
- [OpenZeppelin Contracts](https://docs.openzeppelin.com/contracts/)

## Best Practices

1. **Follow Check-Effects-Interactions** - Always update state before external calls
2. **Use audited libraries** - OpenZeppelin, Solmate for standard implementations
3. **Implement access control** - Use Ownable or AccessControl patterns
4. **Add reentrancy guards** - Protect state-changing functions
5. **Validate inputs** - Check all parameters and conditions
6. **Handle errors properly** - Use require/revert with clear messages
7. **Test extensively** - Aim for 100% coverage on critical code
8. **Document assumptions** - Make security assumptions explicit
9. **Keep it simple** - Complexity increases attack surface
10. **Stay updated** - Follow security advisories and new attack vectors

---

**Remember: Security is not a feature, it's a requirement!**
