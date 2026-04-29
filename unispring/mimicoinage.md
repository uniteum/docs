---
layout: default
title: Mimicoinage
parent: Unispring
permalink: /unispring/mimicoinage/
nav_order: 3
---

{% assign u = site.data.unispring %}
{% assign m = u.mimicoinage %}

# Mimicoinage — 1:1 mirror factory

[Mimicoinage](https://etherscan.io/address/{{ m.address }}#code){:target="_blank"} lets anyone mint an ERC-20 mirror of any existing token (or native ETH). The mirror trades 1:1 against its original within a hard 1-basis-point corridor, backed token-for-token by real originals locked in a Uniswap V4 pool.

A single call to [`mimic(original, name, symbol)`](https://etherscan.io/address/{{ m.address }}#writeContract#F{{ m.write["mimic(original, name, symbol)"].f }}){:target="_blank"} deploys the mirror and funds its pool in the same transaction. From that moment, every unit of the mirror is redeemable 1:1 against the original by swapping in the pool — on any aggregator, frontend, or contract that routes through V4. No oracle, no rebalance keeper, no governance, no unwind path.

---

## Why this is useful

The point is *durability of the peg*. Nobody — including the deployer — can rug, dilute, or unwind the backing. Once the mirror exists, its redemption guarantee is as permanent as the V4 pool itself.

That makes mirrors useful in places where the original isn't, or where the peg of a wrapped token would normally depend on a custodian or governance:

- **Permissionless stablecoin mirror** — deploy `1xUSDC` alongside USDC with its own address, integrations, and reputation. Collateralized 1:1 by real USDC in the pool, with no path for anyone to drain it.
- **Free-floating distribution** — airdrop or distribute the mirror knowing every unit is redeemable 1:1 against the original, forever.
- **Cross-venue scaffold** — mirror a native asset on a venue where bridging the real thing isn't feasible.
- **Dev-chain tracking** — sandbox tokens that track real-world prices without oracle plumbing.

---

## Naming convention

Mirror tokens use a `1x` prefix on the original's symbol:

- `1xUSDC` mirrors USDC
- `1xWBTC` mirrors WBTC
- `1xETH` mirrors native ETH

Name and symbol are caller-supplied; the `1x` prefix is the project convention, not a contract enforcement.

---

## What you get

A real ERC-20 — with its own address and `totalSupply` — that trades inside `[1.0000 × original, 1.0001 × original)`.

| Property | Value |
|:---------|:------|
| Decimals | Same as the original (18 for native ETH) |
| Price corridor | `[1.0000, 1.0001)` × original |
| Backing | Real originals, locked in a single V4 position |
| Swap fee | 0.01%, paid to the Fountain clone owner |
| Supply | Fixed at deploy |

The mirror's only behaviour is "trades close to its original". It is not a wrapped-deposit token, not an LP token, and not a claim on yield.

---

## How to use it

**Deploy a mirror.** Call [`mimic(original, name, symbol)`](https://etherscan.io/address/{{ m.address }}#writeContract#F{{ m.write["mimic(original, name, symbol)"].f }}){:target="_blank"} on Mimicoinage. Pass `address(0)` as `original` to mirror native ETH. The mirror is deployed, fully funded, and tradeable in the same transaction. Use [`predictMimic(original, name, symbol)`](https://etherscan.io/address/{{ m.address }}#readContract#F{{ m.read["predictMimic(original, name, symbol)"].f }}){:target="_blank"} first to see the deterministic address (and whether it already exists) without spending gas.

**Buy or sell.** Route a swap through any V4-aware aggregator or frontend — `original → 1xORIGINAL` to acquire, `1xORIGINAL → original` to redeem. There is no separate "redeem" function: the pool *is* the redemption path.

**Collect fees.** The address that called `Fountain.make` to deploy the underlying clone collects the 0.01% swap-fee stream. Anyone can call `take` to harvest fees from the V4 position into the clone's balance; the clone owner then calls `withdraw` to pull them out. Principal is unreachable.

---

## What it isn't

- **Not elastic.** Supply is fixed at launch. The peg is held by pool inventory, not by issuance.
- **Not an oracle.** If the original depegs from its reference asset, the mirror tracks the original — not the reference.
- **Not a yield source beyond fees.** Only the 0.01% swap fee on volume is extractable.

---

## Trust boundary

Once a mirror is deployed, nothing in the stack retains authority over it.

| Surface | Authority |
|:--------|:----------|
| Mirror supply | Fixed at deploy |
| Pool position | Owned by Fountain clone, no decrease path |
| Original collateral | Locked in the V4 position, no unwind |
| Accrued fees | Fountain clone owner (0.01% of swap volume) |

Even the clone owner cannot harvest the accumulated original by unwinding — only the fee stream is extractable.

---

## Further reading

- [Peg mechanics]({{ site.baseurl }}/unispring/mimicoinage-mechanics) — how the corridor is enforced and why the band is hard.
- [MIMICOIN.md](https://github.com/uniteum/unispring/blob/main/MIMICOIN.md){:target="_blank"} — the full peg argument.
