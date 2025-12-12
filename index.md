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
last_updated: 2024-12-11
version: "0.1"
status: draft
---

# Uniteum

Uniteum is an algebraic liquidity protocol on Ethereum.

Tokens have dimensional units—like physical quantities (meter, second, kilogram) or arbitrary symbols (foo, bar). Units compose algebraically: `meter` divided by `second` gives `meter/second`. Every unit has a reciprocal. Every composition creates new tokens.

Prices aren't set by oracles. They emerge from a single operation—**forge**—and the arbitrage it enables.

## What Makes This Different

Traditional AMMs: isolated pools, oracle-dependent synthetics, external price feeds.

Uniteum:
- **One invariant** governs all operations: `u · v = w²`
- **Infinite interconnected pools** through algebraic composition
- **No oracles**—prices emerge from forge operations and arbitrage
- **No collateral requirements** for symbolic units

## Why This Matters

**Hedge without oracles:** Every anchored token has a reciprocal that acts as an automatic hedge. `$USDC` depegs? Your `1/$USDC` gains offset the losses. No oracles, no collateral, no liquidations.

**Power perpetuals:** `$WETH^2` gives you squared exposure to ETH price movements—leverage without borrowing or liquidation risk. Rational exponents let you design custom convexity profiles.

**Multi-token derivatives:** `$WETH/$USDC` IS the ETH/USD price ratio. `$WETH*$WBTC` is a diversified basket. Combine them algebraically for complex positions. Prices are enforced by arbitrage, not oracles.

See [Use Cases](/use-cases/) for detailed examples and strategies.

## Current Status

**Version 0.1** — Experimental, unaudited, deployed on Mainnet and Sepolia.

This is novel mechanism design. We don't know what emerges at scale. Proceed with curiosity and caution.

## Support This Experiment

If this work interests you and you'd like to participate: the best way to contribute is to [buy "1" tokens from the Discount Kiosk](https://etherscan.io/address/0x55816c3e5d999e2f45ce0146ffd89b2e78a56dc9#writeContract). You're not just supporting development—you're acquiring the liquidity backbone of the system and becoming part of the experiment.

The Kiosk uses linear discount pricing—price increases as inventory depletes. Early acquisition is cheaper.

Early "1" token holders may benefit if the [value hypothesis](/economics-of-one/) holds: as anchored collateral and participation grow, "1" could reflect aggregate system value.

## Quick Links

- [Use Cases](/use-cases/) — What you can build and why it matters
- [Getting Started](/getting-started/) — Buy "1", create your first unit
- [Concepts](/concepts/) — Understand how the system works
- [Safety](/safety/) — Risks and disclaimers

## Contracts

| Contract | Mainnet | Sepolia |
|----------|---------|---------|
| Uniteum 0.1 "1" | [`0x9df9b0501e8f6c05623b5b519f9f18b598d9b253`](https://etherscan.io/address/0x9df9b0501e8f6c05623b5b519f9f18b598d9b253#code) | [`0x9df9b0501e8f6c05623b5b519f9f18b598d9b253`](https://sepolia.etherscan.io/address/0x9df9b0501e8f6c05623b5b519f9f18b598d9b253#code) |
| Uniteum 0.0 "1" (genesis) | [`0xC833f0B7cd7FC479DbbF6581EB4eEFc396Cf39E4`](https://etherscan.io/address/0xC833f0B7cd7FC479DbbF6581EB4eEFc396Cf39E4#code) | [`0xC833f0B7cd7FC479DbbF6581EB4eEFc396Cf39E4`](https://sepolia.etherscan.io/address/0xC833f0B7cd7FC479DbbF6581EB4eEFc396Cf39E4#code) |
| Discount Kiosk | [`0x55816c3e5d999e2f45ce0146ffd89b2e78a56dc9`](https://etherscan.io/address/0x55816c3e5d999e2f45ce0146ffd89b2e78a56dc9#code) | [`0x55816c3e5d999e2f45ce0146ffd89b2e78a56dc9`](https://sepolia.etherscan.io/address/0x55816c3e5d999e2f45ce0146ffd89b2e78a56dc9#code) |

---

Uniteum, "1", and related marks are trademarks. See [Legal](/legal/) for details.
