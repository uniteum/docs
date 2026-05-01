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

[`{{ mimic.name }}`](https://etherscan.io/token/{{ mimic.address }}){:target="_blank"} is a personalized 1:1 mirror of native ETH, minted via [Mimicry]({{ site.baseurl }}/unispring/mimicry/). It trades against ETH inside a hard 1-basis-point corridor and is collateralized token-for-token by ETH locked in a Uniswap V4 pool that no one can unwind.

This page documents what `{{ mimic.name }}` is, the contract pieces behind it, and how the same factory mints other named mirrors under the same `{{ clone.symbol }}` symbol.

---

## At a glance

| | |
|:---|:---|
| Name | `{{ mimic.name }}` |
| Symbol | `{{ clone.symbol }}` |
| Original | {{ clone.original }} |
| Decimals | 18 (matches native ETH) |
| Mimic ERC-20 | [`{{ mimic.address }}`](https://etherscan.io/token/{{ mimic.address }}){:target="_blank"} |
| Clone | [`{{ clone.address }}`](https://etherscan.io/address/{{ clone.address }}#code){:target="_blank"} (the [Mimicry prototype]({{ site.baseurl }}/unispring/mimicry/) itself) |
| Pool | Uniswap V4, single tick at 0, fee tier 0.01%, tickSpacing 1 |
| Price corridor | `[1.0000, 1.0001)` × ETH |

---

## What "personalized" means here

[Mimicry]({{ site.baseurl }}/unispring/mimicry/) is a two-level factory. The prototype mints **clones** keyed by `(original, symbol)` — one per peg pair. Each clone in turn mints **mimics** — fresh ERC-20s sharing the clone's symbol and peg, distinguished only by `name`.

`{{ mimic.name }}` is one named mimic under the `(native ETH, "{{ clone.symbol }}")` clone. It carries the symbol `{{ clone.symbol }}`, it pegs against native ETH, and its name — "{{ mimic.name }}" — is what makes it ours. Anyone else can call [`mimic(name)`](https://etherscan.io/address/{{ m.address }}#writeContract#F{{ m.write["mimic(name)"].f }}){:target="_blank"} on the same clone with a different `name` and produce a parallel ERC-20: a different address, the same peg guarantee.

The personalization is real product surface — its own address, its own listings, its own integrations, its own market reputation. The peg mechanics underneath are shared.

---

## The native-ETH special case

For every other peg pair, [`make(original, symbol)`](https://etherscan.io/address/{{ m.address }}#writeContract#F{{ m.write["make(original, symbol)"].f }}){:target="_blank"} deploys a fresh clone. For `(native ETH, "{{ clone.symbol }}")`, the [Mimicry prototype]({{ site.baseurl }}/unispring/mimicry/) **is** the canonical clone — the same address serves both the factory-of-clones and the clone-for-{{ clone.symbol }}. Two consequences:

- [`make(address(0), "{{ clone.symbol }}")`](https://etherscan.io/address/{{ m.address }}#writeContract#F{{ m.write["make(original, symbol)"].f }}){:target="_blank"} returns the prototype's own address — no separate clone is deployed
- [`mimic(name)`](https://etherscan.io/address/{{ m.address }}#writeContract#F{{ m.write["mimic(name)"].f }}){:target="_blank"} called directly on the prototype mints a `{{ clone.symbol }}`-symbol mirror against native ETH

`{{ mimic.name }}` was minted by calling `mimic("{{ mimic.name }}")` on the prototype directly.

---

## How the peg holds

The mimic's V4 pool is initialized at `tick = 0` with the entire mimic supply (`10²⁷` raw, ~1 billion at 18 decimals) seated single-sided in a single-tick range. Below tick 0 there is no liquidity at all; above the next tick there is no liquidity at all. V4's swap math cannot cross an empty tick range, so price is mathematically constrained to `[1.0000, 1.0001)` × ETH.

The pool is owned by a [Fountain]({{ site.baseurl }}/unispring/fountain/) clone with no decrease-liquidity path. The ETH that backs `{{ mimic.name }}` is locked there forever — Mimicry retains no authority over it, and Fountain itself exposes no withdraw-principal function. The deployer has the same redemption rights as everyone else: trade through the pool.

For the geometric argument in detail, see [Mimicry — peg mechanics]({{ site.baseurl }}/unispring/mimicry-mechanics/).

---

## How to trade it

Route any V4-aware aggregator or frontend through the ETH ↔ `{{ clone.symbol }}` pool:

- `ETH → {{ mimic.name }}` to acquire
- `{{ mimic.name }} → ETH` to redeem

There is no separate redeem function. The pool *is* the redemption path. Any router that reaches Uniswap V4 — Uniswap's own UI, 1inch, Matcha, CoW Swap, custom contracts — can route through it.

---

## Mint your own named mirror under the same clone

To deploy a new named mirror that pegs against native ETH under the `{{ clone.symbol }}` symbol, call [`mimic(name)`](https://etherscan.io/address/{{ m.address }}#writeContract#F{{ m.write["mimic(name)"].f }}){:target="_blank"} on the Mimicry prototype with your chosen name. The supply is fixed at mint, the V4 position seats automatically, and the token is tradeable in the same transaction.

Preview the address before deploying with [`mimicked(name)`](https://etherscan.io/address/{{ m.address }}#readContract#F{{ m.read["mimicked(name)"].f }}){:target="_blank"} on the prototype.

The Fountain owner — the address that originally called `Fountain.make` for the prototype's position-holder — collects the 0.01% swap-fee stream from every mimic minted under this clone, including any new ones. Collateral, supply, and the price corridor are not at the deployer's discretion.

---

## Further reading

- [Mimicry]({{ site.baseurl }}/unispring/mimicry/) — the factory, its layout, and the full set of operations
- [Mimicry — peg mechanics]({{ site.baseurl }}/unispring/mimicry-mechanics/) — why the 1-bp corridor is hard
- [Fountain]({{ site.baseurl }}/unispring/fountain/) — the V4 position primitive backing every mimic
- [Uniteum 1xUSDC]({{ site.baseurl }}/unispring/uniteum-1xusdc/) — the same pattern applied to a stablecoin original
