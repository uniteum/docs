---
title: The 2x Mint
weight: 2
---

# The 2x Mint

When you deposit tokens into Liquid, the protocol mints **twice as many** wrapped tokens as you deposited — split proportionally between you and the pool based on the current state of the system. When you withdraw, the reverse happens — tokens are burned proportionally from both you and the pool.

This is the 2x mint pattern. It is the mechanism by which Liquid turns every deposit into instant, tradeable AMM liquidity — without LP tokens, without separate liquidity provision, and without anyone's permission.

## Why 2x?

Consider the alternative. WETH uses a 1x mint: deposit 1 ETH, receive 1 WETH, done. Simple, but the WETH sitting in your wallet is inert. It has no market. To trade it, you need an external DEX. To get liquidity on that DEX, someone has to deposit both sides of a pair manually.

The 2x mint collapses wrapping and liquidity provision into a single operation:

| | WETH (1x mint) | Liquid (2x mint) |
|:--|:--|:--|
| Deposit 1,000 tokens | Receive 1,000 wrapped | Receive ~1,000 wrapped* |
| Pool receives | Nothing | ~1,000 wrapped* |
| Tradeable immediately? | No — needs external DEX | Yes — built-in AMM |
| Separate LP step? | Yes | No |
| LP tokens to manage? | Yes | No |

*Exact split depends on pool state. On first deposit it's 50/50; subsequent deposits preserve the existing pool-to-supply ratio. Total minted is always exactly 2,000.

The extra tokens minted to the pool are the price of instant liquidity. The proportional split ensures that deposits don't dilute or concentrate the pool's share of the total supply — the system's balance is preserved regardless of when you deposit.

## Formulas

### Terminology

| Term | Symbol | Description |
|------|--------|-------------|
| **Mass** | `m` | Backing (solid) tokens deposited or withdrawn |
| **Liquid** | `u` | Wrapped tokens minted to / burned from the user |
| **Pool** | `P` | Wrapped tokens held by the contract |
| **Lake** | `E` | Hub tokens held by the contract (for trading) |
| **Total Supply** | `T` | Total wrapped tokens in existence |

### Heat (Solid → Liquid)

Deposit `m` backing tokens into a spoke with total supply `T` and pool balance `P`:

```
p = 2m × P / T          (minted to pool — proportional to pool's share)
u = 2m − p              (minted to user — the remainder)
Total minted: u + p = 2m
```

On the first deposit (`T = 0`), the split is 50/50: user and pool each receive `m`. After that, the split preserves the existing ratio between pooled and circulating tokens.

### Cool (Liquid → Solid)

User burns `u` wrapped tokens:

```
U = T − P               (circulating supply outside pool)
m = u × T / U / 2       (mass returned)
p = 2m − u              (burned from pool)
Total burned: u + p = 2m
```

Both operations are proportional: the split between user and pool depends on the current distribution of the wrapped token supply.

The user's wrapped tokens and the pool's wrapped tokens are the **same ERC-20 token**. There is no distinction at the token level between "user tokens" and "pool tokens" — the pool's tokens are simply the contract's own balance.

**Hub exception:** The Hub instance (which wraps "Uniteum 1") uses a simple 1:1 mint/burn — no pool allocation. The 2x pattern applies only to spoke instances.

## Equilibrium

The system is at equilibrium when:

```
P / T = 1/2
```

At equilibrium, the pool holds exactly half of all wrapped tokens. When this condition holds:
- `heat(m)` returns `u = m` (1 solid → 1 liquid)
- `cool(u)` returns `m = u` (1 liquid → 1 solid)

**This means liquid and solid have equal value at equilibrium.**

When the ratio deviates, heat and cool rates shift:

| Condition | Heat | Cool |
|-----------|------|------|
| P/T = 1/2 | u = m (fair exchange) | m = u (fair exchange) |
| P/T < 1/2 | u > m (favorable to heat) | m < u (unfavorable to cool) |
| P/T > 1/2 | u < m (unfavorable to heat) | m > u (favorable to cool) |

### How Equilibrium Breaks

Only **buy** and **sell** operations can break the P/T = 1/2 equilibrium. Heat and cool preserve whatever ratio exists:

| Operation | Effect on P | Effect on T | Result |
|-----------|-------------|-------------|--------|
| buy | decreases | unchanged | P/T < 1/2 |
| sell | increases | unchanged | P/T > 1/2 |
| heat | increases | increases | P/T preserved |
| cool | decreases | decreases | P/T preserved |

