---
title: Units
description: >-
  The four types of units in Uniteum: base, compound,
  anchored, and symbolic. How they differ and compose.

# Navigation
nav_order: 1
parent: Concepts
has_children: false

# Taxonomy
categories:
  - core
  - tokens

# Metadata
last_updated: 2024-12-09
version: "0.1"
status: draft
---

# Units

In Uniteum, every token is a **unit**—a dimensional type that composes algebraically with other units.

## The "1" Token

At the center is "1"—the dimensionless unit. It mediates all base units and serves as the liquidity backbone of the protocol.

- **Total supply:** 1 billion (fixed, minted in v0.0)
- **Role:** Mediates base unit / reciprocal pairs
- **Versions:** v0.0 (genesis ERC-20), v0.1 (full Uniteum features)

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
- `bar^1\2` — bar to the power of 1/2 (square root)

Operators:
- `*` — multiply
- `/` — divide
- `^` — power
- `\` — divide (in exponent context)

Compound units are first-class citizens. They have their own reciprocals and can participate in forge operations with "1".

### Anchored Units

**Format:** `$0xTokenAddress`

**Example:** `$0xdAC17F958D2ee523a2206206994597C13D831ec7` (USDT)

Anchored units are backed 1:1 by an external ERC-20 token. The backing tokens are held by the Unit contract.

- ✅ Real value, redeemable
- ⚠️ Custodial—you trust the contract
- Created via: `one().anchored(IERC20(address))`

### Symbolic Units

**Format:** Up to 30 characters, `[a-zA-Z0-9_.-]+`

**Examples:** `foo`, `meter`, `acme`, `widget`

Symbolic units have no backing. They're just labels. Value emerges from liquidity and consensus.

- ❌ Not pegged to anything real
- ❌ No collateral
- ✅ Permissionless creation
- Created via: `one().multiply("symbol")`

**Warning:** A symbolic unit named `USD` has no connection to US dollars. Avoid real-world financial symbols to prevent confusion.

## Reciprocals

Every unit U has a reciprocal 1/U. They are bound by the invariant:

$$u \cdot v = w^2$$

Where:
- u = supply of U
- v = supply of 1/U
- w = supply of "1" held by the U contract

You cannot have U without 1/U. They are created together and maintain this relationship through all forge operations.

## Address Derivation

Unit contract addresses are deterministically derived from their symbol via CREATE2. Given a symbol, you can predict its address before it exists.

This enables:
- Referencing units before creation
- Verifying unit authenticity
- Building on composability guarantees
