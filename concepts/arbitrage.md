---
title: Arbitrage
description: >-
  How price consistency emerges from arbitrage across
  the mesh of interconnected triads.

# Navigation
nav_order: 5
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

# Arbitrage

Uniteum has no price oracles. Instead, price consistency emerges from arbitrage across interconnected triads.

## The Mesh

Every unit participates in multiple triads:

- Base unit `foo` is in (foo, 1/foo, 1)
- It might also be in (foo, bar, foo*bar)
- And (foo, 1/baz, foo/baz)

These triads share tokens. When one triad's price diverges from another's implied price, arbitrage opportunities appear.

## Arbitrage Mechanics

**Scenario:** `meter/second` is mispriced.

The compound `meter/second` participates in two triads:
1. (meter, 1/second, meter/second) — its formation triad
2. (meter/second, second/meter, 1) — its reciprocal triad

If the price in triad 1 implies a different value than triad 2 (via "1"), an arbitrageur can:
1. Forge in one triad to acquire tokens
2. Forge in the other to convert at a better rate
3. Pocket the difference

This profit-seeking closes the gap. Prices converge.

## Price Consistency Emerges

For compound units, the system enforces:

$$\text{price}(A \cdot B) = \text{price}(A) \times \text{price}(B)$$

Not through oracles. Through arbitrage.

If this relationship breaks, someone profits by fixing it. The more liquid the triads, the faster convergence happens.

## The Role of "1"

"1" is the common denominator. Most arbitrage paths pass through it:

```
meter → "1" → second
```

But direct paths also exist:

```
meter → meter/second → second
```

Multiple paths create redundancy. If one path is illiquid, others remain.

## Emergent Properties

We don't fully know how the system behaves at scale:

- **With few units:** Arbitrage paths are limited, prices may diverge
- **With many units:** Dense mesh of paths, faster convergence (theory)
- **Liquidity distribution:** Where "1" concentrates affects the whole system

These are research questions, not solved problems.

## Gas Considerations

Multi-hop arbitrage costs gas. At some point, the profit doesn't justify the transaction cost.

This means:
- Small price differences may persist
- Arbitrage efficiency depends on gas prices
- Layer 2 deployment could change dynamics

## Implications for Users

**If you're trading:** Multiple paths exist. The cheapest path depends on current liquidity.

**If you're providing liquidity:** Forging into a triad deepens that path, improving arbitrage efficiency.

**If you're arbitraging:** The mesh topology creates opportunities, but competition will be fierce once the system has significant liquidity.

## Open Questions

- How quickly do prices converge with 10 units? 100? 1000?
- What's the minimum liquidity for effective arbitrage?
- Do some mesh topologies work better than others?

These questions await empirical answers.
