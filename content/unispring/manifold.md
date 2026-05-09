---
title: Manifold
weight: 2
---
# Manifold — fair-launch factory

Manifold mints fresh ERC-20 tokens and seats 100% of supply single-sided into a [Fountain](/unispring/fountain) V4 position against a hub. Each launch produces a token with a permanent price floor and routable V4 liquidity from the deploy transaction onward.

The maker spends only gas. No pre-buy. No matched pair. No LP capital.

---

## Launch flow

A single call to `{{< val "unispring.neutrinoSource.name" >}}.launch(name, symbol, decimals, supply, salt, tickLower, tickUpper)`:

1. Lepton mints a fresh ERC-20 at a CREATE2 address that sorts strictly below the hub
2. The supply is transferred to a `{{< val "unispring.manifold.name" >}}` clone keyed by `(hub, tickLower, tickUpper)`
3. The clone calls `Fountain.offer`
4. Fountain initializes the V4 pool at `tickLower` and seats the entire supply single-sided in `[tickLower, tickUpper]`

The token is routable by every V4-aware aggregator the moment the deploy transaction confirms.

---

## The hub

Every Manifold clone is keyed by `(hub, tickLower, tickUpper)`. All spokes within a clone pair against the same hub, so any two of them are reachable in two hops via standard aggregator paths — `spokeA → hub → spokeB`.

The canonical hub will be deployed at a vanity address chosen so almost every spoke address sorts strictly below it without salt mining. V4 requires `currency0 < currency1` in every PoolKey, and the single-sided-at-lower-bound seed math relies on the spoke being `currency0`.

---

## Why the floor holds

The seeded position spans `[tickLower, tickUpper]`. The pool's initial tick is exactly `tickLower`. Below that tick there is **no liquidity at all** — V4's swap math cannot cross an empty tick range, so price cannot fall through the floor.

No hook. No custom curve. The floor is enforced by the **absence** of liquidity.

The same geometry is what makes the seed single-sided in the spoke and free for the maker. See [DESIGN.md §6 and §8](https://github.com/uniteum/unispring/blob/main/DESIGN.md) for the full argument.

---

## Patterns

Because positions can never be removed, the only way a pool grows is by being added to. A few patterns fall out of permissionless re-`offer`:

- **Staged emissions** — fund an initial range; once price moves through it, fund a higher range
- **Multi-tier launch ladder** — split supply across several `offer` calls at different ranges to shape the offering curve
- **Permanent supply removal** — sink tokens as single-sided LP instead of sending to `0xdead`; same supply effect, but the pool gains depth
- **Community-strengthened liquidity** — third parties can top up a spoke's floor without permission from the original funder
- **Re-arming a sold-out position** — once the original range is fully crossed, a fresh `offer` at a new range restarts distribution at market price

Re-offers must start at the current pool tick and seat entirely on one side of it; wrong-side or starting-price-mismatch re-offers revert.

---

## Post-buyout dynamics

A fully-crossed spoke position sits at `tickUpper` as 100% hub. That hub is itself a permanent bid: the first seller back across the boundary consumes it and reactivates the original position. Spoke pools alternate between active-at-spot and saturated-at-`tickUpper`. The saturated state is a waiting state, not a dead state — re-offers and parallel pools above `tickUpper` are optional enhancements, not required repairs.

See [DESIGN.md §14](https://github.com/uniteum/unispring/blob/main/DESIGN.md) for the catalog of options around a spent position.
