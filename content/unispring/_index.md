---
title: Unispring
weight: 12
bookCollapseSection: true
---
# Unispring

Draft — contracts not yet deployed.

Unispring is a family of permissionless contracts on Uniswap V4. A single primitive owns the V4 positions, and two sibling factories mint the tokens that get seated into them.

| Contract | Role |
|:---------|:-----|
| **[{{< val "unispring.fountain.name" >}}](/unispring/fountain)** | V4 position owner. No decrease-liquidity path; principal locked, fees forwarded. |
| **[{{< val "unispring.manifold.name" >}}](/unispring/manifold)** | Fair-launch factory. Mints fresh ERC-20s and seats 100% of supply single-sided against a hub. |
| **[{{< val "unispring.notable.name" >}}](/notable/)** | Two-level mirror factory. Stamps clones per `(original, symbol)`; each clone issues named 1:1 ERC-20 mirrors with a hard 1-bp peg corridor. Documented in its own section: [Notable](/notable/). |

Both factories are one-shot. After they fund the position, no contract in the stack retains authority over the token, the pool, or the liquidity. The only way to acquire any Manifold or Notable token is to buy it from its V4 pool — on any aggregator, frontend, or contract that routes through V4.

---

## Why this design

Other fair-launch protocols ([Solid](/solid/), for example) deliver fair start, built-in liquidity, and a permanent floor — but they live in a custom AMM. Bridging that liquidity to Uniswap requires an external arbitrage keeper, a Chainlink Automation subscription, and ongoing gas. Four moving parts where one should suffice.

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

The factories above the position (`NeutrinoSource`, `NeutrinoChannel`, `Manifold`, `Notable`) are one-shot. After they mint, fund, and seat, none of them retains any authority over what they created.

| After launch, ...                  | ... is governed by                                                |
|:-----------------------------------|:------------------------------------------------------------------|
| Token transfers, approvals, supply | Lepton (the ERC-20 implementation)                                |
| Swap math, pool state, liquidity   | The Uniswap V4 PoolManager — plus any router that reaches it      |
| Accrued swap fees                  | Fountain clone (owner withdraws; no other authority)              |

Each Fountain clone has an immutable `owner` set at deploy time — the address that called `Fountain.make` — and that owner is the only address that can withdraw the clone's accumulated swap fees. The owner cannot pause, cannot decrease liquidity, cannot modify ticks.

---

## Contracts


| Contract | Address |
|:---------|:--------|
| {{< val "unispring.fountain.name" >}} | [`{{< val "unispring.fountain.address" >}}`](https://etherscan.io/address/{{< val "unispring.fountain.address" >}}#code) |
| {{< val "unispring.manifold.name" >}} | [`{{< val "unispring.manifold.address" >}}`](https://etherscan.io/address/{{< val "unispring.manifold.address" >}}#code) |
| {{< val "unispring.neutrinoSource.name" >}} | [`{{< val "unispring.neutrinoSource.address" >}}`](https://etherscan.io/address/{{< val "unispring.neutrinoSource.address" >}}#code) |
| {{< val "unispring.neutrinoChannel.name" >}} | [`{{< val "unispring.neutrinoChannel.address" >}}`](https://etherscan.io/address/{{< val "unispring.neutrinoChannel.address" >}}#code) |
| {{< val "unispring.notable.name" >}} | [`{{< val "unispring.notable.address" >}}`](https://etherscan.io/address/{{< val "unispring.notable.address" >}}#code) |
| {{< val "unispring.hub.name" >}} | [`{{< val "unispring.hub.address" >}}`](https://etherscan.io/address/{{< val "unispring.hub.address" >}}#code) |


---

## Resources

- [GitHub Repository](https://github.com/uniteum/unispring)
- [DESIGN.md](https://github.com/uniteum/unispring/blob/main/DESIGN.md) — design rationale, section by section
- [CRITIQUE.md](https://github.com/uniteum/unispring/blob/main/CRITIQUE.md) — open questions and concerns
- [NOTABLE.md](https://github.com/uniteum/unispring/blob/main/NOTABLE.md) — Notable in depth
