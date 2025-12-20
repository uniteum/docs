---
title: Triads
description: >-
  Valid three-token relationships in Uniteum. Every forge operates on
  (U, V, √(U*V)) where the liquidity unit is the geometric mean of two reserve units.

# Navigation
nav_order: 3
parent: Concepts
has_children: false

# Taxonomy
categories:
  - core
  - trading

# Metadata
last_updated: 2024-12-20
version: "0.2"
status: draft
---

# Triads

{: .note }
> For the forge operation details, see [Forge](/concepts/forge/). For invariant mathematics, see [Tokenomics](/concepts/tokenomics/).

A triad is a valid three-token relationship where forge can operate. Every triad has two **reserve units** and one **liquidity unit** that is the geometric mean of the reserves.

## The Geometric Mean Structure

Every forge triad follows the pattern:

**(U, V, √(U*V))**

Where:
- **U and V** are the **reserve units** (what you're exchanging)
- **√(U*V)** is the **liquidity unit** (mediates the exchange, analogous to Uniswap LP tokens)

This geometric mean structure implements 0.5 power perpetuals, connecting Uniteum to fundamental AMM theory.

## Triad Patterns

### Reciprocal Pair Triad

**(U, 1/U, 1)**

- **Reserve units**: U and 1/U (a reciprocal pair)
- **Liquidity unit**: "1" (since √(U * 1/U) = 1)

Examples:
- (foo, 1/foo, 1)
- (meter, 1/meter, 1)

This is the fundamental pattern connecting all base units through "1".

**Note on "1"**: While "1" commonly appears as the liquidity unit for reciprocal pairs, it can also serve as a reserve unit in triads like `(1, meter², meter)` where √(1 * meter²) = meter.

### Compound Unit Creation Triads

To create a compound unit, you forge the triad where it appears as the geometric mean.

**Pattern**: To create A^p*B^q, forge (A^(2p), B^(2q), A^p*B^q)

Examples:

**(meter², second², meter\*second)**
- **Reserve units**: meter² and second²
- **Liquidity unit**: meter\*second (since √(meter² * second²) = meter\*second)

**(meter², 1/second², meter/second)**
- **Reserve units**: meter² and 1/second²
- **Liquidity unit**: meter/second (since √(meter² * 1/second²) = meter/second)

**(foo², bar², foo\*bar)**
- **Reserve units**: foo² and bar²
- **Liquidity unit**: foo\*bar (since √(foo² * bar²) = foo\*bar)

### Compound Unit Reciprocal Triad

**(A·B, 1/(A·B), 1)**

Compound units have reciprocals too, mediated by "1".

Examples:
- (meter/second, second/meter, 1) — since √((meter/second) * (second/meter)) = 1
- (foo\*bar, 1/(foo\*bar), 1)

## The Universal Invariant

All triads obey the same invariant:

$$\sqrt{u \cdot v} = w$$

Or equivalently: $$u \cdot v = w^2$$

Where:
- **u, v** = supplies of the two reserve units
- **w** = supply of the liquidity unit

The liquidity unit supply is always the geometric mean of the reserve supplies.

| Triad | Reserve U | Reserve V | Liquidity Unit |
|-------|-----------|-----------|----------------|
| (foo, 1/foo, 1) | foo supply | 1/foo supply | "1" supply |
| (meter², 1/second², meter/second) | meter² supply | 1/second² supply | meter/second supply |
| (foo\*bar, 1/(foo\*bar), 1) | foo\*bar supply | reciprocal supply | "1" supply |

Different triads, same mathematical relationship.

## Multi-Path Trading

Because the same unit can serve as a reserve in one triad and a liquidity unit in another, there are often multiple paths between two units.

**Example:** Creating exposure to meter/second

Path A (Direct):
1. Forge (meter², 1/second², meter/second) where meter/second is the liquidity unit

Path B (Through "1"):
1. Forge (meter, 1/meter, 1) to get "1"
2. Forge (second, 1/second, 1) to exchange "1" for 1/second
3. Then combine through other triads

Different paths may have different costs. Arbitrageurs exploit differences, keeping prices consistent.

## Why This Matters

Triads create a **mesh topology**:

- Every base unit connects to "1" via reciprocal pairs
- Compound units can serve as liquidity units in their creation triads
- The same compound units can serve as reserve units in other triads
- Multiple paths exist between any two units

This mesh enables:
- **Arbitrage:** Price inconsistencies create profit opportunities
- **Liquidity sharing:** Deep liquidity in one triad supports others
- **Price discovery:** No oracles needed—arbitrage enforces consistency
- **Power perp mechanics:** Liquidity units track geometric mean relationships

## Multi-Role Composition

The power of triads comes from units serving different roles:

**Example: meter/second**
- **As liquidity unit**: In triad (meter², 1/second², meter/second)
- **As reserve unit**: Could appear in (meter²/second², kg², kg*meter/second)

This multi-role capability creates interconnected liquidity across the entire system.

## Valid vs Invalid Triads

A triad is valid if the geometric mean relationship holds:

✅ **(meter², 1/second², meter/second)** — √(meter² * 1/second²) = meter/second

❌ **(meter, 1/second, meter/second)** — √(meter * 1/second) ≠ meter/second

The contract enforces geometric mean validity. You can't forge invalid triads.
