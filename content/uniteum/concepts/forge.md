---
title: Forge
description: >-
  The single operation that powers all of Uniteum:
  creating, destroying, and swapping tokens through geometric mean triads.

# Navigation

# Taxonomy

# Metadata
weight: 2
---

# Forge


> For valid triad patterns and multi-path trading, see [Triads](/uniteum/concepts/triads/).  
> For the mathematics, see [Tokenomics](/uniteum/concepts/tokenomics/).

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

The forge signature is `forge(du, dv)` returning `dw`. Each signed delta describes a change to *your* balance: positive mints to you, negative burns from you. The contract then mints or burns `dw` of the geometric-mean Unit to keep the invariant satisfied — `dw` is computed by `forgeQuote`, not supplied.

### Forward: Mint Reserves, Consume Geometric-Mean Unit

Increase the supplies of U and V (positive `du`, `dv`). The invariant `u·v = w²` then requires a larger `w` — so the contract burns `1` from your balance to mint additional geometric-mean Units into the reserve pair.

Example with triad (foo, 1/foo, 1):
- You forge with positive `du` and `dv`
- foo and 1/foo are minted to you (their supplies increase)
- `1` is burned from your balance (negative `dw`)

### Reverse: Burn Reserves, Release Geometric-Mean Unit

Decrease the supplies of U and V (negative `du`, `dv`). The invariant now requires a smaller `w`, so the contract mints `1` to you.

Example:
- You forge with negative `du` and `dv`
- foo and 1/foo are burned from you (supplies decrease)
- `1` is minted to you (positive `dw`)

## Forge as Swap

Want to swap foo for 1/foo?

1. Forge with positive `du`, smaller positive `dv` → foo and 1/foo are minted to you, `1` is consumed
2. Forge with negative `du`, more negative `dv` → foo and 1/foo are burned from you, `1` is released

Net effect: you have shifted exposure from foo to 1/foo, mediated by burning and minting `1` against your balance.

With compound-unit triads like (meter², 1/second², meter/second), you can create more complex exposures. See [Triads](/uniteum/concepts/triads/).

## Price Impact

Price effects **emerge from supply changes enforced by the invariant**.

For intuition:

**To increase foo's price:**
- Burn foo (negative `du`)
- Mint 1/foo (positive `dv`)
- The invariant requires more `w`, so `1` is burned from your balance

**To decrease foo's price:**
- Mint foo (positive `du`)
- Burn 1/foo (negative `dv`)
- The invariant requires less `w`, so `1` is minted to your balance

Forging is not just trading—it is market making through invariant-constrained minting and burning.

## The Invariant Constraint

You cannot forge arbitrary amounts. The invariant constrains the relationship:

$$u_1 \cdot v_1 = w_1^2$$

After forging, this relationship must still hold. The contract calculates what combinations of minting and burning are possible and executes accordingly.

See [Tokenomics](/uniteum/concepts/tokenomics/) for the full mathematics.

## No Separate Operations

There is no separate “mint” function.  
There is no separate “burn” function.  
There is no separate “swap” function.

Just forge.

This simplicity is intentional: one operation, one invariant, emergent global behavior.
