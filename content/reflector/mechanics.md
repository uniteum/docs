---
title: Peg mechanics
weight: 2
---
# Reflector — peg mechanics

How the 1-bp corridor is enforced, why the band is hard, and why the backing can never be unwound.

For the user-facing description of what Reflector does and how to use it, see [Reflector](/reflector/).

---

## Single-tick V4 position

A signature token's V4 pool uses `tick = 0`, `fee = 100` (0.01%), `tickSpacing = 1`. The position spans a single tick — the narrowest range V4 allows. The starting price sits exactly at the lower edge of that tick, so the position begins 100% signature-token and 0% original.

A buyer brings the original, receives the signature token, walks price across the tick. A seller reverses. V4's swap math constrains price to the corridor `[1.0000, 1.0001)` — a hard 1-bp band.

| Side | Bound | Enforced by |
|:-----|:------|:------------|
| Floor | `1.0000` | Bottom of the seeded tick |
| Ceiling | `1.0001` | Top of the seeded tick |

The signature token carries the original's decimals (18 for native ETH), so the V4-native raw price of 1 at tick 0 lines up exactly with a 1:1 human-unit peg. Fountain handles the V4 tick flip internally when the signature token sorts above the original — both orderings start the position with 100% signature-token at the edge of the user-semantic range `[0, 1)`.

---

## Why the band can't be broken

The corridor is enforced by Uniswap V4 itself. There is no liquidity outside the seeded tick, and V4's swap math cannot cross an empty tick range.

Trade size cannot break the band either. The supply seated into the pool is caller-chosen at mint, but capped at `maxSupply` — the largest amount that fits V4's `maxLiquidityPerTick` for a single-tick seat at `tickSpacing = 1` (about 9 billion tokens at 18 decimals). Whatever supply is chosen, all of it sits on the bid side of the one tick, so for any plausible original the pool cannot be drained by a real-world quantity of buyers.

No hook, no oracle, no keeper. The peg is geometric: the only place trade can happen is inside the seeded tick, and that tick is a 1-bp corridor by construction.

---

## Why the backing is permanent

The V4 position is owned by a [Fountain](/unispring/fountain) clone. Reflector retains no authority over it after seating, and Fountain itself exposes no decrease-liquidity path — principal cannot be withdrawn by anyone, ever.

The clone's owner is set once at deploy to the address that called `Fountain.make`. The owner can call `withdraw` on the clone to pull accrued swap fees (after anyone calls `take` to harvest them from the V4 position into the clone's balance). Nothing else.

---

## Native-pair originals

When the original is `Currency.wrap(address(0))`, Reflector mints the signature token with 18 decimals and the caller-chosen supply, then funds the V4 position against native ETH. Fountain handles ETH-denominated `PoolManager` calls without a separate WETH wrapper step. The Reflector prototype itself is the canonical clone for the native pair `(address(0), nativeSymbol)` — where `nativeSymbol` is resolved at construction from a chain-local `IStringLookup` (`"1xETH"` on mainnet, `"1xMATIC"` on Polygon, etc.). See [Factory reference](/reflector/reference/) for the factory layout.

---

## Further reading

- [REFLECTOR.md](https://github.com/uniteum/unispring/blob/main/REFLECTOR.md) — the full peg argument
- [DESIGN.md](https://github.com/uniteum/unispring/blob/main/DESIGN.md) — Unispring design rationale, section by section
- [Fountain](/unispring/fountain) — the V4 position primitive both factories build on
