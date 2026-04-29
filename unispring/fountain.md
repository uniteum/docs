---
layout: default
title: Fountain
parent: Unispring
permalink: /unispring/fountain/
nav_order: 1
---

{% assign u = site.data.unispring %}

# Fountain — the position primitive

Fountain is the V4 position owner that sits underneath every Unispring token. It has no decrease-liquidity path. Liquidity goes in; principal stays. Only the 0.01% swap-fee stream comes out.

A Fountain *clone* owns a single V4 position keyed by `(owner = clone, tickLower, tickUpper, salt = 0)`. The Manifold and Mimicoinage factories deploy a clone, fund it, and walk away.

---

## Operations

Three external surfaces, nothing else:

- **`offer(token, supply, tickLower, tickUpper)`** — permissionless deposit. Anyone can fund the position with their own tokens at a chosen tick range. Liquidity only grows.
- **`make()`** — sets the `taker`. First caller wins. The taker is the address that gets to collect future swap fees on this clone.
- **`take(...)`** — the taker sweeps accrued swap fees on a batch of positions. Cannot pause, modify ticks, or touch principal.

There is no `decreaseLiquidity` path anywhere in the contract.

---

## Why no NFT

Fountain talks to V4's `PoolManager` directly via `unlockCallback`, not through `v4-periphery`'s `PositionManager`. `PositionManager` wraps each position as an ERC-721 — whoever holds the NFT can transfer it, withdraw, or collect. Going through periphery would mean Fountain nominally *owns* NFTs, which defeats the "locked forever" guarantee even if code never exposes the token.

Direct `PoolManager` calls produce a position with no NFT, no transfer path, and no collect function anyone outside Fountain can reach. Permanence is enforced at the lowest level the V4 substrate allows.

---

## Re-offering

`offer` is permissionless and re-callable. Any address can fund any Unispring pool at any time, with their own tokens, at their chosen tick range.

Two constraints apply on a pool that's already initialized:

1. The first tick of the new batch must equal the current pool tick. Mismatches revert with `PoolPreInitialized`.
2. The range must sit entirely on one side of the current tick — currency0-sided extends upward from spot, currency1-sided extends downward. Wrong-side ranges revert.

Together these prevent re-offers from carving gaps above or below spot, or bleeding value out of existing positions.

---

## Trust boundary

`taker` collects the 0.01% fee stream. Nothing else.

| Surface | Authority |
|:--------|:----------|
| Principal | None — no withdraw path |
| Tick boundaries | None — fixed at offer time |
| Pause / freeze | None |
| Accrued fees | `taker` (forwarded on `take`) |

`taker` is the first address to call `Fountain.make()` for a given clone. Once set, immutable.
