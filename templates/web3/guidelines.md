# Web3 & dApp Development Guidelines

Guidelines for building decentralized applications (dApps) and secure smart contracts using modern Ethereum-based technologies, Solidity, and Web3 integration libraries.

## Language & Code Standards

**MANDATORY**: All code, comments, documentation, variable names, function names, and commit messages must be in **English**.

## Core Principles

### Smart Contract Development
- **Security first** - Follow Check-Effects-Interactions pattern, use audited standards
- **Gas optimization** - Use `immutable`/`constant`, prefer `uint256`, use `external` for non-internal functions
- **OpenZeppelin standards** - Use audited implementations for tokens and access control
- **Comprehensive testing** - Target high coverage with Foundry fuzzing

### dApp Integration
- **Type-safe contracts** - Use Viem for type safety from ABI to UI
- **Transaction simulation** - Always simulate before execution to prevent failures
- **Secure authentication** - Implement SIWE (Sign-In with Ethereum) for gasless identity verification
- **Error handling** - Decode custom errors for user-friendly feedback

## Smart Contract Development

### Foundry & Hardhat

**Foundry** - Preferred for fast testing and local development
**Hardhat** - Use for complex deployment pipelines and network management

```solidity
// contracts/MyToken.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MyToken is ERC20, Ownable {
    constructor(uint256 initialSupply) ERC20("MyToken", "MTK") Ownable(msg.sender) {
        _mint(msg.sender, initialSupply);
    }
}
```

### Security Patterns

#### Check-Effects-Interactions Pattern
Always follow this order to prevent reentrancy:
1. **Check** - Validate conditions and inputs
2. **Effects** - Update state variables
3. **Interactions** - Call external contracts

```solidity
function withdraw(uint256 amount) external {
    // Check
    require(balances[msg.sender] >= amount, "Insufficient balance");
    
    // Effects
    balances[msg.sender] -= amount;
    
    // Interactions
    (bool success, ) = msg.sender.call{value: amount}("");
    require(success, "Transfer failed");
}
```

#### Gas Optimization
- Use `immutable` for values set in constructor
- Use `constant` for compile-time constants
- Prefer `uint256` over smaller uints (unless packing in structs)
- Use `external` for functions not called internally
- Minimize storage operations (SSTORE is expensive)
- Use `calldata` instead of `memory` for external function parameters

#### Access Control
```solidity
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

// Simple owner-only
contract MyContract is Ownable {
    function adminFunction() external onlyOwner {
        // Only owner can call
    }
}

// Role-based access control
contract MyContract is AccessControl {
    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");
    
    constructor() {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }
    
    function adminFunction() external onlyRole(ADMIN_ROLE) {
        // Only admins can call
    }
}
```

### Testing with Foundry

```solidity
// test/MyToken.t.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import "../src/MyToken.sol";

contract MyTokenTest is Test {
    MyToken token;
    address user = address(0x1);
    
    function setUp() public {
        token = new MyToken(1000000);
    }
    
    function testInitialSupply() public {
        assertEq(token.totalSupply(), 1000000);
    }
    
    // Fuzz testing
    function testFuzzTransfer(address to, uint256 amount) public {
        vm.assume(to != address(0));
        vm.assume(amount <= token.balanceOf(address(this)));
        
        token.transfer(to, amount);
        assertEq(token.balanceOf(to), amount);
    }
}
```

## dApp Integration (Viem + Wagmi + AppKit)

### Provider & Config Setup

Centralize wagmi/viem configuration using AppKit for WalletConnect support:

```typescript
// lib/wagmi.ts
import { createAppKit } from '@reown/appkit/react'
import { WagmiAdapter } from '@reown/appkit-adapter-wagmi'
import { mainnet, sepolia } from '@reown/appkit/networks'

export const projectId = process.env.NEXT_PUBLIC_WALLETCONNECT_PROJECT_ID!

export const networks = [mainnet, sepolia]

export const wagmiAdapter = new WagmiAdapter({
  projectId,
  networks
})

createAppKit({
  adapters: [wagmiAdapter],
  networks,
  projectId,
  features: {
    analytics: true
  }
})
```

