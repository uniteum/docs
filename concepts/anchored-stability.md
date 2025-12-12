---
title: Anchored Unit Stability
description: >-
  How anchored units provide price stability to "1" through asymmetric
  arbitrage reactance, creating a stabilization mechanism distinct from
  symbolic units.

# Navigation
parent: Concepts
nav_order: 6

# Taxonomy
categories:
  - concepts
  - economics
  - arbitrage

# Metadata
last_updated: 2024-12-11
version: "0.1"
status: hypothesis
---

# Anchored Unit Stability

Anchored units create a unique stabilization mechanism for the "1" token through **asymmetric arbitrage reactance**. This page explores why anchored units actively dampen "1" price volatility while symbolic units passively float.

> **Note:** This is a hypothesis about emergent behavior, not a proven mechanism. See also [Economics of "1"](/economics-of-one/) for broader context.

## The Core Asymmetry

### Symbolic Units: Floating Together

When you create a symbolic unit like `foo`:
- Both `foo` and `1/foo` have no external reference
- Both derive value purely from internal consensus/liquidity
- If "1" value doubles, `foo` and `1/foo` can adjust proportionally
- No external anchor creates resistance
- They move **with** "1", not **against** it

**Example:** If "1" goes up 2x:
- `foo` might go up 2x (maintaining relative price)
- `1/foo` might go up 2x (maintaining relative price)
- No arbitrage opportunity emerges from "1" price change alone
- No stabilizing pressure

### Anchored Units: External Anchor Creates Resistance

When you create an anchored unit like `$WETH`:
- `$WETH` has 1:1 backing with real WETH (fixed external value)
- `1/$WETH` floats with the "1" token
- External WETH price creates a reference point
- Deviations from alignment create arbitrage opportunities
- They **react against** changes in "1" value

**Example:** If "1" goes up 2x while WETH price unchanged:
- `$WETH` value unchanged (still backed by real WETH)
- `1/$WETH` becomes 2x more valuable (denominated in "1")
- **Arbitrage opportunity:** `1/$WETH` now overvalued relative to real WETH
- Profitable to forge, creating backpressure on "1"

## The Stabilization Mechanism

### When "1" Value Increases

**Setup:** "1" price rises on external markets while real WETH price stays constant.

**What happens:**

1. **Overvaluation:** `1/$WETH` becomes expensive relative to actual WETH
2. **Arbitrage path:**
   - Buy WETH on external market (cheap)
   - Deposit WETH, mint `$WETH` via anchored unit (1:1)
   - Forge: burn `$WETH` + mint `1/$WETH` (consumes "1")
   - Sell `1/$WETH` for "1" (expensive)
   - Net: extracted value from "1" price premium
3. **Market impact:** Selling "1" creates downward pressure
4. **Equilibrium:** Arbitrage continues until "1" price aligns with WETH-implied value

**Result:** Increase in "1" value is dampened by profitable arbitrage.

### When "1" Value Decreases

**Setup:** "1" price falls on external markets while real WETH price stays constant.

**What happens:**

1. **Undervaluation:** `$WETH` becomes expensive relative to "1" value
2. **Arbitrage path:**
   - Forge: mint `$WETH` + burn `1/$WETH` (generates "1")
   - Burn `$WETH`, withdraw WETH (1:1)
   - Sell WETH on external market
   - Buy cheap "1" on external market
   - Net: extracted value from "1" price discount
3. **Market impact:** Buying "1" creates upward pressure
4. **Equilibrium:** Arbitrage continues until "1" price aligns with WETH-implied value

**Result:** Decrease in "1" value is dampened by profitable arbitrage.

## The Spring Analogy

Think of the system as "1" connected to multiple springs:

### Symbolic Units: No Springs

```
[foo] ~~~ ["1"] ~~~ [1/foo]
```
- Wavy lines = no resistance (float together)
- No external anchor
- No stabilizing force

### Anchored Units: Spring-Loaded

```
[Real WETH] ===[$WETH]=== ["1"] ~~~ [1/$WETH]
```
- `===` represents spring (resistance)
- Real WETH anchors one side
- "1" pulls on the spring when it moves
- Spring tension creates restoring force

### Multiple Anchored Units: Multiple Springs

