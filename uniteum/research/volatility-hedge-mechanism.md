---
layout: page
title: "Volatility Hedge Mechanism - Research Summary"
permalink: /research/volatility-hedge/
parent: Research Materials - Volatility Hedge Discovery
---

# Native Volatility Hedging in Uniteum: A Research Summary

**Author:** Paul Reinholdtsen (reinholdtsen.eth)
**Date:** December 2024
**Status:** Preliminary findings for academic review

## Executive Summary

Uniteum's geometric mean liquidity structure creates a **native volatility hedging instrument** that inverts the traditional AMM impermanent loss payoff. By holding equal amounts of a liquidity unit √(A*B) and its reciprocal 1/√(A*B), traders can profit from price volatility in either direction without directional bias.

This appears to be a novel derivative primitive that combines properties of:
- Long gamma options positions (profit from realized volatility)
- Variance swaps (exposure to volatility, not direction)
- Perpetual instruments (no expiration, no theta decay)

**Key Finding:** The hedged position profits ~6% when the underlying asset doubles OR halves, with no fees charged and no counterparty risk beyond smart contract execution.

---

## 1. Mechanism Overview

### 1.1 Triad Structure

All Uniteum operations use a **triad** structure: (U, V, W) where:
- U, V are **reserve units** (the assets being exchanged)
- W is the **liquidity unit** (geometric mean of reserves)
- Invariant: √(U * V) = W

### 1.2 The Reciprocal Liquidity Pair

For any compound liquidity unit √(A*B), there exists a reciprocal pair triad:

**`(√(A*B), 1/√(A*B), 1)`**

This is valid because: √(√(A*B) * 1/√(A*B)) = √1 = 1 ✓

The liquidity unit for this pair is "1" (the universal base unit in Uniteum).

### 1.3 Creating the Hedge

Starting with "1" tokens, a trader can forge to obtain:
- x units of √(A*B)
- x units of 1/√(A*B)

This requires burning "1" tokens proportional to the quantities minted.

---

## 2. Mathematical Analysis

### 2.1 Notation

Let:
- p_A(t) = price of asset A at time t
- p_B(t) = price of asset B at time t
- p₁ = fixed price of "1" (assumed $1 for this analysis)
- x = quantity held of each hedge component

### 2.2 Value Function

**Position value at time t:**

V(t) = x · √(p_A(t) · p_B(t)) + x · 1/√(p_A(t) · p_B(t))

**Initial value (at t=0 when p_A = p_B = $1):**

V(0) = x · √(1 · 1) + x · 1/√(1 · 1) = x + x = 2x

### 2.3 Profit Function

Let r_A = p_A(t)/p_A(0) be the return on asset A (with p_B held constant at $1).

**Value at time t:**

V(t) = x · √(r_A · 1) + x · 1/√(r_A · 1) = x(√r_A + 1/√r_A)

**Profit/Loss:**

PnL(r_A) = V(t) - V(0) = x(√r_A + 1/√r_A) - 2x = x(√r_A + 1/√r_A - 2)

### 2.4 Key Properties

**Symmetry:** PnL(r) = PnL(1/r)
- Doubling (r=2) gives same profit as halving (r=0.5)
- No directional bias

**Convexity:** d²PnL/dr² > 0 for all r > 0
- Positive gamma (profit accelerates with larger moves)

**Minimum at parity:** PnL(1) = 0
- Maximum loss is zero (at starting prices)

---

## 3. Worked Example

### Setup
- Hold 100 units of √(A*B) + 100 units of 1/√(A*B)
- Initial prices: A = $1, B = $1
- "1" fixed at $1
- Initial value: 100·$1 + 100·$1 = $200

### Scenario 1: A doubles to $2 (B constant at $1)

**New values:**
- √(A*B) = √($2 · $1) = $1.414
- 1/√(A*B) = 1/$1.414 = $0.707

**Position value:**
- 100 × $1.414 = $141.42
- 100 × $0.707 = $70.71
- **Total: $212.13**

**Result: +$12.13 profit (+6.07%)**

### Scenario 2: A halves to $0.50 (B constant at $1)

**New values:**
- √(A*B) = √($0.50 · $1) = $0.707
- 1/√(A*B) = 1/$0.707 = $1.414

**Position value:**
- 100 × $0.707 = $70.71
- 100 × $1.414 = $141.42
- **Total: $212.13**

**Result: +$12.13 profit (+6.07%)**

### Comparison to Impermanent Loss

An LP who forged (A, B, √(A*B)) and holds only the liquidity unit would experience **impermanent loss** of approximately -5.7% in the same scenarios.

The hedge position **inverts** this payoff structure.

---

## 4. Open Research Questions

### 4.1 Conservation of Value

**Where does the profit come from?**
- Who holds the offsetting loss?
- Can everyone hold the hedged position simultaneously?
- What are the no-arbitrage bounds?

### 4.2 Equilibrium Analysis

