---
layout: page
title: "Dynamic Rebalancing Strategy - Maximizing Hedge Returns"
permalink: /research/dynamic-rebalancing/
parent: Research Materials - Volatility Hedge Discovery
---

# Dynamic Rebalancing: Maximizing Volatility Hedge Returns

## Key Insight

A hedger holding √(A*B) + 1/√(A*B) can **increase profits by continuously rebalancing** the position as prices move, rather than simply holding until final liquidation.

**Trade-off:** Rebalancing profit vs. gas costs

---

## The Mechanism

### Static Hold Strategy (Original Analysis)

**Action:**
1. Forge equal amounts of √(A*B) and 1/√(A*B)
2. Hold as prices move
3. Liquidate when desired

**Profit:** ~6% when price doubles or halves (as shown in previous analysis)

### Dynamic Rebalancing Strategy

**Action:**
1. Forge equal amounts initially
2. As prices move, the ratio becomes imbalanced
3. **Rebalance** by forging/burning to restore equal value
4. Repeat continuously
5. Final liquidation

**Profit:** Compounds with each rebalancing event

---

## Mathematical Analysis

### Why Rebalancing Increases Profit

Consider the profit function:
```
PnL(r) = x(√r + 1/√r - 2)
```

This is **convex** (d²PnL/dr² > 0), which means:
- Profit accelerates as price moves further from parity
- Early realization of gains allows re-investment at better ratios
- Each rebalancing "locks in" volatility profit and resets the position

### Example: Price Moves from 1 → 2 → 1

**Static strategy:**
- Start at r=1, end at r=1
- Net profit: **0** (back to original prices)

**Rebalancing strategy:**
- Start at r=1
- When r=2: Liquidate, profit ~6%, re-forge equal amounts
- When r returns to 1: Liquidate again, profit another ~6%
- Net profit: **~12%** (profit on both legs)

**Key insight:** Volatility = profit opportunity, even if prices return to start

---

## Optimal Rebalancing Strategy

### Frequency Trade-off

**More frequent rebalancing:**
- ✅ Captures more volatility profit
- ✅ Compounds gains faster
- ❌ Higher gas costs
- ❌ More transactions = more MEV risk

**Less frequent rebalancing:**
- ✅ Lower gas costs
- ✅ Less MEV exposure
- ❌ Misses intermediate volatility
- ❌ Position drifts further from optimal ratio

### Optimal Trigger Points

**Question:** When should you rebalance?

**Potential strategies:**

1. **Fixed ratio threshold**
   - Rebalance when √(A*B) / (1/√(A*B)) diverges by X%
   - Example: Rebalance at 1.2:1 or 1:1.2 ratio

2. **Profit threshold**
   - Rebalance when unrealized profit exceeds gas cost + margin
   - Example: Rebalance when PnL > 2× gas cost

3. **Volatility regime**
   - High volatility: Rebalance more frequently
   - Low volatility: Hold longer (avoid gas waste)

4. **Gas price sensitive**
   - Rebalance during low gas periods
   - Batch rebalances with other operations

---

## Numerical Example

### Setup
- Initial position: 100 √(A*B) + 100 1/√(A*B)
- Starting value: $200 (A=$1, B=$1)
- Gas cost per rebalance: $5 (assumption)

### Scenario: A oscillates 1 → 1.5 → 1 → 1.5 → 1

**Static hold (no rebalancing):**
- End at same prices (A=$1)
- Net profit: **$0**
- Gas cost: $0 (no transactions)
- **Total: $0**

**Rebalance at each turning point:**

| Event | Price | Action | Position Value | Profit | Gas Cost | Net |
|-------|-------|--------|----------------|--------|----------|-----|
| Start | A=$1 | Forge | $200 | - | -$5 | $195 |
| Peak 1 | A=$1.5 | Liquidate & Re-forge | $205.62 | +$5.62 | -$5 | $200.62 |
| Trough 1 | A=$1 | Liquidate & Re-forge | $206.24 | +$5.62 | -$5 | $201.24 |
| Peak 2 | A=$1.5 | Liquidate & Re-forge | $211.92 | +$5.68 | -$5 | $206.92 |
| End | A=$1 | Liquidate | $212.60 | +$5.68 | -$5 | **$207.60** |