```
[Real WETH] ===[$WETH]=== ["1"] ===[$USDC]=== [Real USDC]
                  ||
                  ||
          [Real WBTC] ===[$WBTC]===
```

- Each anchored unit is a spring to external market
- "1" sits in the center
- Movement in any direction creates tension
- More springs = stronger stabilization

## Mathematical Framing

### Implied "1" Price from Anchored Unit

For an anchored unit like `$WETH`:

**Invariant:**
```
sqrt(supply_$WETH × supply_1/$WETH) = locked_"1"_in_contract
```

**External WETH price:** `P_WETH` (e.g., $2000)

**Total WETH value locked:** `supply_$WETH × P_WETH`

**Implied "1" price:**
```
P_1_implied = (supply_$WETH × P_WETH) / locked_"1"
```

If market "1" price `P_1_market ≠ P_1_implied`, arbitrage profit exists.

### Arbitrage Profit Function

**When P_1_market > P_1_implied** ("1" overvalued):

```
profit = P_1_market - P_1_implied (per unit of arbitrage)
```

Arbitrageurs exploit by:
- Minting cheap `$WETH` (external cost: `P_WETH`)
- Burning expensive `1/$WETH` (internal value: `P_1_market`)
- Extracting profit, selling "1"

**When P_1_market < P_1_implied** ("1" undervalued):

```
profit = P_1_implied - P_1_market (per unit of arbitrage)
```

Arbitrageurs exploit by:
- Burning `$WETH` (reclaim `P_WETH` value)
- Minting cheap `1/$WETH` (internal cost: `P_1_market`)
- Extracting profit, buying "1"

### Multiple Anchored Units

With N anchored units, each provides independent implied price:

```
P_1_implied_WETH = f(WETH_locked, "1"_locked_in_WETH_contract, P_WETH)
P_1_implied_USDC = f(USDC_locked, "1"_locked_in_USDC_contract, P_USDC)
P_1_implied_WBTC = f(WBTC_locked, "1"_locked_in_WBTC_contract, P_WBTC)
...
```

**Equilibrium:** `P_1_market` converges toward weighted average of all implied prices (weighted by TVL and liquidity).

**Arbitrage opportunities** emerge from any deviation → multiple paths to exploit → stronger correction force.

## Why This Matters

### 1. Anchored Units Provide Active Stability

Unlike symbolic units that passively track "1", anchored units actively resist changes through profitable arbitrage.

**Implication:** More anchored unit TVL = stronger "1" price stability.

### 2. Stability Increases With Anchored Diversity

Multiple anchored units provide multiple reference points:
- `$WETH` ties "1" to ETH price
- `$USDC` ties "1" to USD
- `$WBTC` ties "1" to BTC price

If these external prices move independently, "1" is anchored to a **basket** rather than single asset.

**Result:** "1" volatility < any single constituent (diversification + reactance).

### 3. Symbolic Units Still Contribute Value

While symbolic units don't provide reactance, they:
- Add liquidity and utility to the system
- Contribute to aggregate value (Hypothesis 1 in [Economics of "1"](/economics-of-one/))
- Provide diversification (Hypothesis 3)

**Both unit types matter**, just in different ways.

### 4. Bootstrap Problem Is Real

Early phase with zero or low anchored TVL:
- Weak stabilization (few springs)
- High volatility possible
- "1" price more speculative

**Critical mass:** System likely needs substantial anchored TVL before strong stability emerges.

## Testable Predictions

If this mechanism works as hypothesized:

### Prediction 1: TVL Correlation

**Test:** Plot "1" volatility vs total anchored unit TVL over time.

**Expected:** Negative correlation (more TVL → lower volatility).

**Falsification:** No correlation, or positive correlation.

### Prediction 2: Arbitrage Activity

**Test:** Monitor on-chain forge transactions during "1" price volatility.

**Expected:** Spike in anchored unit forge operations during price deviations.

**Falsification:** No arbitrage response, or symbolic units show equal activity.

### Prediction 3: Price Convergence Speed

**Test:** Measure time for "1" price to revert after shocks as anchored TVL grows.

**Expected:** Faster convergence with more anchored units/TVL.

**Falsification:** Convergence time unchanged or slower.

