---
title: The Economics of "1"
description: >-
  Hypotheses about how the "1" token's value may emerge from
  aggregate system participation and anchored collateral.

# Navigation
nav_order: 4
has_children: false

# Taxonomy
categories:
  - economics
  - research

# Metadata
last_updated: 2024-12-11
version: "0.1"
status: hypothesis
---

# The Economics of "1"

The "1" token is Uniteum's universal mediator—the backbone that connects all base units and enables forge operations. But what determines the value of "1" itself?

This page explores two related hypotheses about "1" token economics. **These are hypotheses, not proven mechanisms.** They represent testable predictions about emergent system behavior.

## Hypothesis 1: "1" as Aggregate Value Index

**Central claim:** As anchored collateral and symbolic unit participation grow, the value of "1" will tend to reflect aggregate system value (anchored + symbolic).

### The Intuition

Think of "1" as an **unintentional index fund** of all Uniteum value.

Every unit needs "1" for liquidity. When value flows into the system—whether real collateral (anchored units) or consensus value (symbolic units)—that value becomes tied to "1" through the invariant.

### Anchored Collateral Effect

When you create an anchored unit like `$WETH`:

1. Real WETH gets locked in the contract (1:1 backing)
2. `$WETH` and `1/$WETH` are created as a reciprocal pair
3. To provide liquidity, users must lock "1" tokens in the contract
4. The invariant ties these together: `$WETH × (1/$WETH) = 1²`

**Result:** Real WETH value becomes indirectly tied to "1" value through the liquidity relationship.

As more anchored units launch (`$USDC`, `$WBTC`, `$LINK`), each brings real collateral that requires "1" for liquidity. The "1" token becomes the common denominator for all this value.

### Mathematical Framing

Consider a simplified scenario with three anchored units:

| Anchored Unit | Collateral Locked | "1" Locked in Contract |
|---------------|-------------------|------------------------|
| `$WETH` | 100 WETH ($200k) | 500k "1" |
| `$USDC` | 300k USDC ($300k) | 300k "1" |
| `$WBTC` | 5 WBTC ($500k) | 700k "1" |
| **Total** | **$1M** | **1.5M "1"** |

If "1" reflects proportional value: `$1M / 1.5M = $0.67 per "1"`

This is crude (ignores symbolic units, compounds, circulation), but illustrates the mechanism: anchored collateral value distributed across locked "1" supply.

### Symbolic Unit Participation

Symbolic units (no backing, pure consensus) can also contribute value:

- If `foo` token gains market acceptance and trades at meaningful prices
- Its reciprocal `1/foo` also has value (enforced by invariant)
- Both require "1" for liquidity
- Successful symbolic units increase demand for "1"

**Example:** A gaming community adopts `sword` and `shield` as in-game currency. Players forge compound units (`sword*shield`), provide liquidity, trade on secondary markets. This activity increases "1" utility and potentially value—even though these are unbacked symbolic units.

### Network Effects

As the unit mesh grows:

**More units → More "1" demand:**
- Each new base unit needs "1" for reciprocal liquidity
- Compound units (`$WETH/$USDC`, `$WBTC^2`) create additional forge paths
- All paths flow through "1" (directly or indirectly)

**More forge paths → Stronger price consistency:**
- Arbitrage mesh topology keeps prices aligned
- "1" becomes more liquid (tradable via many routes)
- Higher liquidity → potentially higher value

### The Index Fund Analogy

Traditional index fund:
- Holds basket of stocks
- Fund share value = (total stock value) / (number of shares)
- Diversified exposure to all constituents

