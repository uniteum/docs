---
title: Forge
description: >-
  The single operation that powers all of Uniteum:
  creating, destroying, and swapping tokens through geometric mean triads.

# Navigation
nav_order: 2
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

# Forge

{: .note }
> For valid triad patterns and multi-path trading, see [Triads](/concepts/triads/).  
> For the mathematics, see [Tokenomics](/concepts/tokenomics/).

Forge is the universal operation in Uniteum. Every swap, every mint, every burn—all are forge operations on triads with geometric mean structure.

## What Forge Does

Forge transforms tokens within a valid triad **(U, V, √(U·V))** while preserving the invariant:

$$\sqrt{u \cdot v} = w$$

Or equivalently:

$$u \cdot v = w^2$$

Where:
- **u, v** = supplies of two Units in the triad (often treated as reserves by convention)
- **w** = supply of the geometric-mean Unit in the same triad

Here, **W is an independent ERC-20 Unit whose supply is constrained by the invariant**, not a value derived on demand from U and V.

You provide some combination of the three tokens; forge adjusts all supplies to maintain the invariant.

## Two Directions

### Forward: Reserves → Geometric-Mean Unit

Provide Units U and V, receive the geometric-mean Unit W.

Example with triad (foo, 1/foo, 1):
- You provide foo and 1/foo
- You receive `1`
- Supplies of foo and 1/foo increase
- `1` transfers from the contract to you

### Reverse: Geometric-Mean Unit → Reserves

Provide the geometric-mean Unit W, receive Units U and V.

Example:
- You provide `1`
- You receive foo and 1/foo
- `1` transfers to the contract
- Supplies of foo and 1/foo decrease

## Forge as Swap

Want to swap foo for 1/foo?

1. Forge forward: provide foo and some 1/foo → receive `1`
2. Forge reverse: provide `1` → receive foo and 1/foo (in a different ratio)

Net effect: you have traded foo for 1/foo, passing through the `1` Unit.

With compound-unit triads like (meter², 1/second², meter/second), you can create more complex exposures. See [Triads](/concepts/triads/).

## Price Impact

Price effects **emerge from supply changes enforced by the invariant**.

For intuition:

**To increase foo’s price:**
- Decrease the supply of foo
- Increase the supply of 1/foo
- This consumes `1`

**To decrease foo’s price:**
- Increase the supply of foo
- Decrease the supply of 1/foo
- This releases `1`

Forging is not just trading—it is market making through invariant-constrained minting and burning.

## The Invariant Constraint

You cannot forge arbitrary amounts. The invariant constrains the relationship:

$$u_1 \cdot v_1 = w_1^2$$

After forging, this relationship must still hold. The contract calculates what combinations of minting and burning are possible and executes accordingly.

See [Tokenomics](/concepts/tokenomics/) for the full mathematics.

## No Separate Operations

There is no separate “mint” function.  
There is no separate “burn” function.  
There is no separate “swap” function.

Just forge.

This simplicity is intentional: one operation, one invariant, emergent global behavior.
