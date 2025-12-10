---
title: Tokenomics
description: >-
  Supply mechanics and the invariant that governs all Uniteum operations.
  How token supplies constrain prices and how forging changes them.

# Navigation
nav_order: 4
parent: Concepts
has_children: false

# Taxonomy
categories:
  - core
  - tokens

# Metadata
last_updated: 2024-12-09
version: "0.1"
status: draft
---

# Tokenomics

Every forge operation in Uniteum obeys a single invariant. Understanding this invariant—and how it constrains token supplies—is key to understanding how prices emerge and how the system maintains consistency.

## Notation

Throughout this page, we use lowercase letters for **circulating supplies**:

| Symbol | Meaning |
|--------|---------|
| u | Supply of the first token in a triad |
| v | Supply of the second token in a triad |
| w | Supply of the mediating token |

These are positional. In the triad (meter, 1/second, meter/second):
- u = supply of `meter`
- v = supply of `1/second`
- w = supply of `meter/second`

## The Invariant

All triads obey:

$$u \cdot v = w^2$$

The product of the two operand supplies equals the square of the mediator supply.

If you're familiar with constant-product AMMs like Uniswap, this should look familiar. The difference: in Uniswap, *k* is an arbitrary constant set at pool creation. In Uniteum, **k = w²**—the mediator's supply determines the liquidity depth.

### What This Means Geometrically

The mediator supply *w* is the **geometric mean** of *u* and *v*:

$$w = \sqrt{u \cdot v}$$

This creates a symmetric relationship. Neither operand is privileged; they jointly determine the mediator.

## Forge Mechanics

Forging transforms tokens while preserving the invariant. There are two directions:

### Forward Forge: Consume Operands, Mint Mediator

You provide some amount of U and V; you receive W.

Before: u₀, v₀, w₀ (where u₀ · v₀ = w₀²)

You contribute Δu of U and Δv of V.

After: u₁ = u₀ + Δu, v₁ = v₀ + Δv, w₁ = ?

The invariant requires:

$$(u_0 + \Delta u)(v_0 + \Delta v) = w_1^2$$

So:

$$w_1 = \sqrt{(u_0 + \Delta u)(v_0 + \Delta v)}$$

You receive w₁ - w₀ of the mediator token.

### Reverse Forge: Burn Mediator, Receive Operands

You provide W; you receive U and V.

This is the inverse. You specify how much W to burn, and the invariant determines how much U and V you receive.

### Numerical Example

Consider the triad (foo, 1/foo, 1) with initial supplies:
- u = 1,000 (foo)
- v = 1,000 (1/foo)
- w = 1,000 (1)

Check: 1,000 × 1,000 = 1,000² ✓

**Scenario:** You want to forge by adding 100 foo and 100 of 1/foo.

New supplies:
- u₁ = 1,100
- v₁ = 1,100
- w₁ = √(1,100 × 1,100) = 1,100

You receive: 1,100 - 1,000 = **100 "1" tokens**

The invariant holds: 1,100 × 1,100 = 1,100² ✓

### Asymmetric Forging

You don't have to contribute equal amounts. Suppose instead you add 200 foo but only 50 of 1/foo:

- u₁ = 1,200
- v₁ = 1,050
- w₁ = √(1,200 × 1,050) ≈ 1,122.5

You receive approximately 122.5 "1" tokens.

But notice: this changes the ratio u/v, which changes the **price**.

## Price Relationships

Price emerges from supply ratios. For a unit U with reciprocal 1/U:

$$\text{price}(U) = \frac{v}{u}$$

This is denominated in 1/U per U. Intuitively: if there's more 1/U than U in circulation, U is "scarcer" and thus more expensive.

### Price in Terms of the Mediator

Since u · v = w², we can derive:

$$\text{price}(U) = \frac{w^2}{u^2}$$

Or equivalently:

$$\text{price}(U) = \left(\frac{w}{u}\right)^2$$

This shows how the mediator supply affects price. More "1" locked in the U contract means higher prices for U.

### Price Control via Forging

To **increase** U's price:
- Burn U (decrease u)
- Mint 1/U (increase v)
- This consumes "1" from the contract

To **decrease** U's price:
- Mint U (increase u)
- Burn 1/U (decrease v)
- This releases "1" from the contract

Forging is market making. The invariant just ensures you pay a fair price for the trade.

## Conservation

### What's Conserved

Within a single triad, the invariant u · v = w² is always preserved. You cannot forge in a way that violates it.

### What's Not Conserved

**Total token supply across the system is not fixed.** When you forge (foo, 1/foo, 1):
- foo and 1/foo supplies change
- "1" moves between the contract and your wallet

The "1" tokens aren't created or destroyed—they transfer. But foo and 1/foo can be minted or burned as the forge operation requires.

### The "1" Supply

The total "1" supply is fixed at 1 billion (minted in v0.0). But this supply is distributed across:
- User wallets
- Unit contracts (as locked liquidity)
- The Discount Kiosk (unsold inventory)

When you forge a base unit, "1" moves between your wallet and the unit contract. The invariant determines how much.

## Compound Units

Compound units follow the same invariant. Consider the triad (meter, 1/second, meter/second):

$$\text{meter} \cdot \text{(1/second)} = \text{(meter/second)}^2$$

Or with our notation:

$$u \cdot v = w^2$$

Where now:
- u = supply of meter
- v = supply of 1/second
- w = supply of meter/second

### Compounds Have Reciprocals Too

The unit `meter/second` is itself a first-class unit. It has a reciprocal `second/meter`, and this pair is mediated by "1":

$$(meter/second) \cdot (second/meter) = 1^2$$

So compound units participate in two kinds of triads:
1. Their "birth" triad: (A, B, A·B)
2. Their "reciprocal" triad: (A·B, 1/(A·B), 1)

This creates the mesh topology that enables multi-path arbitrage.

## One Invariant, Infinite Triads

The key insight: **every valid triad obeys the same invariant**.

| Triad | u | v | w |
|-------|---|---|---|
| (foo, 1/foo, 1) | foo supply | 1/foo supply | "1" held by foo contract |
| (meter, 1/second, meter/second) | meter supply | 1/second supply | meter/second supply |
| (kilogram·meter, 1/second², force) | kg·m supply | 1/s² supply | force supply |
| (force, 1/force, 1) | force supply | 1/force supply | "1" held by force contract |

Each row is a separate triad, but all obey u · v = w².

When these triads share tokens—and they do, extensively—arbitrage keeps prices consistent across the entire mesh.

## Implications

### Liquidity Depth = Mediator Supply

The mediator supply w determines how much slippage a trade incurs. Higher w means deeper liquidity, smaller price impact per trade.

For base units, this means: **more "1" locked in a unit contract = more liquid that unit is.**

### Price Consistency Is Emergent

No oracle sets prices. The invariant constrains local relationships, and arbitrage propagates consistency globally.

If `meter/second` is mispriced relative to `meter` and `1/second`, arbitrageurs profit by forging through both triads until prices align.

### Everything Connects Through "1"

Base units connect to "1". Compound units connect to their constituents. But compound units *also* connect to "1" via their reciprocals.

This means "1" is the liquidity backbone of the entire system. Its distribution across unit contracts determines the liquidity landscape.

---

## Summary

| Concept | Formula |
|---------|---------|
| Invariant | u · v = w² |
| Price of U | v / u |
| Price in mediator terms | (w / u)² |
| Geometric mean | w = √(u · v) |

One invariant governs all operations. Prices emerge from supply ratios. Forging is the universal operation that respects the invariant while allowing market participants to express their views.

The rest is arbitrage.
