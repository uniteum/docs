---
title: Design
weight: 3
---

# Liquid Protocol Design

A mathematical and architectural specification of the Liquid automated market maker protocol.

## Abstract

Liquid is an automated market maker (AMM) protocol that wraps arbitrary tokens into tradeable representations with built-in liquidity. The protocol uses a constant-product formula for price discovery and implements a symmetric mint/burn mechanism that automatically creates liquidity during the wrapping process.

## Core Concepts

### Token States

Each instance of the protocol operates on two token states:

- **Backing Token**: An external token that serves as collateral
- **Wrapped Token**: A tradeable token with embedded liquidity

The wrapped token inherits the metadata (name, symbol, decimals) of its backing token, creating a transparent relationship between the two forms.

### Liquidity Representation

The protocol maintains two balance pools per wrapped token instance:

- **Token Pool**: Wrapped tokens (spoke tokens) held by the protocol
- **Hub Pool**: Hub tokens held by the protocol

The Hub is itself a wrapped token instance (wrapping "Uniteum 1", symbol "1"), creating a unified token system where all spoke tokens share a common denominator for pricing and exchange. Spoke tokens are any liquid tokens other than the Hub.

## Mathematical Model

### Constant Product Invariant

For any wrapped token instance, the following invariant holds during trades:

```
pool × lake = k
```

Where:
- `pool` = wrapped token (spoke) balance held by protocol
- `lake` = hub token balance held by protocol
- `k` = constant (changes only during wrap/unwrap operations)

This is the classical constant-product formula used in automated market makers, providing deterministic price discovery through supply and demand dynamics.

### Wrapping Operation

When a user deposits `n` backing tokens into a spoke with current pool balance `P` and total supply `T`:

```
p = 2n × P / T      (minted to pool — proportional to pool's share)
u = 2n − p           (minted to user — the remainder)
Total minted: u + p = 2n
```

On the first deposit (`T = 0`), the split is 50/50: user and pool each receive `n`. Subsequent deposits preserve the existing pool-to-supply ratio `P/T`.

**Effect**: Creates liquidity proportional to deposits without requiring separate liquidity provision. The user receives tradeable tokens while simultaneously deepening the available pool for other traders.

**At equilibrium** (`P/T = 1/2`):
- User receives: `n` wrapped tokens
- Pool receives: `n` wrapped tokens
- Total minted: `2n`
- User ownership: `n / 2n = 50%` of new issuance

**Away from equilibrium** the split shifts: when `P/T < 1/2` (pool depleted after buying), the user receives more than `n`; when `P/T > 1/2` (pool oversupplied after selling), the user receives less than `n`. See [The 2x Mint](/liquid/2x-mint) for full analysis.

### Unwrapping Operation

When a user burns `u` wrapped tokens from a spoke with current pool balance `P`, total supply `T`, and backing balance `B`:

```
U = T − P                (circulating supply outside pool)
m = u × T / (U × 2)     (backing tokens returned)
p = 2m − u               (burned from pool)
Total burned: u + p = 2m
```

**Invariant**: The ratio `P/T` is preserved, maintaining symmetry with wrapping. The user receives backing tokens proportional to their share of the circulating supply.

**Mathematical properties**:
- Burns are split between user (`u`) and pool (`p`) to preserve `P/T`
- Backing returned: `m = u × T / (2U)` where `U = T − P`
- At equilibrium (`P/T = 1/2`): `m = u` (1:1 redemption)
- Away from equilibrium: redemption rate shifts (see [The 2x Mint](/liquid/2x-mint))

### Trading Operations

#### Buy (Hub → Spoke)

To purchase `s` spoke tokens:

```
pool' = pool - s
lake' = (pool × lake) / pool'
hub_cost = lake' - lake
```

**Transfer**:
- `s` spoke tokens: protocol → user
- `hub_cost` hub tokens: user → protocol

**Properties**:
- Price increases as more tokens are bought (pool decreases)
- Invariant preserved: `pool' × lake' = pool × lake`
- Slippage increases non-linearly with trade size

