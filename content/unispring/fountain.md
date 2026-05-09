---
title: Fountain
weight: 1
---
# Fountain — the position primitive

Fountain is the V4 position owner that sits underneath every Unispring token. It has no decrease-liquidity path. Liquidity goes in; principal stays. Only the 0.01% swap-fee stream comes out.

A Fountain *clone* owns its V4 positions and accumulates swap fees in its own balance. The clone's `owner` — the address that called `Fountain.make` to deploy it — is the only address that can withdraw those fees.

---

## Bitsy factory

Fountain follows the prototype-plus-clones pattern. The prototype holds the logic; clones are EIP-1167 minimal proxies with their own storage.

`make(variant)` is called on the prototype. It deploys a clone CREATE2-deterministically at an address derived from `keccak256(msg.sender, variant)`, sets the clone's `owner` to `msg.sender`, and returns the clone address.

There is no race. Each unique `(caller, variant)` pair maps to its own clone address. Two different callers calling `make(0)` get two different clones. The same caller calling `make(0)` twice gets the same clone (idempotent — re-calls just return the existing address).

A clone's address is predictable before deploy, so callers can pre-fund it.

---

## Operations on a clone

- **`offer(token, quote, ticks, amounts)`** — seats single-sided V4 liquidity into the clone's positions. Permissionless. Liquidity only grows.
- **`take(ids)`** — pulls accrued swap fees from a batch of the clone's positions into the clone's own balance via zero-delta `modifyLiquidity` calls. Permissionless to trigger.
- **`withdraw(currency, amount)`** — `onlyOwner`. Transfers the clone's balance to its owner.

There is no `decreaseLiquidity` path anywhere in the contract. Principal stays.

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

The clone's `owner` collects the 0.01% fee stream. Nothing else.

| Surface | Authority |
|:--------|:----------|
| Principal | None — no withdraw path |
| Tick boundaries | None — fixed at offer time |
| Pause / freeze | None |
| Accrued fees | Clone `owner` (via `withdraw`, after permissionless `take`) |

The owner is set once at clone deploy by `zzInit` to the address that called `Fountain.make`. It cannot be changed.
