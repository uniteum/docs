---
layout: default
title: Uniteum 1xUSDC
parent: Unispring
permalink: /unispring/uniteum-1xusdc/
nav_order: 6
---

{% assign u = site.data.unispring %}
{% assign n = u.notable %}
{% assign clone = n.clones["1xUSDC"] %}
{% assign issue = clone.issues[0] %}

# Uniteum 1xUSDC

[`{{ issue.name }}`]({% if issue.address %}https://etherscan.io/token/{{ issue.address }}{% else %}#{% endif %}){:target="_blank"} is an ERC-20 that always trades 1:1 against USDC. One `{{ issue.name }}` is worth one USDC, give or take a hundredth of a percent — and every token in circulation is backed, right now, by an equal amount of real USDC locked in a Uniswap V4 pool.

Mint it, swap it, hold it, send it. It behaves like USDC for any use that wants its own ERC-20 surface — but with its own address, its own name, and the same `(clone, issue)` addresses on every chain it's deployed to.

This page also shows how to mint your own 1xUSDC-symbol mirror under your own name. The mechanism is permissionless: pick a name, send the mint transaction, and you have a backed ERC-20 with the same peg guarantee.

---

## At a glance

| | |
|:---|:---|
| Name | `{{ issue.name }}` |
| Symbol | `{{ clone.symbol }}` |
| Backing | Chain-local USDC (resolved via [`{{ clone.original_lookup }}`](https://etherscan.io/address/{{ clone.original_lookup_address }}#code){:target="_blank"}), locked in a Uniswap V4 pool |
| Decimals | 6 on Ethereum (matches USDC) |
| Trading range | `[1.0000, 1.0001)` × USDC |
| Issue ERC-20 | {% if issue.address %}[`{{ issue.address }}`](https://etherscan.io/token/{{ issue.address }}){:target="_blank"}{% else %}_(pending deploy)_{% endif %} |

---

## Swap USDC for `{{ issue.name }}`

Use any V4-aware DEX or aggregator — Uniswap's own UI, 1inch, Matcha, CoW Swap, custom routers — and pick `USDC ↔ {{ issue.name }}`. There is no separate "redeem" function: the pool is the redemption path.

- `USDC → {{ issue.name }}` to acquire
- `{{ issue.name }} → USDC` to redeem

The swap settles inside the `[1.0000, 1.0001)` × USDC band. You'll never pay more than 1.0001 USDC per token to buy, and you'll never receive less than 1.0000 USDC per token to sell.

---

## Mint your own personalized 1xUSDC

You don't have to use ours. Anyone can mint their own `1xUSDC`-symbol mirror with their own chosen name and their own ERC-20 address. The peg is identical — every named mirror trades inside the same `[1.0000, 1.0001)` × USDC band, backed by USDC locked in its own V4 pool.

**To mint a new named mirror against USDC:**

1. Open the `1xUSDC` clone on Etherscan: {% if clone.address %}[`{{ clone.address }}`](https://etherscan.io/address/{{ clone.address }}#writeContract){:target="_blank"}{% else %}_(pending deploy)_{% endif %}.
2. Connect a wallet with enough ETH to cover gas. (No collateral capital is needed — the mint funds itself.)
3. Call [`issue(name)`]({% if clone.address %}https://etherscan.io/address/{{ clone.address }}#writeContract#F{{ n.write["issue(name)"].f }}{% else %}#{% endif %}){:target="_blank"} with the name you want — `"Acme 1xUSDC"`, `"Treasury 1xUSDC"`, whatever.

That single call deploys your ERC-20, mints its full supply, and seats it in a fresh V4 pool against the chain's USDC. Your token is tradeable in the same transaction.

To preview the deterministic address before deploying, call [`issued(name)`]({% if clone.address %}https://etherscan.io/address/{{ clone.address }}#readContract#F{{ n.read["issued(name)"].f }}{% else %}#{% endif %}){:target="_blank"} with the same name on the read tab.

**What you keep as the deployer:** the wallet that submits the `issue(name)` transaction is recorded on-chain as the creator of your new ERC-20. That's the address Etherscan, CoinGecko, CoinMarketCap, and similar registries verify against when you submit token info — icon, description, project website, social links. The token's public identity is yours to claim.

**What you don't keep:** the 0.01% swap fees flow to the Fountain owner of the clone's [placer]({{ site.baseurl }}/unispring/fountain/), set once when the placer was deployed; later issues don't change that. Supply, the price corridor, and the backing are all locked the moment the mint transaction confirms.

---

## What "personalized" gives you

A named mirror is a real product, not a relabel. It has its own ERC-20 address, its own integrations, its own listing on aggregators, its own market reputation. Two parties can each mint a `1xUSDC`-symbol mirror with different names and end up with two genuinely separate tokens — sharing only the symbol and the underlying peg corridor.

Crucially, the wallet that mints it is the on-chain deployer of that ERC-20 — which is the lever block explorers and token registries use to verify ownership when you submit token info. So `{{ issue.name }}`'s icon, description, and project links on Etherscan are ours to set; `Acme 1xUSDC`'s would be Acme's. Their backing guarantees are identical; the brand on the token is not.

---

## Why the peg holds

The issue's V4 pool is initialized at `tick = 0` with the entire supply (about 1 billion at USDC's 6 decimals) seated single-sided in a single-tick range. Below tick 0 there is no liquidity at all; above the next tick there is no liquidity at all. V4's swap math cannot cross an empty tick range, so price is mathematically constrained to `[1.0000, 1.0001)` × USDC.

The pool is owned by a [Fountain]({{ site.baseurl }}/unispring/fountain/) clone with no decrease-liquidity path. The USDC that backs `{{ issue.name }}` is locked there forever — Notable retains no authority over it, and Fountain itself exposes no withdraw-principal function. The deployer has the same redemption rights as everyone else: trade through the pool.

For the geometric argument in detail, see [Notable — peg mechanics]({{ site.baseurl }}/unispring/notable-mechanics/).

---

## Behind the scenes: cross-chain portability

USDC lives at a different address on every chain. If the `1xUSDC` clone keyed off the raw USDC address, deploying it on Ethereum versus Arbitrum would produce two different clone addresses — fragmenting integrations and making cross-chain UX hostile.

Instead, the clone keys off [`{{ clone.original_lookup }}`]({{ site.baseurl }}/locale/) — a [Locale]({{ site.baseurl }}/locale/) lookup contract whose `value()` resolves to the chain-local USDC. Notable computes the clone's CREATE2 salt from the **lookup address**, not from whatever the lookup resolves to. The same lookup address on every chain yields the same clone address on every chain.

So `{{ issue.name }}` will be the same `(clone, issue)` pair of addresses on Ethereum, Arbitrum, Base, and any other chain we deploy `{{ clone.original_lookup }}` to — with each chain's issue backed by its own chain's USDC.

---

## Further reading

- [Notable]({{ site.baseurl }}/unispring/notable/) — the factory, its layout, and the full set of operations
- [Notable — peg mechanics]({{ site.baseurl }}/unispring/notable-mechanics/) — why the 1-bp corridor is hard
- [Fountain]({{ site.baseurl }}/unispring/fountain/) — the V4 position primitive backing every issue
- [Locale]({{ site.baseurl }}/locale/) — the deterministic lookup contract used as the clone's `original`
- [Uniteum 1xETH]({{ site.baseurl }}/unispring/uniteum-1xeth/) — the same pattern applied to native ETH