#### Sell (Spoke → Hub)

To sell `s` spoke tokens:

```
pool' = pool + s
lake' = (pool × lake) / pool'
hub_received = lake - lake'
```

**Transfer**:
- `s` spoke tokens: user → protocol
- `hub_received` hub tokens: protocol → user

**Properties**:
- Price decreases as more tokens are sold (pool increases)
- Invariant preserved: `pool' × lake' = pool × lake`
- Always provides some liquidity (never fully depleted)

#### Deployed Trading Functions

The protocol exposes exactly two single-instance trading operations, each with a `view` quote function and an executing function:

- **`buy(e)`** — spend `e` hub tokens, receive `s = buys(e)` spoke tokens
- **`sell(s)`** — sell `s` spoke tokens, receive `e = sells(s)` hub tokens

Both are *specify-input* operations: the caller specifies what they put in, and the constant-product formula determines what they get out. There are no specify-output variants (no `buyWith`, no `sellFor` in the "specify hub output" sense — see the cross-instance section below for the actual `sellFor`/`sellsFor` signatures).

### Cross-Instance Swaps

To swap between two different spoke tokens A and B, the protocol routes through the hub atomically in a single transaction. Only one variant is deployed:

- **`sellFor(that, s)`** on spoke A — sells `s` of A's spoke tokens for hub, then immediately spends that hub to buy B's spoke tokens; returns `(e, thats)` where `e` is the hub used as intermediary and `thats` is the amount of B's spoke tokens received.
- **`sellsFor(that, s)`** is the corresponding `view` quote.

Both are specify-input on the source spoke side (`s` of A in). There is no specify-output cross-instance variant, no `buy(A, B)` / `sell(A, B)` pair — only the single `sellFor` direction.

**Mathematical composition**:
```
A → Hub: Standard sell operation on instance A (consumes s of A, produces e hub)
Hub → B: Standard buy operation on instance B (consumes e hub, produces thats of B)
Net effect: A → B swap with hub as intermediary
```

To swap in the reverse direction (B → A), call `sellFor` on spoke B with A as the target. Each instance maintains its own constant-product invariant.

## Architectural Design

### Instance Creation

Wrapped token instances are created deterministically:

```
address = deterministic_function(backing_token_address, factory_address)
```

**Properties**:
- Same backing token always produces same wrapped token address
- Address predictable before deployment
- Enables trustless address discovery
- Prevents duplicate instances for same backing token

The deterministic addressing allows users to independently verify that a wrapped token instance corresponds to a specific backing token without relying on external registries.

### Factory Pattern

The Hub instance serves as the factory for creating new spoke instances:

```
function create_instance(backing_token) → spoke_instance
```

**Constraints**:
- Only the Hub instance can create new spoke instances
- Centralizes instance registry while keeping protocol permissionless
- Creates single source of truth for valid instances

**Rationale**: Having a single factory prevents fragmentation of liquidity across duplicate instances while maintaining permissionless access (anyone can request instance creation).

### Access Control Model

**Public Operations** (universally accessible):
- Wrap backing tokens into spoke tokens
- Unwrap spoke tokens into backing tokens
- Trade spoke tokens for hub
- Trade hub for spoke tokens
- Cross-instance swaps

**Protected Operations** (only callable by verified instances):
- Internal balance updates during cross-swaps
- Hook functions for multi-instance coordination

**Verification Method**: Caller address must match deterministically predicted address for its backing token.

**Design principle**: Maximize openness for user-facing operations, restrict only internal coordination mechanisms to prevent manipulation.

## Economic Properties

### Price Discovery

Price of spoke token in hub terms:

```
price = lake / pool
```

Price adjusts automatically as:
- Demand increases → pool decreases → price increases
- Supply increases → pool increases → price decreases

This creates a self-balancing mechanism where price moves to equilibrate supply and demand without external oracle input.

### Slippage Characteristics

For a buy of size `s`:

```
slippage = (marginal_price - average_price) / average_price

where:
  marginal_price = lake / (pool - s)
  average_price = hub_cost / s
```

