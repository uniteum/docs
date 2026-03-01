---
layout: page
title: "Native Volatility Hedging - One Page Summary"
permalink: /research/one-page-summary/
parent: Research Materials - Volatility Hedge Discovery
---

# Native Volatility Hedging in Uniteum
## One-Page Research Summary

---

### The Mechanism (3 sentences)

Uniteum uses geometric mean invariants √(A*B) = W to create composable liquidity units. For any liquidity unit √(A*B), there exists a reciprocal pair: (√(A*B), 1/√(A*B), 1). Holding equal quantities of both creates a position that profits from price volatility in either direction.

---

### The Math

**Value function:**
```
V(t) = x·√(p_A·p_B) + x·(1/√(p_A·p_B))
```

**Profit when A moves (B constant):**
```
PnL(r) = x(√r + 1/√r - 2)
```

**Properties:**
- Symmetric: PnL(2) = PnL(0.5)
- Convex: d²PnL/dr² > 0
- Minimum at parity: PnL(1) = 0

---

### Numerical Example

| Scenario | √(A*B) Value | 1/√(A*B) Value | Total | Profit |
|----------|--------------|----------------|-------|--------|
| **Start** (A=$1, B=$1) | $1.00 × 100 | $1.00 × 100 | **$200** | — |
| **A doubles** (A=$2, B=$1) | $1.414 × 100 | $0.707 × 100 | **$212.13** | +$12.13 |
| **A halves** (A=$0.50, B=$1) | $0.707 × 100 | $1.414 × 100 | **$212.13** | +$12.13 |

**Result:** +6.07% profit from volatility in either direction

**Key Enhancement:** Continuous rebalancing amplifies returns
- Static hold: Profit on one-way moves only
- Dynamic rebalancing: Profit on ALL volatility (bidirectional)
- Example: Price oscillates 1→2→1 yields ~12% vs 0% for static hold
- **Limited only by gas costs** (highly profitable on L2s)

---

### Comparison to Traditional AMM

| Position | Directional Bias | Volatility Payoff | Expiration | Fees/Theta |
|----------|------------------|-------------------|------------|------------|
| **Uniswap LP** | None | -5.7% (loss) | None | +Trading fees |
| **Uniteum Hedge** | None | +6.07% (profit) | None | None |
| **Long Straddle** | None | +Gamma | Yes | -Theta decay |
| **Variance Swap** | None | +Volatility | Yes | Funding rate |

The Uniteum hedge **inverts** the AMM impermanent loss payoff.

---

### Open Questions (Critical)

1. **Conservation:** Where does the profit come from? Who loses?
2. **Equilibrium:** Can everyone hedge? What's the sustainable LP/hedger ratio?
3. **Stability:** Are there systemic risks or price spirals?
4. **Pricing:** How should √(A*B) trade relative to underlying pools?
5. **Greeks:** What are the gamma, vega, and risk characteristics?

---

### Why This Matters

**Novel primitive:** Combines properties of power perps + variance swaps + long gamma positions, but:
- No options market needed
- No market makers or counterparties
- No collateralization beyond reserves
- Composable with other units

**Connection to literature:**
- Implements arbitrary power perpetuals (Paradigm 2024: "Everything is a Perp")
- Geometric mean structure generalizes Uniswap's constant product
- Multi-dimensional arbitrage mesh (no oracles)

---

### Implementation Status

✅ **Deployed:** Ethereum mainnet + Sepolia testnet
✅ **Working:** Smart contracts implement full mechanism
⚠️ **Unaudited:** Experimental protocol
📊 **Early stage:** Limited real-world usage data

**Contract:** [0x5bA96211E3679FDcc7047a5c64d40A4Dd3fBdAD7](https://etherscan.io/address/0x5bA96211E3679FDcc7047a5c64d40A4Dd3fBdAD7#code)

---

### Research Need

This requires **rigorous mathematical finance analysis** to:
- Prove or disprove conservation laws
- Characterize equilibria and stability
- Derive no-arbitrage bounds
- Validate with numerical simulation
- Connect to existing derivatives theory

**Seeking collaboration with researchers in:**
- Derivatives pricing and quantitative finance
- Market microstructure and AMM design
- Applied mathematics and numerical methods

---

### Contact

**Paul Reinholdtsen** | reinholdtsen.eth
Web: [uniteum.one](https://uniteum.one) | GitHub: [github.com/uniteum](https://github.com/uniteum)

**Full research summary:** [volatility-hedge-mechanism.md](volatility-hedge-mechanism.html)