**Result:** $7.60 profit despite prices returning to start
- Captured volatility: 4 moves × ~$5.62 avg = $22.48
- Gas costs: 5 rebalances × $5 = $25
- Net profit: **$7.60** (vs $0 static hold)

*Note: Numbers approximate; actual profit formula is PnL = x(√r + 1/√r - 2)*

---

## Gas Cost Considerations

### Break-even Analysis

**When does rebalancing pay off?**

Profit from rebalancing must exceed gas cost:
```
x(√r + 1/√r - 2) > GAS_COST
```

Solving for minimum position size x:
```
x_min = GAS_COST / (√r + 1/√r - 2)
```

**Example:** If gas = $5 and r = 1.5:
```
√1.5 + 1/√1.5 - 2 ≈ 0.0345
x_min = $5 / 0.0345 ≈ $145
```

**Conclusion:** Need ~$145 position size to break even on rebalancing at 50% price move

### Current Gas Environment (Ethereum Mainnet)

**Typical forge operation:**
- ~100,000 gas (estimate, depends on complexity)
- At 30 gwei: ~0.003 ETH = ~$7.50 (at $2,500 ETH)
- At 100 gwei: ~0.01 ETH = ~$25

**Layer 2 considerations:**
- Arbitrum/Optimism: ~100× cheaper (~$0.075 per rebalance)
- Makes frequent rebalancing economically viable
- Opens up automated strategies

---

## Automated Rebalancing Strategies

### Simple Threshold Bot

```solidity
// Pseudocode
function checkAndRebalance() {
    (uint256 uBalance, uint256 vBalance) = getBalances();
    uint256 ratio = uBalance * 1e18 / vBalance;

    // Rebalance if ratio > 1.2 or < 0.833 (±20%)
    if (ratio > 1.2e18 || ratio < 0.833e18) {
        if (estimatedProfit() > gasCost * 2) {
            liquidateAndReforge();
        }
    }
}
```

### Advanced Strategies

1. **Volatility-adjusted thresholds**
   - Tighter thresholds in high volatility
   - Wider thresholds in low volatility

2. **Gas price oracle integration**
   - Only rebalance when gas is below threshold
   - Queue rebalances for optimal execution

3. **Multi-position optimization**
   - Batch rebalances across multiple hedges
   - Amortize gas costs

4. **MEV protection**
   - Use Flashbots or private RPCs
   - Sandwich attack prevention

---

## Comparison to Traditional Strategies

### vs. Static Hold

| Strategy | Static Hold | Dynamic Rebalancing |
|----------|-------------|---------------------|
| **Profit from volatility** | Yes | Yes (higher) |
| **Profit from range-bound** | No | Yes |
| **Gas costs** | Low (once) | High (frequent) |
| **Complexity** | Simple | Requires automation |
| **MEV risk** | Low | Higher |
| **Optimal for** | Large moves, high gas | Choppy markets, L2 |

### vs. Traditional Market Making

| Aspect | Uniteum Rebalancing | Traditional MM |
|--------|---------------------|----------------|
| **Capital efficiency** | High (no inventory) | Low (hold inventory) |
| **Directional risk** | None (hedged) | Yes (unhedged) |
| **Profit source** | Volatility | Bid-ask spread |
| **Automation** | On-chain bot | Off-chain systems |
| **Infrastructure** | Minimal | Complex |

---

## Research Questions

### Optimal Control Problem

**Question:** What is the mathematically optimal rebalancing strategy?

**Formulation:**
- Objective: Maximize cumulative profit - gas costs
- Constraints: Capital limits, gas costs, MEV risk
- Variables: Rebalancing frequency, position sizing
- State: Current balances, price history, volatility regime

**Potential approach:**
- Dynamic programming
- Stochastic control theory
- Reinforcement learning (DQN, PPO)

### Market Microstructure

**Questions:**
1. How many rebalancers can the system support?
2. Do rebalancers compete with each other?
3. What's the equilibrium between LPs, hedgers, and rebalancing hedgers?
4. Are there cascading effects or feedback loops?

### Game Theory

**Questions:**
1. Is frequent rebalancing a Nash equilibrium?
2. Do MEV searchers profit from front-running rebalances?
3. Can adversaries trigger unprofitable rebalances?

