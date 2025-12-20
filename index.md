---
title: Uniteum
description: >-
  An algebraic liquidity protocol where tokens have dimensional units
  and prices emerge from forge operations, not oracles.

# Navigation
nav_order: 1
has_children: false

# Taxonomy
categories:
  - getting-started

# Metadata
last_updated: 2024-12-17
version: "0.3"
status: draft
---

# Uniteum

<img src="/assets/images/uniteum-one-icon.svg" alt="Uniteum 1 Token" width="120" height="120" style="float: right; margin-left: 20px; margin-bottom: 10px;">

Uniteum is an algebraic liquidity protocol on Ethereum.

Tokens have dimensional units—like physical quantities (meter, second, kilogram) or arbitrary symbols (foo, bar). Units compose algebraically: `meter` divided by `second` gives `meter/second`. Every unit has a reciprocal. Every composition creates new tokens.

Prices aren't set by oracles. They emerge from a single operation—**forge**—and the arbitrage it enables.

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

**Power perpetuals:** Create any convexity profile through geometric mean triads. `$WETH^2` (2x power) gives squared exposure, `$WETH` (1x power) gives linear exposure, `$WETH^(1/2)` (0.5x power like Uniswap) gives square root exposure—all without borrowing, collateral, or liquidation risk. Design custom convexity with any rational exponent.

**Multi-token derivatives:** `$WETH/$USDC` IS the ETH/USD price ratio. `$WETH*$WBTC` is a diversified basket. Combine them algebraically for complex positions. Prices are enforced by arbitrage, not oracles.

**Reciprocal pairs:** Every unit has a reciprocal. Hold both sides to dampen volatility or speculate on relative price movements within diversified baskets.

See [Use Cases](/use-cases/) for detailed examples and strategies.

## Current Status

{% assign current_uniteum = site.data.contracts.uniteum[site.data.contracts.current.uniteum] -%}
**Version {{ current_uniteum.version }}** — Experimental, unaudited, deployed on Mainnet and Sepolia.

This is novel mechanism design. We don't know what emerges at scale. Proceed with curiosity and caution.

No known issues. See [Known Issues](/known-issues/) for version history and reporting guidelines.

## Support This Experiment

If this work interests you and you'd like to participate: the best way to contribute is to [buy "1" tokens from the Discount Kiosk](https://etherscan.io/address/0x55816c3e5d999e2f45ce0146ffd89b2e78a56dc9#writeContract). You're not just supporting development—you're acquiring the liquidity backbone of the system and becoming part of the experiment.

The Kiosk uses linear discount pricing—price increases as inventory depletes. Early acquisition is cheaper.

Early "1" token holders may benefit if the [value hypothesis](/economics-of-one/) holds: as anchored collateral and participation grow, "1" could reflect aggregate system value.

## Quick Links

- [Getting Started](/getting-started/) — Buy "1", create your first unit
- [Use Cases](/use-cases/) — What you can build and why it matters
- [Concepts](/concepts/) — Understand how the system works
- [Known Issues](/known-issues/) — Version history and bug reporting
- [Safety](/safety/) — Risks and disclaimers

## Contracts

{% assign current_uniteum = site.data.contracts.uniteum[site.data.contracts.current.uniteum] -%}
{% assign genesis_uniteum = site.data.contracts.uniteum.v0_0 -%}
{% assign current_kiosk = site.data.contracts.kiosk[site.data.contracts.current.kiosk] -%}
{% assign genesis_kiosk = site.data.contracts.kiosk.v0_0 -%}

| Contract | Mainnet | Sepolia |
|----------|---------|---------|
| {{ current_uniteum.name }} | [`{{ current_uniteum.mainnet }}`](https://etherscan.io/address/{{ current_uniteum.mainnet }}#code) | [`{{ current_uniteum.sepolia }}`](https://sepolia.etherscan.io/address/{{ current_uniteum.sepolia }}#code) |
| {{ genesis_uniteum.name }} | [`{{ genesis_uniteum.mainnet }}`](https://etherscan.io/address/{{ genesis_uniteum.mainnet }}#code) | [`{{ genesis_uniteum.sepolia }}`](https://sepolia.etherscan.io/address/{{ genesis_uniteum.sepolia }}#code) |
| {{ current_kiosk.name }} | [`{{ current_kiosk.mainnet }}`](https://etherscan.io/address/{{ current_kiosk.mainnet }}#code) | [`{{ current_kiosk.sepolia }}`](https://sepolia.etherscan.io/address/{{ current_kiosk.sepolia }}#code) |
| {{ genesis_kiosk.name }} | [`{{ genesis_kiosk.mainnet }}`](https://etherscan.io/address/{{ genesis_kiosk.mainnet }}#code) | [`{{ genesis_kiosk.sepolia }}`](https://sepolia.etherscan.io/address/{{ genesis_kiosk.sepolia }}#code) |

---

Uniteum, "1", and related marks are trademarks. See [Legal](/legal/) for details.
