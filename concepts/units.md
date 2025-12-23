---
title: Units
description: >-
  The four types of units in Uniteum: base, compound,
  anchored, and floating. How they differ and compose.

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

{: .note }
> For complete technical specifications, see [Functions Reference](/reference/functions/). For supply mechanics, see [Tokenomics](/concepts/tokenomics/).

In Uniteum, every token is a **unit** — a symbolic type that composes algebraically with other units.

This page defines **what a unit is** and **how unit symbols compose**. Protocol mechanics (liquidity, pricing, invariants, supply rules) are documented elsewhere.

---

## Normative Definition

A **unit** is a finite multiset of **terms**. Each term consists of:
- a **base** (either a symbol or an anchored address), and
- an **exponent**, represented as a **rational number**.

A unit is in **canonical form** if:
- terms are sorted deterministically by base,
- like bases are merged by adding exponents,
- any term whose exponent becomes zero is removed, and
- rational exponents are reduced to lowest terms.

Two units are equal **if and only if** their canonical forms are identical.

Units are purely **symbolic**. They do not encode quantity, magnitude, conversion rates, or physical meaning.

---

## Exponents

Exponents are rationals of the form **n/d**, where:
- **n** is a signed integer numerator, and
- **d** is a positive integer denominator.

Rational exponents are a first-class part of the unit system.

Examples:
- `foo^2` → exponent `2/1`
- `bar^1:2` → exponent `1/2`

{: .note }
> Exponents are symbolic only. Uniteum does not interpret expressions such as `meter^1:2` physically or numerically.

---

## The Identity Unit (`1`)

The identity unit is **`1`**.

In mathematics, the multiplicative identity is sometimes called *unity*, but Uniteum uses the symbol `1` consistently in unit expressions and token names.

Algebraically:
- `U * 1 = U`
- `U / U = 1`

The ERC-20 token written as `"1"` is the token associated with the identity unit. Its protocol role and supply rules are described in [Tokenomics](/concepts/tokenomics/).

---

## Unit Types

### Base Units

Base units are simple, non-compound symbolic identifiers.

Examples:
```

foo
meter
kilogram

```

A base unit consists of a single base with exponent `+1`.

Every base unit has a reciprocal (`1/foo`). Any additional relationships involving `1` are protocol mechanics, not part of the unit definition.

---

### Compound Units

Compound units are created by algebraic composition of other units.

Examples:
```

meter/second
kilogram*meter
foo^2
bar^1:2

```

Supported operators:
- `*` — multiplication
- `/` — division
- `^` — raise to a rational power
- `:` — divides numerator and denominator **inside the exponent** (e.g. `^1:2`)

Compound units are first-class units. They may be composed further, inverted, or exponentiated.

---

### Anchored Units

{: .note }
> For documentation shorthands ($WETH, $USDC, etc.) and complete reference, see [Anchored Units](/reference/anchored-units/).

Anchored units bind a unit to an external ERC-20 token address.

**Format:**
```

$0xTokenAddress

```

**Example:**
```

$0xdAC17F958D2ee523a2206206994597C13D831ec7

```

Anchored units are backed 1:1 by the external ERC-20 token. The backing tokens are held by the Unit contract.

- ✅ Redeemable for the backing token
- ⚠️ Custodial by construction
- Created via: `one().anchored(IERC20(address))`

Anchoring affects **token behavior**, not the algebraic definition of units.

---

### Floating Units

Floating units are unanchored base units.

**Format:** up to 30 characters, `[a-zA-Z0-9_.-]+`

**Examples:**
```

foo
meter
acme
widget

```

Floating units have no backing. They are purely symbolic labels.

- ✅ Permissionless creation
- ❌ No collateral or peg implied by the name
- Created via: `one().multiply("symbol")`

**Warning:** A floating unit named `USD` has no connection to U.S. dollars. Avoid real-world financial symbols to prevent confusion.

---

## Reciprocals

Every unit `U` has a reciprocal `1/U`.

Symbolically:
- the reciprocal negates all exponents, and
- `U * (1/U) = 1`.

Any supply, liquidity, or invariant relationships involving reciprocals are protocol mechanics and are not part of the unit definition.

---

## Canonical Form

A unit is in canonical form if:
- all zero-exponent terms are omitted,
- each base appears at most once,
- bases are ordered deterministically, and
- rational exponents are normalized.

Canonical form ensures that structurally equivalent units have identical representations and addresses.

---

## Address Derivation

Unit contract addresses are deterministically derived from the **canonical unit representation** using `CREATE2`.

This enables:
- predicting unit addresses before deployment,
- verifying unit authenticity, and
- relying on composability guarantees.