Hypothetical "1" behavior:
- Mediates all unit pairs (doesn't hold them, but connects them)
- "1" value influenced by aggregate locked collateral and activity
- Diversified exposure to entire Uniteum ecosystem

## Hypothesis 2: Diversification Reduces Volatility

**Central claim:** With many diverse units, "1" may exhibit reduced volatility compared to individual units or external assets.

### The Diversification Mechanism

**Standard portfolio theory:** Diversified assets have lower volatility than concentrated holdings (assuming imperfect correlation).

Applied to "1":
- "1" is locked across many different unit contracts
- If `$WETH` dumps but `$WBTC` pumps, offsetting effects
- If `foo` symbolic unit collapses, but `$USDC` is stable, net impact reduced
- "1" volatility < weighted average volatility of constituent units

### Correlation Structure Matters

**Key question:** How correlated are different units?

**Anchored crypto assets** (`$WETH`, `$WBTC`, `$LINK`):
- Likely high correlation (crypto moves together)
- Limited diversification benefit

**Anchored stablecoins** (`$USDC`, `$USDT`, `$DAI`):
- Low correlation with crypto
- Stabilizing effect on "1"

**Symbolic units** (`foo`, `bar`, `gaming_token`):
- Potentially uncorrelated with external markets
- Could reduce volatility if they gain independent value

**Compound units:**
- Inherit correlation structure of constituents
- `$WETH/$USDC` correlated with WETH
- `foo*bar` depends on foo/bar correlation

### Mathematical Intuition

Portfolio volatility for N uncorrelated assets:

$$\sigma_{\text{portfolio}} = \frac{\sigma_{\text{individual}}}{\sqrt{N}}$$

If "1" behaves like a portfolio of N diverse units, its volatility could decrease as N grows.

**But:** This assumes equal weighting and zero correlation. Real units will have:
- Unequal liquidity (different amounts of "1" locked)
- Non-zero correlation (especially anchored crypto)
- Varying participation levels

### Testable Prediction

If diversification hypothesis holds:

**Before many units launch:**
- "1" price highly correlated with dominant unit (likely first major anchored asset)
- High volatility matching crypto market

**After ecosystem diversification:**
- "1" price correlation with any single asset decreases
- Volatility lower than average constituent volatility
- Behaves more like diversified crypto index

**Observable metric:** 30-day rolling volatility of "1" vs major crypto assets

## Counter-Arguments & Risks

### Supply Dynamics

**Challenge:** Total "1" supply is fixed (1 billion), but forging can move "1" between contracts and circulation.

Could "1" get drained from critical pools?
- If users heavily forge one direction, "1" concentrates in certain contracts
- Other unit pairs become illiquid
- Does this create instability?

**Counter:** Arbitrage should rebalance. If one pool is "1"-rich, forging is cheaper there, attracting activity.

### Liquidity Fragmentation

**Challenge:** More units = "1" spread across more pools = less liquidity per pool?

- 1 billion "1" divided among 1,000 units = 1M average per pool
- Shallow liquidity = high slippage = less utility
- Could fragmentation reduce "1" value?

**Counter:** Network effects may dominate. More units = more forge paths = more utility = higher value, despite fragmentation.

### Symbolic Unit Collapse Risk

**Challenge:** If major symbolic units collapse to zero, does "1" suffer?

**Analysis:** Symbolic units aren't backed, so their collapse doesn't destroy real value. But:
- Locked "1" in collapsed unit pools becomes stranded
- Reduces effective "1" circulation
- Could create temporary supply shock

**Mitigant:** "1" can be recovered by forging with worthless symbolic units (essentially burning the symbolic, reclaiming "1").

### External "1" Pricing

**Challenge:** How does "1" price actually form?

Is there an external "1"/USDC or "1"/ETH market that drives valuation? Or does price emerge purely from internal forge relationships?

**Likely:** Hybrid
- Internal forge operations establish relative prices (unit/1, unit*unit/1)
- External markets (if they exist) provide "1"/USD discovery
- Arbitrage keeps them aligned

But initially, "1" price might be arbitrary/unstable until sufficient liquidity develops.

### The Bootstrap Problem

**Chicken-and-egg:** "1" value depends on ecosystem activity, but ecosystem needs valuable "1" to function well.

Early phases may see:
- Low "1" value due to minimal activity
- Low activity because "1" isn't valuable yet
- High volatility during price discovery

**Resolution path:** Early adopters provide liquidity expecting future value. As utility grows, value follows.

## What Would Falsify These Hypotheses?

Good hypotheses are falsifiable. What observations would prove these wrong?

### Against Aggregate Value Hypothesis

**Evidence that would falsify:**
- "1" price completely uncorrelated with anchored collateral TVL
- Major anchored unit launch (e.g., $10M WETH locked) has zero impact on "1" price
- "1" trades below reasonable value implied by locked collateral
- External "1" markets diverge wildly from internal forge prices with no arbitrage

### Against Diversification Hypothesis

**Evidence that would falsify:**
- "1" volatility remains high even with 50+ diverse units
- "1" price perfectly tracks single dominant asset (no diversification effect)
- Addition of uncorrelated units doesn't reduce "1" volatility
- "1" is MORE volatile than constituent units (inverse effect)

## Observable Metrics

To test these hypotheses, track:

### Value Metrics

- **Total anchored collateral TVL** (USD value of locked WETH, USDC, WBTC, etc.)
- **"1" market cap** (circulating supply × price)
- **"1" price vs collateral ratio** (TVL / locked "1" supply)
- **"1"/USD price** (if external market exists)

### Volatility Metrics

- **30-day "1" volatility** vs major crypto assets
- **"1" correlation matrix** with WETH, WBTC, USDC, etc.
- **Beta of "1"** relative to broader crypto market
- **Volatility trend** as unit count increases

### Activity Metrics

- **Number of active units** (base + compound)
- **"1" distribution** across unit contracts (Gini coefficient)
- **Daily forge volume** (indicates liquidity/activity)
- **Arbitrage event frequency** (healthy mesh function)

### Unit Contract Queries

You can check "1" locked in any unit contract:

```solidity
IUnit(unitAddress).invariant()  // Returns (u, v, w) where w = "1" locked
```

Sum across all units for total locked "1" supply.

## Scenarios & Predictions

### Scenario 1: First Major Anchored Unit

**Setup:** Someone creates `$WETH` and locks 100 WETH ($200k) with equivalent "1" liquidity.

**Prediction (if hypothesis holds):**
- "1" price should move toward value implied by WETH collateral
- Arbitrage between `$WETH/1` and external WETH/USD markets
- Increased "1" trading volume
- "1" volatility initially high (single asset correlation)

### Scenario 2: Stablecoin Diversification

**Setup:** After `$WETH`, users add `$USDC` and `$USDT` with significant TVL.

**Prediction:**
- "1" correlation with WETH decreases
- "1" volatility decreases (crypto + stable mix)
- "1" price stabilizes (stablecoins anchor one side)
- "1" becomes useful as multi-asset numeraire

### Scenario 3: Symbolic Unit Success

**Setup:** A popular symbolic unit (`gaming_coin`) gains consensus value independent of crypto markets.

**Prediction:**
- "1" gains value from symbolic participation (not just anchored)
- "1" correlation with external crypto further reduced
- Demonstrates value beyond just collateral backing
- May exhibit unique price dynamics

### Scenario 4: Ecosystem Maturity

**Setup:** 100+ units (50 anchored, 50 symbolic, many compounds), $10M+ TVL, daily trading activity.

**Prediction:**
- "1" behaves like diversified crypto index
- Volatility significantly below BTC/ETH
- Price discovery stable
- Network effects dominate fragmentation concerns
- "1" is useful as stable-ish numeraire across ecosystem

## Implications for Participants

If these hypotheses hold, how does it affect decisions?

### For "1" Holders

**Early accumulation bet:**
- Buy "1" cheap before ecosystem value accrues
- Hold as ecosystem grows (value index thesis)
- Benefit from diversification (lower vol than individual units)

**Risk:** Hypotheses wrong, "1" doesn't capture value, remains volatile/worthless.

### For Unit Creators

**Anchored unit creators:**
- Locking real collateral potentially increases "1" value
- But also fragments "1" supply across pools
- Net effect depends on TVL magnitude

**Symbolic unit creators:**
- Can contribute to "1" value via consensus/activity
- No collateral required
- Success benefits entire ecosystem (including "1" holders)

### For Liquidity Providers

**Provide liquidity to many unit pairs:**
- Lock "1" across diverse pools
- Capture fees from forge operations
- Benefit if "1" appreciates (value index thesis)
- Risk if "1" becomes illiquid (fragmentation)

**Concentrated liquidity:**
- Focus on high-volume pairs
- Higher fee capture potential
- But concentrated "1" exposure

### For Arbitrageurs

**Monitor price consistency:**
- Compound units should track constituents
- "1" should reflect aggregate value
- Deviations = arbitrage opportunity

**Bootstrap liquidity:**
- Early arb activity helps establish price relationships
- Contributes to ecosystem health
- May profit from initial inefficiencies

## Open Questions

These hypotheses raise questions that can only be answered through observation:

1. **Value Accrual:** Does "1" value actually track anchored TVL? What's the lag time?
2. **Minimum Diversity:** How many units needed before diversification effect appears?
3. **Correlation Structure:** What's the actual correlation matrix of anchored units?
4. **Optimal "1" Distribution:** Is there an ideal Gini coefficient for "1" across pools?
5. **Fragmentation Threshold:** At what unit count does fragmentation harm outweigh network effects?
6. **Symbolic Value Ceiling:** Can symbolic units contribute substantial value, or only anchored matter?
7. **Price Discovery Path:** How does "1"/USD price initially form? Via which markets/pairs?
8. **Stability vs Growth:** Does diversification create stability at the cost of growth potential?

## Related Concepts

- [Tokenomics](/concepts/tokenomics/) — The invariant and supply mechanics
- [Arbitrage](/concepts/arbitrage/) — How price consistency emerges
- [Use Cases](/use-cases/) — What this enables for participants
- [Forge](/concepts/forge/) — The operation that moves "1" between contracts

## Observing in Practice

**Check "1" contract:**
- Mainnet: [`0x9df9b0501e8f6c05623b5b519f9f18b598d9b253`](https://etherscan.io/address/0x9df9b0501e8f6c05623b5b519f9f18b598d9b253#readContract)
- Sepolia: [`0x9df9b0501e8f6c05623b5b519f9f18b598d9b253`](https://sepolia.etherscan.io/address/0x9df9b0501e8f6c05623b5b519f9f18b598d9b253#readContract)

**Query total supply:**
```solidity
totalSupply()  // Should return 1 billion (1e9 × 1e18)
```

**Check unit distribution:**
Enumerate all created units via `UnitCreate` events, query each for locked "1".

---

## Summary

**Hypothesis 1:** "1" value may reflect aggregate system value (anchored collateral + symbolic participation) as ecosystem grows.

**Hypothesis 2:** "1" volatility may decrease as diverse units create diversification effects.

**Status:** Untested. These are predictions about emergent behavior in a novel mechanism.

**Approach:** Deploy, observe, measure. Let the data speak.

This is experimental economics in real-time. Nobody knows what happens when you make liquidity multi-dimensional and algebraically composable at scale. The "1" token may become a valuable index of the ecosystem—or it may not. The hypothesis is testable. The experiment is live.

**Watch, measure, learn.**