## Arbitrage Mechanics

An arbitrageur who holds only the backing token (solid) can profit from disequilibrium. The key insight is that **heat gives them liquid to trade with**, and the favorable/unfavorable rates create profit opportunities.

**Scenario 1: Pool Undersupplied (P/T < 1/2)**

After someone buys liquid, the pool has less liquid than equilibrium:

```
1. Arbitrageur heats m solid
   → Gets u > m liquid (favorable! heat bonus)
   → Pool has scarce liquid, so liquid is "expensive"

2. Arbitrageur sells liquid for hub
   → Liquid fetches premium price in hub
   → P increases back toward equilibrium

3. Profit realized:
   → Received bonus liquid from heating (u > m)
   → Sold at inflated pool price
   → Net gain in hub value
```

**Scenario 2: Pool Oversupplied (P/T > 1/2)**

After someone sells liquid, the pool has more liquid than equilibrium:

```
1. Arbitrageur heats m solid
   → Gets u < m liquid (unfavorable, but necessary)
   → Pool has excess liquid, so liquid is "cheap"

2. Arbitrageur buys more liquid with hub
   → Liquid is discounted due to oversupply
   → P decreases back toward equilibrium

3. Arbitrageur cools all liquid
   → At restored equilibrium, m = u (fair exchange)
   → Profit from buying cheap liquid, cooling at fair value
```

### Why This Works

The arbitrageur's profit comes from the **asymmetry between heat/cool rates and pool prices**:

- When P/T < 1/2: Heat is favorable (u > m), AND pool price is high
- When P/T > 1/2: Cool is favorable (m > u), AND pool price is low

These conditions are complementary — the same disequilibrium that makes one operation favorable also makes the corresponding trade profitable.

```
┌─────────────────────────────────────────────────────────────┐
│                     EQUILIBRIUM                              │
│                      P/T = 1/2                               │
│                    1 liquid = 1 solid                        │
└─────────────────────────────────────────────────────────────┘
         │                                    │
         │ buy (P↓)                          │ sell (P↑)
         ▼                                    ▼
┌─────────────────────┐          ┌─────────────────────┐
│    P/T < 1/2        │          │    P/T > 1/2        │
│    u > m            │          │    m > u            │
│  (heat favorable)   │          │  (cool favorable)   │
└─────────────────────┘          └─────────────────────┘
         │                                    │
         │ arbitrage: sell                   │ arbitrage: buy
         │                                    │
         └────────────────┬───────────────────┘
                          │
                          ▼
                   EQUILIBRIUM RESTORED
                   Arbitrageur profits
```

## Invariants

### Constant Product (AMM)

```
pool × lake = k  (maintained by buy/sell)
```

Where `pool` is the contract's wrapped token balance and `lake` is its Hub token balance.

The 2x mint changes `pool` but does NOT change `lake`. This means heat/cool changes `k` (the invariant constant), while trading preserves it. The two operations are cleanly separated:

- **Heat/Cool** — change total liquidity depth (modify k)
- **Buy/Sell** — move along the constant-product curve (preserve k)

This separation means deposits and withdrawals cannot be used to manipulate trading prices through sandwich attacks on the heat/cool operations themselves — they change the depth of liquidity, not the price.

### Ratio Preservation

Heat and cool preserve whatever P/T ratio exists:

```
After heat: P'/T' = P/T
After cool: P'/T' = P/T
```

**Proof for heat:**
```
Given:  p = 2*m*P/T,  u = 2*m - p
After:  P' = P + p,   T' = T + 2*m

P'/T' = (P + 2*m*P/T) / (T + 2*m)
      = P(T + 2*m)/T / (T + 2*m)
      = P/T  ✓
```

**Why ratio preservation matters:**

1. **Separates liquidity from trading**: Heat/cool are for entering/exiting the system. They don't create arbitrage opportunities by themselves — only buy/sell can break equilibrium.

2. **Prevents drain exploits**: If heat/cool could shift the ratio, users could repeatedly heat/cool to extract value. Ratio preservation ensures immediate round-trip returns exactly what was deposited.

3. **Economic fairness**: At equilibrium (P/T = 1/2), both operations are fair (1:1). Deviations affect heat and cool symmetrically — one becomes favorable while the other becomes unfavorable by the same degree.

### Heat/Cool Symmetry

The formulas are inverses: a heat followed immediately by a cool (with no intervening trades) returns you to your starting position minus rounding.

