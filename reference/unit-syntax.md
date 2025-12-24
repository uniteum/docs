---
title: Unit syntax
description: >-
  How Uniteum unit expressions are written, parsed, and rendered canonically.

# Navigation
nav_order: 2
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

# Unit syntax

Uniteum represents Units (ERC-20 tokens) using **symbolic unit expressions**. These expressions are parsed into a structured form and then **canonicalized** so that equivalent expressions map to a single Unit identity.

This page describes the **string syntax** used for unit expressions. For canonicalization rules, see [Canonicalization](/concepts/canonicalization). For how new Units arise from expressions, see [Unit Creation](/concepts/unit-creation).

## What a unit expression names

A unit expression names either:
- a **base Unit** (a single symbol), like `meter` or `USD`
- a **compound Unit** built from other Units, like `meter/second` or `kg*meter/second^2`
- the **identity Unit**, written as `1`

All Units are ERC-20 tokens; the expression describes structure, not magnitude.

## Operators

Unit expressions use three structural operators:

- `*` multiplication (product)
- `/` division (structural reciprocal)
- `^` exponentiation

Examples:
- `meter*second`
- `meter/second`
- `second^2`
- `kg*meter/second^2`

### Precedence

Expressions are interpreted with the following precedence:

1. Exponentiation (`^`)
2. Multiplication and division (`*` and `/`) evaluated left-to-right

Parentheses may be supported by the implementation. Documentation should prefer forms that do not require parentheses.

## Identity

The identity Unit is written as:

```

1

```

Examples:
- `meter*1` canonicalizes to `meter`
- `meter/meter` canonicalizes to `1`

## Multiplication

`*` combines Units into a compound Unit.

Examples:
- `foo*bar`
- `kg*meter`
- `meter*second`

In canonical form, terms are ordered deterministically.

## Division and reciprocals

`/` expresses structural reciprocals.

Examples:
- `1/foo`
- `meter/second`
- `meter/(second^2)` (if parentheses are supported)

Canonical form **never uses negative exponents**. For example, if the parser accepts `foo^-1`, it canonicalizes to `1/foo` (and if the parser does not accept `-`, `foo^-1` is simply invalid input).

## Exponents

A Unit term may be raised to a power with `^`.

Examples:
- `meter^2`
- `second^2`
- `foo^4`

### Rational exponents

Uniteum supports **rational exponents** as part of its symbolic structure. The exact textual encoding of rational exponents is implementation-defined (see `Unit.json`). Documentation should follow the canonical renderer’s output.

Examples of intent (not necessarily exact syntax):
- `meter^(1/2)`
- `foo^(3/2)`

## Canonical form (summary)

Canonical rendering is deterministic. Key rules:

- Identity is written as `1`
- Canonical output never uses negative exponents
- Reciprocals are structural (`1/x`, not `x^-1`)
- Terms are ordered canonically

See [Canonicalization](/concepts/canonicalization) for the normative list.

## Validity vs canonicality

A parser may accept more inputs than the canonical renderer emits.

- **Valid input**: an expression the parser accepts
- **Canonical output**: the unique normalized representation

Documentation and examples should use canonical forms unless explicitly labeled “non-canonical input”.

## Examples

### Base and identity
- `USD`
- `meter`
- `1`

### Compound products
- `foo*bar`
- `kg*meter`

### Ratios
- `meter/second`
- `kg*meter/second^2`

### Reciprocal pair
- `foo*(1/foo)` → canonicalizes to `1`

## See also

- [Canonicalization](/concepts/canonicalization)
- [Unit Creation](/concepts/unit-creation)
- [Triads](/concepts/triads)
- [Forge](/concepts/forge)