**Properties**:
- Slippage increases non-linearly with trade size
- Larger pools provide better execution for fixed trade size
- Small trades approximate spot price
- Large trades move the market significantly

### Liquidity Depth

Total value locked in instance:

```
TVL = pool × price + lake
    = pool × (lake / pool) + lake
    = 2 × lake
```

**Implication**: Total liquidity depth is exactly twice the hub pool size, regardless of the spoke token price. This creates a predictable relationship between hub deposits and available liquidity.

### Arbitrage Resistance

The protocol prevents simple arbitrage cycles through mathematical properties:

**Cycle 1: Wrap → Sell → Buy → Unwrap**
- Wrap: Receive n tokens, pool grows by n
- Sell: Incur AMM slippage
- Buy: Incur AMM slippage in opposite direction
- Unwrap: Proportional burn reduces redemption value
- Net result: Loss due to slippage and proportional mechanics

**Cycle 2: Wrap → Unwrap (immediate reversal)**
- Wrap n: Mint 2n total (n to user, n to pool)
- Unwrap n: Burn 2n proportionally
- Net result: User share diluted by pool share

Both cycles result in net loss, preventing exploitative arbitrage while allowing beneficial arbitrage that moves prices toward external market values.

### Liquidity Bootstrapping

The [2x mint](/liquid/2x-mint) mechanism creates automatic liquidity:

```
First wrap of n tokens:
  User receives: n wrapped tokens
  Pool receives: n wrapped tokens
  Tradeable depth: 50% of wrapped supply

Subsequent wraps of n tokens (given pool ratio P/T):
  Pool receives: 2n × P/T wrapped tokens
  User receives: 2n − pool's share
  Ratio P/T preserved
```

**Comparison to traditional AMMs**:
- Traditional: User must deposit both sides of pair (e.g., 50 A + 50 B)
- Liquid: User deposits only backing token (e.g., 100 solid) and the protocol creates pool liquidity automatically

This eliminates the bootstrapping problem where new tokens cannot trade until someone provides initial liquidity.

## Protocol Topology

### Network Structure

```
                      HUB (wraps Uniteum 1)
                         |
         +---------------+---------------+
         |               |               |
      Spoke A        Spoke B         Spoke C
   (wraps USDC)    (wraps DAI)    (wraps WETH)
```

**Topology properties**:
- Star topology with Hub at center
- All spoke instances independent except during cross-swaps
- No global state synchronization required
- Scales to arbitrary number of instances without increasing complexity

### Routing Mechanics

**Direct trade**: `Spoke ↔ Hub` (single hop)
**Cross-instance**: `Spoke A ↔ Hub ↔ Spoke B` (two hops)

**Maximum path length**: 2 hops for any token-to-token swap

**Comparison to mesh topology**:
- Mesh (Uniswap): n² pairs for n tokens, any pair directly tradeable
- Star (Liquid): n pools for n tokens, maximum 2 hops for any swap
- Trade-off: Liquid sacrifices direct pair routing for massive reduction in pool count

### Composability

Instances are independently deployable and tradeable. No global state synchronization required except during cross-instance swaps (which are atomic operations).

**Composability guarantees**:
- Instance A operations cannot affect instance B state (except during explicit cross-swap)
- New instances can be added without affecting existing instances
- Protocol-level upgrades not required for instance creation
- Each instance maintains its own invariants

## Design Rationale

### Why Constant Product?

The constant-product formula `x × y = k` provides:

1. **Infinite liquidity**: Always able to trade, though at increasingly worse prices
2. **Automatic price discovery**: Price adjusts based on supply/demand without oracles
3. **Mathematical simplicity**: Easy to compute, audit, and reason about
4. **Proven track record**: Used successfully in Uniswap, Balancer, and other AMMs

**Alternatives considered**:
- Constant sum (x + y = k): Better for stablecoins, but allows price to hit zero
- Stableswap curves: More complex, optimized for like-kind assets
- Order books: Requires active market makers, can have zero liquidity

