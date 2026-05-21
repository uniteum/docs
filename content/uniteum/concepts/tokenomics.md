---
title: Tokenomics
description: >-
  Supply mechanics and the invariant that governs all Uniteum operations.
  How token supplies constrain prices and how forging changes them.

# Navigation

# Taxonomy

# Metadata
weight: 4
---

# Tokenomics

Every forge operation in Uniteum obeys a single invariant. Understanding this invariant—and how it constrains token supplies—is key to understanding how prices emerge and how the system maintains consistency.

## Notation

Throughout this page, we use lowercase letters for **circulating supplies**:

| Symbol | Meaning |
|--------|---------|
| u | Supply of the first reserve unit in a triad |
| v | Supply of the second reserve unit in a triad |
| w | Supply of the liquidity unit |

Every triad has the form (U, V, √(U*V)) where √(U*V) is the liquidity unit. In the triad (meter², 1/second², meter/second):
- u = supply of `meter²` (reserve unit)
- v = supply of `1/second²` (reserve unit)
- w = supply of `meter/second` (liquidity unit)

## The Invariant

All triads obey:

$$\sqrt{u \cdot v} = w$$

Or equivalently: $$u \cdot v = w^2$$

The liquidity unit supply is the geometric mean of the two reserve unit supplies.

If you're familiar with constant-product AMMs like Uniswap, this should look familiar. The difference: in Uniswap, *k* is an arbitrary constant set at pool creation. In Uniteum, **k = w²**—the liquidity unit's supply determines the liquidity depth.

### What This Means Geometrically

The liquidity unit supply *w* is the **geometric mean** of *u* and *v*:

$$w = \sqrt{u \cdot v}$$

This creates a symmetric relationship between the reserve units. Neither reserve is privileged; they jointly determine the liquidity unit supply.

This geometric mean structure enables 0.5 power perpetuals, connecting Uniteum to the theoretical framework of constant product AMMs. (The v1 contract does not enforce cross-power value constraints — see [_index](/uniteum/) for the design scope.)

## Forge Mechanics

Forging transforms balances while preserving the invariant. Signs are from the **caller's** point of view: positive `du`, `dv` mint U and V to you (increasing their supplies); negative values burn from you.

`forgeQuote` then computes the matching `dw`:

$$dw = w_0 - w_1 \quad\text{where}\quad w_1 = \sqrt{(u_0 + du)(v_0 + dv)}$$

A positive `dw` mints `1` to your balance; a negative `dw` burns `1` from you.

### The floating-pair doubling

When **both** sides of the triad are floating Units (neither U nor V is anchored to an external ERC-20), the contract applies a factor of 2:

$$dw = 2 \cdot (w_0 - w_1)$$

This factor keeps the invariant balanced when both reserves are mint/burnable Units. With one anchored side, the factor is 1; with both sides anchored, `dw = 0` (the `1` balance is untouched). See `Unit.sol:75-88` for the full implementation.

### Forward direction: Mint Reserves, Consume `1`

You forge with positive `du` and `dv`. The supplies of U and V increase, so the invariant requires a larger `w` → `dw < 0`, and `1` is **burned from your balance**.

### Reverse direction: Burn Reserves, Release `1`

You forge with negative `du` and `dv`. The supplies of U and V decrease, so the invariant requires a smaller `w` → `dw > 0`, and `1` is **minted to your balance**.

### Numerical Example

Consider the triad (foo, 1/foo, 1) — both reserves are floating — with initial supplies:
- u = 1,000 (foo)
- v = 1,000 (1/foo)
- w = 1,000 (1)

Check: 1,000 × 1,000 = 1,000² ✓

**Scenario:** You forge with du = +100, dv = +100 (mint 100 foo and 100 of 1/foo to yourself).

New reserves:
- u₁ = 1,100
- v₁ = 1,100
- w₁ = √(1,100 × 1,100) = 1,100

Apply the doubled formula (both sides floating):

$$dw = 2 \cdot (w_0 - w_1) = 2 \cdot (1{,}000 - 1{,}100) = -200$$

You receive: **−200 "1"** — i.e., 200 of your `1` are burned to fund the mint.

The invariant holds: 1,100 × 1,100 = 1,100² ✓

### Asymmetric Forging

