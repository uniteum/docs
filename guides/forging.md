---
title: Forging
description: >-
  How to execute forge operations in Uniteum
  using Etherscan and other tools.

# Navigation
nav_order: 2
parent: Guides
has_children: false

# Taxonomy
categories:
  - trading

# Metadata
last_updated: 2024-12-09
version: "0.1"
status: draft
---

# Forging

This guide explains how to execute forge operations.

## Prerequisites

- "1" tokens (v0.1) in your wallet
- The unit(s) you want to forge must exist
- Understanding of [Triads](/concepts/triads/)

## Basic Forge: (foo, 1/foo, 1)

### Adding Liquidity (Forward Forge)

Provide foo and 1/foo, receive "1":

1. Approve the foo contract to spend your foo tokens
2. Approve the 1/foo contract to spend your 1/foo tokens
3. Call `forge()` with your desired amounts
4. Receive "1" tokens

### Removing Liquidity (Reverse Forge)

Provide "1", receive foo and 1/foo:

1. Approve the Unit contract to spend your "1" tokens
2. Call `forge()` specifying withdrawal
3. Receive foo and 1/foo tokens

## Via Etherscan

*Detailed steps with screenshots coming soon.*

## Via Code

```javascript
// Example using ethers.js
const fooUnit = new ethers.Contract(FOO_UNIT_ADDRESS, UNIT_ABI, signer);

// Forge the reciprocal pair (foo, 1/foo, 1)
// Mint 100 foo, burn 50 1/foo, receive "1"
const tx = await fooUnit.forge(
  ethers.utils.parseEther("100"),   // du: mint 100 foo
  ethers.utils.parseEther("-50")    // dv: burn 50 1/foo
);

// For compound unit forging (meter, second, meter*second)
const meterUnit = new ethers.Contract(METER_UNIT_ADDRESS, UNIT_ABI, signer);
const secondUnit = new ethers.Contract(SECOND_UNIT_ADDRESS, UNIT_ABI, signer);
const tx2 = await meterUnit.forge(
  secondUnit.address,               // V: the other unit
  ethers.utils.parseEther("100"),   // du: change in meter
  ethers.utils.parseEther("-50")    // dv: change in second
);
```

*Full code examples coming soon.*

## Calculating Amounts

The invariant constrains what's possible:

$$u \cdot v = w^2$$

Given current supplies and your input, the contract calculates outputs.

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
