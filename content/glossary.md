---
title: Glossary
description: >-
  Canonical definitions of terms used throughout the Uniteum documentation.

# Navigation

# Taxonomy

# Metadata
weight: 90
---

# Glossary

This glossary defines terms as they are used **normatively** across the Uniteum documentation.

If a term is defined here, that definition takes precedence over informal usage elsewhere.

Term entries are listed in alphabetical order.

---

## Arbitrage

**Arbitrage** is the act of exploiting price inconsistencies between forge paths.

Arbitrage:
- is permissionless
- aligns prices across the mesh
- is the mechanism by which global coherence emerges

---

## Base Unit

A **base Unit** is a Unit whose symbolic identity is not composed of other Units.

Examples:
- `meter`
- `second`
- `USD`

Base Units are not privileged economically; they differ only in symbolic structure.

---

## Canonicalization

**Canonicalization** is the deterministic normalization process that maps a symbolic unit structure to a single canonical representation.

Canonicalization ensures:
- uniqueness of Unit identities
- stable naming
- consistent comparisons

Canonicalization does not mint or burn tokens.

---

## Compound Unit

A **compound Unit** is a Unit whose symbolic identity is composed from other Units via multiplication, division, or exponentiation.

Examples:
- `meter/second`
- `foo*bar`
- `meter^2`

Compound Units are first-class Units with their own ERC-20 contracts.

---

## Decimal Amount

A **decimal amount** is the human-readable representation of a token amount, expressed with a decimal point (e.g., `1.5 USDC`).

Contrast with *integer amount* (or *base units*), the on-chain `uint256` value scaled by `10^decimals()` (e.g., `1_500_000` for 1.5 USDC with 6 decimals).

The two representations encode the same value; conversion requires the token's `decimals()`.

---

## Forge

**Forge** is the single on-chain operation that mints and burns Unit balances while preserving a local invariant.

Forge:
- operates only on triads
- enforces a geometric-mean invariant per triad
- subsumes minting, burning, and swapping

Forge never creates new Unit identities.

---

## Geometric-Mean Unit

The **geometric-mean Unit** of a triad is the Unit whose supply is constrained by:

```

w² = u · v

```

It is:
- a first-class ERC-20 Unit
- not computed on demand
- often called the “liquidity unit” by convention

A Unit may be a geometric-mean Unit in one triad and a reserve Unit in another.

---

## Identity Unit (`1`)

The **identity Unit**, written as `1`, is the Unit that satisfies:

```

U * 1 = U

```

and

```

√(U · 1/U) = 1

```

`1` is:
- a Unit
- an ERC-20 token
- commonly the geometric-mean Unit in reciprocal triads

`1` is not a special case in forge; it participates like any other Unit.

---

## Integer Amount

An **integer amount** (also **base units**) is the on-chain `uint256` representation of a token amount: the value scaled by `10^decimals()` (e.g., `1_500_000` for 1.5 USDC with 6 decimals).

Every on-chain quantity is an integer amount — ERC-20 balances, transfer values, and event arguments are never decimal. For 18-decimal tokens the base unit is named `wei`, so `1` token = `1_000_000_000_000_000_000` wei.

Contrast with *decimal amount*, the human-readable value expressed with a decimal point (e.g., `1.5 USDC`).

---

## Invariant

An **invariant** is a constraint enforced by the forge operation.

In Uniteum:
- invariants are local to a single triad
- all triads enforce the same geometric-mean invariant
- no higher-order or global invariant exists

---

## Mesh

The **mesh** is the network formed by overlapping triads.

Properties of the mesh:
- Units may appear in many triads
- Multiple forge paths may exist between Units
- Arbitrage enforces global price consistency
- No central pool or oracle exists

---

## Par Token

A **par token** is a token whose price against a single reference asset is structurally bounded to a hard band starting at parity, backed at least 1:1 by that reference asset held in a locked position.

A par token:
- trades within a hard corridor `[1.0000, 1.0001)` against its reference asset
- is fully reserved in the real reference asset — not a synthetic or oracle-priced proxy
- has no redemption function, no oracle, and no governance
- is exited by selling back into the same locked position at ≥ par, not by burning a claim

A **[signature token](#signature-token)** is Uniteum's implementation of a par token. "Par token" names the generic instrument class; "signature token" names an instance produced by the [Reflector](/reflector/) factory.

---

## Reciprocal

The **reciprocal** of a Unit `U` is the Unit `1/U`.

Reciprocals:
- are structurally distinct Units
- have their own identities
- commonly form triads of the form `(U, 1/U, 1)`

Canonical form never uses negative exponents to represent reciprocals.

---

## Reserve Unit (Conventional)

A **reserve Unit** is a Unit that appears as one of the two non-geometric-mean Units in a triad.

“Reserve” is a **conventional role**, not a structural distinction.

---

## Signature Token

A **signature token** is a named, fully-backed ERC-20 minted by the [Reflector](/reflector/) factory: the deployer's chosen name and identity ride on top of a token whose value is locked to an existing original (USDC, ETH, anything mirrored). Every signature token is a [par token](#par-token) — it trades 1:1 with its original inside a hard 1-basis-point corridor, with the original held in a Uniswap V4 position that no one (including the deployer) can unwind.

The name carries the brand; the original carries the value. The two are coupled at mint and cannot be decoupled. Use `signature token` for an instance ("Tokyo Steakhouse Dollar is a 1xUSDC signature token") and `par token` for the underlying instrument class ("every signature token is a par token").

---

## Term

A **term** is an atomic component of a unit expression.

Terms consist of:
- a base symbol (or address-anchored symbol)
- an associated exponent

Compound Units are composed of one or more terms.

---

## Triad

A **triad** is a valid three-Unit relationship of the form:

```

(U, V, √(U·V))

```

Triads define the only context in which forge operates.

Each triad enforces one local invariant:
```

u · v = w²

```

There is no invariant spanning multiple triads.

---

## Unit

A **Unit** is an ERC-20 token whose identity is defined by a symbolic unit expression.

A Unit:
- is always an ERC-20 token
- has its own total supply and balances
- may represent a base unit or a compound unit
- may participate in one or more triads

Units are symbolic identities; their economic behavior emerges through forge.

---

## Unit Creation

**Unit creation** is the process by which new Unit identities (and their ERC-20 contracts) come into existence.

Unit creation involves:
- parsing symbolic expressions
- multiplication and reciprocals
- canonicalization

Unit creation does not mint balances or affect prices.

---

## Non-Goals

The following are explicitly **out of scope**:

- dimensional analysis
- physical correctness
- unit conversion
- numerical scale or magnitude
- global invariants

---

## See also

- [Forge](/uniteum/concepts/forge)
- [Triads](/uniteum/concepts/triads)
- [Unit Creation](/uniteum/concepts/unit-creation)
- [Canonicalization](/uniteum/concepts/canonicalization)
