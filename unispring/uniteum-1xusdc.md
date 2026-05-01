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

[`{{ mimic.name }}`](https://etherscan.io/token/{{ mimic.address }}){:target="_blank"} is a personalized 1:1 mirror of USDC, minted via [Mimicry]({{ site.baseurl }}/unispring/mimicry/). It trades against the local chain's USDC inside a hard 1-basis-point corridor and is collateralized token-for-token by real USDC locked in a Uniswap V4 pool that no one can unwind.

It also demonstrates a second Mimicry feature: cross-chain portability via a [Locale]({{ site.baseurl }}/locale/) lookup. The clone's address is identical on every chain that has a `USDCLookup` deployed, even though the underlying USDC token has a different address on each.

---

## At a glance

| | |
|:---|:---|
| Name | `{{ mimic.name }}` |
| Symbol | `{{ clone.symbol }}` |
| Original | {{ clone.original }} |
| Original lookup | [`{{ clone.original_lookup }}`](https://etherscan.io/address/{{ clone.original_lookup_address }}#code){:target="_blank"} |
| Decimals | Matches USDC (6 on Ethereum) |
| Mimic ERC-20 | [`{{ mimic.address }}`](https://etherscan.io/token/{{ mimic.address }}){:target="_blank"} |
| Clone | [`{{ clone.address }}`](https://etherscan.io/address/{{ clone.address }}#code){:target="_blank"} |
| Pool | Uniswap V4, single tick at 0, fee tier 0.01%, tickSpacing 1 |
| Price corridor | `[1.0000, 1.0001)` × USDC |

---

## What "personalized" means here

[Mimicry]({{ site.baseurl }}/unispring/mimicry/) is a two-level factory. The prototype mints **clones** keyed by `(original, symbol)` — one per peg pair. Each clone in turn mints **mimics** — fresh ERC-20s sharing the clone's symbol and peg, distinguished only by `name`.

`{{ mimic.name }}` is one named mimic under the `(USDCLookup, "{{ clone.symbol }}")` clone. It carries the symbol `{{ clone.symbol }}`, it pegs against chain-local USDC, and its name — "{{ mimic.name }}" — is what makes it ours. Anyone else can call [`mimic(name)`](https://etherscan.io/address/{{ clone.address }}#writeContract#F{{ m.write["mimic(name)"].f }}){:target="_blank"} on the same clone with a different `name` and produce a parallel ERC-20: a different address, the same peg guarantee.

The personalization is real product surface — its own address, its own listings, its own integrations, its own market reputation. The peg mechanics underneath are shared.

---

## Why the clone uses a Locale lookup

USDC lives at a different address on every chain. If the clone keyed off the raw token address, deploying `(0xA0b8…USDC, "{{ clone.symbol }}")` on Ethereum and `(0xaf88…USDC, "{{ clone.symbol }}")` on Arbitrum would produce two different clone addresses — fragmenting integrations and making cross-chain UX hostile.

Passing an [`IAddressLookup`]({{ site.baseurl }}/locale/) — a Locale-deployed contract whose `value()` resolves to the chain-local USDC — solves this. Mimicry computes the clone's CREATE2 salt from the **lookup address**, not from whatever the lookup resolves to. The same lookup address on every chain yields the same clone address on every chain.

So `{{ mimic.name }}` will be the same `(clone, mimic)` pair of addresses on Ethereum, Arbitrum, Base, and any other chain we deploy `{{ clone.original_lookup }}` to — with each chain's mimic backed by its own chain's USDC.

---

## How the peg holds

The mimic's V4 pool is initialized at `tick = 0` with the entire mimic supply (about 1 billion at USDC's 6 decimals) seated single-sided in a single-tick range. Below tick 0 there is no liquidity at all; above the next tick there is no liquidity at all. V4's swap math cannot cross an empty tick range, so price is mathematically constrained to `[1.0000, 1.0001)` × USDC.

The pool is owned by a [Fountain]({{ site.baseurl }}/unispring/fountain/) clone with no decrease-liquidity path. The USDC that backs `{{ mimic.name }}` is locked there forever — Mimicry retains no authority over it, and Fountain itself exposes no withdraw-principal function. The deployer has the same redemption rights as everyone else: trade through the pool.

For the geometric argument in detail, see [Mimicry — peg mechanics]({{ site.baseurl }}/unispring/mimicry-mechanics/).

---

## How to trade it

Route any V4-aware aggregator or frontend through the USDC ↔ `{{ clone.symbol }}` pool:

- `USDC → {{ mimic.name }}` to acquire
- `{{ mimic.name }} → USDC` to redeem

There is no separate redeem function. The pool *is* the redemption path. Any router that reaches Uniswap V4 — Uniswap's own UI, 1inch, Matcha, CoW Swap, custom contracts — can route through it.

---

## Mint your own named mirror under the same clone

To deploy a new named mirror that pegs against chain-local USDC under the `{{ clone.symbol }}` symbol, call [`mimic(name)`](https://etherscan.io/address/{{ clone.address }}#writeContract#F{{ m.write["mimic(name)"].f }}){:target="_blank"} on the clone with your chosen name. The supply is fixed at mint, the V4 position seats automatically, and the token is tradeable in the same transaction.

Preview the address before deploying with [`mimicked(name)`](https://etherscan.io/address/{{ clone.address }}#readContract#F{{ m.read["mimicked(name)"].f }}){:target="_blank"} on the clone, or [`mimicked(original, symbol, name)`](https://etherscan.io/address/{{ m.address }}#readContract#F{{ m.read["mimicked(original, symbol, name)"].f }}){:target="_blank"} on the prototype if the clone hasn't been deployed yet on the target chain.

The Fountain owner — the address that originally called `Fountain.make` for the clone's position-holder — collects the 0.01% swap-fee stream from every mimic minted under this clone, including any new ones. Collateral, supply, and the price corridor are not at the deployer's discretion.

---

## Further reading

- [Mimicry]({{ site.baseurl }}/unispring/mimicry/) — the factory, its layout, and the full set of operations
- [Mimicry — peg mechanics]({{ site.baseurl }}/unispring/mimicry-mechanics/) — why the 1-bp corridor is hard
- [Fountain]({{ site.baseurl }}/unispring/fountain/) — the V4 position primitive backing every mimic
- [Locale]({{ site.baseurl }}/locale/) — the deterministic lookup contract used as the clone's `original`
- [Uniteum 1xETH]({{ site.baseurl }}/unispring/uniteum-1xeth/) — the same pattern applied to native ETH
