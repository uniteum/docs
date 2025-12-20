---
title: Forge
description: >-
  The single operation that powers all of Uniteum:
  creating, destroying, and swapping tokens.

# Navigation
nav_order: 2
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

# Forge

{: .note }
> For valid triad patterns and multi-path trading, see [Triads](/concepts/triads/). For the mathematics, see [Tokenomics](/concepts/tokenomics/).

Forge is the universal operation in Uniteum. Every swap, every mint, every burn—all are forge operations.

## What Forge Does

Forge transforms tokens within a valid triad while preserving the invariant:

$$u \cdot v = w^2$$

You provide some combination of the three tokens; forge adjusts all supplies to maintain the invariant and returns the difference.

## Two Directions

### Forward: Operands → Mediator

Provide U and V, receive W.

Example with triad (foo, 1/foo, 1):
- You provide foo and 1/foo
- You receive "1"
- Supplies of foo and 1/foo increase
- "1" transfers from contract to you

### Reverse: Mediator → Operands

Provide W, receive U and V.

Example:
- You provide "1"
- You receive foo and 1/foo
- "1" transfers to contract
- Supplies of foo and 1/foo decrease

## Forge as Swap

Want to swap foo for 1/foo?

1. Forge forward: provide foo + some 1/foo → receive "1"
2. Forge reverse: provide "1" → receive foo + 1/foo (different ratio)

Net effect: you've traded foo for 1/foo, passing through "1".

But with triads like (foo, bar, foo*bar), you can swap more directly. See [Triads](/concepts/triads/).

## Price Impact

Forging changes supply ratios, which changes prices.

**To increase foo's price:**
- Burn foo (decrease u)
- Mint 1/foo (increase v)
- This consumes "1"

**To decrease foo's price:**
- Mint foo (increase u)
- Burn 1/foo (decrease v)
- This releases "1"

Forging isn't just trading—it's market making.

## The Invariant Constraint

You can't forge arbitrary amounts. The invariant constrains the relationship:

$$u_1 \cdot v_1 = w_1^2$$

After forging, this must hold. The contract calculates what's possible and executes accordingly.

See [Tokenomics](/concepts/tokenomics/) for the full math.

## No Separate Operations

There is no "mint" function. No "burn" function. No "swap" function.

Just forge.

This simplicity is intentional. One operation, one invariant, infinite possibilities.
