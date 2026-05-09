---
title: Liquid Tutorial
weight: 2
---
# Tutorial: Using Liquid on Etherscan

> Wrap a token with built-in liquidity, trade it, and swap it — all from a block explorer.

Everything here uses [Etherscan](https://etherscan.io) directly. No custom app, no frontend, no SDK.

The [Hub](https://etherscan.io/token/{{< val "liquids.hub.address" >}}) is the central contract — it wraps [Uniteum 1](https://etherscan.io/token/{{< val "solids" "1" "address" >}}) and acts as the factory for all spoke tokens.

We'll use [{{< val "liquids.spoke.name" >}} ({{< val "liquids.spoke.symbol" >}})](https://etherscan.io/token/{{< val "liquids.spoke.address" >}}#readContract#F{{< val "liquid" "read" "solid()" "f" >}}) as our example spoke, backed by [{{< val "backing.spoke.name" >}} ({{< val "backing.spoke.symbol" >}})](https://etherscan.io/token/{{< val "backing.spoke.address" >}}).

---

## 1. Get Hub tokens

**Goal:** Wrap "Uniteum 1" (a Solid) into Hub tokens. You need Hub tokens to interact with spoke pools.

Hub heat is a simple 1:1 wrap — no pool mechanics, no [2x mint](/liquid/2x-mint).

### Approve

The Hub needs permission to transfer your "Uniteum 1" tokens.

1. Go to [Uniteum 1 → approve](https://etherscan.io/token/{{< val "solids" "1" "address" >}}#writeContract#F{{< val "solid" "write" "approve(spender, value)" "f" >}})
2. Connect your wallet
3. Enter:
   - `spender`: `{{< val "liquids.hub.address" >}}` (the Hub)
   - `amount`: the amount to approve (in wei, 18 decimals)
4. Click **Write** and confirm

### Heat

1. Go to [Hub → heat(m, e)](https://etherscan.io/token/{{< val "liquids.hub.address" >}}#writeContract#F{{< val "liquid" "write" "heat(m, e)" "f" >}})
2. Enter `m` — the amount of "Uniteum 1" to wrap (in wei, 18 decimals)
3. Click **Write** and confirm

**What happened:**
- Your "Uniteum 1" tokens were deposited into the Hub
- You received the same amount of Hub tokens (1:1)

**Verify:** Call [`balanceOf`](https://etherscan.io/token/{{< val "liquids.hub.address" >}}#readContract#F{{< val "liquid" "read" "balanceOf(account)" "f" >}}) on the Hub with your wallet address.

<!-- TODO: example tx hash for a Hub heat transaction -->

---

## 2. Create a spoke

**Goal:** Create a new liquid token for any ERC-20.

### Check if it already exists

1. Go to [Hub → made](https://etherscan.io/token/{{< val "liquids.hub.address" >}}#readContract#F{{< val "liquid" "read" "made(backing)" "f" >}})
2. Enter `backing`: the address of the ERC-20 you want to wrap
3. Click **Query**

If `cloned` = `true`, the spoke already exists at the `home` address.
If `cloned` = `false`, you can create it — and `home` shows where it will be deployed.

### Create it

1. Go to [Hub → make](https://etherscan.io/token/{{< val "liquids.hub.address" >}}#writeContract#F{{< val "liquid" "write" "make(backing)" "f" >}})
2. Enter `backing`: the ERC-20 token address
3. Click **Write** and confirm

**What happened:**
- A new spoke was deployed at a deterministic address (the `home` from `made`)
- The spoke wraps your chosen ERC-20 with a built-in AMM pool connected to Hub
- The spoke starts empty — someone needs to heat it to create liquidity

**Find the address:** Call [`made`](https://etherscan.io/token/{{< val "liquids.hub.address" >}}#readContract#F{{< val "liquid" "read" "made(backing)" "f" >}}) again with the same backing address. The `home` field is your spoke's contract.

<!-- TODO: example tx hash for a make transaction -->

---

## 3. Add liquidity (heat a spoke)

**Goal:** Deposit backing tokens into a spoke to get liquid tokens and create pool liquidity.

This is where the **2x mint** happens: you deposit N backing tokens, the protocol mints 2N liquid tokens total — split between you and the pool based on the current ratio. On first deposit (or at equilibrium), the split is 50/50. Instant tradeable liquidity.

### Approve

1. Go to [{{< val "backing.spoke.name" >}} → approve](https://etherscan.io/token/{{< val "backing.spoke.address" >}}#writeContract#F{{< val "solid" "write" "approve(spender, value)" "f" >}})
2. Enter:
   - `spender`: `{{< val "liquids.spoke.address" >}}` (the {{< val "liquids.spoke.symbol" >}} spoke)
   - `amount`: how much to approve (in wei, 18 decimals)
3. Click **Write** and confirm

### Heat

1. Go to [{{< val "liquids.spoke.symbol" >}} → heat(m, e)](https://etherscan.io/token/{{< val "liquids.spoke.address" >}}#writeContract#F{{< val "liquid" "write" "heat(m, e)" "f" >}})
2. Enter `m` — the amount of {{< val "backing.spoke.name" >}} tokens to deposit
3. Click **Write** and confirm

**What happened:**
- Your {{< val "backing.spoke.name" >}} tokens were deposited into the spoke
- You received {{< val "liquids.spoke.symbol" >}} tokens (your share)
- The pool also received {{< val "liquids.spoke.symbol" >}} tokens (instant liquidity)
- Total minted: 2 × your deposit, split between you and the pool

**Verify:** Call [`pool`](https://etherscan.io/token/{{< val "liquids.spoke.address" >}}#readContract#F{{< val "liquid" "read" "pool()" "f" >}}) on {{< val "liquids.spoke.symbol" >}} — it returns `(P, E)` where P is spoke tokens in the pool and E is Hub tokens in the pool.

<!-- TODO: example tx hash for a spoke heat transaction -->

---

## 4. Sell spoke tokens for Hub

**Goal:** Trade your {{< val "liquids.spoke.symbol" >}} tokens for Hub tokens.

### Preview

1. Go to [{{< val "liquids.spoke.symbol" >}} → sells](https://etherscan.io/token/{{< val "liquids.spoke.address" >}}#readContract#F{{< val "liquid" "read" "sells(s)" "f" >}})
2. Enter the amount of {{< val "liquids.spoke.symbol" >}} tokens to sell
3. Click **Query**

The result is how many Hub tokens you'd receive.

### Sell

1. Go to [{{< val "liquids.spoke.symbol" >}} → sell](https://etherscan.io/token/{{< val "liquids.spoke.address" >}}#writeContract#F{{< val "liquid" "write" "sell(s)" "f" >}})
2. Enter `s` — the amount of spokes to sell
3. Click **Write** and confirm

**What happened:**
- Your {{< val "liquids.spoke.symbol" >}} tokens moved into the pool
- Hub tokens moved from the pool's lake to your wallet
- The pool's constant-product invariant (P × E = k) was maintained

**Verify:** Call [`balanceOf`](https://etherscan.io/token/{{< val "liquids.hub.address" >}}#readContract#F{{< val "liquid" "read" "balanceOf(account)" "f" >}}) on the Hub with your wallet address.

<!-- TODO: example tx hash for a sell transaction -->

---

## 5. Buy spoke tokens with Hub

**Goal:** Trade Hub tokens for {{< val "liquids.spoke.symbol" >}} tokens from the pool.

### Preview

1. Go to [{{< val "liquids.spoke.symbol" >}} → buys](https://etherscan.io/token/{{< val "liquids.spoke.address" >}}#readContract#F{{< val "liquid" "read" "buys(e)" "f" >}})
2. Enter the amount of Hub tokens to spend
3. Click **Query**

The result is how many {{< val "liquids.spoke.symbol" >}} tokens you'd receive.

### Buy

1. Go to [{{< val "liquids.spoke.symbol" >}} → buy](https://etherscan.io/token/{{< val "liquids.spoke.address" >}}#writeContract#F{{< val "liquid" "write" "buy(e)" "f" >}})
2. Enter `e` — the amount of Hub (lake) to spend
3. Click **Write** and confirm

**What happened:**
- Hub tokens moved from your wallet into the pool's lake
- {{< val "liquids.spoke.symbol" >}} tokens moved from the pool to your wallet

**Verify:** Call [`balanceOf`](https://etherscan.io/token/{{< val "liquids.spoke.address" >}}#readContract#F{{< val "liquid" "read" "balanceOf(account)" "f" >}}) on {{< val "liquids.spoke.symbol" >}} with your wallet address.

<!-- TODO: example tx hash for a buy transaction -->

---

## 6. Cross-swap between two spokes

**Goal:** Trade one spoke token for another in a single transaction. This sells spoke A for Hub internally, then immediately buys spoke B with that Hub.

### Preview

1. On spoke A, go to [`sellsFor`](https://etherscan.io/token/{{< val "liquids.spoke.address" >}}#readContract#F{{< val "liquid" "read" "sellsFor(that, s)" "f" >}})
2. Enter:
   - `that`: spoke B's contract address
   - `spokes`: amount of spoke A to trade
3. Click **Query**

The result shows Hub used and spoke B tokens you'd receive.

### Swap

1. On spoke A, go to [`sellFor`](https://etherscan.io/token/{{< val "liquids.spoke.address" >}}#writeContract#F{{< val "liquid" "write" "sellFor(that, s)" "f" >}})
2. Enter:
   - `that`: spoke B's contract address
   - `spokes`: amount of spoke A to trade
3. Click **Write** and confirm

**What happened:**
- Your spoke A tokens went into spoke A's pool
- Hub moved internally from spoke A's lake to spoke B's lake
- Spoke B tokens moved from spoke B's pool to your wallet
- All in one transaction — no intermediate steps

**Verify:** Call `balanceOf` on spoke B's Read Contract with your wallet address.

<!-- TODO: example tx hash for a sellFor transaction -->

---

## 7. Exit your position (cool)

**Goal:** Burn {{< val "liquids.spoke.symbol" >}} tokens and withdraw {{< val "backing.spoke.name" >}}.

### Preview

1. Go to [{{< val "liquids.spoke.symbol" >}} → cools](https://etherscan.io/token/{{< val "liquids.spoke.address" >}}#readContract#F{{< val "liquid" "read" "cools(u)" "f" >}}) (the one with just `uint256 u`)
2. Enter the amount of {{< val "liquids.spoke.symbol" >}} tokens to burn
3. Click **Query**

The result shows how many {{< val "backing.spoke.name" >}} tokens you'd receive (`s`) and how many pool tokens get burned alongside yours (`p`).

### Cool

1. Go to [{{< val "liquids.spoke.symbol" >}} → cool](https://etherscan.io/token/{{< val "liquids.spoke.address" >}}#writeContract#F{{< val "liquid" "write" "cool(u)" "f" >}}) (the one with just `uint256 u`)
2. Enter `u` — the amount of {{< val "liquids.spoke.symbol" >}} tokens to burn
3. Click **Write** and confirm

**What happened:**
- Your {{< val "liquids.spoke.symbol" >}} tokens were burned
- A matching amount was burned from the pool (maintaining the 2x symmetry from heat)
- {{< val "backing.spoke.name" >}} tokens were returned to your wallet proportional to pool reserves

To unwrap Hub back to "Uniteum 1", call [`cool`](https://etherscan.io/token/{{< val "liquids.hub.address" >}}#writeContract#F{{< val "liquid" "write" "cool(u)" "f" >}}) on the Hub — this is a simple 1:1 unwrap.

<!-- TODO: example tx hash for a cool transaction -->

---

## Quick reference

### Hub ([`{{< val "liquids.hub.address" >}}`](https://etherscan.io/token/{{< val "liquids.hub.address" >}}))

#### Write

{{% fn_table proto="liquid" kind="write" token="liquids.hub.address" %}}

#### Read

{{% fn_table proto="liquid" kind="read" token="liquids.hub.address" %}}

### Spoke (links use [{{< val "liquids.spoke.symbol" >}}](https://etherscan.io/token/{{< val "liquids.spoke.address" >}}) — any spoke works the same way)

#### Write

{{% fn_table proto="liquid" kind="write" token="liquids.spoke.address" %}}

#### Read

{{% fn_table proto="liquid" kind="read" token="liquids.spoke.address" %}}

All amounts use the token's own decimals. Hub and "Uniteum 1" use 18 decimals.

## What to try next

- [Introduction](/liquid/introduction) — detailed walkthrough with example scenarios
- [The 2x Mint](/liquid/2x-mint) — the liquidity mechanism, equilibrium, and arbitrage
- [Design](/liquid/design) — mathematical specification of all formulas
