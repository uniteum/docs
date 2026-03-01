---
title: Introduction
description: >-
  Three independent protocols for creating, trading, and composing tokens on Ethereum.
  No governance. No oracles. Just math.

# Navigation
nav_order: 1
has_children: false

# Metadata
last_updated: 2026-03-01
status: draft
---

# uniteum.one

Three independent protocols for creating, trading, and composing tokens on Ethereum.

Each protocol is permissionless, immutable, and governed entirely by on-chain math—no admin keys, no governance, no oracles.

---

## [Solid](/solid/) — Fair-Launch Tokens

**Make a token that starts fair, stays tradeable, and never goes to zero.**

A single transaction creates a token, its trading pool, a fair starting price, and a permanent price floor. 100% of the supply begins in the pool. The maker buys in like everyone else.

- Always tradeable, always liquid
- Permanent price floor via virtual reserve
- No free allocation, no operator, no governance

---

## [Liquid](/liquid/) — Liquidity Wrappers

**Wrap any ERC-20 with built-in liquidity. Zero fees, no LP tokens.**

Every Liquid token is both a standard ERC-20 and its own AMM. Deposits create instant tradeable depth through the 2x mint pattern. All Liquid tokens connect through a Hub token, enabling cross-pool swaps—100 tokens need 100 pools, not 5,000.

- Zero fees, hardcoded forever
- Automatic liquidity on every deposit
- Universal cross-swap via Hub routing

---

## [Uniteum](/uniteum/) — Algebraic Liquidity

**Tokens with dimensional units that compose like physics: `meter/second`, `USD/BTC`, `foo*bar`.**

The notation is the price relationship. One operation—**forge**—maintains algebraic consistency through arbitrage. Build custom derivatives with any power profile. No oracles needed.

- Geometric mean triads: every forge operates on (U, V, √(U*V))
- Arbitrary power perpetuals (0.5x, 1x, 2x, custom exponents)
- Infinite interconnected pools through algebraic composition

---

## Common Thread

All three protocols share a design philosophy: simple on-chain primitives with complex emergent behavior. No governance tokens, no admin keys, no upgrade paths. Once deployed, the rules are permanent.

They are connected by strategic choice, not architectural dependency. The [Solid "Uniteum 1"](/solid/uniteum-1) token serves as the backing for both the Liquid Hub and the Uniteum "1" identity Unit—amplifying its value across all three protocols.

---

## Status

Experimental, unaudited, deployed on Mainnet. This is novel mechanism design. Proceed with curiosity and caution.

See [Safety](/uniteum/safety/) and [Legal](/legal/).

---

Uniteum, "1", and related marks are trademarks. See [Legal](/legal/) for details.