```
Total minted in heat = 2m
Total burned in cool  = u + p = 2m
```

## What the Pattern Eliminates

**No liquidity bootstrapping problem.** Traditional AMMs can't trade a new token until someone provides initial liquidity on both sides. With the 2x mint, the first deposit creates a tradeable pool.

**No LP tokens.** In Uniswap, liquidity providers receive LP tokens representing their pool share — a separate token they must track, stake, and eventually redeem. In Liquid, your wrapped tokens ARE your position. Hold them, trade them, or cool them back to solid.

**No two-sided deposits.** Uniswap requires depositing equal value on both sides of a pair (e.g., 50% USDC + 50% ETH). Liquid requires only the backing token. The protocol creates the other side.

**No liquidity fragmentation.** Because every deposit automatically deepens the pool, liquidity is never scattered across multiple venues or pair combinations. All liquidity for a given token lives in one place.

## The Wrapped Token Serves Three Roles

In traditional AMMs, three distinct instruments exist:

1. **The token itself** — what you hold and transfer
2. **LP tokens** — representing your share of pool liquidity
3. **Pool reserves** — tokens locked in the AMM contract

The 2x mint collapses all three into one. The Liquid wrapped token simultaneously serves as:

1. **A standard ERC-20** — holdable, transferable, composable with any DeFi protocol
2. **A liquidity position** — your tokens and the pool's tokens are the same asset; cooling redeems your proportional share of backing reserves
3. **The pool reserve itself** — the contract's own token balance IS the sell-side liquidity

This triple role is possible because the pool doesn't hold a *different* token as reserve — it holds more of the *same* wrapped token.

## Prior Art

The 2x mint pattern has no direct precedent in DeFi. The closest mechanism is **Bancor v2.1's co-investment model** (2020), which pioneered the idea of a protocol minting matching tokens alongside user deposits. The differences are structural:

| | Liquid 2x Mint | Bancor Co-Investment |
|:--|:--|:--|
| What's minted to pool | Same wrapped token | Different token (BNT) |
| Separate LP token | No | Yes (bnETH, bnBNT) |
| Permissionless | Yes — every wrap, every token | No — requires DAO whitelisting |
| Governance required | None | Co-investment caps set by DAO |
| Fee model | Zero fees, hardcoded | Fees fund impermanent loss insurance |

The critical distinction: Bancor mints a **different token** (BNT, its native governance token) to the protocol side of the pool. This requires BNT to have independent value, creates governance surface area around minting caps, and introduces the complexity of impermanent loss insurance funded by trading fees.

Liquid mints the **same wrapped token** to both user and pool. No second token. No governance. No insurance mechanism needed. The wrapped token is its own liquidity.

### Other protocols compared

**Uniswap / SushiSwap / Curve / Balancer:** All require explicit, two-sided liquidity provision with separate LP tokens. None mint matching tokens on deposit.

**THORChain synthetic assets:** Mints synth tokens to users and internal "synth units" to pools. The pool side is internal accounting, not a tradeable token. Different mechanism, different purpose.

**WETH and other wrapped tokens:** 1x mint only. No pool creation, no built-in trading.

**Ampleforth / rebase tokens:** Change supply globally through rebasing. No relationship to liquidity provision.

**OlympusDAO bonding:** Protocol acquires LP tokens through bonding. Users provide pre-existing LP positions, not deposits that create liquidity.

No academic literature describes this specific pattern (deposit-creates-matching-pool-liquidity using the same token).

## Consequences

The 2x mint creates several emergent properties that follow from the mechanism:

**Every holder is a liquidity provider.** There is no distinction between "holding wrapped tokens" and "providing liquidity." If you hold Liquid tokens, you have contributed liquidity (at heat time) and your cool redemption value depends on pool state.

**Liquidity scales with adoption.** More users wrapping tokens means deeper pools, which means better execution for traders, which attracts more users. The feedback loop is built into the deposit mechanism.

**No liquidity mining needed.** Protocols typically incentivize liquidity with token rewards because LP provision is a separate, voluntary step. When every deposit automatically creates liquidity, the incentive problem disappears.

**Variable redemption ratio.** Because the pool's token balance changes through trading (buys remove tokens, sells add them), the cool operation doesn't always return exactly 1:1. On average across all users it approaches 1:1, but individual redemptions depend on the pool distribution at the time of cooling. Your wrapped tokens carry implicit LP exposure — which can work for or against you depending on how the pool has been traded since you deposited.
