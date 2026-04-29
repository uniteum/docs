---
layout: default
title: Mimicoinage
parent: Unispring
permalink: /unispring/mimicoinage/
nav_order: 3
---

{% assign u = site.data.unispring %}

# Mimicoinage — 1:1 mirror factory

Mimicoinage mints permissionless ERC-20 mirrors of any existing token (or native ETH), pegged within a hard 1-basis-point corridor. No oracle. No rebalance keeper. No governance.

A single call to `mimic(original, name, symbol)` mints a fresh mirror and seats its entire supply into a single-tick V4 position collateralized by real originals locked in a [Fountain]({{ site.baseurl }}/unispring/fountain) clone no one — including the deployer — can unwind.

---

## Naming convention

Mirror tokens use a `1x` prefix on the original's symbol:

- `1xUSDC` mirrors USDC
- `1xWBTC` mirrors WBTC
- `1xETH` mirrors native ETH

Name and symbol are caller-supplied; the `1x` prefix is the project convention, not a contract enforcement.

---

## How the peg holds

The mirror's V4 pool uses `tick = 0`, `fee = 100` (0.01%), `tickSpacing = 1`. The position spans a single tick — the narrowest range V4 allows. The starting price sits exactly at the lower edge of that tick, so the position begins 100% mirror and 0% original.

A buyer brings the original, receives mirror, walks price across the tick. A seller reverses. V4's swap math constrains price to the corridor `[1.0000, 1.0001)` — a hard 1-bp band.

| Side | Bound | Enforced by |
|:-----|:------|:------------|
| Floor | `1.0000` | Bottom of the seeded tick |
| Ceiling | `1.0001` | Top of the seeded tick |

The 10²⁷ raw mimic units seeded are large enough that the pool cannot be drained by any quantity of original that exists.

---

## Trust boundary

The Fountain position is owned by a Fountain clone. Mimicoinage retains no authority over it after seating.

| Surface | Authority |
|:--------|:----------|
| Mirror supply | Fixed at deploy |
| Pool position | Owned by Fountain clone, no decrease path |
| Original collateral | Locked in the V4 position, no unwind |
| Accrued fees | Fountain clone owner (0.01% of swap volume) |

Even the clone owner cannot harvest the accumulated original by unwinding — only the 0.01% fee stream is extractable.

---

## What it's for

- **Permissionless stablecoin mirror** — deploy `1xUSDC` alongside USDC with its own address, integrations, and reputation, collateralized 1:1 by real USDC in the pool
- **Free-floating distribution** — airdrop or distribute the mirror knowing every unit is redeemable 1:1 against the original, forever
- **Cross-venue scaffold** — mirror a native asset on a venue where bridging the real thing isn't feasible
- **Dev-chain tracking** — sandbox tokens that track real-world prices without oracle plumbing

---

## What it isn't

- **Not elastic.** Supply is fixed at launch. The peg is held by pool inventory, not by issuance.
- **Not an oracle.** If the original depegs from its reference asset, the mirror tracks the original — not the reference.
- **Not a yield source beyond fees.** Only the 0.01% swap fee on volume is extractable.

See [MIMICOIN.md](https://github.com/uniteum/unispring/blob/main/MIMICOIN.md){:target="_blank"} for the full peg argument.
