---
title: Uniteum 1xETH
weight: 4
---
# Uniteum 1xETH

[`Uniteum 1xETH`](https://{{< escan >}}/token/) is an ERC-20 that always trades 1:1 against ETH. One `Uniteum 1xETH` is worth one ETH, give or take a hundredth of a percent — and every token in circulation is backed, right now, by an equal amount of real ETH locked in a Uniswap V4 pool.

Mint it, swap it, hold it, send it. It behaves like ETH for any use that wants ERC-20 plumbing — but with its own address and its own name.

This page also shows how to mint your own 1xETH-symbol mirror under your own name. The mechanism is permissionless: pick a name, send the mint transaction, and you have a backed ERC-20 with the same peg guarantee.

---

## At a glance

| | |
|:---|:---|
| Name | `Uniteum 1xETH` |
| Symbol | `1xETH` |
| Backing | Native ETH, locked in a Uniswap V4 pool |
| Decimals | 18 (matches ETH) |
| Trading range | `[1.0000, 1.0001)` × ETH |
| Issue ERC-20 | [``](https://{{< escan >}}/token/) |

---

## Swap ETH for `Uniteum 1xETH`

Use any V4-aware DEX or aggregator — Uniswap's own UI, 1inch, Matcha, CoW Swap, custom routers — and pick `ETH ↔ Uniteum 1xETH`. There is no separate "redeem" function: the pool is the redemption path.

- `ETH → Uniteum 1xETH` to acquire
- `Uniteum 1xETH → ETH` to redeem

The swap settles inside the `[1.0000, 1.0001)` × ETH band. You'll never pay more than 1.0001 ETH per token to buy, and you'll never receive less than 1.0000 ETH per token to sell.

---

## Mint your own personalized 1xETH

You don't have to use ours. Anyone can mint their own `1xETH`-symbol mirror with their own chosen name and their own ERC-20 address. The peg is identical — every named mirror trades inside the same `[1.0000, 1.0001)` × ETH band, backed by ETH locked in its own V4 pool.

**To mint a new named mirror against native ETH:**

1. Open the [Reflector prototype](/reflector/reference/) on Etherscan: [`{{< val "unispring.reflector.address" >}}`](https://{{< escan >}}/address/{{< val "unispring.reflector.address" >}}#writeContract).
2. Connect a wallet with enough ETH to cover gas. (No collateral capital is needed — the mint funds itself.)
3. Call [`issue(name)`](https://{{< escan >}}/address/{{< val "unispring.reflector.address" >}}#writeContract#F{{< val "unispring" "reflector" "write" "issue(name, variant)" "f" >}}) with the name you want — `"Acme 1xETH"`, `"Bob 1xETH"`, whatever.

That single call deploys your ERC-20, mints its full supply, and seats it in a fresh V4 pool against native ETH. Your token is tradeable in the same transaction.

To preview the deterministic address before deploying, call [`issued(name)`](https://{{< escan >}}/address/{{< val "unispring.reflector.address" >}}#readContract#F{{< val "unispring" "reflector" "read" "issued(name, variant)" "f" >}}) with the same name on the read tab.

**What you keep as the deployer:** the wallet that submits the `issue(name)` transaction is recorded on-chain as the creator of your new ERC-20. That's the address Etherscan, CoinGecko, CoinMarketCap, and similar registries verify against when you submit token info — icon, description, project website, social links. The token's public identity is yours to claim.

**What you don't keep:** the 0.01% swap fees flow to the Fountain owner of the clone's [placer](/unispring/fountain/), set once when the placer was deployed; later issues don't change that. Supply, the price corridor, and the backing are all locked the moment the mint transaction confirms.

---

## What "personalized" gives you

A named mirror is a real product, not a relabel. It has its own ERC-20 address, its own integrations, its own listing on aggregators, its own market reputation. Two parties can each mint a `1xETH`-symbol mirror with different names and end up with two genuinely separate tokens — sharing only the symbol and the underlying peg corridor.

Crucially, the wallet that mints it is the on-chain deployer of that ERC-20 — which is the lever block explorers and token registries use to verify ownership when you submit token info. So `Uniteum 1xETH`'s icon, description, and project links on Etherscan are ours to set; `Acme 1xETH`'s would be Acme's. Their backing guarantees are identical; the brand on the token is not.

---

## Why the peg holds

The issue's V4 pool is initialized at `tick = 0` with the entire supply (`10²⁷` raw, ~1 billion at 18 decimals) seated single-sided in a single-tick range. Below tick 0 there is no liquidity at all; above the next tick there is no liquidity at all. V4's swap math cannot cross an empty tick range, so price is mathematically constrained to `[1.0000, 1.0001)` × ETH.

The pool is owned by a [Fountain](/unispring/fountain/) clone with no decrease-liquidity path. The ETH that backs `Uniteum 1xETH` is locked there forever — Reflector retains no authority over it, and Fountain itself exposes no withdraw-principal function. The deployer has the same redemption rights as everyone else: trade through the pool.

For the geometric argument in detail, see [Reflector — peg mechanics](/reflector/mechanics/).

---

## Behind the scenes: the native-pair clone

[Reflector](/reflector/reference/) is organized as a prototype that mints **clones** keyed by `(original, symbol)` — one clone per peg pair. For native ETH and the `1xETH` symbol, the prototype itself **is** the canonical clone — no separate clone is ever deployed for that pair. That's why the mint instructions above point at the prototype directly. (The native pair's symbol is resolved at construction from a chain-local `IStringLookup` — `"1xETH"` here on mainnet, `"1xMATIC"` on Polygon, etc.)

For any other peg pair (`(USDC, "1xUSDC")`, `(WBTC, "1xWBTC")`, etc.), `issue(name)` is called on the corresponding clone instead. See [Uniteum 1xUSDC](/reflector/uniteum-1xusdc/) for an example with a non-native original.

---

## Further reading

- [Factory reference](/reflector/reference/) — the factory, its layout, and the full set of operations
- [Reflector — peg mechanics](/reflector/mechanics/) — why the 1-bp corridor is hard
- [Fountain](/unispring/fountain/) — the V4 position primitive backing every issue
- [Uniteum 1xUSDC](/reflector/uniteum-1xusdc/) — the same pattern applied to a stablecoin original