### Why 2x Mint?

The symmetric mint mechanism (total 2x, split between user and pool) provides:

1. **Automatic liquidity**: No solid-start problem for new tokens
2. **Proportional depth**: Liquidity scales with wrapping activity
3. **Symmetric unwrap**: Burn mechanics mirror mint mechanics
4. **Elegant mathematics**: Total minted = Total burned over time

**Alternative considered**:
- 1x mint (like WETH): Simpler but requires separate liquidity provision step

### Why Star Topology?

The star topology (n pools) vs mesh topology (n² pairs) provides:

1. **Scalability**: Linear growth vs quadratic growth
2. **Liquidity concentration**: Single pool per token vs fragmentation across pairs
3. **Simplified routing**: Maximum 2 hops vs complex multi-hop routing
4. **Reduced state**: One pool per token vs combinatorial pair explosion

**Trade-off**:
- Mesh: Direct trading between any pair (1 hop), but n² pools
- Star: Maximum 2 hops, but only n pools

For small n (e.g., n < 10), mesh is superior. For large n (e.g., n > 100), star becomes necessary.

### Why Zero Fees?

The protocol charges no fees on any operation:

**Advantages**:
- Simplifies mathematics (no fee calculation in formulas)
- Maximizes capital efficiency for traders
- Removes governance attack surface (no fee switches to capture)
- Positions protocol as public infrastructure rather than rent-extraction

**Disadvantages**:
- No revenue for protocol development
- No mechanism to reward liquidity providers beyond market making
- Relies on wrapping activity to create liquidity rather than fee incentives

**Design philosophy**: Liquid prioritizes trust-minimization and simplicity over revenue generation.

## Formal Properties

### Conservation Laws

1. **Token Conservation**: Total wrapped tokens minted = Total backing tokens deposited
2. **Symmetry**: Total wrapped tokens burned = Proportional reduction in supply
3. **Value Conservation**: Trades preserve total value (modulo slippage)

### Determinism

**Property**: Given identical inputs and state, operations produce identical outputs.

**Implications**:
- Reproducible results for testing and verification
- Predictable behavior for integrators
- No randomness or external dependencies

### Invariant Preservation

1. **Constant Product**: `pool × lake = k` before and after trades
2. **Mint/Burn Symmetry**: `total_minted = 2n` implies `total_burned = 2n` over full lifecycle
3. **Backing Solvency**: `backing_balance ≥ redemption_obligations` at all times

### Atomicity

**Property**: Multi-step operations (like cross-swaps) complete fully or revert entirely.

**Guarantee**: No partial state where step 1 succeeds but step 2 fails, leaving inconsistent state.

### Isolation

**Property**: Instance A operations cannot affect instance B state except during explicit cross-swaps.

**Guarantee**: Adding new instances or trading on existing instances does not change the state of unrelated instances.

## Comparison to Related Designs

### vs. Uniswap V2

| Property | Liquid | Uniswap V2 |
|----------|--------|------------|
| Formula | Constant product (xy=k) | Constant product (xy=k) |
| Topology | Star (n pools) | Mesh (n² pairs) |
| Fees | Zero | 0.3% per trade |
| Liquidity | Automatic (2x mint) | Manual provision required |
| Governance | None (immutable) | Fee switch (upgradeable) |
| Scaling | Linear in token count | Quadratic in token count |

**When to use Liquid**: Large token ecosystems (n > 100), zero-fee priority, trust-minimization
**When to use Uniswap**: Established token pairs, direct routing priority, fee revenue desired

### vs. Curve Finance

| Property | Liquid | Curve |
|----------|--------|-------|
| Formula | Constant product | Stableswap (hybrid) |
| Optimization | General purpose | Like-kind assets |
| Complexity | Low (single formula) | High (parameter tuning) |
| Governance | None | DAO-controlled parameters |
| Fees | Zero | Variable per pool |

**When to use Liquid**: General token wrapping, trust-minimization, simplicity
**When to use Curve**: Stablecoin swaps, minimal slippage for like-kind assets