### Prediction 4: Implied Price Alignment

**Test:** Calculate implied "1" price from each anchored unit, compare to market price.

**Expected:** Market price stays within tight range of implied prices.

**Falsification:** Wild divergence persists without arbitrage correction.

## Example Scenarios

### Scenario A: Early Phase (No Anchored Units)

**Setup:**
- Only symbolic units exist (`foo`, `bar`, etc.)
- "1" trades on speculative/consensus value only
- No external anchors

**Behavior:**
- High "1" volatility
- Price driven by sentiment, speculation
- No stabilizing arbitrage mechanism
- "1" could 10x or 0.1x on hype/fear

**Spring diagram:** No springs, "1" floats freely.

### Scenario B: Single Large Anchored Unit

**Setup:**
- `$WETH` launched with $1M TVL
- Still some symbolic units
- "1" has external reference point

**Behavior:**
- "1" price strongly correlated with WETH
- Volatility tied to WETH volatility
- Arbitrage keeps `P_1` aligned with WETH-implied price
- If WETH dumps 20%, "1" likely follows (spring pulls it down)

**Spring diagram:** Single strong spring to WETH.

### Scenario C: Diversified Anchored Portfolio

**Setup:**
- `$WETH` ($1M), `$USDC` ($2M), `$WBTC` ($1M), `$DAI` ($500k)
- Multiple external anchors
- "1" connected to basket of real assets

**Behavior:**
- "1" volatility < WETH, WBTC volatility (diversification)
- "1" stabilized by stablecoin springs (USDC, DAI)
- Crypto pumps/dumps partially offset
- Arbitrage more complex (multiple paths)
- "1" becomes useful as multi-asset numeraire

**Spring diagram:** Multiple springs to different external markets, balanced tension.

### Scenario D: Extreme "1" Shock

**Setup:** External event causes sudden 50% "1" price increase (speculation, hype, etc.)

**Anchored unit response:**

1. **All `1/[anchored]` become massively overvalued**
2. **Arbitrage bots activate:**
   - Buy WETH, USDC, WBTC on external markets
   - Mint `$WETH`, `$USDC`, `$WBTC` (cheap collateral)
   - Forge to burn these, mint reciprocals
   - Sell reciprocals for "1" (expensive)
   - Dump "1" on market
3. **Massive sell pressure on "1"**
4. **Price corrects rapidly** (minutes to hours, not days)

**Result:** Strong reactance prevents sustained deviation.

## Observing in Practice

### On-Chain Metrics

**Monitor these to test the hypothesis:**

1. **Anchored unit TVL:**
   ```solidity
   IUnit(anchoredUnit).invariant()  // Returns (u, v, w)
   // TVL = u × external_price (since u = locked collateral)
   ```

2. **Implied "1" price from each anchored unit:**
   ```solidity
   P_1_implied = (u × P_external) / w
   ```

3. **Forge activity correlation:**
   - Filter `Forge` events during "1" price volatility
   - Check if anchored units show higher activity

4. **Price deviation duration:**
   - Time between deviation and convergence
   - Should decrease as TVL grows

### Example Analysis

**Check `$WETH` implied "1" price:**

