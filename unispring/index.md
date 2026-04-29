---
layout: default
title: Unispring
nav_order: 12
has_children: true
permalink: /unispring/
status: draft
---

{% assign u = site.data.unispring %}

# Unispring
{: .label .label-yellow }
Draft — contracts not yet deployed.

Unispring is a family of permissionless contracts on Uniswap V4. A single primitive owns the V4 positions, and two sibling factories mint the tokens that get seated into them.

At the core is **{{ u.fountain.name }}** — a V4 position owner with no withdraw path. Two sibling factories seat tokens into Fountain positions and walk away:

- **{{ u.unispring.name }}** mints fresh fair-launch ERC-20s and seats 100% of supply single-sided against a hub. Each token launches with a permanent price floor and routable V4 liquidity from the deploy transaction onward.
- **{{ u.mimicoinage.name }}** mints 1:1 mirrors of existing tokens, collateralized by a Fountain position locked at a single tick — a hard 1-bp peg corridor with no oracle.

Both factories are one-shot. After they fund the position, no contract in the stack retains authority over the token, the pool, or the liquidity. The only way to acquire any Unispring or Mimicoinage token is to buy it from its V4 pool — on any aggregator, frontend, or contract that routes through V4.

---

## Fountain — the primitive

A Fountain clone owns a single V4 position. Three operations, nothing else:

- **`offer`** — permissionless deposit. Anyone can fund the position with tokens at a chosen tick range. Liquidity only grows.
- **`make`** — sets the `taker`. First caller wins.
- **Fee collection** — the `taker` can sweep accrued swap fees. They cannot pause, modify ticks, or touch principal.

There is no `decreaseLiquidity` path. The position's principal is immobile, forever.

Fountain knows nothing about fair launches or mirrors. It's a one-way valve for V4 liquidity. What gets seated into it, and why, is the job of the factories below.

---

## Unispring — fair-launch factory

A single call to `{{ u.neutrinoSource.name }}.launch(name, symbol, decimals, supply, salt, tickLower, tickUpper)`:

1. Lepton mints a fresh ERC-20 at a CREATE2 address that sorts strictly below the hub
2. The supply is transferred to a `{{ u.unispring.name }}` clone keyed by `(hub, tickLower, tickUpper)`
3. The clone calls `Fountain.offer`
4. Fountain initializes the V4 pool at `tickLower` and seats the entire supply single-sided in `[tickLower, tickUpper]`

The maker spends only gas. The token is routable by every V4-aware aggregator the moment the deploy transaction confirms.

### The hub

Every Unispring clone is keyed by `(hub, tickLower, tickUpper)`. All spokes within a clone pair against the same hub, so any two of them are reachable in two hops via standard aggregator paths. The canonical hub will be deployed at a vanity address chosen so that almost every spoke address sorts strictly below it without salt mining.

### Why the floor holds

The seeded position spans `[tickLower, tickUpper]` and the pool's initial tick is exactly `tickLower`. Below it there is no liquidity at all — V4's swap math cannot cross an empty tick range, so price cannot fall through the floor. No hook, no custom curve. The floor is enforced by the **absence** of liquidity.

