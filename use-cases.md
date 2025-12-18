---
title: Use Cases
description: >-
  Practical applications and value propositions for Uniteum's
  algebraic liquidity protocol.

# Navigation
nav_order: 3
has_children: false

# Taxonomy
categories:
  - use-cases
  - derivatives

# Metadata
last_updated: 2024-12-11
version: "0.1"
status: draft
---

# Use Cases

Uniteum enables novel financial primitives through algebraic composition of units. Here are the key value propositions and use cases.

> **Notation:** For readability, we use [$WETH](/reference/anchored-units/weth/), [$USDC](/reference/anchored-units/usdc/), etc. in examples. Remember that anchored units actually use full contract addresses: `$0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2` for WETH. Click any token link to see its actual symbol. See [Token Reference](/reference/anchored-units/) and [Anchored Units](#anchored-units) below.

## Hedging with Reciprocals

**The simplest and most powerful use case:** Every anchored unit has a reciprocal that acts as a hedge.

### Stablecoin Depeg Protection

Create an anchored USDC unit and its reciprocal:

- [$USDC](/reference/anchored-units/usdc/) — backed 1:1 by real USDC held in the contract
- `1/$USDC` — synthetic reciprocal (not backed)

**Price relationship:** `price($USDC) × price(1/$USDC) = price(1)`

When USDC depegs:

| USDC Price | $USDC Value | 1/$USDC Value | Effect |
|------------|-------------|---------------|--------|
| $1.00 | ~1 "1" | ~1 "1" | Equilibrium |
| $0.90 | ↓ 10% | ↑ 11% | Hedge gains |
| $0.50 | ↓ 50% | ↑ 100% | Strong protection |

**Hold both:** Your `1/$USDC` gains offset `$USDC` losses automatically.

**No oracle needed** — the reciprocal relationship is enforced by the invariant and arbitrage.

### Volatile Asset Hedging

The same mechanism works for any ERC-20:

**[$WETH](/reference/anchored-units/weth/) and `1/$WETH`:**
- Long ETH? Hold [$WETH](/reference/anchored-units/weth/)
- Short ETH? Hold `1/$WETH`
- Hedged exposure? Hold both

**[$WBTC](/reference/anchored-units/wbtc/) and `1/$WBTC`:**
- Protect BTC holdings from dumps
- Gain from BTC price increases
- No borrowing, no collateral, no liquidations

### Why This Is Novel

Traditional DeFi hedging requires:
- ❌ Oracles (manipulation risk, latency)
- ❌ Collateral (capital inefficiency)
- ❌ Liquidation mechanisms (complexity, risk)

Uniteum reciprocal hedging:
- ✅ No oracles (pure arbitrage enforcement)
- ✅ No collateral for synthetic side (`1/$USDC` isn't backed)
- ✅ No liquidations (spot tokens, supply/demand via forge)

**The reciprocal IS the derivative**, and its price is mathematically enforced.

## Power Perpetuals

Compound units with exponents create leveraged exposure without borrowing.

### Squared Units

**`$WETH^2` (ETH squared):**

Price relationship: `price($WETH^2) = price($WETH)²`

| ETH Moves | $WETH Change | $WETH^2 Change |
|-----------|--------------|----------------|
| 2x | +100% | +300% (4x) |
| 1.5x | +50% | +125% (2.25x) |
| 0.5x | -50% | -75% (0.25x) |

**Leveraged upside, amplified downside** — without liquidation risk.

**`1/$WETH^2` (inverse squared):**
- Convex hedge against ETH dumps
- If ETH drops 50%, this gains 300% (4x)
- Non-linear protection

### Rational Exponents

**`$WETH^3\2` (ETH to the 3/2 power):**
- Custom convexity profiles
- Design exact risk/reward curves
- Build exotic options-like payoffs

Note: Exponent division uses `\` (backslash): `^3\2` means "to the 3/2 power"

### Comparison to Traditional Perpetuals

**Traditional perps:**
- Need funding rates
- Require oracles
- Liquidation mechanisms
- Counterparty risk

**Uniteum power perpetuals:**
- ✅ No funding (liquidity depth determines slippage)
- ✅ No oracles (algebraic price enforcement)
- ✅ No liquidations (spot tokens)
- ✅ No counterparty (AMM-like mechanism)

## Multi-Token Derivatives

Compound units combine multiple tokens into single derivatives.

### Ratio Units (Pair Trading)

**`$WETH/$USDC` — the ETH/USD price ratio itself:**

Not tracking the price — **this token IS the price ratio**.

Enforced by: `price($WETH/$USDC) = price($WETH) / price($USDC)`

- Long this = long ETH, short USD
- Arbitrage keeps it aligned with external markets
- Pure directional bet on ETH vs USD

**`$WBTC/$WETH` — BTC/ETH relative value:**
- Don't care about USD price
- Only care about BTC vs ETH
- Oracle-free pair trading

### Product Units (Baskets)

**`$WETH*$WBTC` — diversified crypto basket:**

Price relationship: `price($WETH*$WBTC) = price($WETH) × price($WBTC)`

- If either pumps, basket pumps
- Diversified exposure in one token
- No index fund operator needed

**Multi-asset baskets:**
- `$WETH*$WBTC*$LINK` — three-token basket
- Automatically rebalances via arbitrage
- Permissionless index creation

### Complex Combinations

**`$WETH^2/$USDC` — squared ETH vs USD:**
- Leveraged ETH exposure relative to USD
- Combines power perpetual with ratio

**`$WBTC*$WETH/$USDC^2` — complex multi-asset derivative:**
- Long BTC+ETH
- Inverse squared USD exposure
- Custom risk profile

**`1/($WETH*$WBTC)` — short the crypto market:**
- Inverse of basket
- Gains when crypto dumps
- Relative to "1" token

## Volatility Trading

### Straddle-Like Positions

**Hold both `$WETH` and `1/$WETH`:**

When WETH is stable:
- Both trade near parity
- Tight spreads
- Low volatility value

When WETH moves (either direction):
- One side gains more than other loses (convexity)
- Volatility creates profit opportunity
- Pure vol play

### Correlation Trading

**Long `$WETH/$WBTC`, short `$WETH*$WBTC`:**
- Profits when correlation between ETH and BTC changes
- Previously required complex derivatives
- Accessible through simple unit composition

## Liquidity Provision

### Universal Market Making

Traditional AMMs: Choose specific pools (ETH/USDC, WBTC/ETH, etc.)

Uniteum: **Forging any unit pair IS market making**

- One operation (`forge`) provides liquidity
- "1" tokens are the universal mediator
- Liquidity provision across infinite interconnected pools

### Composable Returns

Provide liquidity to base units (meter, second):
- Indirectly creates liquidity for compounds (meter/second, meter²)
- Network effects amplify positions
- Earn on entire algebraic mesh

### Fee Opportunities

Forge operations create trading spreads:
- Tight when supplies are balanced
- Wide when supplies are imbalanced
- Arbitrageurs pay to rebalance
- Liquidity providers capture spread

## Speculation & Discovery

### Novel Mechanism, Unknown Emergent Properties

This is experimental territory:
- Multi-dimensional constant-product AMM
- Algebraic price relationships
- Mesh topology of arbitrage paths

**Nobody knows what emerges at scale.**

### Early Participant Advantages

- Understand arbitrage dynamics before others
- Profit from price inefficiencies during discovery
- Shape liquidity in new unit pairs
- Front-run conceptual understanding

### Floating Units

Create units with arbitrary labels:
- `foo`, `bar`, `ACME`, `moon`
- No backing, no inherent value
- Value emerges purely from consensus/liquidity
- Speculative social tokens

**IMPORTANT:** Floating `MSFT` has ZERO connection to Microsoft stock. It's just a label.

## Builder Primitives

### Permissionless Financial Engineering

- Create arbitrary units
- Compose algebraically
- Let arbitrage enforce price relationships
- No governance approvals needed

### Programmable Price Relationships

`price(A*B) = price(A) × price(B)` enforced mathematically, not by oracles.

Design complex financial instruments knowing price structure is self-consistent.

### Use Case Examples

**Prediction markets:**
- Create units for outcomes
- Price discovery via forging
- Settlement via algebraic relationships

**Gaming economies:**
- In-game items as units
- Crafting = compound units (sword*shield)
- Market-driven pricing

**Experimental derivatives:**
- Custom convexity profiles
- Multi-asset exposures
- Novel risk/reward structures

## Anchored Units

### The Critical Distinction

**Anchored units use full contract addresses:**

Real format: `$0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2` (WETH)

Created via: `one().anchored(IERC20(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2))`

Common anchored units (click for details):
- [$WETH](/reference/anchored-units/weth/) — `$0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2`
- [$USDC](/reference/anchored-units/usdc/) — `$0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48`
- [$USDT](/reference/anchored-units/usdt/) — `$0xdAC17F958D2ee523a2206206994597C13D831ec7`
- [$WBTC](/reference/anchored-units/wbtc/) — `$0x2260FAC5E5542a773Aa44fBCfEDf7C193bc2C599`
- [$DAI](/reference/anchored-units/dai/) — `$0x6B175474E89094C44Da98b954EedeAC495271d0F`

See [Token Reference](/reference/anchored-units/) for complete list and usage examples.

### Anchored vs Floating

| Aspect | Anchored (`$0xAddress`) | Floating (`symbol`) |
|--------|------------------------|---------------------|
| Backing | 1:1 ERC-20 in contract | None |
| Value | Real, custodial | Consensus/liquidity only |
| Creation | `one().anchored(IERC20)` | `one().multiply("symbol")` |
| Redeemable | Yes, for underlying | No |
| Trust | Contract security | Market belief |

**Floating `WETH` ≠ Anchored `$0xC02a...56Cc2`**

A floating unit with label "WETH" has no connection to actual WETH. It's just a name.

## Risk Considerations

All use cases carry significant risks:

- **Smart contract risk** — unaudited, experimental code
- **Novel mechanism risk** — unknown emergent properties at scale
- **Liquidity risk** — needs critical mass to function well
- **Gas costs** — complex operations may be expensive
- **Floating units** — have NO inherent value or backing

See [Safety](/safety/) for detailed risk disclosures.

## What We Don't Know

Open research questions:
- Scale behavior with hundreds of interconnected units?
- Do compound unit prices actually track constituents reliably?
- How efficient is arbitrage across mesh topology?
- What breaks? What unexpected patterns emerge?

**These are experiments, not solved problems.**

## Next Steps

- [Getting Started](/getting-started/) — Try it yourself
- [Concepts](/concepts/) — Understand the mechanism
- [Guides](/guides/) — Practical tutorials
- [Examples](/examples/) — Concrete transactions

---

**Remember:** This is Version 0.1 — experimental, unaudited, novel mechanism design. Proceed with curiosity and caution.

Uniteum, "1", and related marks are trademarks. See [Legal](/legal/) for details.
