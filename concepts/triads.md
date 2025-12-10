---
title: Triads
description: >-
  Valid three-token relationships in Uniteum. Forge works on
  any algebraically valid triad, not just (U, 1/U, 1).

# Navigation
nav_order: 3
parent: Concepts
has_children: false

# Taxonomy
categories:
  - core
  - trading

# Metadata
last_updated: 2024-12-09
version: "0.1"
status: draft
---

# Triads

A triad is a valid three-token relationship where forge can operate. Understanding triads unlocks Uniteum's full power.

## Beyond (U, 1/U, 1)

The simplest triad is a base unit with its reciprocal, mediated by "1":

**(foo, 1/foo, 1)**

But this is just one pattern. Forge works on **any algebraically valid triad**.

## Triad Patterns

### Base Unit Triad

**(U, 1/U, 1)**

- U = base unit
- 1/U = its reciprocal
- 1 = mediator

Examples:
- (foo, 1/foo, 1)
- (meter, 1/meter, 1)

### Compound Formation Triad

**(A, B, A·B)**

- A = first operand
- B = second operand
- A·B = their product

Examples:
- (meter, second, meter*second)
- (meter, 1/second, meter/second)
- (foo, bar, foo*bar)

No "1" involved. Direct composition.

### Compound Reciprocal Triad

**(A·B, 1/(A·B), 1)**

Compound units are first-class. They have reciprocals, mediated by "1".

Examples:
- (meter/second, second/meter, 1)
- (foo*bar, 1/(foo*bar), 1)

### Nested Compounds

**(A·B, C, A·B·C)**

You can forge compounds with other units to create deeper compounds.

Example:
- (meter/second, second, meter) — yes, this simplifies!

## The Universal Invariant

All triads obey the same invariant:

$$u \cdot v = w^2$$

Where u, v, w are supplies of the three tokens in positional order.

| Triad | u | v | w |
|-------|---|---|---|
| (foo, 1/foo, 1) | foo supply | 1/foo supply | "1" in contract |
| (meter, 1/second, meter/second) | meter supply | 1/second supply | meter/second supply |
| (foo*bar, 1/(foo*bar), 1) | foo*bar supply | reciprocal supply | "1" in contract |

Different triads, same math.

## Multi-Path Trading

Because multiple triads exist, there are often multiple paths between two tokens.

**Example:** Convert `meter` to `second`

Path A (through "1"):
1. Forge (meter, 1/meter, 1): meter → "1"
2. Forge (second, 1/second, 1): "1" → second

Path B (through compound):
1. Forge (meter, 1/second, meter/second): meter + 1/second → meter/second
2. Forge differently to extract second

Different paths may have different costs. Arbitrageurs exploit differences, keeping prices consistent.

## Why This Matters

Triads create a **mesh topology**:

- Every base unit connects to "1"
- Compound units connect to their constituents
- Compound units also connect to "1" via reciprocals
- Multiple paths exist between any two units

This mesh enables:
- **Arbitrage:** Price inconsistencies create profit opportunities
- **Liquidity sharing:** Deep liquidity in one triad supports others
- **Price discovery:** No oracles needed—arbitrage enforces consistency

## Valid vs Invalid Triads

A triad is valid if the algebra works out:

✅ **(meter, 1/second, meter/second)** — meter × (1/second) = meter/second

❌ **(meter, second, meter/second)** — meter × second ≠ meter/second

The contract enforces validity. You can't forge invalid triads.
