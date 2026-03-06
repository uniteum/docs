---
layout: default
title: The 2x Mint
parent: Liquid
permalink: /liquid/2x-mint/
nav_order: 2.5
---

# The 2x Mint

When you deposit tokens into Liquid, the protocol mints **twice as many** wrapped tokens as you deposited — split proportionally between you and the pool based on the current state of the system. When you withdraw, the reverse happens — tokens are burned proportionally from both you and the pool.

This is the 2x mint pattern. It is the mechanism by which Liquid turns every deposit into instant, tradeable AMM liquidity — without LP tokens, without separate liquidity provision, and without anyone's permission.

## Definition

**Heat** (deposit `m` mass (backing) tokens into a spoke with total supply `T` and pool balance `P`):

```
p = 2m × P / T          (minted to pool — proportional to pool's share)
u = 2m − p              (minted to user — the remainder)
Total minted: u + p = 2m
```

On the first deposit (`T = 0`), the split is 50/50: user and pool each receive `m`. After that, the split preserves the existing ratio between pooled and circulating tokens.

**Cool** (user burns `u` wrapped tokens from their balance):

```
U = T − P               (circulating supply outside pool)
m = u × T / U / 2       (mass returned)
p = 2m − u              (burned from pool)
Total burned: u + p = 2m
```

Both operations are proportional: the split between user and pool depends on the current distribution of the wrapped token supply.

The user's wrapped tokens and the pool's wrapped tokens are the **same ERC-20 token**. There is no distinction at the token level between "user tokens" and "pool tokens" — the pool's tokens are simply the contract's own balance.

**Hub exception:** The Hub instance (which wraps "Uniteum 1") uses a simple 1:1 mint/burn — no pool allocation. The 2x pattern applies only to spoke instances.

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

## What the Pattern Eliminates

**No liquidity bootstrapping problem.** Traditional AMMs can't trade a new token until someone provides initial liquidity on both sides. With the 2x mint, the first deposit creates a tradeable pool.

**No LP tokens.** In Uniswap, liquidity providers receive LP tokens representing their pool share — a separate token they must track, stake, and eventually redeem. In Liquid, your wrapped tokens ARE your position. Hold them, trade them, or cool them back to solid.

**No two-sided deposits.** Uniswap requires depositing equal value on both sides of a pair (e.g., 50% USDC + 50% ETH). Liquid requires only the backing token. The protocol creates the other side.

**No liquidity fragmentation.** Because every deposit automatically deepens the pool, liquidity is never scattered across multiple venues or pair combinations. All liquidity for a given token lives in one place.

## Symmetry

The 2x burn on withdrawal mirrors the 2x mint on deposit. Both operations are proportional and both always total exactly `2m`:

**Heat:** `2m` tokens minted, split proportionally between user (`u`) and pool (`p`) based on `P/T`.

**Cool:** User burns `u` tokens, pool burns `p = 2m − u` tokens, user receives `m` mass (backing) tokens — where `m` depends on the circulating-to-total ratio `U/T`.

The formulas are inverses: a heat followed immediately by a cool (with no intervening trades) returns you to your starting position minus rounding. The proportional split in both directions means the pool's share of total supply is preserved through deposits and withdrawals alike.

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

## Interaction with the Constant Product

Liquid uses the standard constant-product formula for trading:

```
pool * lake = k
```

Where `pool` is the contract's wrapped token (spoke) balance and `lake` is its Hub token balance.

The 2x mint changes `pool` but does NOT change `lake`. This means wrapping/unwrapping changes `k` (the invariant constant), while trading preserves it. The two operations are cleanly separated:

- **Heat/Cool** — change total liquidity depth (modify k)
- **Buy/Sell** — move along the constant-product curve (preserve k)

This separation means deposits and withdrawals cannot be used to manipulate trading prices through sandwich attacks on the heat/cool operations themselves — they change the depth of liquidity, not the price.

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
