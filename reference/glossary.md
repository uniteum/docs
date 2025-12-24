---
title: Glossary
description: >-
  Canonical definitions of terms used throughout Uniteum documentation.

# Navigation
nav_order: 1
parent: Reference
has_children: false

# Taxonomy
categories:
  - reference
  - core

# Metadata
last_updated: 2024-12-20
version: "0.2"
status: draft
---

# Glossary

This glossary defines terms as they are used **normatively** in Uniteum.

If a term is defined here, that definition takes precedence over informal usage elsewhere.

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

## Base Unit

A **base Unit** is a Unit whose symbolic identity is not composed of other Units.

Examples:
- `meter`
- `second`
- `USD`

Base Units are not privileged economically; they differ only in symbolic structure.

---

## Compound Unit

A **compound Unit** is a Unit whose symbolic identity is composed from other Units via multiplication, division, or exponentiation.

Examples:
- `meter/second`
- `foo*bar`
- `meter^2`

Compound Units are first-class Units with their own ERC-20 contracts.

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

## Reciprocal

The **reciprocal** of a Unit `U` is the Unit `1/U`.

Reciprocals:
- are structurally distinct Units
- have their own identities
- commonly form triads of the form `(U, 1/U, 1)`

Canonical form never uses negative exponents to represent reciprocals.

---

## Term

A **term** is an atomic component of a unit expression.

Terms consist of:
- a base symbol (or address-anchored symbol)
- an associated exponent

Compound Units are composed of one or more terms.

---

## Canonicalization

**Canonicalization** is the deterministic normalization process that maps a symbolic unit structure to a single canonical representation.

Canonicalization ensures:
- uniqueness of Unit identities
- stable naming
- consistent comparisons

Canonicalization does not mint or burn tokens.

---

## Forge

**Forge** is the single on-chain operation that mints and burns Unit balances while preserving a local invariant.

Forge:
- operates only on triads
- enforces a geometric-mean invariant per triad
- subsumes minting, burning, and swapping

Forge never creates new Unit identities.

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

## Reserve Unit (Conventional)

A **reserve Unit** is a Unit that appears as one of the two non-geometric-mean Units in a triad.

“Reserve” is a **conventional role**, not a structural distinction.

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

## Arbitrage

**Arbitrage** is the act of exploiting price inconsistencies between forge paths.

Arbitrage:
- is permissionless
- aligns prices across the mesh
- is the mechanism by which global coherence emerges

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

- [Forge](/concepts/forge)
- [Triads](/concepts/triads)
- [Unit Creation](/concepts/unit-creation)
- [Canonicalization](/concepts/canonicalization)
