---
layout: default
title: Uniteum
nav_order: 8
has_children: true
permalink: /uniteum/
---

# Uniteum Protocol

<img src="/assets/images/uniteum-one-icon.svg" alt="Uniteum 1 Token" width="120" height="120" style="float: right; margin-left: 20px; margin-bottom: 10px;">

Uniteum is an algebraic liquidity protocol on Ethereum.

Tokens have dimensional units that compose algebraically: `meter/second`, `USD/BTC`, `foo*bar`. The value of `meter/second` is the value of `meter` divided by the value of `second`. The value of `foo²` tracks `foo` squared. What you see is what you get—the notation is the price relationship.

One operation—**forge**—maintains these algebraic relationships through arbitrage. Build custom derivatives with any power profile. No oracles needed.

---

## What Makes This Different

Traditional AMMs: isolated pools, oracle-dependent synthetics, external price feeds.

Uniteum:
- **Geometric mean triads**: Every forge operates on (U, V, √(U*V)) where liquidity units mediate reserve units
- **One invariant** governs all operations: `√(u · v) = w`
- **Infinite interconnected pools** through algebraic composition
- **Arbitrary power perps**: Generalizes beyond Uniswap's 0.5 power perps—create any convexity profile (0.5x, 1x, 2x, custom rational exponents)
- **No oracles**—prices emerge from forge operations and arbitrage
- **Permissionless liquidity creation**—anyone can create units and provide "1" token liquidity

## Why This Matters

**Power perpetuals:** Create any convexity profile through geometric mean triads. `0xWETH^2` (2x power) gives squared exposure, `0xWETH` (1x power) gives linear exposure, `0xWETH^(1/2)` (0.5x power like Uniswap) gives square root exposure—all without borrowing, collateral, or liquidation risk. Design custom convexity with any rational exponent.

**Multi-token derivatives:** `0xWETH/0xUSDC` IS the ETH/USD price ratio. `0xWETH*0xWBTC` is a diversified basket. Combine them algebraically for complex positions. Prices are enforced by arbitrage, not oracles.

**Reciprocal pairs:** Every unit has a reciprocal. Hold both sides to dampen volatility or speculate on relative price movements within diversified baskets.

See [Use Cases](/uniteum/use-cases/) for detailed examples and strategies.

## Current Status

Under active development, unaudited, deployed on Mainnet.

The core forge mechanics for floating units work. The mechanics around anchored units are incomplete, and it may not be possible to get them working. This is novel mechanism design—we don't know what emerges at scale.

No known issues with current functionality. See [Known Issues](/uniteum/known-issues/) for version history and reporting guidelines.

## Support This Experiment

If this work interests you and you'd like to participate, see [Getting Started](/uniteum/getting-started/) for how to acquire "1" tokens. You're not just supporting development—you're acquiring the liquidity backbone of the system and becoming part of the experiment.

Early "1" token holders may benefit if the [value hypothesis](/uniteum/economics-of-one/) holds: as anchored collateral and participation grow, "1" could reflect aggregate system value.

## Quick Links

- [Getting Started](/uniteum/getting-started/) — Buy "1", create your first unit
- [Use Cases](/uniteum/use-cases/) — What you can build and why it matters
- [Concepts](/uniteum/concepts/) — Understand how the system works
- [Known Issues](/uniteum/known-issues/) — Version history and bug reporting
- [Safety](/uniteum/safety/) — Risks and disclaimers

## Contracts

| Contract | Address |
|----------|---------|
| {{ site.data.contracts.uniteum.name }} | {% include etherscan.html address=site.data.contracts.uniteum.address section="code" text=site.data.contracts.uniteum.address %} |
| {{ site.data.contracts.genesis.name }} | {% include etherscan.html address=site.data.contracts.genesis.address section="code" text=site.data.contracts.genesis.address %} |
