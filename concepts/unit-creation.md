---
title: Unit Creation
description: >-
  How new Unit identities are created from symbolic expressions, independently of forging balances.

# Navigation
nav_order: 3
parent: Concepts
has_children: false

# Taxonomy
categories:
  - core
  - units

# Metadata
last_updated: 2024-12-20
version: "0.2"
status: draft
---

# Unit Creation

Uniteum Units are **ERC-20 tokens whose identities are defined by symbolic unit expressions**.

This page describes how **new Unit identities (and their corresponding token contracts)** come into existence.  
It is intentionally separate from [Forge](/concepts/forge), which operates on **balances of existing Units**.

## Two distinct layers

Uniteum has two closely related but distinct layers:

### 1. Unit identity creation (this page)

- Determines **which Units exist**
- Defines how Units are named and structured
- Produces new ERC-20 Unit contracts when needed

### 2. Forge (economic operation)

- Mints and burns balances of existing Units
- Operates on triads with geometric-mean invariants
- Never creates new Unit identities

Confusing these two layers leads to incorrect mental models.  
This page covers **identity creation only**.

## What a Unit is

A Unit is:
- an ERC-20 token
- with a symbolic identity derived from a unit expression
- potentially representing a base unit or a compound unit

Units may represent:
- primitive symbols (e.g. `m`, `USD`)
- compound expressions (e.g. `m/s`, `kg*m/s^2`)
- geometric-mean constructions (e.g. `a^1:2 * b^1:2`)

The symbolic expression defines the Unit’s **place in the liquidity mesh**, not its numerical value.

## Operations that create new Unit identities

New Unit identities arise through **symbolic composition**, including:

### Parsing

A unit expression string is parsed into a structured representation of terms and exponents.

Parsing answers the question:
> “What symbolic structure does this expression describe?”

### Multiplication

Units can be multiplied to form compound Units.

Example intent:
- `m * s` → a Unit representing meters·seconds

### Reciprocal

Every Unit has a reciprocal structure.

Example intent:
- `s` → `1/s`

Reciprocal Units are structurally distinct Units with their own identities.

### Canonicalization

All unit identities are normalized to a **canonical representation**.

Canonicalization ensures:
- determinism
- uniqueness
- consistent identity across the system

Canonical rules include:
- the identity Unit is named `1`
- canonical form never uses negative exponents
- reciprocals are represented structurally as `1/x`
- terms are ordered canonically

If two expressions canonicalize to the same structure, they refer to the **same Unit**.

## Identity creation vs balance changes

Creating a Unit identity:
- may deploy a new ERC-20 Unit contract
- does **not** mint balances for users
- does **not** change prices
- does **not** involve forge

Balance changes occur **only** through forge.

## Relationship to triads

Once a Unit exists, it may participate in one or more triads of the form:

```

(a, b, a^1:2 * b^1:2)

```

These triads define how forge can mint and burn balances involving the Unit.

Unit creation determines **what nodes exist in the mesh**.  
Forge determines **how value flows through the mesh**.

## Non-goals

Unit creation does not:
- perform dimensional analysis
- enforce physical meaning
- convert between units
- assign numerical scale or magnitude

Units are symbolic identities whose economic behavior emerges only when combined with forge.

## See also

- [Forge](/concepts/forge)
- [Triads](/concepts/triads)
- [Canonicalization](/concepts/canonicalization)
