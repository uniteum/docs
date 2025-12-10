---
title: Contracts
description: >-
  Deployed contract addresses, verification links,
  and deployment details for Uniteum.

# Navigation
nav_order: 1
parent: Reference
has_children: false

# Taxonomy
categories:
  - development

# Metadata
last_updated: 2024-12-09
version: "0.1"
status: draft
---

# Contracts

All Uniteum contracts are deployed using Nick's deterministic deployer, resulting in identical addresses across networks.

## Core Contracts

### Uniteum 0.1 "1"

The current version with full Uniteum functionality.

| Network | Address |
|---------|---------|
| Mainnet | `0x9df9b0501e8f6c05623b5b519f9f18b598d9b253` |
| Sepolia | `0x9df9b0501e8f6c05623b5b519f9f18b598d9b253` |

- [Mainnet Etherscan](https://etherscan.io/address/0x9df9b0501e8f6c05623b5b519f9f18b598d9b253)
- [Sepolia Etherscan](https://sepolia.etherscan.io/address/0x9df9b0501e8f6c05623b5b519f9f18b598d9b253)

### Uniteum 0.0 "1" (Genesis)

The genesis token—a simple ERC-20 holding the initial 1 billion supply.

| Network | Address |
|---------|---------|
| Mainnet | `0xC833f0B7cd7FC479DbbF6581EB4eEFc396Cf39E4` |
| Sepolia | `0xC833f0B7cd7FC479DbbF6581EB4eEFc396Cf39E4` |

- [Mainnet Etherscan](https://etherscan.io/address/0xC833f0B7cd7FC479DbbF6581EB4eEFc396Cf39E4)
- [Sepolia Etherscan](https://sepolia.etherscan.io/address/0xC833f0B7cd7FC479DbbF6581EB4eEFc396Cf39E4)

### Discount Kiosk

Sells genesis "1" tokens at a linear discount.

| Network | Address |
|---------|---------|
| Mainnet | `0x55816c3e5d999e2f45ce0146ffd89b2e78a56dc9` |
| Sepolia | `0x55816c3e5d999e2f45ce0146ffd89b2e78a56dc9` |

- [Mainnet Etherscan](https://etherscan.io/address/0x55816c3e5d999e2f45ce0146ffd89b2e78a56dc9)
- [Sepolia Etherscan](https://sepolia.etherscan.io/address/0x55816c3e5d999e2f45ce0146ffd89b2e78a56dc9)

## Deployment

### Deployer

Nick's deterministic deployment method ensures identical addresses across any EVM chain.

**Deployer EOA:** `0xff96a8c70dcc85a0cc4d690bfc02166a90e71004` (0.eoa.uniteum.eth)

### Architecture

- **Minimal proxy clones:** EIP-1167 for gas-efficient unit deployment
- **CREATE2:** Deterministic address derivation from symbol hash
- **Solidity:** 0.8.30
- **Framework:** Foundry

## Verification

All contracts are verified on Etherscan. Source code available at [github.com/uniteum](https://github.com/uniteum).

## Audit Status

**Not audited.** See [Safety](/safety/).
