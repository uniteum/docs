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

| Contract | Role |
|:---------|:-----|
| **[{{ u.fountain.name }}]({{ site.baseurl }}/unispring/fountain)** | V4 position owner. No decrease-liquidity path; principal locked, fees forwarded. |
| **[{{ u.manifold.name }}]({{ site.baseurl }}/unispring/manifold)** | Fair-launch factory. Mints fresh ERC-20s and seats 100% of supply single-sided against a hub. |
| **[{{ u.mimicry.name }}]({{ site.baseurl }}/unispring/mimicry)** | Mirror factory. Mints 1:1 ERC-20 mirrors of existing tokens with a hard 1-bp peg corridor. |

Both factories are one-shot. After they fund the position, no contract in the stack retains authority over the token, the pool, or the liquidity. The only way to acquire any Manifold or Mimicry token is to buy it from its V4 pool — on any aggregator, frontend, or contract that routes through V4.

---

## Why this design

Other fair-launch protocols ([Solid]({{ site.baseurl }}/solid/), for example) deliver fair start, built-in liquidity, and a permanent floor — but they live in a custom AMM. Bridging that liquidity to Uniswap requires an external arbitrage keeper, a Chainlink Automation subscription, and ongoing gas. Four moving parts where one should suffice.

Building on V4 directly removes the custom AMM, the keeper, and the arbitrage latency. Tokens are routable by every aggregator the moment the deploy transaction confirms.

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
| Swap fee | None | None | 0.01% (to Fountain clone owner) |
| Cross-token routing | N/A | Via Uniswap | Two-hop via hub |

---

## Permanence and trust boundaries

The factories above the position (`NeutrinoSource`, `NeutrinoChannel`, `Manifold`, `Mimicry`) are one-shot. After they mint, fund, and seat, none of them retains any authority over what they created.

| After launch, ...                  | ... is governed by                                                |
|:-----------------------------------|:------------------------------------------------------------------|
| Token transfers, approvals, supply | Lepton (the ERC-20 implementation)                                |
| Swap math, pool state, liquidity   | The Uniswap V4 PoolManager — plus any router that reaches it      |
| Accrued swap fees                  | Fountain clone (owner withdraws; no other authority)              |

Each Fountain clone has an immutable `owner` set at deploy time — the address that called `Fountain.make` — and that owner is the only address that can withdraw the clone's accumulated swap fees. The owner cannot pause, cannot decrease liquidity, cannot modify ticks.

---

## Contracts

{% if u.fountain.address %}
| Contract | Address |
|:---------|:--------|
{% if u.fountain.address %}| {{ u.fountain.name }} | [`{{ u.fountain.address }}`](https://etherscan.io/address/{{ u.fountain.address }}#code){:target="_blank"} |{% endif %}
{% if u.manifold.address %}| {{ u.manifold.name }} | [`{{ u.manifold.address }}`](https://etherscan.io/address/{{ u.manifold.address }}#code){:target="_blank"} |{% endif %}
{% if u.neutrinoSource.address %}| {{ u.neutrinoSource.name }} | [`{{ u.neutrinoSource.address }}`](https://etherscan.io/address/{{ u.neutrinoSource.address }}#code){:target="_blank"} |{% endif %}
{% if u.neutrinoChannel.address %}| {{ u.neutrinoChannel.name }} | [`{{ u.neutrinoChannel.address }}`](https://etherscan.io/address/{{ u.neutrinoChannel.address }}#code){:target="_blank"} |{% endif %}
{% if u.mimicry.address %}| {{ u.mimicry.name }} | [`{{ u.mimicry.address }}`](https://etherscan.io/address/{{ u.mimicry.address }}#code){:target="_blank"} |{% endif %}
{% if u.hub.address %}| {{ u.hub.name }} | [`{{ u.hub.address }}`](https://etherscan.io/address/{{ u.hub.address }}#code){:target="_blank"} |{% endif %}
{% else %}
Contracts have not yet been deployed. Addresses will be published in `_data/unispring.yml` at launch.
{% endif %}

---

## Resources

- [GitHub Repository](https://github.com/uniteum/unispring)
- [DESIGN.md](https://github.com/uniteum/unispring/blob/main/DESIGN.md){:target="_blank"} — design rationale, section by section
- [CRITIQUE.md](https://github.com/uniteum/unispring/blob/main/CRITIQUE.md){:target="_blank"} — open questions and concerns
- [MIMICOIN.md](https://github.com/uniteum/unispring/blob/main/MIMICOIN.md){:target="_blank"} — Mimicry in depth
