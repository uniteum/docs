---
title: Introduction
description: >-
  Independent protocols and infrastructure for creating, trading, and composing tokens on Ethereum.
  No governance. No oracles. Just math.

# Navigation
nav_order: 1
has_children: false

# Metadata
last_updated: 2026-03-01
status: draft
---

# uniteum.one

Independent protocols and infrastructure for creating, trading, and composing tokens on Ethereum.

Each project is permissionless, immutable, and governed entirely by on-chain math—no admin keys, no governance, no oracles.

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

Every Liquid token is both a standard ERC-20 and its own AMM. Deposits create instant tradeable depth through the [2x mint]({{ site.baseurl }}/liquid/2x-mint) pattern. All Liquid tokens connect through a Hub token, enabling cross-pool swaps—100 tokens need 100 pools, not 5,000.

- Zero fees, hardcoded forever
- Automatic liquidity on every deposit
- Universal cross-swap via Hub routing

---

## [Lepton](/lepton/) — Token Factory

**One call makes a fixed-supply ERC-20. Deterministic address, no owner, no inflation.**

Lepton deploys standard ERC-20 tokens as minimal proxy clones via CREATE2. You pick a name, symbol, and supply — the entire supply is minted to you in a single transaction. Idempotent: the same parameters always produce the same token.

- Fixed supply, minted once at creation
- Deterministic addresses via CREATE2
- Permissionless, no owner, no governance

---

## [Unispring](/unispring/) — Fair Launch on Uniswap V4

**Fair-launch tokens deployed directly into Uniswap V4. Permanent liquidity, built-in price floor, zero maker capital.**

A single transaction mints a fixed-supply ERC-20, initializes a V4 pool against a hub token, and locks 100% of the supply as a single-sided concentrated position. The maker provides only gas. The position is owned by a Fountain clone with no decrease-liquidity path.

- Native Uniswap V4 — routable by every aggregator from block one
- Permanent floor enforced by the absence of liquidity below `tickLower`
- Hub-and-spoke topology gives any two Unispring tokens a two-hop swap path

A sibling factory, **Mimicoinage**, mints permissionless 1:1 mirrors of any ERC-20 with a hard 1-bp peg corridor (`1xUSDC`, `1xWBTC`, `1xETH`).

---

## [Locale](/locale/) — On-Chain Reference Data

**Immutable reference contracts at deterministic addresses, with data native to each chain.**

Locale deploys lookup contracts that resolve to chain-specific values. The same address exists on every supported network. Query it on Ethereum mainnet and you get one answer. Query it on Arbitrum and you get another. The address never changes. The data never changes. There is no owner.

- Same address on every chain, different data per chain
- Initialized once, immutable forever
- No owner, no upgrade path, no governance

---

## [Uniteum](/uniteum/) — Algebraic Liquidity

**Tokens with dimensional units that compose like physics: `meter/second`, `USD/BTC`, `foo*bar`.**

The notation is the price relationship. One operation—**forge**—maintains algebraic consistency through arbitrage. Build custom derivatives with any power profile. No oracles needed.

- Geometric mean triads: every forge operates on (U, V, √(U*V))
- Arbitrary power perpetuals (0.5x, 1x, 2x, custom exponents)
- Infinite interconnected pools through algebraic composition

---

## Common Thread

All six projects are [Bitsy](/bitsy/) — immutable, permissionless, governance-free, cloned, deterministic, direct, composable, and math-only. These are not aspirations; they are verifiable properties of the deployed bytecode.

They are connected by strategic choice, not architectural dependency. The [Solid "Uniteum 1"](/solid/uniteum-1) token serves as the backing for both the Liquid Hub and the Uniteum "1" identity Unit—amplifying its value across all three protocols. Unispring uses its own dedicated hub on Uniswap V4.

---

## Status

All projects are deployed on Mainnet, unaudited, and at different stages of maturity:

- **Solid** — Complete. The protocol is simple and does what it says.
- **Liquid** — Likely complete, but not yet tested at scale.
- **Lepton** — Complete. A minimal factory with a small, fixed interface.
- **Unispring** — Code complete; contracts not yet deployed. Fair-launch factory on Uniswap V4; Mimicoinage sibling for 1:1 mirrors.
- **Locale** — Complete. Immutable reference contracts with a fixed interface.
- **Uniteum** — Under active development. The mechanics around anchored units are incomplete, and it may not be possible to get them working.

None of these contracts have been formally audited. Audits can give a false sense of security — audited contracts are regularly found to have severe defects after the fact. Read the code, understand the risks, and proceed with caution.

See [Safety](/uniteum/safety/) and [Legal](/legal/).

---

Uniteum, "1", and related marks are trademarks. See [Legal](/legal/) for details.