You don't have to mint equal amounts. With du = +200 and dv = +50:

- u₁ = 1,200
- v₁ = 1,050
- w₁ = √(1,200 × 1,050) ≈ 1,122.5

$$dw = 2 \cdot (w_0 - w_1) \approx 2 \cdot (1{,}000 - 1{,}122.5) \approx -245$$

Roughly **−245 "1"** burned from your balance.

This also changes the ratio u/v, which changes the **price**.

## Price Relationships

Price emerges from supply ratios. For a unit U with reciprocal 1/U:

$$\text{price}(U) = \frac{v}{u}$$

This is denominated in 1/U per U. Intuitively: if there's more 1/U than U in circulation, U is "scarcer" and thus more expensive.

### Price in Terms of the Mediator

Since u · v = w², we can derive:

$$\text{price}(U) = \frac{w^2}{u^2}$$

Or equivalently:

$$\text{price}(U) = \left(\frac{w}{u}\right)^2$$

This shows how the geometric-mean Unit's bookkeeping value `w` relates price to `u`. Larger `w` relative to `u` means a higher price for U.

### Price Control via Forging

To **increase** U's price:
- Burn U (negative `du`)
- Mint 1/U (positive `dv`)
- The invariant requires more `w`, so `1` is burned from your balance

To **decrease** U's price:
- Mint U (positive `du`)
- Burn 1/U (negative `dv`)
- The invariant requires less `w`, so `1` is minted to your balance

Forging is market making. The invariant just ensures you pay a fair price for the trade.

## Conservation

### What's Conserved

Within a single triad, the invariant u · v = w² is always preserved. You cannot forge in a way that violates it.

### What's Not Conserved

**Total token supply across the system is not fixed.** When you forge (foo, 1/foo, 1):
- foo and 1/foo are minted to (or burned from) your balance
- "1" is burned from (or minted to) your balance, in the opposite direction

`1` is minted and burned globally on the ONE contract — it does not sit "locked" in unit contracts. The bookkeeping value `w = √(u·v)` is computed from reserves, not custodied.

### The "1" Supply


> For economic hypotheses about "1" value, see [Economics of "1"](/uniteum/economics-of-one/).

The primordial "1" supply of 1 billion was minted once in v0.0 (genesis). This is the ceiling—total "1" across all versions will never exceed this amount.

The current version's "1" supply grows through migration from v0.0. At any given time:
- Total supply across all versions ≤ 1 billion
- Current version supply ≤ 1 billion (less until migration occurs)
- v0.0 supply decreases as users migrate to current version

Within each version, the supply lives in user wallets. When you forge a base unit, `1` is minted to or burned from your balance globally on the ONE contract — it is not custodied in the unit contract. The invariant determines how much.

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
| (foo, 1/foo, 1) | foo supply | 1/foo supply | √(u·v), bookkeeping value of `1` for this pair |
| (meter, 1/second, meter/second) | meter supply | 1/second supply | meter/second supply |
| (kilogram·meter, 1/second², force) | kg·m supply | 1/s² supply | force supply |
| (force, 1/force, 1) | force supply | 1/force supply | √(u·v), bookkeeping value of `1` for this pair |

Each row is a separate triad, but all obey u · v = w².

When these triads share tokens—and they do, extensively—arbitrage keeps prices consistent across the entire mesh.

## Implications

### Liquidity Depth = Geometric-Mean Bookkeeping

The bookkeeping value `w = √(u·v)` determines how much slippage a trade incurs. Higher `w` (driven by larger reserve supplies u and v) means deeper liquidity and smaller price impact per trade.

For base units, this means: **larger reserve supplies (more forge activity on that pair) = more liquid that unit is.**

### Price Consistency Is Emergent

No oracle sets prices. The invariant constrains local relationships, and arbitrage propagates consistency globally.

If `meter/second` is mispriced relative to `meter` and `1/second`, arbitrageurs profit by forging through both triads until prices align.

### Everything Connects Through "1"

Base units connect to "1". Compound units connect to their constituents. But compound units *also* connect to "1" via their reciprocals.

This means "1" is the liquidity backbone of the entire system. Its global minting and burning during forge operations — and the resulting holder balances — shape the liquidity landscape.

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
