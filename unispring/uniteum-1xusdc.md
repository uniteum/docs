---
layout: default
title: Uniteum 1xUSDC
parent: Unispring
permalink: /unispring/uniteum-1xusdc/
nav_order: 6
---

{% assign u = site.data.unispring %}
{% assign m = u.mimicry %}
{% assign clone = m.clones["1xUSDC"] %}
{% assign mimic = clone.mimics[0] %}

# Uniteum 1xUSDC

[`{{ mimic.name }}`](https://etherscan.io/token/{{ mimic.address }}){:target="_blank"} is an ERC-20 that always trades 1:1 against USDC. One `{{ mimic.name }}` is worth one USDC, give or take a hundredth of a percent — and every token in circulation is backed, right now, by an equal amount of real USDC locked in a Uniswap V4 pool.

Mint it, swap it, hold it, send it. It behaves like USDC for any use that wants its own ERC-20 surface — but with its own address, its own name, and the same `(clone, mimic)` addresses on every chain it's deployed to.

This page also shows how to mint your own 1xUSDC-symbol mirror under your own name. The mechanism is permissionless: pick a name, send the mint transaction, and you have a backed ERC-20 with the same peg guarantee.

---

## At a glance

| | |
|:---|:---|
| Name | `{{ mimic.name }}` |
| Symbol | `{{ clone.symbol }}` |
| Backing | Chain-local USDC (resolved via [`{{ clone.original_lookup }}`](https://etherscan.io/address/{{ clone.original_lookup_address }}#code){:target="_blank"}), locked in a Uniswap V4 pool |
| Decimals | 6 on Ethereum (matches USDC) |
| Trading range | `[1.0000, 1.0001)` × USDC |
| Mimic ERC-20 | [`{{ mimic.address }}`](https://etherscan.io/token/{{ mimic.address }}){:target="_blank"} |

---

## Swap USDC for `{{ mimic.name }}`

Use any V4-aware DEX or aggregator — Uniswap's own UI, 1inch, Matcha, CoW Swap, custom routers — and pick `USDC ↔ {{ mimic.name }}`. There is no separate "redeem" function: the pool is the redemption path.

- `USDC → {{ mimic.name }}` to acquire
- `{{ mimic.name }} → USDC` to redeem

The swap settles inside the `[1.0000, 1.0001)` × USDC band. You'll never pay more than 1.0001 USDC per token to buy, and you'll never receive less than 1.0000 USDC per token to sell.

---

## Mint your own personalized 1xUSDC

You don't have to use ours. Anyone can mint their own `1xUSDC`-symbol mirror with their own chosen name and their own ERC-20 address. The peg is identical — every named mirror trades inside the same `[1.0000, 1.0001)` × USDC band, backed by USDC locked in its own V4 pool.

**To mint a new named mirror against USDC:**

1. Open the `1xUSDC` clone on Etherscan: [`{{ clone.address }}`](https://etherscan.io/address/{{ clone.address }}#writeContract){:target="_blank"}.
2. Connect a wallet with enough ETH to cover gas. (No collateral capital is needed — the mint funds itself.)
3. Call [`mimic(name)`](https://etherscan.io/address/{{ clone.address }}#writeContract#F{{ m.write["mimic(name)"].f }}){:target="_blank"} with the name you want — `"Acme 1xUSDC"`, `"Treasury 1xUSDC"`, whatever.

That single call deploys your ERC-20, mints its full supply, and seats it in a fresh V4 pool against the chain's USDC. Your token is tradeable in the same transaction.

To preview the deterministic address before deploying, call [`mimicked(name)`](https://etherscan.io/address/{{ clone.address }}#readContract#F{{ m.read["mimicked(name)"].f }}){:target="_blank"} with the same name on the read tab.

What you keep, as the deployer, is the 0.01% swap-fee stream from your mirror's pool. You do **not** keep authority over the supply, the price corridor, or the backing — they're locked the moment the mint transaction confirms.

---

## What "personalized" gives you

A named mirror is a real product, not a relabel. It has its own ERC-20 address, its own integrations, its own listing on aggregators, its own market reputation. Two parties can each mint a `1xUSDC`-symbol mirror with different names and end up with two genuinely separate tokens — sharing only the symbol and the underlying peg corridor.

The value is in *whose* mirror it is. `{{ mimic.name }}` is the named mirror Uniteum publishes. `Acme 1xUSDC` would be Acme's. Their backing guarantees are identical; the brand on the token is not.

---

## Why the peg holds

The mimic's V4 pool is initialized at `tick = 0` with the entire supply (about 1 billion at USDC's 6 decimals) seated single-sided in a single-tick range. Below tick 0 there is no liquidity at all; above the next tick there is no liquidity at all. V4's swap math cannot cross an empty tick range, so price is mathematically constrained to `[1.0000, 1.0001)` × USDC.

The pool is owned by a [Fountain]({{ site.baseurl }}/unispring/fountain/) clone with no decrease-liquidity path. The USDC that backs `{{ mimic.name }}` is locked there forever — Mimicry retains no authority over it, and Fountain itself exposes no withdraw-principal function. The deployer has the same redemption rights as everyone else: trade through the pool.

For the geometric argument in detail, see [Mimicry — peg mechanics]({{ site.baseurl }}/unispring/mimicry-mechanics/).

---

## Behind the scenes: cross-chain portability

USDC lives at a different address on every chain. If the `1xUSDC` clone keyed off the raw USDC address, deploying it on Ethereum versus Arbitrum would produce two different clone addresses — fragmenting integrations and making cross-chain UX hostile.

Instead, the clone keys off [`{{ clone.original_lookup }}`]({{ site.baseurl }}/locale/) — a [Locale]({{ site.baseurl }}/locale/) lookup contract whose `value()` resolves to the chain-local USDC. Mimicry computes the clone's CREATE2 salt from the **lookup address**, not from whatever the lookup resolves to. The same lookup address on every chain yields the same clone address on every chain.

So `{{ mimic.name }}` will be the same `(clone, mimic)` pair of addresses on Ethereum, Arbitrum, Base, and any other chain we deploy `{{ clone.original_lookup }}` to — with each chain's mimic backed by its own chain's USDC.

---

## Further reading

- [Mimicry]({{ site.baseurl }}/unispring/mimicry/) — the factory, its layout, and the full set of operations
- [Mimicry — peg mechanics]({{ site.baseurl }}/unispring/mimicry-mechanics/) — why the 1-bp corridor is hard
- [Fountain]({{ site.baseurl }}/unispring/fountain/) — the V4 position primitive backing every mimic
- [Locale]({{ site.baseurl }}/locale/) — the deterministic lookup contract used as the clone's `original`
- [Uniteum 1xETH]({{ site.baseurl }}/unispring/uniteum-1xeth/) — the same pattern applied to native ETH