**What is the equilibrium price of "1"?**
- Is "1" truly stable at $1?
- How does demand for hedged positions affect "1" pricing?
- What are the stable equilibria (if any)?

### 4.3 Market Dynamics

**Arbitrage behavior:**
- How do arbitrageurs maintain invariants across multiple triads?
- What is the convergence rate for price alignment?
- Are there profitable MEV strategies?

**Liquidity provision:**
- What incentivizes LPs to provide liquidity if hedgers profit from volatility?
- Is there a sustainable equilibrium between LPs and volatility traders?
- Can the system function if everyone hedges?

### 4.4 Greeks and Risk Metrics

**Options analogs:**
- What is the gamma of the hedged position?
- How does it compare to a traditional straddle?
- Can we derive a Black-Scholes analog for pricing?

**Vega exposure:**
- Is this position long implied volatility or realized volatility?
- How does it behave under different volatility regimes?

### 4.5 Stability and Robustness

**System-level risks:**
- Can price spirals occur in the multi-dimensional liquidity mesh?
- What happens under extreme volatility or liquidity crises?
- Are there attack vectors or instabilities?

**Path dependency:**
- Does order of operations matter?
- Are there profitable manipulation strategies?

### 4.6 Generalization

**Beyond reciprocal pairs:**
- Does this mechanism extend to other compound units?
- Can hedges be constructed for triads where "1" is not the liquidity unit?
- What is the general theory of hedging in geometric mean AMMs?

---

## 5. Connection to Existing Literature

### 5.1 Power Perpetuals (Paradigm Research)

Uniteum implements arbitrary power perpetuals through geometric mean invariants:
- Uniswap: 0.5 power perp (√(A * B))
- Uniteum: Any rational exponent via triad structure

**Reference:** [Everything is a Perp](https://www.paradigm.xyz/2024/03/everything-is-a-perp)

### 5.2 Impermanent Loss Literature

Standard result: LPs lose to arbitrageurs in constant-product AMMs.

**Novel contribution:** Uniteum provides a **native hedging instrument** that inverts this payoff.

### 5.3 Variance Swaps and Volatility Trading

The hedged position resembles a variance swap:
- Profit from volatility, not direction
- No expiration
- No theta decay

**Question:** What is the implied volatility being "sold" by LPs and "bought" by hedgers?

---

## 6. Potential Research Directions

### 6.1 Theoretical Analysis

- Prove conservation laws and no-arbitrage bounds
- Derive equilibrium pricing models
- Characterize stable and unstable regimes
- Develop a calculus of hedging strategies

### 6.2 Numerical Simulation

- Agent-based modeling of LPs, arbitrageurs, and hedgers
- Monte Carlo analysis under different volatility scenarios
- Stress testing and stability analysis
- Optimal execution strategies

### 6.3 Empirical Study

- Deploy on testnet with simulated agents
- Measure convergence rates and arbitrage efficiency
- Validate theoretical predictions
- Identify emergent behaviors

### 6.4 Extensions

- Multi-asset hedging strategies
- Dynamic hedging and portfolio optimization
- Integration with traditional derivatives markets
- Applications to real-world assets

---

## 7. Implementation Details

**Smart Contract:** [Uniteum 0.4](https://etherscan.io/address/0x5bA96211E3679FDcc7047a5c64d40A4Dd3fBdAD7#code)
**Network:** Ethereum Mainnet (also on Sepolia testnet)
**Language:** Solidity 0.8.30
**Audit Status:** Unaudited (experimental protocol)

**Key Functions:**
- `forge(IUnit V, int256 du, int256 dv)` - Create/destroy unit combinations
- `multiply(string symbol)` - Create new units from "1"
- `reciprocal()` - Get reciprocal unit address

---

## 8. Conclusion

Uniteum's geometric mean liquidity structure appears to create a novel derivative primitive with unique properties:

✅ **Native volatility exposure** without options markets or market makers
✅ **No expiration or theta decay** (perpetual instrument)
✅ **No fees** to establish or maintain position
✅ **Symmetrical payoff** (profit from moves in either direction)
✅ **Composable** (can be used in other triads)

However, critical questions remain about:
❓ **Conservation of value** - where does the profit come from?
❓ **Equilibrium sustainability** - can the system support all participants hedging?
❓ **Stability** - are there systemic risks or instabilities?

**These questions require rigorous mathematical finance analysis to answer.**

---

## 9. References

- Paradigm Research: "Everything is a Perp" (2024)
- Uniswap v2 whitepaper (constant product AMM)
- Black-Scholes-Merton options pricing theory
- Variance swap and volatility derivatives literature

---

## Contact

**Paul Reinholdtsen**
Creator, Uniteum Protocol
ENS: reinholdtsen.eth
GitHub: github.com/uniteum
Web: uniteum.one

**Seeking collaboration with researchers in:**
- Mathematical finance and derivatives pricing
- Market microstructure and AMM design
- Quantitative trading and risk management
- Applied mathematics and numerical methods