### Feature-Based Smart Contract Integration

Organize blockchain logic within features directory:

```text
src/features/[feature-name]/
├── contracts/      # ABIs and contract addresses
├── hooks/          # useWatchContract, useSubmitTransaction
├── components/     # AppKitButton (Connect Wallet), TransactionStatus
└── actions.ts      # SIWE authentication actions
```

### Type-Safe Contract Interactions

```typescript
// contracts/mytoken.ts
import { parseAbi } from 'viem'

export const myTokenAbi = parseAbi([
  'function balanceOf(address owner) view returns (uint256)',
  'function transfer(address to, uint256 amount) returns (bool)',
  'event Transfer(address indexed from, address indexed to, uint256 value)'
]) as const

export const myTokenAddress = '0x...' as const
```

```typescript
// hooks/useTokenBalance.ts
import { useReadContract } from 'wagmi'
import { myTokenAbi, myTokenAddress } from '../contracts/mytoken'

export function useTokenBalance(address: `0x${string}` | undefined) {
  return useReadContract({
    address: myTokenAddress,
    abi: myTokenAbi,
    functionName: 'balanceOf',
    args: address ? [address] : undefined,
    query: {
      enabled: !!address,
    }
  })
}
```

### Transaction Simulation & Execution

Always simulate transactions before execution:

```typescript
// hooks/useTransferToken.ts
import { useSimulateContract, useWriteContract, useWaitForTransactionReceipt } from 'wagmi'
import { myTokenAbi, myTokenAddress } from '../contracts/mytoken'

export function useTransferToken() {
  const { data: simulateData } = useSimulateContract({
    address: myTokenAddress,
    abi: myTokenAbi,
    functionName: 'transfer',
    args: [to, amount],
  })
  
  const { writeContract, data: hash } = useWriteContract()
  
  const { isLoading, isSuccess } = useWaitForTransactionReceipt({
    hash,
  })
  
  const transfer = () => {
    if (simulateData?.request) {
      writeContract(simulateData.request)
    }
  }
  
  return { transfer, isLoading, isSuccess, hash }
}
```

### Multicall for Batch Reads

Use `useReadContracts` for batching multiple reads:

```typescript
import { useReadContracts } from 'wagmi'

const { data } = useReadContracts({
  contracts: [
    {
      address: myTokenAddress,
      abi: myTokenAbi,
      functionName: 'balanceOf',
      args: [address1],
    },
    {
      address: myTokenAddress,
      abi: myTokenAbi,
      functionName: 'balanceOf',
      args: [address2],
    },
  ],
})
```

### Watch Contract Events

```typescript
import { useWatchContractEvent } from 'wagmi'

useWatchContractEvent({
  address: myTokenAddress,
  abi: myTokenAbi,
  eventName: 'Transfer',
  onLogs(logs) {
    console.log('New transfer:', logs)
  },
})
```

## SIWE (Sign-In with Ethereum)

Implement secure, gasless authentication:

```typescript
// lib/siwe.ts
import { SiweMessage } from 'siwe'

export async function createSiweMessage(address: string, nonce: string) {
  const message = new SiweMessage({
    domain: window.location.host,
    address,
    statement: 'Sign in with Ethereum to the app.',
    uri: window.location.origin,
    version: '1',
    chainId: 1,
    nonce,
    issuedAt: new Date().toISOString(),
    expirationTime: new Date(Date.now() + 24 * 60 * 60 * 1000).toISOString(), // 24 hours
  })
  
  return message.prepareMessage()
}
```

