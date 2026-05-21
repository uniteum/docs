---
title: Units
description: >-
  The four types of units in Uniteum: base, compound,
  anchored, and floating. How they differ and compose.

# Navigation

# Taxonomy

# Metadata
weight: 1
---

# Units


> For complete technical specifications, see [Functions Reference](/uniteum/reference/functions/). For supply mechanics, see [Tokenomics](/uniteum/concepts/tokenomics/).

In Uniteum, every token is a **unit**—a dimensional type that composes algebraically with other units.

## The "1" Token

At the center is "1"—the dimensionless unit. It mediates all base units and serves as the liquidity backbone of the protocol.

- **Primordial supply:** 1 billion (minted once in v0.0, this is the ceiling for all versions)
- **Supply mechanics:** Current version supply grows through migration from v0.0; total across all versions ≤ 1 billion
- **Role:** Mediates base unit / reciprocal pairs
- **Versions:** v0.0 (genesis ERC-20, primordial supply), current version (full Uniteum features)

## Unit Types

### Base Units

Simple, non-compound units. Examples: `foo`, `meter`, `kilogram`.

Every base unit has:
- A **reciprocal** (e.g., `1/foo`)
- A relationship with "1" via the triad (foo, 1/foo, 1)

### Compound Units

Created by algebraic composition:

- `meter/second` — meter divided by second
- `kilogram*meter` — kilogram times meter
- `foo^2` — foo squared
- `bar^1:2` — bar to the power of 1/2 (square root)

Operators:
- `*` — multiply
- `/` — divide
- `^` — power
- `:` — divide (in exponent context)

Compound units are first-class citizens. They have their own reciprocals and can participate in forge operations with "1".

### Anchored Units


> For documentation shorthands (0xWETH, 0xUSDC, etc.) and complete reference, see [Anchored Units](/uniteum/reference/anchored-units/).


> Anchored units are not yet fully implemented. The description below covers intended design.

**Format:** `0xTokenAddress`

**Example:** `0xdAC17F958D2ee523a2206206994597C13D831ec7` (USDT)

Anchored units are backed 1:1 by an external ERC-20 token. The backing tokens are held by the Unit contract.

- ✅ Real value, redeemable
- ⚠️ Custodial—you trust the contract
- Created via: `one().anchored(IERC20(address))`

### Floating Units

**Format:** Up to 30 characters, `[a-zA-Z0-9_.-]+`

**Examples:** `foo`, `meter`, `acme`, `widget`

Floating units have no backing. They're just labels. Value emerges from liquidity and consensus.

- ❌ Not pegged to anything real
- ❌ No collateral
- ✅ Permissionless creation
- Created via: `one().multiply("symbol")`

**Warning:** A floating unit named `USD` has no connection to US dollars. Avoid real-world financial symbols to prevent confusion.

## Reciprocals

Every unit U has a reciprocal 1/U. They are bound by the invariant:

$$u \cdot v = w^2$$

Where:
- u = supply of U
- v = supply of 1/U
- w = √(u·v), the geometric-mean bookkeeping value returned by `invariant()` — **not** a custodied balance of `1`

`1` is minted and burned globally on the ONE contract during forge; it does not sit "locked" inside the U contract. You cannot have U without 1/U: they are created together and maintain this relationship through all forge operations.

## Address Derivation

Unit contract addresses are deterministically derived from their symbol via CREATE2. Given a symbol, you can predict its address before it exists.

This enables:
- Referencing units before creation
- Verifying unit authenticity
- Building on composability guarantees
