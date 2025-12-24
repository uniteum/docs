---
title: Canonicalization
description: >-
  Deterministic normalization rules that ensure every Unit has a single, unique representation.

# Navigation
nav_order: 4
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

# Canonicalization

Canonicalization is the process by which a symbolic unit expression is normalized into a **single, deterministic representation**.

Its purpose is to ensure that:
- every Unit identity is unique
- equivalent expressions resolve to the same Unit
- unit identities are stable across time, contracts, and systems

Canonicalization applies **only to unit identity creation**, not to forging balances.

## Why canonicalization exists

Without canonicalization:
- the same unit could be represented in multiple ways
- identical economic structures could fragment into distinct Units
- determinism and interoperability would be lost

Canonicalization guarantees a **one-to-one mapping** between:
> symbolic structure ↔ Unit identity

## Canonical rules (normative)

The following rules define canonical form.

### Identity Unit

The identity Unit is named:

```

1

```

All expressions that reduce to the identity resolve to `1`.

### No negative exponents

Canonical form **never uses negative exponents**.

Examples:
- canonical: `1/s`
- not canonical: `s^-1`

Reciprocal structure must be explicit.

### Structural reciprocals

Reciprocals are represented structurally using division:

```

1/x

```

This applies at all levels, including compound Units.

### Canonical ordering

Terms within a compound Unit are ordered canonically.

Ordering is deterministic and implementation-defined, ensuring that:
- equivalent expressions render identically
- term merging and comparison are efficient

There is no support for alternative or user-defined orderings.

### Deterministic rendering

Canonicalization produces **exactly one** canonical representation for a given structure.

If two expressions canonicalize to the same result, they refer to the **same Unit**.

## Canonicalization vs parsing

Parsing:
- accepts a textual unit expression
- produces a structured representation

Canonicalization:
- normalizes that structure
- removes ambiguity
- enforces the canonical rules above

A parser may accept non-canonical input, but **canonical output is always deterministic**.

## Canonicalization and Unit creation

Canonicalization is part of **Unit identity creation**:

- it determines whether a Unit already exists
- it prevents duplicate Unit identities
- it defines the Unit’s symbolic name

Canonicalization does **not**:
- mint or burn tokens
- affect balances
- change prices

Those effects occur only through [Forge](/concepts/forge).

## Non-goals

Canonicalization does not:
- perform dimensional analysis
- validate physical meaning
- convert between units
- assign numerical scale

It is purely a structural normalization process.

## See also

- [Unit Creation](/concepts/unit-creation)
- [Forge](/concepts/forge)
- [Triads](/concepts/triads)