```typescript
// Server action for verification
'use server'
import { SiweMessage } from 'siwe'

export async function verifySiweMessage(message: string, signature: string) {
  try {
    const siweMessage = new SiweMessage(message)
    const result = await siweMessage.verify({ signature })
    
    if (result.success) {
      // Create session, set cookie, etc.
      return { success: true, address: siweMessage.address }
    }
    
    return { success: false, error: 'Invalid signature' }
  } catch (error) {
    return { success: false, error: 'Verification failed' }
  }
}
```

## Security Best Practices

### Smart Contract Security
- **Reentrancy guards** - Use OpenZeppelin's ReentrancyGuard
- **Integer overflow** - Use Solidity 0.8+ (built-in overflow checks)
- **Access control** - Implement proper role-based permissions
- **Input validation** - Validate all external inputs
- **External calls** - Follow Check-Effects-Interactions pattern
- **Static analysis** - Use Slither and Aderyn
- **Fuzzing** - Use Foundry's fuzzing for edge cases
- **Invariant testing** - Target 100% invariant coverage for critical state

### dApp Security
- **Transaction simulation** - Always simulate via RPC before execution
- **Phishing protection** - Verify domain in SIWE, use trusted providers
- **Address validation** - Use `isAddress` from viem before operations
- **Secret management** - Never hardcode private keys, use environment variables
- **Rate limiting** - Implement on API routes
- **SIWE security** - Include nonce (replay protection), domain (phishing protection), and expiration

## Testing Strategy

### Smart Contracts
- **Unit tests** - Test individual functions
- **Integration tests** - Test contract interactions
- **Fuzz testing** - Use Foundry's fuzzing for edge cases
- **Invariant testing** - Define and test system invariants
- **Gas optimization tests** - Benchmark gas usage
- **Coverage** - Target 100% branch coverage for critical contracts

### dApp
- **Component tests** - React Testing Library for UI components
- **Hook tests** - Test custom wagmi hooks
- **E2E tests** - Playwright with local testnet
- **Transaction simulation** - Test all transaction flows

## Common Patterns

### Error Decoding

```typescript
import { decodeErrorResult } from 'viem'

try {
  await writeContract(...)
} catch (error) {
  const decodedError = decodeErrorResult({
    abi: myTokenAbi,
    data: error.data,
  })
  console.error('Contract error:', decodedError)
}
```

### ENS Integration

```typescript
import { useEnsName, useEnsAvatar } from 'wagmi'

export function UserProfile({ address }: { address: `0x${string}` }) {
  const { data: ensName } = useEnsName({ address })
  const { data: ensAvatar } = useEnsAvatar({ name: ensName })
  
  return (
    <div>
      {ensAvatar && <img src={ensAvatar} alt={ensName || address} />}
      <span>{ensName || address}</span>
    </div>
  )
}
```

## Deployment

### Foundry Deployment

```bash
forge script script/Deploy.s.sol:DeployScript --rpc-url $RPC_URL --broadcast --verify
```

### Hardhat Deployment

```typescript
// scripts/deploy.ts
import { ethers } from "hardhat"

async function main() {
  const MyToken = await ethers.getContractFactory("MyToken")
  const token = await MyToken.deploy(1000000)
  await token.waitForDeployment()
  
  console.log("MyToken deployed to:", await token.getAddress())
}

main().catch((error) => {
  console.error(error)
  process.exitCode = 1
})
```

## Resources

- [Viem Documentation](https://viem.sh)
- [Wagmi Documentation](https://wagmi.sh)
- [AppKit Documentation](https://docs.reown.com/appkit)
- [SIWE Documentation](https://login.xyz/)
- [Foundry Book](https://book.getfoundry.sh/)
- [Hardhat Documentation](https://hardhat.org/docs)
- [OpenZeppelin Contracts](https://docs.openzeppelin.com/contracts/)
- [Solidity Documentation](https://docs.soliditylang.org/)

---

**Remember: Decentralized, Typed, Secure, and Gas-Efficient!**