The same geometry is what makes the seed single-sided in the spoke and free for the maker. See [DESIGN.md §6 and §8](https://github.com/uniteum/unispring/blob/main/DESIGN.md){:target="_blank"} for the full argument.

---

## Mimicoinage — 1:1 mirror factory

`Mimicoinage` mints a mirror of any existing ERC-20 (or native ETH) and seats the entire mimic supply as a single-tick V4 position at tick 0, fee 100 (0.01%), tick-spacing 1. The position is collateralized by real originals locked in a Fountain position no one — including the deployer — can unwind.

The single-tick geometry constrains the mirror's price to the corridor `[0, 1.0001)` — a 1-basis-point peg enforced by V4 swap math, with no oracle, no rebalance keeper, and no governance. Mirror tokens use a `1x` prefix on the original's symbol: `1xUSDC` mirrors USDC, `1xWBTC` mirrors WBTC, `1xETH` mirrors native ETH.

See [MIMICOIN.md](https://github.com/uniteum/unispring/blob/main/MIMICOIN.md){:target="_blank"} for the peg argument.

---

## Why this design

Other fair-launch protocols ([Solid]({{ site.baseurl }}/solid/), for example) deliver fair start, built-in liquidity, and a permanent floor — but they live in a custom AMM. Bridging that liquidity to Uniswap requires an external arbitrage keeper, a Chainlink Automation subscription, and ongoing gas. Four moving parts where one should suffice.

Building on V4 directly removes the custom AMM, the keeper, and the arbitrage latency. Tokens are routable by every aggregator the moment the deploy transaction confirms.

---

## Permanence and trust boundaries

The factories above the position (`NeutrinoSource`, `NeutrinoChannel`, `Unispring`, `Mimicoinage`) are one-shot. After they mint, fund, and seat, none of them retains any authority over what they created.

| After launch, ...                  | ... is governed by                                                |
|:-----------------------------------|:------------------------------------------------------------------|
| Token transfers, approvals, supply | Lepton (the ERC-20 implementation)                                |
| Swap math, pool state, liquidity   | The Uniswap V4 PoolManager — plus any router that reaches it      |
| Accrued swap fees                  | Fountain (forwards to `taker` on demand; no other authority)      |

`taker` is the first address to call `Fountain.make()` for a given position. It can collect the 0.01% swap-fee stream — nothing else. It cannot pause, cannot decrease liquidity, cannot modify ticks.

---

## Patterns

`offer` is permissionless and re-callable. Anyone can fund any Unispring pool with their own tokens at their chosen tick range. Because positions can never be removed, the only way a pool grows is by being added to. A few patterns fall out:

- **Staged emissions** — fund an initial range; once price moves through it, fund a higher range
- **Multi-tier launch ladder** — split supply across several `offer` calls at different ranges to shape the offering curve
- **Permanent supply removal** — sink tokens as single-sided LP instead of sending to `0xdead`; same supply effect, but the pool gains depth
- **Community-strengthened liquidity** — third parties can top up a spoke's floor without permission from the original funder
- **Re-arming a sold-out position** — once the original range is fully crossed, a fresh `offer` at a new range restarts distribution at market price

Re-offers must start at the current pool tick and seat entirely on one side of it; wrong-side or starting-price-mismatch re-offers revert.

---

## Comparison

| Property | Solid | Solid + UniSolid | Unispring |
|:---------|:------|:-----------------|:----------|
| Fair launch | Yes | Yes | Yes |
| Price floor | Yes | Yes | Yes |
| Maker capital required | None | None | None |
| Custom AMM | Yes | Yes | No |
| Uniswap tradeable | No | Via arbitrage | Native |
| DEX aggregator support | No | Indirect | Immediate |
| Chainlink dependency | No | Yes | No |
| Contracts required | 1 | 4 | 1 |
| Ongoing costs | None | Chainlink + gas | None |
| Swap fee | None | None | 0.01% (to Fountain `taker`) |
| Cross-token routing | N/A | Via Uniswap | Two-hop via hub |

---

## Contracts

{% if u.fountain.address %}
| Contract | Address |
|:---------|:--------|
{% if u.fountain.address %}| {{ u.fountain.name }} | [`{{ u.fountain.address }}`](https://etherscan.io/address/{{ u.fountain.address }}#code){:target="_blank"} |{% endif %}
{% if u.unispring.address %}| {{ u.unispring.name }} | [`{{ u.unispring.address }}`](https://etherscan.io/address/{{ u.unispring.address }}#code){:target="_blank"} |{% endif %}
{% if u.neutrinoSource.address %}| {{ u.neutrinoSource.name }} | [`{{ u.neutrinoSource.address }}`](https://etherscan.io/address/{{ u.neutrinoSource.address }}#code){:target="_blank"} |{% endif %}
{% if u.neutrinoChannel.address %}| {{ u.neutrinoChannel.name }} | [`{{ u.neutrinoChannel.address }}`](https://etherscan.io/address/{{ u.neutrinoChannel.address }}#code){:target="_blank"} |{% endif %}
{% if u.mimicoinage.address %}| {{ u.mimicoinage.name }} | [`{{ u.mimicoinage.address }}`](https://etherscan.io/address/{{ u.mimicoinage.address }}#code){:target="_blank"} |{% endif %}
{% if u.hub.address %}| {{ u.hub.name }} | [`{{ u.hub.address }}`](https://etherscan.io/address/{{ u.hub.address }}#code){:target="_blank"} |{% endif %}
{% else %}
Contracts have not yet been deployed. Addresses will be published in `_data/unispring.yml` at launch.
{% endif %}

---

## Resources

- [GitHub Repository](https://github.com/uniteum/unispring)
- [DESIGN.md](https://github.com/uniteum/unispring/blob/main/DESIGN.md){:target="_blank"} — design rationale, section by section
- [CRITIQUE.md](https://github.com/uniteum/unispring/blob/main/CRITIQUE.md){:target="_blank"} — open questions and concerns
- [MIMICOIN.md](https://github.com/uniteum/unispring/blob/main/MIMICOIN.md){:target="_blank"} — Mimicoinage in depth
