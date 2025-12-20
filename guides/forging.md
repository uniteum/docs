---
title: Forging
description: >-
  How to execute forge operations on geometric mean triads
  using Etherscan and other tools.

# Navigation
nav_order: 2
parent: Guides
has_children: false

# Taxonomy
categories:
  - trading

# Metadata
last_updated: 2024-12-20
version: "0.2"
status: draft
---

# Forging

This guide explains how to execute forge operations on triads with geometric mean structure.

## Prerequisites

- "1" tokens (v0.1) in your wallet
- The unit(s) you want to forge must exist
- Understanding of [Triads](/concepts/triads/) — every forge operates on (U, V, √(U*V))

## Basic Forge: Reciprocal Pair (foo, 1/foo, 1)

In this triad:
- **Reserve units**: foo and 1/foo
- **Liquidity unit**: "1" (since √(foo * 1/foo) = 1)

### Adding Liquidity (Forward Forge)

Provide reserve units (foo and 1/foo), receive liquidity unit ("1"):

1. Approve the foo contract to spend your foo tokens
2. Approve the 1/foo contract to spend your 1/foo tokens
3. Call `forge()` with your desired amounts
4. Receive "1" tokens (the liquidity unit)

### Removing Liquidity (Reverse Forge)

Provide liquidity unit ("1"), receive reserve units (foo and 1/foo):

1. Approve the Unit contract to spend your "1" tokens
2. Call `forge()` specifying withdrawal
3. Receive foo and 1/foo tokens (the reserves)

## Via Etherscan

*Detailed steps with screenshots coming soon.*

## Via Code

```javascript
// Example using ethers.js
const fooUnit = new ethers.Contract(FOO_UNIT_ADDRESS, UNIT_ABI, signer);

// Forge reciprocal pair triad (foo, 1/foo, 1)
// Reserve units: foo and 1/foo
// Liquidity unit: "1"
// Mint 100 foo, burn 50 1/foo, changes in "1" supply
const tx = await fooUnit.forge(
  ethers.utils.parseEther("100"),   // du: mint 100 foo (reserve)
  ethers.utils.parseEther("-50")    // dv: burn 50 1/foo (reserve)
);

// For compound unit forging (meter², second², meter*second)
// Reserve units: meter² and second²
// Liquidity unit: meter*second (the geometric mean)
const meter2Unit = new ethers.Contract(METER2_UNIT_ADDRESS, UNIT_ABI, signer);
const second2Unit = new ethers.Contract(SECOND2_UNIT_ADDRESS, UNIT_ABI, signer);
const tx2 = await meter2Unit.forge(
  second2Unit.address,              // V: the other reserve unit
  ethers.utils.parseEther("100"),   // du: change in meter²
  ethers.utils.parseEther("-50")    // dv: change in second²
);
// This mints/burns meter*second (liquidity unit) and transfers meter², second² (reserves)
```

*Full code examples coming soon.*

## Calculating Amounts

The invariant constrains what's possible:

$$\sqrt{u \cdot v} = w$$

Or equivalently: $$u \cdot v = w^2$$

Where:
- **u, v** = supplies of the reserve units
- **w** = supply of the liquidity unit (geometric mean)

Given current supplies and your input, the contract calculates outputs to maintain the invariant.

See [Tokenomics](/concepts/tokenomics/) for the math.

## Slippage

Large forges relative to existing liquidity cause slippage. The invariant curve is continuous—small trades have small impact, large trades have large impact.

## Gas Costs

Forge operations involve:
- Token transfers
- Supply updates
- Invariant calculations

Gas costs scale with complexity. Simple triads are cheapest.

## Next Steps

- [Price Control](/guides/price-control/) — Use forging strategically
- [Arbitrage](/concepts/arbitrage/) — Profit from price differences
