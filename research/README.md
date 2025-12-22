---
layout: page
title: "Research Materials - Volatility Hedge Discovery"
permalink: /research/
---

# Uniteum Research Materials

This directory contains research materials documenting the **native volatility hedging mechanism** discovered in Uniteum's geometric mean liquidity protocol.

---

## 📄 Documents

### 1. [Volatility Hedge Mechanism - Full Research Summary](volatility-hedge-mechanism.html)
**Purpose:** Comprehensive mathematical and economic analysis
**Audience:** Academic researchers, quantitative finance professionals
**Length:** ~3,000 words

**Contents:**
- Mathematical formulation with notation
- Worked numerical examples
- 20+ open research questions
- Connection to existing literature (power perps, variance swaps, AMM theory)
- Implementation details and references

**Key finding:** Holding equal amounts of √(A*B) and 1/√(A*B) creates a position that profits from price volatility in either direction, inverting traditional AMM impermanent loss.

---

### 2. [Test Case Analysis - Empirical Proof](test-case-analysis.html)
**Purpose:** Code walkthrough demonstrating the mechanism works
**Audience:** Developers, skeptics who want executable proof
**Length:** ~2,000 words

**Contents:**
- Line-by-line analysis of Foundry test case
- Actor breakdown (hedger vs LP)
- Step-by-step execution trace
- Proof of complementary payoffs (hedger gains ⟺ LP loses)
- Suggestions for additional test scenarios

**Key evidence:** `testVolatilityHedge()` shows hedger ends with more "1" than initial capital, while LP ends with less—empirical validation of the mathematical model.

---

### 3. [One-Page Summary - Quick Reference](one-page-summary.html)
**Purpose:** Concise overview for quick assessment
**Audience:** Busy researchers, initial screening
**Length:** 1 page

**Contents:**
- Mechanism summary (3 sentences)
- Core mathematics
- Numerical example with comparison table
- Open questions (bullet points)
- Why it matters
- Implementation status

**Use case:** Print and hand out at conferences, attach to emails, share on social media

---

### 4. [Dynamic Rebalancing Strategy](dynamic-rebalancing.html)
**Purpose:** Analysis of continuous rebalancing to maximize returns
**Audience:** Researchers, quant traders, protocol developers
**Length:** ~2,500 words

**Contents:**
- Why rebalancing increases profits beyond static hold
- Optimal control problem formulation
- Gas cost break-even analysis
- Comparison of L1 vs L2 economics
- Connection to gamma scalping and volatility harvesting
- Automated strategy designs

**Key insight:** Continuous rebalancing allows profit from **all volatility** (bidirectional), not just one-way moves. Limited only by gas costs.

---

### 5. [Email Template - Academic Collaboration](email-template-collaboration.html)
**Purpose:** Pre-written outreach email for professors/researchers
**Audience:** Protocol creator (you)
**Length:** ~500 words

**Contents:**
- Professional introduction
- Core finding summary
- Research questions posed
- Materials list
- Clear ask (assessment + guidance)
- Customization notes and follow-up strategy

**Status:** Ready to customize and send (add specific professor's name, your email, etc.)

---

## 🎯 The Core Discovery

### What We Found

In a geometric mean AMM using the invariant √(U*V) = W, there exists a **native hedging instrument**:

**Hedged Position:** Hold equal amounts of √(A*B) and 1/√(A*B)

**Properties:**
- ✅ Profits from volatility in either direction (+6% when asset doubles OR halves)
- ✅ **Continuous rebalancing amplifies returns** (profit from bidirectional volatility, limited only by gas costs)
- ✅ No directional bias (symmetric payoff)
- ✅ No expiration or theta decay (perpetual)
- ✅ No fees to establish or maintain
- ✅ Composable with other units

**Complementary Relationship:**
- Hedgers profit from volatility
- LPs suffer traditional impermanent loss
- Value is conserved (zero-sum within the system)

### Why It Matters

This appears to be a **novel derivative primitive** that:
1. Inverts AMM impermanent loss into profit
2. Implements arbitrary power perpetuals through geometric means
3. Requires no oracles, no market makers, no traditional options infrastructure
4. Is already deployed and working on Ethereum mainnet

### Open Questions

Critical questions requiring academic rigor:
- What's the equilibrium between LPs and hedgers?
- Can the system function if everyone hedges?
- What are the stability boundaries?
- How does this relate to variance swaps and power perps?
- Are there profitable MEV or manipulation strategies?

---

## 🧪 Evidence

### Theoretical
- Mathematical derivation of profit function: `PnL(r) = x(√r + 1/√r - 2)`
- Proof of symmetry: `PnL(2) = PnL(0.5)`
- Proof of convexity: `d²PnL/dr² > 0`

### Empirical
- Foundry test case: `testVolatilityHedge()`
- Deployed contracts on mainnet: [0x5bA9...dAD7](https://etherscan.io/address/0x5bA96211E3679FDcc7047a5c64d40A4Dd3fBdAD7#code)
- Verified source code
- Working implementation with full test suite

---

## 🎓 Suggested Next Steps

### For Academic Collaboration

**Ideal researcher profiles:**
- Mathematical finance / derivatives pricing
- Market microstructure / AMM design
- Quantitative trading / risk management
- Applied mathematics / numerical methods

**Potential research projects:**
1. Prove or disprove conservation laws and no-arbitrage bounds
2. Characterize equilibria and stability conditions
3. Derive optimal hedging strategies
4. Numerical simulation and agent-based modeling
5. Connection to power perps and variance swap theory
6. MEV analysis and game-theoretic properties

**Deliverables:**
- Academic paper (potentially publishable)
- Formal mathematical proofs
- Numerical simulations
- Security/stability analysis

### For Protocol Development

**Extensions to explore:**
- Add trading fees to compensate LPs
- Multi-asset hedging strategies
- Dynamic hedge ratio optimization
- Integration with existing DeFi protocols
- Risk management tools for hedgers and LPs

---

## 📊 Current Status

**Protocol:** Uniteum v0.4
**Network:** Ethereum Mainnet + Sepolia Testnet
**Audit:** Unaudited (experimental)
**Stage:** Early deployment, limited real-world usage

**Creator:** Paul Reinholdtsen (reinholdtsen.eth)
**License:** [To be determined - check main repo]
**Repository:** github.com/uniteum

---

## 📞 Contact

For research collaboration inquiries:
- Email: paul@reinholdtsen.com
- GitHub: github.com/uniteum
- Web: uniteum.one
- ENS: reinholdtsen.eth

---

## 📚 Additional Resources

- [Uniteum Documentation](https://uniteum.one)
- [Concepts: Forge Mechanism](https://uniteum.one/concepts/forge/)
- [Concepts: Triads](https://uniteum.one/concepts/triads/)
- [Concepts: Tokenomics](https://uniteum.one/concepts/tokenomics/)
- [Smart Contract Reference](https://etherscan.io/address/0x5bA96211E3679FDcc7047a5c64d40A4Dd3fBdAD7#code)

---

**Last Updated:** December 2024
**Version:** 1.0 (Initial research summary)
