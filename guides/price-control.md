---
title: Price Control
description: >-
  How to influence token prices through strategic forging
  in Uniteum.

# Navigation
nav_order: 3
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

# Price Control

Forging isn't just trading—it's market making. This guide explains how to influence prices.

## Price Mechanics

For a unit U with reciprocal 1/U:

$$\text{price}(U) = \frac{v}{u}$$

Where:
- u = supply of U
- v = supply of 1/U

To change price, change the ratio.

## Increasing U's Price

Make U scarcer relative to 1/U:

1. **Burn U:** Decrease u
2. **Mint 1/U:** Increase v
3. **Cost:** This consumes "1" from the contract

Result: v/u increases → price(U) increases

## Decreasing U's Price

Make U more abundant:

1. **Mint U:** Increase u
2. **Burn 1/U:** Decrease v
3. **Effect:** This releases "1" from the contract

Result: v/u decreases → price(U) decreases

## Practical Example

*Detailed example with numbers coming soon.*

## Compound Unit Prices

For compound units, the relationship:

$$\text{price}(A \cdot B) = \text{price}(A) \times \text{price}(B)$$

Is enforced by arbitrage, not directly.

To influence compound prices:
- Forge in the compound's formation triad
- Or influence constituent prices

## Market Making Strategy

*Coming soon: thoughts on providing liquidity strategically.*

## Risks

- Other participants can move prices against you
- Arbitrageurs will exploit mispricings
- Gas costs eat into margins

See [Safety](/safety/) for full risk disclosure.

## Next Steps

- [Arbitrage](/concepts/arbitrage/) — Understanding the counterforce
- [Tokenomics](/concepts/tokenomics/) — The full math