### vs. Balancer

| Property | Liquid | Balancer |
|----------|--------|----------|
| Pools | Binary (spoke + hub) | N-ary (multiple tokens) |
| Weights | 50/50 fixed | Arbitrary weights |
| Complexity | Low | High |
| Liquidity | Automatic | Manual provision |
| Fees | Zero | Configurable per pool |

**When to use Liquid**: Simple wrapping, automatic liquidity, zero fees
**When to use Balancer**: Custom pool weights, portfolio rebalancing, fee revenue

### vs. Wrapped Tokens (WETH)

| Property | Liquid | WETH |
|----------|--------|------|
| Wrapping | 1:1 backing | 1:1 backing |
| Mint | 2x (user + pool) | 1x (user only) |
| Liquidity | Built-in AMM | Requires external DEX |
| Trading | Native | Requires separate protocol |
| Complexity | Higher | Lower |

**When to use Liquid**: Want built-in trading without external DEX
**When to use WETH**: Simple wrapping, established ecosystem, composability with existing DEXs

## Extensions and Generalizations

### Quote Functions

Non-state-changing functions that return expected trade results without executing trades:

```
buy_quote(amount) → hub_cost
sell_quote(amount) → hub_received
buy_with_quote(hub) → amount_received
sell_for_quote(hub) → amount_to_sell
```

**Purpose**: Enable off-chain price discovery, UI integration, and trade simulation without blockchain interaction.

### Batch Operations

Multiple operations can be composed in single transaction:

```
batch_execute([
  wrap(tokenA, amountA),
  trade(tokenA, tokenB, amountAB),
  unwrap(tokenB, amountB)
])
```

**Properties**:
- Atomicity: All operations succeed or all revert
- Gas efficiency: Single transaction overhead
- Composability: Arbitrary operation sequencing

### Generalized Wrapping

The protocol can be generalized to support different wrapping ratios:

**Standard (2x)**:
- Total minted: 2n
- On first deposit: n to user, n to pool (50/50)
- Subsequent deposits preserve existing P/T ratio

**Generalized (rx)**:
- Total minted: r×n
- On first deposit: n to user, (r-1)n to pool
- Equilibrium at P/T = (r-1)/r

**Trade-off**: Higher r creates deeper liquidity but dilutes user ownership more.

## Mathematical Proofs

### Theorem 1: Invariant Preservation

**Claim**: The constant-product invariant is preserved during buy and sell operations.

**Proof** (Buy operation):
```
Given: pool × lake = k
Buy s tokens:
  pool' = pool - s
  lake' = k / pool' = (pool × lake) / (pool - s)

Verify invariant:
  pool' × lake' = (pool - s) × (pool × lake) / (pool - s)
                = pool × lake
                = k ✓
```

**Proof** (Sell operation):
```
Given: pool × lake = k
Sell s tokens:
  pool' = pool + s
  lake' = k / pool' = (pool × lake) / (pool + s)

Verify invariant:
  pool' × lake' = (pool + s) × (pool × lake) / (pool + s)
                = pool × lake
                = k ✓
```

**Integer rounding note.** The deployed implementation computes the lake remainder with ceiling division to guarantee the invariant never *decreases* under integer arithmetic. Concretely, `sells(s)` returns `e = E − ⌈(E·S + E − 1) / (S + s)⌉`, where the deduction is rounded up so `e` is rounded down. Any sub-wei residue stays in the lake on the protocol's side, so the post-trade `pool' × lake' ≥ pool × lake = k` rather than `= k` exactly. The exact-arithmetic identity above is the limit; the deployed identity is a one-sided inequality in favor of the pool.

### Theorem 2: Wrap/Unwrap Symmetry

**Claim**: Wrapping n tokens then immediately unwrapping results in receiving ≤ n backing tokens.