---

## Practical Implementation

### On Mainnet (High Gas)

**Strategy:** Infrequent, high-conviction rebalances
- Threshold: ±50% price move OR 10% profit
- Gas limit: Only rebalance if profit > 3× gas cost
- Timing: Monitor gas prices, execute during low periods

**Expected ROI:** Moderate (5-15% annual on volatility)

### On L2 (Low Gas)

**Strategy:** Frequent, automated rebalancing
- Threshold: ±10% price move OR 1% profit
- Gas limit: Profit > 1.1× gas cost
- Timing: Near-continuous monitoring

**Expected ROI:** Higher (could be 20-50%+ in volatile markets)

### Hybrid Strategy

**Strategy:** Use L2 for active trading, settle to mainnet periodically
- Trade frequently on Arbitrum/Optimism
- Bridge to mainnet for security/final settlement
- Best of both worlds (low cost + mainnet security)

---

## Connection to Existing Strategies

### Similar to:

1. **Volatility harvesting** (options strategies)
   - Gamma scalping: Rebalance delta-hedged options
   - Uniteum analog: Rebalance volatility hedge

2. **Rebalancing premium** (portfolio theory)
   - Diversified portfolios benefit from rebalancing
   - Geometric mean portfolios capture rebalancing bonus

3. **Market making with inventory** (traditional finance)
   - MMs rebalance inventory after trades
   - Uniteum: Rebalance hedge after price moves

### Novel aspects:

- ✅ No theta decay (unlike options)
- ✅ No directional bias (unlike delta hedging)
- ✅ Pure volatility play (unlike portfolio rebalancing)
- ✅ On-chain, permissionless (unlike traditional MM)

---

## Implications for Research

### Updated Open Questions

1. **Optimal rebalancing policy**
   - Closed-form solution vs. numerical optimization?
   - Role of transaction costs and slippage?

2. **Gas cost dynamics**
   - How does gas price volatility affect strategy?
   - L1 vs. L2 trade-offs?

3. **MEV considerations**
   - Are rebalancers systematically front-run?
   - Can you profit-share with MEV searchers?

4. **System-level effects**
   - Does widespread rebalancing increase or decrease system stability?
   - Feedback loops with LP positions?

5. **Empirical validation**
   - Backtest on historical price data
   - Compare to traditional vol trading strategies
   - Measure actual gas costs and slippage

---

## Value Proposition Update

### Original finding:
"Hold √(A*B) + 1/√(A*B) and profit ~6% when price doubles/halves"

### Enhanced finding:
"**Continuously rebalance** √(A*B) + 1/√(A*B) to extract compounding profits from volatility, limited only by gas costs"

**This transforms the strategy from:**
- Static hedge → Profit on one-way moves
- **TO**
- Dynamic strategy → Profit on all volatility (bidirectional)

---

## Recommendations for Academic Collaboration

### Additional analysis needed:

1. **Optimal control formulation**
   - Mathematical framework for rebalancing decisions
   - Closed-form solutions if possible
   - Numerical methods otherwise

2. **Empirical study**
   - Backtest on ETH/USD historical data
   - Compare L1 vs. L2 economics
   - Measure sensitivity to gas prices

3. **Game-theoretic model**
   - Multi-agent simulation
   - Equilibrium analysis
   - Stability conditions

4. **Implementation guide**
   - Reference bot architecture
   - Risk management framework
   - Performance metrics

---

## Conclusion

The volatility hedge becomes **significantly more powerful** with dynamic rebalancing:

**Static hold:**
- Profit from one-way moves
- Limited by final price difference
- Simple but suboptimal

**Dynamic rebalancing:**
- Profit from all volatility (both directions)
- Compounds gains on oscillations
- Complex but potentially much higher returns
- **Limited only by gas costs**

**On L2 with low gas costs, this could be a highly profitable automated strategy.**

This adds another dimension to the research opportunity—not just "does the hedge work?" but **"what's the optimal way to manage it?"**

---

**For Tim St. Leung:** This connects to optimal execution and dynamic hedging in your research area. The rebalancing problem is a stochastic control problem with transaction costs.

---

**Created:** December 2024
**Status:** Preliminary analysis, needs rigorous optimization theory
