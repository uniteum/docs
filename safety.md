---
title: Safety & Risks
description: >-
  Important disclaimers, risk factors, and safety considerations
  for interacting with Uniteum.

# Navigation
nav_order: 3
has_children: false

# Taxonomy
categories:
  - safety

# Metadata
last_updated: 2024-12-09
version: "0.1"
status: draft
---

# Safety & Risks

Uniteum is experimental. Read this page before interacting with the protocol.

## Audit Status

**Uniteum has not been audited.**

The contracts are novel mechanism design. They have been tested but not formally verified or reviewed by third-party auditors.

## Smart Contract Risk

All smart contract interactions carry risk:

- **Bugs:** Undiscovered bugs could result in loss of funds. The contracts are immutable and cannot be patched or upgraded.
- **Exploits:** Novel mechanisms may have unexpected attack vectors

Only interact with funds you can afford to lose.

## Mechanism Risk

Uniteum's price discovery mechanism is untested at scale:

- **Unknown emergent behavior:** We don't know how the system behaves with many interconnected units
- **Arbitrage assumptions:** Price consistency depends on arbitrageurs acting rationally
- **Liquidity dynamics:** Thin liquidity can cause extreme price movements

## Symbolic Units Are Not Backed

**Critical:** Symbolic units (e.g., `foo`, `meter`) have no inherent value or backing.

- They are not pegged to anything
- They are not collateralized
- Their value comes purely from liquidity and market consensus
- A symbolic unit named `USD` has zero connection to US dollars

Only anchored units (format: `$0xAddress`) have real backing.

## Anchored Unit Risk

Anchored units are backed 1:1 by external ERC-20 tokens held by the Unit contract. Risks include:

- **Custodial risk:** You trust the Unit contract to hold backing correctly
- **Underlying token risk:** If the backing token fails, the anchored unit fails
- **Smart contract risk:** Bugs in the anchoring mechanism

## No Guarantees

Uniteum is provided as-is. The creator makes no guarantees about:

- Price stability
- Liquidity availability
- Protocol longevity
- Fitness for any purpose

## Recommendations

1. **Use Sepolia testnet first:** All contracts are deployed at identical addresses on both Mainnet and Sepolia testnet, including [Uniteum 0.0 "1"](https://sepolia.etherscan.io/address/0xC833f0B7cd7FC479DbbF6581EB4eEFc396Cf39E4#code) and the [Discount Kiosk](https://sepolia.etherscan.io/address/0x55816c3e5d999e2f45ce0146ffd89b2e78a56dc9#code). Test your operations with testnet ETH before risking real funds.
2. **Start small:** Experiment with amounts you can lose entirely
3. **Verify contracts:** Check addresses against official sources
4. **Understand before acting:** Read the [Concepts](/concepts/) section
5. **Monitor transactions:** Use Etherscan to verify what you're signing

## Reporting Issues

Found a bug or vulnerability? Contact:

- GitHub: [github.com/uniteum](https://github.com/uniteum)
- ENS: reinholdtsen.eth