On [Etherscan](https://etherscan.io/address/0x9df9b0501e8f6c05623b5b519f9f18b598d9b253#readContract):

1. Call `anchoredPredict(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2)` to get `$WETH` address
2. Call `invariant(address)` on the returned address
3. Get current WETH price from external source (e.g., Uniswap, Chainlink)
4. Calculate: `P_1_implied = (u × P_WETH) / w`
5. Compare to market "1" price

**If close:** Mechanism working
**If divergent:** Arbitrage opportunity (or mechanism failing)

## Limitations and Open Questions

### Unknown Efficiency

**Question:** How efficient is the arbitrage in practice?

- Are bots fast enough?
- Are gas costs prohibitive for small deviations?
- Does liquidity depth matter?

**Implication:** Reactance may be slower or weaker than theory suggests.

### Minimum TVL Threshold

**Question:** How much anchored TVL needed for meaningful stability?

- $1M sufficient?
- $10M?
- $100M?

**Implication:** Stability might not emerge until critical mass.

### Correlation Breakdown

**Question:** What if external anchored assets become highly correlated?

**Example:** Crypto crash where WETH, WBTC, LINK all dump together.

- All springs pull "1" down simultaneously
- No offsetting forces
- "1" follows market down

**Implication:** Reactance doesn't prevent correlated moves, just independent deviations.

### Oracle Risk

**Question:** How do arbitrageurs determine external prices?

- Uniswap TWAP?
- Chainlink oracles?
- CEX prices?

**Implication:** Oracle manipulation could create false arbitrage signals.

## Comparison to Other Stability Mechanisms

### vs. Collateralized Stablecoins (DAI, LUSD)

**Traditional CDP:**
- Peg to external reference (USD)
- Over-collateralization requirement
- Liquidation mechanism for peg maintenance

**Uniteum "1" with anchored units:**
- No direct peg (floats based on aggregate)
- 1:1 collateral for anchored units (not "1" itself)
- Arbitrage mechanism for price alignment

**Key difference:** "1" isn't trying to peg to USD; it's being pulled by multiple anchors.

### vs. Algorithmic Stablecoins (Pre-crash LUNA/UST)

**Algorithmic:**
- Mint/burn mechanism tied to peg target
- No collateral backing
- Death spiral risk if peg breaks

**Uniteum "1" with anchored units:**
- Forge mechanism not explicitly targeting peg
- Anchored units ARE backed (1:1)
- Death spiral risk lower (real collateral exists)

**Key difference:** Anchored units bring real value, not just algorithmic promises.

### vs. Index Funds (Traditional Finance)

**Traditional index:**
- Hold basket of assets
- Share price = NAV / shares
- Direct ownership of constituents

**Uniteum "1":**
- Mediates basket of units (doesn't hold them)
- Price emerges from arbitrage mesh
- Indirect exposure via locked liquidity

**Key difference:** "1" doesn't own assets, it connects them.

## Implications for Strategy

### For "1" Holders

**If reactance hypothesis holds:**

- **Early accumulation attractive:** Before major anchored TVL, "1" more volatile/speculative
- **Post-TVL stability:** After anchored units launch, "1" becomes more stable
- **Hold through volatility:** Early phase expected to be volatile, stability emerges later

**Risk:** Hypothesis wrong, stability doesn't emerge, volatility persists.

### For Anchored Unit Creators

**Creating anchored units benefits ecosystem:**

- Provides stabilization springs
- Increases "1" utility
- Attracts liquidity providers
- Makes entire system more useful

**But also:**

- Locks your capital in contract (custody risk)
- Fragments "1" supply across pools
- Requires trust in contract security

**Strategic question:** Is providing stability a public good you want to fund?

### For Arbitrageurs

**Opportunity:** Profit from stabilization mechanism

- Monitor implied "1" prices from all anchored units
- Watch for deviations during volatility
- Execute corrective arbitrage (get paid to stabilize)

**Requirements:**
- Fast infrastructure
- Capital for gas
- Monitoring multiple anchored units simultaneously

**Early phase:** Potentially high profits (inefficient markets)
**Mature phase:** Thinner margins (competitive arbitrage)

## Related Concepts

- [Economics of "1"](/economics-of-one/) — Broader hypotheses about "1" value
- [Arbitrage](/concepts/arbitrage/) — How arbitrage maintains price consistency
- [Forge](/concepts/forge/) — The operation that enables arbitrage
- [Units](/concepts/units/) — Anchored vs symbolic unit mechanics

## Summary

**Core mechanism:** Anchored units create asymmetric arbitrage resistance that dampens "1" volatility.

**How it works:**
- Anchored units tied to external prices (springs)
- Symbolic units float freely (no springs)
- Deviations in "1" price create profitable arbitrage
- Arbitrage activity creates backpressure (reactance)
- More anchored TVL = stronger stabilization

**Testable predictions:**
- "1" volatility decreases as anchored TVL grows
- Arbitrage activity spikes during price deviations
- Implied prices converge toward market price
- Diversified anchored units = stronger effect

**Status:** Hypothesis. Needs real-world observation to validate or falsify.

**Watch the experiment unfold on-chain.**

---

*This is a hypothesis about emergent economic behavior in a novel mechanism. The actual behavior may differ from these predictions. Observe, measure, update.*