**Proof**:
```
Initial state:
  pool = P, total_supply = T, backing = B

Heat(n) — using the ratio-preserving formula:
  p = 2n × P/T          (minted to pool)
  u = 2n − p             (minted to user)
  P' = P + p,  T' = T + 2n,  B' = B + n

Cool(u) — immediately after:
  U' = T' − P' = (T + 2n) − (P + p) = T − P + 2n − p = T − P + u
  m  = u × T' / (U' × 2)

Substituting T' = T + 2n and U' = T − P + u:
  m  = u × (T + 2n) / (2 × (T − P + u))

At equilibrium (P/T = 1/2, so P = T/2):
  u = n, U' = T/2 + n
  m = n × (T + 2n) / (2 × (T/2 + n)) = n × (T + 2n) / (T + 2n) = n ✓

When T > 0 and P > 0 (non-first deposit):
  u < 2n and U' > u, so m < n in general.

Therefore: backing_received ≤ n ✓
```

### Theorem 3: No-Arbitrage in Heat-Cool Cycles

**Claim**: A cycle of heat → sell → buy → cool results in net loss.

**Proof sketch**:
```
1. Heat n: Receive u tokens, pool grows by p (where u + p = 2n)
2. Sell u: Receive hub H (with AMM slippage)
3. Buy with H: Receive tokens u' < u (due to constant-product concavity)
4. Cool u': Receive backing m' < n (due to proportional burn)

Result: backing_received < n = backing_deposited

Net loss from:
  - AMM slippage on sell (step 2)
  - AMM slippage on buy (step 3)
  - Proportional dilution on cool (step 4)
```

## Implementation Considerations

### Numerical Precision

All calculations use integer arithmetic to avoid floating-point imprecision:

```
price = lake / pool  (integer division)
```

**Implications**:
- Small rounding errors accumulate over many trades
- Dust amounts may become untradeble
- Requires sufficient token decimals for precision

**Mitigation**: Use tokens with ≥ 6 decimals for acceptable precision.

### Edge Cases

**Empty pool** (`pool = 0`):
- Cannot buy (no tokens in pool to purchase)
- Cannot sell profitably (with `k = pool × lake = 0`, selling adds to pool but yields zero hub)
- Can wrap (creates initial pool via 2x mint)

**Empty lake** (`lake = 0`):
- `sells(s)` / `sell(s)` **revert** with arithmetic underflow. The deployed quote computes `e = E − ⌈(E·S + E − 1) / (S + s)⌉`, and the inner `E − 1` underflows when `E = 0` (uint subtraction). Selling into an empty lake is not "yields zero hub" — it is a hard revert.
- Cannot buy profitably (buying removes pool tokens but costs zero hub — no meaningful price)
- Requires seeding: a cross-instance swap or direct hub transfer to establish `k > 0`

**Maximum trade size**:
- Buy: Limited by pool size (cannot buy more than pool)
- Sell: No hard limit, but price approaches zero

### Deployment Considerations

**Initial state**:
- New spoke instance has zero pool, zero lake
- First wrap creates initial pool
- Initial lake requires cross-instance swap or direct transfer

**Bootstrapping**:
1. Deploy Hub instance with initial backing (Uniteum 1)
2. Wrap backing into hub (1:1 mint — hub has no pool or lake)
3. Deploy additional spoke instances as needed
4. Heat spokes to create initial pools; cross-swaps seed lakes

## Conclusion

Liquid protocol implements a minimal, elegant AMM design that unifies token wrapping with liquidity provision. The mathematical foundation rests on the proven constant-product formula, extended with a symmetric 2x mint mechanism that automatically creates tradeable depth.

The star topology trades direct pair routing for linear scalability, positioning the protocol for ecosystems with hundreds or thousands of unique tokens. Zero fees and immutable design eliminate governance risk and protocol capture, at the cost of no revenue mechanism.

The design achieves mathematical elegance through:
- Single invariant (constant product) maintained across all trades
- Symmetric operations (2x mint ↔ 2x burn)
- Deterministic pricing (no oracles, no governance)
- Compositional swaps (atomic multi-instance trades)

This positions Liquid as trust-minimized infrastructure for token liquidity, suitable for environments where simplicity, transparency, and censorship-resistance are paramount.
