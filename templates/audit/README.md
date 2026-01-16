# Smart Contract Audit Template

This directory contains standards, tools, and methodologies for performing security audits on Solidity smart contracts.

## 🛡️ Audit Stack
- **Static Analysis**: [Slither](https://github.com/crytic/slither), [Aderyn](https://github.com/Cyfrin/aderyn).
- **Fuzzing & Invariants**: [Foundry (Echidna/Medusa style)](https://book.getfoundry.sh/forge/fuzz-testing).
- **Linters**: [Solhint](https://github.com/protofire/solhint), [Ethlint](https://github.com/duaraghav8/Ethlint).
- **Formal Verification**: Basics with [SMTChecker](https://docs.soliditylang.org/en/latest/smtchecker.html).
- **Documentation**: [Doxygen](https://www.doxygen.nl/) or [Solidity-docgen](https://github.com/OpenZeppelin/solidity-docgen).

## 📖 Methodology
1. **Reconnaissance**: Understand the business logic and system architecture.
2. **Static Analysis**: Automated scans to find common vulnerabilities.
3. **Manual Review**: Deep dive into the code, logic flows, and edge cases.
4. **Testing & Fuzzing**: Verify invariants and try to break the system.
5. **Reporting**: Document findings with severity, impact, and recommendations.

Refer to `CLAUDE.md` for specific audit commands and report structures.
