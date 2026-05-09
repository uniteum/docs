---
title: Uniteum
weight: 13
bookCollapseSection: true
---

# Uniteum Protocol

<img src="/images/uniteum-one-icon.svg" alt="Uniteum 1 Token" width="120" height="120" style="float: right; margin-left: 20px; margin-bottom: 10px;">

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


> The examples below use anchored unit notation (0xWETH, 0xUSDC, etc.) to illustrate what becomes possible once anchored units are fully implemented. Today, floating units (foo, meter, etc.) and their forge operations work as documented. See the [anchored units caveat](#current-status) above.

**Power perpetuals:** Create any convexity profile through geometric mean triads. `foo^2` (2x power) gives squared exposure, `foo` (1x power) gives linear exposure, `foo^(1/2)` (0.5x power like Uniswap) gives square root exposure—all without borrowing, collateral, or liquidation risk. Design custom convexity with any rational exponent. Once anchored units work, the same applies to `0xWETH^2`, `0xWETH`, etc.

**Multi-token derivatives:** With anchored units, `0xWETH/0xUSDC` would BE the ETH/USD price ratio. `0xWETH*0xWBTC` would be a diversified basket. Today, floating units already compose algebraically—`foo/bar` IS the foo/bar price ratio, enforced by arbitrage, not oracles.

**Reciprocal pairs:** Every unit has a reciprocal. Hold both sides to dampen volatility or speculate on relative price movements within diversified baskets.

See [Use Cases](/uniteum/use-cases/) for detailed examples and strategies.

## Current Status

Under active development, unaudited, deployed on Mainnet.

The core forge mechanics for floating units work. The mechanics around anchored units are incomplete, and it may not be possible to get them working. This is novel mechanism design—we don't know what emerges at scale.

No known issues with current functionality. See [Known Issues](/uniteum/known-issues/) for version history and reporting guidelines.


> **Anchored units are incomplete.** The current contract does not fully support anchored units—units backed 1:1 by external ERC-20 tokens. The deposit and withdrawal mechanics need further work, and it may turn out that the design cannot accommodate them. All documentation referencing anchored units (0xWETH, 0xUSDC, etc.) describes intended behavior, not current capability. Floating units and their forge operations work as documented.

## Support This Experiment

If this work interests you and you'd like to participate, see [Getting Started](/uniteum/getting-started/) for how to acquire "1" tokens. You're not just supporting development—you're acquiring the liquidity backbone of the system and becoming part of the experiment.

Early "1" token holders may benefit if the [value hypothesis](/uniteum/economics-of-one/) holds: as participation grows, "1" could reflect aggregate system value.

## Quick Links

- [Getting Started](/uniteum/getting-started/) — Acquire "1", create your first unit
- [Use Cases](/uniteum/use-cases/) — What you can build and why it matters
- [Concepts](/uniteum/concepts/) — Understand how the system works
- [Known Issues](/uniteum/known-issues/) — Version history and bug reporting
- [Safety](/uniteum/safety/) — Risks and disclaimers

## Contracts

| Contract | Address |
|----------|---------|
| {{< val "contracts.uniteum.name" >}} | {{< etherscan address="0xace41cf6d750d7ba06f4de57ac9e063246b2b090" section="code" text="0xace41cf6d750d7ba06f4de57ac9e063246b2b090" >}} |
| {{< val "contracts.genesis.name" >}} | {{< etherscan address="0x7D5B1349157335aEEB929080a51003B529758830" section="code" text="0x7D5B1349157335aEEB929080a51003B529758830" >}} |
