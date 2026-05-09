---
layout: default
title: Notable
nav_order: 13
has_children: true
permalink: /notable/
---

{% assign u = site.data.unispring %}
{% assign n = u.notable %}

# Notable — 1:1 mirror factory

[Notable]({% if n.address %}https://etherscan.io/address/{{ n.address }}#code{% else %}#{% endif %}){:target="_blank"} issues permissionless ERC-20 mirrors of any existing token (or native ETH). Each mirror trades 1:1 against its original within a hard 1-basis-point corridor, backed token-for-token by real originals locked in a Uniswap V4 pool. No oracle, no rebalance keeper, no governance, no unwind path.

Notable is a **two-level factory**. The prototype mints **clones** keyed by `(original, symbol)`. Each clone is itself a token factory whose `issue(name)` mints fresh ERC-20s — many distinct issues under one shared `(original, symbol)`, differing only by `name`. Every issue carries the clone's symbol and is pegged against the clone's original.

---

## How the factory is laid out

```
prototype Notable  →  clone per (original, symbol)  →  issue per name
```

1. **Prototype.** Deployed once per chain. Holds all the logic. Not used directly to mint mirrors of arbitrary originals — instead, it stamps clones via [`make(original, symbol)`]({% if n.address %}https://etherscan.io/address/{{ n.address }}#writeContract#F{{ n.write["make(original, symbol)"].f }}{% else %}#{% endif %}){:target="_blank"}.
2. **Clone.** A minimal proxy at a deterministic CREATE2 address derived from `(original, symbol)`. Carries only its own configuration (the `original` and `symbol` it issues under). Calling [`issue(name)`]({% if n.address %}https://etherscan.io/address/{{ n.address }}#writeContract#F{{ n.write["issue(name)"].f }}{% else %}#{% endif %}){:target="_blank"} on the clone mints a fresh ERC-20 carrying the clone's symbol and seats its full supply as a single-tick V4 position against the clone's original.
3. **Issue.** A real ERC-20 minted by the clone via [Coinage](https://github.com/uniteum/lepton){:target="_blank"}. Its address is deterministic in `(clone, name, symbol, decimals, supply)`, so distinct names produce distinct issues under the same clone.

`make` and `issue` are both **idempotent**. Calling `make` with a `(original, symbol)` that already has a clone returns the existing clone. Calling `issue` with a `name` that's already been minted returns the existing token.

### The native-pair special case

The prototype itself is the canonical clone for the native pair `(address(0), nativeSymbol)`, where `nativeSymbol` is resolved at construction from a chain-local `IStringLookup` — `"1xETH"` on mainnet, `"1xMATIC"` on Polygon, and so on. Calling `make(address(0), nativeSymbol)` returns the prototype directly — no separate clone is deployed for that pair. To mint a native-pair mirror, call [`issue(name)`]({% if n.address %}https://etherscan.io/address/{{ n.address }}#writeContract#F{{ n.write["issue(name)"].f }}{% else %}#{% endif %}){:target="_blank"} on the prototype.

### IAddressLookup originals

Passing an [IAddressLookup]({{ site.baseurl }}/locale/) as `original` peg-mirrors against whatever the lookup resolves to via `value()`. The clone's salt is computed from the **lookup address**, not the resolved token, so the same `IAddressLookup` yields the same clone address on every chain — even when the resolved token differs per chain. This makes a clone like `(USDCLookup, "1xUSDC")` portable: deploy it on Ethereum, Arbitrum, Base, and the address is the same on all three, but each chain's clone issues against its chain-local USDC.

---

## Why this is useful

The point is *durability of the peg*. Nobody — including the deployer — can rug, dilute, or unwind the backing. Once an issue exists, its redemption guarantee is as permanent as the V4 pool itself.

That makes mirrors useful where the original isn't, or where a wrapped token's peg would otherwise depend on a custodian or governance:

- **Permissionless stablecoin mirror** — issue `1xUSDC` alongside USDC with its own address, integrations, and reputation. Collateralized 1:1 by real USDC in the pool, with no path for anyone to drain it.
- **Free-floating distribution** — airdrop or distribute an issue knowing every unit is redeemable 1:1 against the original, forever.
- **Dev-chain tracking** — sandbox tokens that track real-world prices without oracle plumbing.

---

## Naming convention

A clone's symbol is the project convention `1x<ORIGINAL>`:

- `1xUSDC` clone mirrors USDC
- `1xWBTC` clone mirrors WBTC
- `1xETH` clone (the prototype itself, on mainnet) mirrors native ETH

Within a clone, each issue carries the clone's symbol and is distinguished by `name`. So `Uniteum 1xUSDC` and a different "Foo 1xUSDC" issued later under the same `1xUSDC` clone are two distinct ERC-20s sharing one symbol and one peg corridor.

The `1x` prefix is convention, not enforcement; symbols and names are caller-supplied. The native pair's symbol is the only one resolved automatically — from the chain-local `IStringLookup` used at prototype construction.

---

## What you get

Each issue is a real ERC-20 — its own address, its own `totalSupply` — that trades inside `[1.0000 × original, 1.0001 × original)`.

| Property | Value |
|:---------|:------|
| Decimals | Same as the original (18 for native ETH) |
| Price corridor | `[1.0000, 1.0001)` × original |
| Backing | Real originals, locked in a single-tick V4 position |
| Swap fee | 0.01%, paid to the Fountain owner |
| Supply | Fixed at mint, scaled to original's decimals |

The issue's only behaviour is "trades close to its original". It is not a wrapped-deposit token, not an LP token, and not a claim on yield.

---

## How to use it

**Find or deploy a clone.** Call [`make(original, symbol)`]({% if n.address %}https://etherscan.io/address/{{ n.address }}#writeContract#F{{ n.write["make(original, symbol)"].f }}{% else %}#{% endif %}){:target="_blank"} on the prototype. Pass `address(0)` for native ETH, an `IAddressLookup` for chain-local resolution, or any other address as the token directly. Use [`made(original, symbol)`]({% if n.address %}https://etherscan.io/address/{{ n.address }}#readContract#F{{ n.read["made(original, symbol)"].f }}{% else %}#{% endif %}){:target="_blank"} first to preview the deterministic clone address and whether it already exists.

**Mint an issue.** Call [`issue(name)`]({% if n.address %}https://etherscan.io/address/{{ n.address }}#writeContract#F{{ n.write["issue(name)"].f }}{% else %}#{% endif %}){:target="_blank"} on the clone (or on the prototype, for the native pair). The issue is deployed, fully funded, and tradeable in the same transaction. The wallet that submits the call is recorded on-chain as the deployer of the new ERC-20 — relevant when submitting token-info updates (icon, description, project URL) to Etherscan and other registries that verify ownership against the deployer address. Use [`issued(name)`]({% if n.address %}https://etherscan.io/address/{{ n.address }}#readContract#F{{ n.read["issued(name)"].f }}{% else %}#{% endif %}){:target="_blank"} on the clone — or [`issued(original, symbol, name)`]({% if n.address %}https://etherscan.io/address/{{ n.address }}#readContract#F{{ n.read["issued(original, symbol, name)"].f }}{% else %}#{% endif %}){:target="_blank"} on the prototype — to preview the issue address before deploying.

**Buy or sell.** Route a swap through any V4-aware aggregator or frontend — `original → issue` to acquire, `issue → original` to redeem. There is no separate "redeem" function: the pool *is* the redemption path.

**Collect fees.** The address that called `Fountain.make` for the underlying Fountain clone is the `taker` and collects the 0.01% swap-fee stream. Anyone can call `take` to harvest fees from the V4 position into the Fountain clone's balance; the clone owner then withdraws them. Principal is unreachable.

---

## Deployed instances

{% if n.address %}{% for entry in n.clones %}{% assign c = entry[1] %}
### {{ c.symbol }} — clone for {{ c.original }}

| | |
|:---|:---|
| Symbol | `{{ c.symbol }}` |
| Original | {{ c.original }} |{% if c.original_lookup %}
| Original lookup | [`{{ c.original_lookup }}`](https://etherscan.io/address/{{ c.original_lookup_address }}#code){:target="_blank"} |{% endif %}{% if c.address %}
| Clone | [`{{ c.address }}`](https://etherscan.io/address/{{ c.address }}#code){:target="_blank"} |{% endif %}

{{ c.note }}

{% if c.issues %}**Issues minted:**

| Name | Address |
|:-----|:--------|
{% for iss in c.issues %}| {% if iss.permalink %}[{{ iss.name }}]({{ site.baseurl }}{{ iss.permalink }}){% else %}{{ iss.name }}{% endif %} | {% if iss.address %}[`{{ iss.address }}`](https://etherscan.io/address/{{ iss.address }}){:target="_blank"}{% else %}_(pending deploy)_{% endif %} |
{% endfor %}{% endif %}
{% endfor %}{% else %}
Notable is not yet deployed. Clone and issue addresses will be published once the prototype is mined and deployed.
{% endif %}

---

## What it isn't

- **Not elastic.** Supply is fixed at mint. The peg is held by pool inventory, not by issuance.
- **Not an oracle.** If the original depegs from its reference asset, the issue tracks the original — not the reference.
- **Not a yield source beyond fees.** Only the 0.01% swap fee on volume is extractable.

---

## Trust boundary

Once an issue is minted, nothing in the stack retains authority over it.

| Surface | Authority |
|:--------|:----------|
| Issue supply | Fixed at mint |
| Pool position | Owned by Fountain clone, no decrease path |
| Original collateral | Locked in the V4 position, no unwind |
| Accrued fees | Fountain `taker` (0.01% of swap volume) |

Even the Fountain `taker` cannot harvest the accumulated original by unwinding — only the fee stream is extractable.

---

## Further reading

- [Peg mechanics]({{ site.baseurl }}/notable/mechanics/) — how the corridor is enforced and why the band is hard.
- [Plain-English intro]({{ site.baseurl }}/notable/intro/) — the same thing for non-engineers.
- [About the FDV]({{ site.baseurl }}/notable/fdv/) — why the headline valuation is harmless.
- [NOTABLE.md](https://github.com/uniteum/unispring/blob/main/NOTABLE.md){:target="_blank"} — the full peg argument.
