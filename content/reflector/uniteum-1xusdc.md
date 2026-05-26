---
title: Uniteum Dollar
weight: 5
---
# Uniteum Dollar

`Uniteum Dollar` is a signature token that always trades 1:1 against USDC. One `Uniteum Dollar` is worth one USDC, give or take a hundredth of a percent — and every token in circulation is backed, right now, by an equal amount of real USDC locked in a Uniswap V4 pool.

Mint it, swap it, hold it, send it. It behaves like USDC for any purpose that calls for a distinct ERC-20 — one with its own address and name — and carries the same `(clone, signature token)` pair of addresses on every chain it's deployed to.

This page also shows how to mint your own 1xUSDC signature token under your own name. The mechanism is permissionless: pick a name, send the mint transaction, and you have a backed ERC-20 with the same peg guarantee.

---

## At a glance

| | |
|:---|:---|
| Name | `Uniteum Dollar` |
| Symbol | `1xUSDC` |
| Backing | Chain-local USDC (resolved via [`{{< val "unispring.reflector.clones.1xUSDC.peg_lookup" >}}`](https://{{< escan >}}/address/{{< val "unispring.reflector.clones.1xUSDC.peg_lookup_address" >}}#code)), locked in a Uniswap V4 pool |
| Decimals | 6 on Ethereum (matches USDC) |
| Trading range | `[1.0000, 1.0001)` × USDC |
| Token address | _(pending deploy)_ |

---

## Swap USDC for `Uniteum Dollar`

Use any V4-aware DEX or aggregator — Uniswap's own UI, 1inch, Matcha, CoW Swap, custom routers — and pick `USDC ↔ Uniteum Dollar`. There is no separate "redeem" function: the pool is the redemption path.

- `USDC → Uniteum Dollar` to acquire
- `Uniteum Dollar → USDC` to redeem

The swap settles inside the `[1.0000, 1.0001)` × USDC band. You'll never pay more than 1.0001 USDC per token to buy, and you'll never receive less than 1.0000 USDC per token to sell.

---

## Mint your own personalized 1xUSDC

You don't have to use ours. Anyone can mint their own `1xUSDC` signature token with their own chosen name and their own ERC-20 address. The peg is identical — every named signature token in the family trades inside the same `[1.0000, 1.0001)` × USDC band, backed by USDC locked in its own V4 pool.

**To mint a new named signature token against USDC:**

1. Open the `1xUSDC` clone on Etherscan: [`{{< val "unispring.reflector.clones.1xUSDC.address" >}}`](https://{{< escan >}}/address/{{< val "unispring.reflector.clones.1xUSDC.address" >}}#writeContract).
2. Connect a wallet with enough ETH to cover gas. (No collateral capital is needed — the mint funds itself.)
3. Call [`issue(name)`](https://{{< escan >}}/address/{{< val "unispring.reflector.clones.1xUSDC.address" >}}#writeContract#F{{< val "unispring" "reflector" "write" "issue(name, variant)" "f" >}}) with the name you want — `"Acme 1xUSDC"`, `"Treasury 1xUSDC"`, whatever.

That single call deploys your ERC-20, mints its full supply, and seats it in a fresh V4 pool against the chain's USDC. Your token is tradeable in the same transaction.

To preview the deterministic address before deploying, call [`issued(name)`](https://{{< escan >}}/address/{{< val "unispring.reflector.clones.1xUSDC.address" >}}#readContract#F{{< val "unispring" "reflector" "read" "issued(name, variant)" "f" >}}) with the same name on the read tab.

**What you keep as the deployer:** the wallet that submits the `issue(name)` transaction is recorded on-chain as the creator of your new ERC-20. That's the address Etherscan, CoinGecko, CoinMarketCap, and similar registries verify against when you submit token info — icon, description, project website, social links. The token's public identity is yours to claim.

**What you don't keep:** the 0.01% swap fees flow to the owner of the clone's [placer](/unispring/fountain/) — the Fountain that holds every signature token's position — set once when that Fountain was deployed; later signature tokens don't change it. Supply, the price corridor, and the backing are all locked the moment the mint transaction confirms.

---

## What "personalized" gives you

A named signature token is a real product, not a relabel. It has its own ERC-20 address, its own integrations, its own listing on aggregators, its own market reputation. Two parties can each mint a `1xUSDC` signature token with different names and end up with two genuinely separate tokens — sharing only the symbol and the underlying peg corridor.

Crucially, the wallet that mints it is the on-chain deployer of that ERC-20 — which is the lever block explorers and token registries use to verify ownership when you submit token info. So `Uniteum Dollar`'s icon, description, and project links on Etherscan are ours to set; `Acme 1xUSDC`'s would be Acme's. Their backing guarantees are identical; the brand on the token is not.

---

## Why the peg holds

The signature token's V4 pool is initialized at `tick = 0` with the entire supply (about 1 billion at USDC's 6 decimals) seated single-sided in a single-tick range. There is no liquidity below tick 0, and none above the next tick. V4's swap math cannot cross an empty tick range, so price is mathematically constrained to `[1.0000, 1.0001)` × USDC.

The pool is owned by a [Fountain](/unispring/fountain/) clone with no decrease-liquidity path. The USDC that backs `Uniteum Dollar` is locked there forever — Reflector retains no authority over it, and Fountain itself exposes no withdraw-principal function. The deployer has the same redemption rights as everyone else: trade through the pool.

For the geometric argument in detail, see [Reflector — peg mechanics](/reflector/mechanics/).

---

## Behind the scenes: cross-chain portability

USDC lives at a different address on every chain. If the `1xUSDC` clone keyed off the raw USDC address, deploying it on Ethereum versus Arbitrum would produce two different clone addresses — fragmenting integrations and making cross-chain UX hostile.

Instead, the clone keys off `{{< val "unispring.reflector.clones.1xUSDC.peg_lookup" >}}` — a [Locale](/locale/) lookup contract whose `value()` resolves to the chain-local USDC. Reflector computes the clone's CREATE2 salt from the **lookup address**, not from the address it resolves to. Because that lookup sits at the same address on every chain, the clone does too.

So `Uniteum Dollar` will be the same `(clone, signature-token)` pair of addresses on Ethereum, Arbitrum, Base, and any other chain we deploy `{{< val "unispring.reflector.clones.1xUSDC.peg_lookup" >}}` to — with each chain's signature token backed by its own chain's USDC.

---

## Further reading

- [Factory reference](/reflector/reference/) — the factory, its layout, and the full set of operations
- [Reflector — peg mechanics](/reflector/mechanics/) — why the 1-bp corridor is hard
- [Fountain](/unispring/fountain/) — the V4 position primitive backing every signature token
- [Locale](/locale/) — the deterministic lookup contract used as the clone's `peg`
- [Uniteum Ether](/reflector/uniteum-1xeth/) — the same pattern applied to native ETH
