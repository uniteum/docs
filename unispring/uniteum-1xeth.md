---
layout: default
title: Uniteum 1xETH
parent: Unispring
permalink: /unispring/uniteum-1xeth/
nav_order: 5
---

{% assign u = site.data.unispring %}
{% assign m = u.mimicry %}
{% assign clone = m.clones["1xETH"] %}
{% assign mimic = clone.mimics[0] %}

# Uniteum 1xETH

[`{{ mimic.name }}`](https://etherscan.io/token/{{ mimic.address }}){:target="_blank"} is an ERC-20 that always trades 1:1 against ETH. One `{{ mimic.name }}` is worth one ETH, give or take a hundredth of a percent — and every token in circulation is backed, right now, by an equal amount of real ETH locked in a Uniswap V4 pool.

Mint it, swap it, hold it, send it. It behaves like ETH for any use that wants ERC-20 plumbing — but with its own address and its own name.

This page also shows how to mint your own 1xETH-symbol mirror under your own name. The mechanism is permissionless: pick a name, send the mint transaction, and you have a backed ERC-20 with the same peg guarantee.

---

## At a glance

| | |
|:---|:---|
| Name | `{{ mimic.name }}` |
| Symbol | `{{ clone.symbol }}` |
| Backing | Native ETH, locked in a Uniswap V4 pool |
| Decimals | 18 (matches ETH) |
| Trading range | `[1.0000, 1.0001)` × ETH |
| Mimic ERC-20 | [`{{ mimic.address }}`](https://etherscan.io/token/{{ mimic.address }}){:target="_blank"} |

---

## Swap ETH for `{{ mimic.name }}`

Use any V4-aware DEX or aggregator — Uniswap's own UI, 1inch, Matcha, CoW Swap, custom routers — and pick `ETH ↔ {{ mimic.name }}`. There is no separate "redeem" function: the pool is the redemption path.

- `ETH → {{ mimic.name }}` to acquire
- `{{ mimic.name }} → ETH` to redeem

The swap settles inside the `[1.0000, 1.0001)` × ETH band. You'll never pay more than 1.0001 ETH per token to buy, and you'll never receive less than 1.0000 ETH per token to sell.

---

## Mint your own personalized 1xETH

You don't have to use ours. Anyone can mint their own `1xETH`-symbol mirror with their own chosen name and their own ERC-20 address. The peg is identical — every named mirror trades inside the same `[1.0000, 1.0001)` × ETH band, backed by ETH locked in its own V4 pool.

**To mint a new named mirror against native ETH:**

1. Open the [Mimicry prototype]({{ site.baseurl }}/unispring/mimicry/) on Etherscan: [`{{ m.address }}`](https://etherscan.io/address/{{ m.address }}#writeContract){:target="_blank"}.
2. Connect a wallet with enough ETH to cover gas. (No collateral capital is needed — the mint funds itself.)
3. Call [`mimic(name)`](https://etherscan.io/address/{{ m.address }}#writeContract#F{{ m.write["mimic(name)"].f }}){:target="_blank"} with the name you want — `"Acme 1xETH"`, `"Bob 1xETH"`, whatever.

That single call deploys your ERC-20, mints its full supply, and seats it in a fresh V4 pool against native ETH. Your token is tradeable in the same transaction.

To preview the deterministic address before deploying, call [`mimicked(name)`](https://etherscan.io/address/{{ m.address }}#readContract#F{{ m.read["mimicked(name)"].f }}){:target="_blank"} with the same name on the read tab.

What you keep, as the deployer, is the 0.01% swap-fee stream from your mirror's pool. You do **not** keep authority over the supply, the price corridor, or the backing — they're locked the moment the mint transaction confirms.

---

## What "personalized" gives you

A named mirror is a real product, not a relabel. It has its own ERC-20 address, its own integrations, its own listing on aggregators, its own market reputation. Two parties can each mint a `1xETH`-symbol mirror with different names and end up with two genuinely separate tokens — sharing only the symbol and the underlying peg corridor.

The value is in *whose* mirror it is. `{{ mimic.name }}` is the named mirror Uniteum publishes. `Acme 1xETH` would be Acme's. Their backing guarantees are identical; the brand on the token is not.

---

## Why the peg holds

The mimic's V4 pool is initialized at `tick = 0` with the entire supply (`10²⁷` raw, ~1 billion at 18 decimals) seated single-sided in a single-tick range. Below tick 0 there is no liquidity at all; above the next tick there is no liquidity at all. V4's swap math cannot cross an empty tick range, so price is mathematically constrained to `[1.0000, 1.0001)` × ETH.

The pool is owned by a [Fountain]({{ site.baseurl }}/unispring/fountain/) clone with no decrease-liquidity path. The ETH that backs `{{ mimic.name }}` is locked there forever — Mimicry retains no authority over it, and Fountain itself exposes no withdraw-principal function. The deployer has the same redemption rights as everyone else: trade through the pool.

For the geometric argument in detail, see [Mimicry — peg mechanics]({{ site.baseurl }}/unispring/mimicry-mechanics/).

---

## Behind the scenes: the native-ETH clone

[Mimicry]({{ site.baseurl }}/unispring/mimicry/) is organized as a prototype that mints **clones** keyed by `(original, symbol)` — one clone per peg pair. For native ETH and the `{{ clone.symbol }}` symbol, the prototype itself **is** the canonical clone — no separate clone is ever deployed for that pair. That's why the mint instructions above point at the prototype directly.

For any other peg pair (`(USDC, "1xUSDC")`, `(WBTC, "1xWBTC")`, etc.), `mimic(name)` is called on the corresponding clone instead. See [Uniteum 1xUSDC]({{ site.baseurl }}/unispring/uniteum-1xusdc/) for an example with a non-native original.

---

## Further reading

- [Mimicry]({{ site.baseurl }}/unispring/mimicry/) — the factory, its layout, and the full set of operations
- [Mimicry — peg mechanics]({{ site.baseurl }}/unispring/mimicry-mechanics/) — why the 1-bp corridor is hard
- [Fountain]({{ site.baseurl }}/unispring/fountain/) — the V4 position primitive backing every mimic
- [Uniteum 1xUSDC]({{ site.baseurl }}/unispring/uniteum-1xusdc/) — the same pattern applied to a stablecoin original
