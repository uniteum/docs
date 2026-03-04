---
layout: default
title: Tutorial
parent: Liquid
permalink: /liquid/tutorial/
nav_order: 2
---

# Tutorial: Using Liquid on Etherscan

> Wrap a token with built-in liquidity, trade it, and swap it — all from a block explorer.

Everything here uses [Etherscan](https://etherscan.io){:target="_blank"} directly. No custom app, no frontend, no SDK.

The [Hub](https://etherscan.io/address/{{site.data.liquids.hub.address}}){:target="_blank"} is the central contract — it wraps [Uniteum 1](https://etherscan.io/token/{{site.data.solids["1"].address}}){:target="_blank"} and acts as the factory for all spoke tokens.

---

## 1. Get Hub tokens

**Goal:** Wrap "Uniteum 1" (a Solid) into Hub tokens. You need Hub tokens to interact with spoke pools.

Hub heat is a simple 1:1 wrap — no pool mechanics, no 2x mint.

### Approve

The Hub needs permission to transfer your "Uniteum 1" tokens.

1. Go to [Uniteum 1 → Write Contract](https://etherscan.io/token/{{site.data.solids["1"].address}}#writeContract){:target="_blank"}
2. Connect your wallet
3. Find **`approve`**
4. Enter:
   - `spender`: `{{site.data.liquids.hub.address}}` (the Hub)
   - `amount`: the amount to approve (in wei, 18 decimals)
5. Click **Write** and confirm

### Heat

1. Go to [Hub → Write Contract](https://etherscan.io/address/{{site.data.liquids.hub.address}}#writeContract){:target="_blank"}
2. Find **`heat`** (the one with just `uint256 s`)
3. Enter `s` — the amount of "Uniteum 1" to wrap (in wei, 18 decimals)
4. Click **Write** and confirm

**What happened:**
- Your "Uniteum 1" tokens were deposited into the Hub
- You received the same amount of Hub tokens (1:1)

**Verify:** Call `balanceOf` on [Hub → Read Contract](https://etherscan.io/address/{{site.data.liquids.hub.address}}#readContract){:target="_blank"} with your wallet address.

<!-- TODO: example tx hash for a Hub heat transaction -->

---

## 2. Create a spoke

**Goal:** Create a new liquid token for any ERC-20.

### Check if it already exists

1. Go to [Hub → Read Contract](https://etherscan.io/address/{{site.data.liquids.hub.address}}#readContract){:target="_blank"}
2. Find **`made`**
3. Enter `backing`: the address of the ERC-20 you want to wrap
4. Click **Query**

If `cloned` = `true`, the spoke already exists at the `home` address.
If `cloned` = `false`, you can create it — and `home` shows where it will be deployed.

### Create it

1. Go to [Hub → Write Contract](https://etherscan.io/address/{{site.data.liquids.hub.address}}#writeContract){:target="_blank"}
2. Find **`make`**
3. Enter `backing`: the ERC-20 token address
4. Click **Write** and confirm

**What happened:**
- A new spoke was deployed at a deterministic address (the `home` from `made`)
- The spoke wraps your chosen ERC-20 with a built-in AMM pool connected to Hub
- The spoke starts empty — someone needs to heat it to create liquidity

**Find the address:** Call `made` again with the same backing address. The `home` field is your spoke's contract.

<!-- TODO: example tx hash for a make transaction -->

---

## 3. Add liquidity (heat a spoke)

**Goal:** Deposit backing tokens into a spoke to get liquid tokens and create pool liquidity.

This is where the **2x mint** happens: you deposit N backing tokens, you get N liquid tokens, and the pool also gets N liquid tokens. Instant tradeable liquidity.

### Approve

1. Go to the backing token's Write Contract on Etherscan
2. Find **`approve`**
3. Enter:
   - `spender`: the spoke contract address
   - `amount`: how much to approve (in the backing token's decimals)
4. Click **Write** and confirm

### Heat

1. Go to the spoke's Write Contract
2. Find **`heat`** (the one with just `uint256 s`)
3. Enter `s` — the amount of backing tokens to deposit
4. Click **Write** and confirm

**What happened:**
- Your backing tokens were deposited into the spoke
- You received liquid tokens (your share)
- The pool also received liquid tokens (instant liquidity)
- Total minted: 2 × your deposit, split between you and the pool

**Verify:** Call `pool` on the spoke's Read Contract — it returns `(P, E)` where P is spoke tokens in the pool and E is Hub tokens in the pool.

<!-- TODO: example tx hash for a spoke heat transaction -->

---

## 4. Sell spoke tokens for Hub

**Goal:** Trade your liquid (spoke) tokens for Hub tokens.

### Preview

1. On the spoke's Read Contract
2. Find **`sells`**
3. Enter the amount of spoke tokens to sell
4. Click **Query**

The result is how many Hub tokens you'd receive.

### Sell

1. On the spoke's Write Contract
2. Find **`sell`**
3. Enter `spokes` — the amount to sell
4. Click **Write** and confirm

**What happened:**
- Your spoke tokens moved into the pool
- Hub tokens moved from the pool's lake to your wallet
- The pool's constant-product invariant (P × E = k) was maintained

**Verify:** Call `balanceOf` on [Hub → Read Contract](https://etherscan.io/address/{{site.data.liquids.hub.address}}#readContract){:target="_blank"} with your wallet address.

<!-- TODO: example tx hash for a sell transaction -->

---

## 5. Buy spoke tokens with Hub

**Goal:** Trade Hub tokens for liquid (spoke) tokens from the pool.

### Preview

1. On the spoke's Read Contract
2. Find **`buys`**
3. Enter the amount of Hub tokens to spend
4. Click **Query**

The result is how many spoke tokens you'd receive.

### Buy

1. On the spoke's Write Contract
2. Find **`buy`**
3. Enter `hubs` — the amount of Hub to spend
4. Click **Write** and confirm

**What happened:**
- Hub tokens moved from your wallet into the pool's lake
- Spoke tokens moved from the pool to your wallet

**Verify:** Call `balanceOf` on the spoke's Read Contract with your wallet address.

<!-- TODO: example tx hash for a buy transaction -->

---

## 6. Cross-swap between two spokes

**Goal:** Trade one spoke token for another in a single transaction. This sells spoke A for Hub internally, then immediately buys spoke B with that Hub.

### Preview

1. On spoke A's Read Contract
2. Find **`sellsFor`**
3. Enter:
   - `that`: spoke B's contract address
   - `spokes`: amount of spoke A to trade
4. Click **Query**

The result shows Hub used and spoke B tokens you'd receive.

### Swap

1. On spoke A's Write Contract
2. Find **`sellFor`**
3. Enter:
   - `that`: spoke B's contract address
   - `spokes`: amount of spoke A to trade
4. Click **Write** and confirm

**What happened:**
- Your spoke A tokens went into spoke A's pool
- Hub moved internally from spoke A's lake to spoke B's lake
- Spoke B tokens moved from spoke B's pool to your wallet
- All in one transaction — no intermediate steps

**Verify:** Call `balanceOf` on spoke B's Read Contract with your wallet address.

<!-- TODO: example tx hash for a sellFor transaction -->

---

## 7. Exit your position (cool)

**Goal:** Burn liquid tokens and withdraw the backing tokens.

### Preview

1. On the spoke's Read Contract
2. Find **`cools`** (the one with just `uint256 u`)
3. Enter the amount of liquid tokens to burn
4. Click **Query**

The result shows how many backing tokens you'd receive (`s`) and how many pool tokens get burned alongside yours (`p`).

### Cool

1. On the spoke's Write Contract
2. Find **`cool`** (the one with just `uint256 u`)
3. Enter `u` — the amount of liquid tokens to burn
4. Click **Write** and confirm

**What happened:**
- Your liquid tokens were burned
- A matching amount was burned from the pool (maintaining the 2x symmetry from heat)
- Backing tokens were returned to your wallet proportional to pool reserves

To unwrap Hub back to "Uniteum 1", call `cool` on the [Hub contract](https://etherscan.io/address/{{site.data.liquids.hub.address}}#writeContract){:target="_blank"} — this is a simple 1:1 unwrap.

<!-- TODO: example tx hash for a cool transaction -->

---

## Quick reference

### Hub

| Action | Function | Approval needed |
|:-------|:---------|:----------------|
| Wrap "1" → Hub | [`heat(s)`](https://etherscan.io/address/{{site.data.liquids.hub.address}}#writeContract){:target="_blank"} | Approve "1" for Hub |
| Unwrap Hub → "1" | [`cool(u)`](https://etherscan.io/address/{{site.data.liquids.hub.address}}#writeContract){:target="_blank"} | No |
| Create spoke | [`make(backing)`](https://etherscan.io/address/{{site.data.liquids.hub.address}}#writeContract){:target="_blank"} | No |
| Check spoke | [`made(backing)`](https://etherscan.io/address/{{site.data.liquids.hub.address}}#readContract){:target="_blank"} | — |

### Spoke (any liquid token)

| Action | Function | Approval needed |
|:-------|:---------|:----------------|
| Deposit backing | `heat(s)` | Approve backing for spoke |
| Withdraw backing | `cool(u)` | No |
| Sell spoke → Hub | `sell(spokes)` | No |
| Buy spoke ← Hub | `buy(hubs)` | No |
| Cross-swap | `sellFor(that, spokes)` | No |
| Preview sell | `sells(spokes)` | — |
| Preview buy | `buys(hubs)` | — |
| Preview swap | `sellsFor(that, spokes)` | — |
| Pool state | `pool()` | — |
| Backing balance | `mass()` | — |

All amounts use the token's own decimals. Hub and "Uniteum 1" use 18 decimals.

## What to try next

- [Introduction]({{ site.baseurl }}/liquid/introduction) — detailed walkthrough with example scenarios
- [The 2x Mint]({{ site.baseurl }}/liquid/2x-mint) — why deposits create double the liquidity
- [Design]({{ site.baseurl }}/liquid/design) — mathematical specification of all formulas
- [Tokenomics]({{ site.baseurl }}/liquid/tokenomics) — equilibrium mechanics and price stability
