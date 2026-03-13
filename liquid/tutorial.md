---
layout: default
title: Liquid Tutorial
parent: Liquid
permalink: /liquid/tutorial/
nav_order: 2
---

{% assign spoke = site.data.liquids.H %}
{% assign backing = site.data.solids.H %}
{% assign hub_fn = site.data.liquid-functions.hub %}
{% assign spoke_fn = site.data.liquid-functions.spoke %}

# Tutorial: Using Liquid on Etherscan

> Wrap a token with built-in liquidity, trade it, and swap it — all from a block explorer.

Everything here uses [Etherscan](https://etherscan.io){:target="_blank"} directly. No custom app, no frontend, no SDK.

The [Hub](https://etherscan.io/token/{{site.data.liquids.hub.address}}){:target="_blank"} is the central contract — it wraps [Uniteum 1](https://etherscan.io/token/{{site.data.solids["1"].address}}){:target="_blank"} and acts as the factory for all spoke tokens.

We'll use [{{spoke.name}} ({{spoke.symbol}})](https://etherscan.io/token/{{spoke.address}}#readContract#F16){:target="_blank"} as our example spoke, backed by [{{backing.name}} (H)](https://etherscan.io/token/{{backing.address}}){:target="_blank"}.

---

## 1. Get Hub tokens

**Goal:** Wrap "Uniteum 1" (a Solid) into Hub tokens. You need Hub tokens to interact with spoke pools.

Hub heat is a simple 1:1 wrap — no pool mechanics, no [2x mint]({{ site.baseurl }}/liquid/2x-mint).

### Approve

The Hub needs permission to transfer your "Uniteum 1" tokens.

1. Go to [Uniteum 1 → approve](https://etherscan.io/token/{{site.data.solids["1"].address}}#writeContract#F2){:target="_blank"}
2. Connect your wallet
3. Enter:
   - `spender`: `{{site.data.liquids.hub.address}}` (the Hub)
   - `amount`: the amount to approve (in wei, 18 decimals)
4. Click **Write** and confirm

### Heat

1. Go to [Hub → heat(m)](https://etherscan.io/token/{{site.data.liquids.hub.address}}#writeContract#F{{ hub_fn.write["heat(m)"].f }}){:target="_blank"}
2. Enter `m` — the amount of "Uniteum 1" to wrap (in wei, 18 decimals)
3. Click **Write** and confirm

**What happened:**
- Your "Uniteum 1" tokens were deposited into the Hub
- You received the same amount of Hub tokens (1:1)

**Verify:** Call [`balanceOf`](https://etherscan.io/token/{{site.data.liquids.hub.address}}#readContract#F3){:target="_blank"} on the Hub with your wallet address.

<!-- TODO: example tx hash for a Hub heat transaction -->

---

## 2. Create a spoke

**Goal:** Create a new liquid token for any ERC-20.

### Check if it already exists

1. Go to [Hub → made](https://etherscan.io/token/{{site.data.liquids.hub.address}}#readContract#F{{ hub_fn.read["made(backing)"].f }}){:target="_blank"}
2. Enter `backing`: the address of the ERC-20 you want to wrap
3. Click **Query**

If `cloned` = `true`, the spoke already exists at the `home` address.
If `cloned` = `false`, you can create it — and `home` shows where it will be deployed.

### Create it

1. Go to [Hub → make](https://etherscan.io/token/{{site.data.liquids.hub.address}}#writeContract#F{{ hub_fn.write["make(backing)"].f }}){:target="_blank"}
2. Enter `backing`: the ERC-20 token address
3. Click **Write** and confirm

**What happened:**
- A new spoke was deployed at a deterministic address (the `home` from `made`)
- The spoke wraps your chosen ERC-20 with a built-in AMM pool connected to Hub
- The spoke starts empty — someone needs to heat it to create liquidity

**Find the address:** Call [`made`](https://etherscan.io/token/{{site.data.liquids.hub.address}}#readContract#F{{ hub_fn.read["made(backing)"].f }}){:target="_blank"} again with the same backing address. The `home` field is your spoke's contract.

<!-- TODO: example tx hash for a make transaction -->

---

## 3. Add liquidity (heat a spoke)

**Goal:** Deposit backing tokens into a spoke to get liquid tokens and create pool liquidity.

This is where the **2x mint** happens: you deposit N backing tokens, the protocol mints 2N liquid tokens total — split between you and the pool based on the current ratio. On first deposit (or at equilibrium), the split is 50/50. Instant tradeable liquidity.

### Approve

1. Go to [{{backing.name}} → approve](https://etherscan.io/token/{{backing.address}}#writeContract#F1){:target="_blank"}
2. Enter:
   - `spender`: `{{spoke.address}}` (the {{spoke.symbol}} spoke)
   - `amount`: how much to approve (in wei, 18 decimals)
3. Click **Write** and confirm

### Heat

1. Go to [{{spoke.symbol}} → heat(m)](https://etherscan.io/token/{{spoke.address}}#writeContract#F{{ spoke_fn.write["heat(m)"].f }}){:target="_blank"}
2. Enter `m` — the amount of {{backing.name}} tokens to deposit
3. Click **Write** and confirm

**What happened:**
- Your {{backing.name}} tokens were deposited into the spoke
- You received {{spoke.symbol}} tokens (your share)
- The pool also received {{spoke.symbol}} tokens (instant liquidity)
- Total minted: 2 × your deposit, split between you and the pool

**Verify:** Call [`pool`](https://etherscan.io/token/{{spoke.address}}#readContract#F{{ spoke_fn.read["pool()"].f }}){:target="_blank"} on {{spoke.symbol}} — it returns `(P, E)` where P is spoke tokens in the pool and E is Hub tokens in the pool.

<!-- TODO: example tx hash for a spoke heat transaction -->

---

## 4. Sell spoke tokens for Hub

**Goal:** Trade your {{spoke.symbol}} tokens for Hub tokens.

### Preview

1. Go to [{{spoke.symbol}} → sells](https://etherscan.io/token/{{spoke.address}}#readContract#F{{ spoke_fn.read["sells(s)"].f }}){:target="_blank"}
2. Enter the amount of {{spoke.symbol}} tokens to sell
3. Click **Query**

The result is how many Hub tokens you'd receive.

### Sell

1. Go to [{{spoke.symbol}} → sell](https://etherscan.io/token/{{spoke.address}}#writeContract#F{{ spoke_fn.write["sell(s)"].f }}){:target="_blank"}
2. Enter `s` — the amount of spokes to sell
3. Click **Write** and confirm

**What happened:**
- Your {{spoke.symbol}} tokens moved into the pool
- Hub tokens moved from the pool's lake to your wallet
- The pool's constant-product invariant (P × E = k) was maintained

**Verify:** Call [`balanceOf`](https://etherscan.io/token/{{site.data.liquids.hub.address}}#readContract#F3){:target="_blank"} on the Hub with your wallet address.

<!-- TODO: example tx hash for a sell transaction -->

---

## 5. Buy spoke tokens with Hub

**Goal:** Trade Hub tokens for {{spoke.symbol}} tokens from the pool.

### Preview

1. Go to [{{spoke.symbol}} → buys](https://etherscan.io/token/{{spoke.address}}#readContract#F{{ spoke_fn.read["buys(e)"].f }}){:target="_blank"}
2. Enter the amount of Hub tokens to spend
3. Click **Query**

The result is how many {{spoke.symbol}} tokens you'd receive.

### Buy

1. Go to [{{spoke.symbol}} → buy](https://etherscan.io/token/{{spoke.address}}#writeContract#F{{ spoke_fn.write["buy(e)"].f }}){:target="_blank"}
2. Enter `e` — the amount of Hub (lake) to spend
3. Click **Write** and confirm

**What happened:**
- Hub tokens moved from your wallet into the pool's lake
- {{spoke.symbol}} tokens moved from the pool to your wallet

**Verify:** Call [`balanceOf`](https://etherscan.io/token/{{spoke.address}}#readContract#F3){:target="_blank"} on {{spoke.symbol}} with your wallet address.

<!-- TODO: example tx hash for a buy transaction -->

---

## 6. Cross-swap between two spokes

**Goal:** Trade one spoke token for another in a single transaction. This sells spoke A for Hub internally, then immediately buys spoke B with that Hub.

### Preview

1. On spoke A, go to [`sellsFor`](https://etherscan.io/token/{{spoke.address}}#readContract#F{{ spoke_fn.read["sellsFor(that, s)"].f }}){:target="_blank"}
2. Enter:
   - `that`: spoke B's contract address
   - `spokes`: amount of spoke A to trade
3. Click **Query**

The result shows Hub used and spoke B tokens you'd receive.

### Swap

1. On spoke A, go to [`sellFor`](https://etherscan.io/token/{{spoke.address}}#writeContract#F{{ spoke_fn.write["sellFor(that, s)"].f }}){:target="_blank"}
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

**Goal:** Burn {{spoke.symbol}} tokens and withdraw {{backing.name}}.

### Preview

1. Go to [{{spoke.symbol}} → cools](https://etherscan.io/token/{{spoke.address}}#readContract#F{{ spoke_fn.read["cools(u)"].f }}){:target="_blank"} (the one with just `uint256 u`)
2. Enter the amount of {{spoke.symbol}} tokens to burn
3. Click **Query**

The result shows how many {{backing.name}} tokens you'd receive (`s`) and how many pool tokens get burned alongside yours (`p`).

### Cool

1. Go to [{{spoke.symbol}} → cool](https://etherscan.io/token/{{spoke.address}}#writeContract#F{{ spoke_fn.write["cool(u)"].f }}){:target="_blank"} (the one with just `uint256 u`)
2. Enter `u` — the amount of {{spoke.symbol}} tokens to burn
3. Click **Write** and confirm

**What happened:**
- Your {{spoke.symbol}} tokens were burned
- A matching amount was burned from the pool (maintaining the 2x symmetry from heat)
- {{backing.name}} tokens were returned to your wallet proportional to pool reserves

To unwrap Hub back to "Uniteum 1", call [`cool`](https://etherscan.io/token/{{site.data.liquids.hub.address}}#writeContract#F{{ hub_fn.write["cool(u)"].f }}){:target="_blank"} on the Hub — this is a simple 1:1 unwrap.

<!-- TODO: example tx hash for a cool transaction -->

---

## Quick reference

### Hub ([`{{site.data.liquids.hub.address}}`](https://etherscan.io/token/{{site.data.liquids.hub.address}}){:target="_blank"})

#### Write

| Action | Purpose |
|:-------|:--------|
{% for fn in site.data.liquid-functions.hub.write %}| [`{{ fn[0] }}`](https://etherscan.io/token/{{site.data.liquids.hub.address}}#writeContract#F{{ fn[1].f }}){:target="_blank"} | {{ fn[1].purpose }} |
{% endfor %}

#### Read

| Action | Purpose |
|:-------|:--------|
{% for fn in site.data.liquid-functions.hub.read %}| [`{{ fn[0] }}`](https://etherscan.io/token/{{site.data.liquids.hub.address}}#readContract#F{{ fn[1].f }}){:target="_blank"} | {{ fn[1].purpose }} |
{% endfor %}

### Spoke (links use [{{spoke.symbol}}](https://etherscan.io/token/{{spoke.address}}){:target="_blank"} — any spoke works the same way)

#### Write

| Action | Purpose |
|:-------|:--------|
{% for fn in site.data.liquid-functions.spoke.write %}| [`{{ fn[0] }}`](https://etherscan.io/token/{{spoke.address}}#writeContract#F{{ fn[1].f }}){:target="_blank"} | {{ fn[1].purpose }} |
{% endfor %}

#### Read

| Action | Purpose |
|:-------|:--------|
{% for fn in site.data.liquid-functions.spoke.read %}| [`{{ fn[0] }}`](https://etherscan.io/token/{{spoke.address}}#readContract#F{{ fn[1].f }}){:target="_blank"} | {{ fn[1].purpose }} |
{% endfor %}

All amounts use the token's own decimals. Hub and "Uniteum 1" use 18 decimals.

## What to try next

- [Introduction]({{ site.baseurl }}/liquid/introduction) — detailed walkthrough with example scenarios
- [The 2x Mint]({{ site.baseurl }}/liquid/2x-mint) — the liquidity mechanism, equilibrium, and arbitrage
- [Design]({{ site.baseurl }}/liquid/design) — mathematical specification of all formulas
