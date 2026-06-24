---
title: The $0 price display
weight: 5
---
# Why a tracker can show $0

A freshly seated Unispring token — a [Reflector](/reflector/) par token or a [Manifold](/unispring/manifold) fair-launch token — often shows a price of **$0** on Uniswap's own token page and chart, even though its V4 pool is funded, routable, and trades at the right price the instant you swap.

It is the mirror image of the [$2.3-trillion FDV artifact](/reflector/fdv/): the same single-tick geometry that produces an absurdly *large* headline number on one screen produces a flat *zero* on another. Both are correct arithmetic answers to the wrong question, and neither says anything about whether the token is worth holding.

This page explains exactly where the $0 comes from, why it is **not** a defect in the token or the pool, why it reaches well beyond par tokens, and what to read instead.

## It is not the pool — the price you trade at is real

Two different systems are at work, and only one of them is reading the pool.

- **The swap engine** quotes you a price by reading the pool's current tick directly. Ask Uniswap (or any aggregator) for a quote and it is correct — par tokens quote at ~1× their backing, Manifold tokens quote at their floor or above. Swaps execute at that price.
- **The token-page price** is a *derived metric*. It is not read from the pool at swap time; it is computed ahead of time by Uniswap's indexing layer (the open-source [Uniswap subgraph](https://github.com/Uniswap/v4-subgraph)) and served to the interface. The $0 is manufactured there, downstream of the chain.

So "the pool is funded and trades at par" and "the chart says $0" are not in conflict. They are produced by two different code paths, and only the cosmetic one fails.

## Where the zero comes from

The indexer will assign a token a USD price only when **both** of these hold:

1. The token has a pool whose *other* side is a trusted anchor — a whitelisted stablecoin or wrapped-native token — so there is a path to USD it is willing to trust; **and**
2. That anchor side holds more than a minimum amount of liquidity. The threshold is a per-chain constant named `minimumNativeLocked` (`MINIMUM_ETH_LOCKED` in the older v3 indexer). On Arbitrum, for instance, it is the equivalent of **one ETH**; it varies by chain.

If a token has no trusted-anchor pool, or its anchor side sits below that floor, the derived price falls back to **zero**, and the page shows $0. The threshold is not secret — it is a named constant in Uniswap's public subgraph repository, which anyone can read.

## Why single-sided seeds trip it

Every Unispring token is seated **single-sided**: 100% of supply goes into the pool, and *none* of the anchor. The anchor side fills only as people buy in. So at rest — and for a long time after, if trading is light — the pool is almost entirely the token itself and holds only a trickle of the anchor.

The result: a pool can hold a quarter of a million dollars of token and only a few hundred dollars of the anchor. The token-side value is large; the *anchor-side* value, which is the only thing the floor measures, is far below the threshold. Derived price: $0.

This is structural, not a misconfiguration. The single-sided seed that makes Unispring tokens free to launch and impossible to rug is exactly the shape that starts life below the anchor floor.

## This is not only a par-token problem

The same mechanism catches a much wider class of tokens:

- **Manifold fair-launch tokens are hit twice.** They are single-sided *and* paired against a [hub](/unispring/manifold) (canonically Uniteum 1), which is not itself a whitelisted stablecoin or wrapped-native token. So even setting the liquidity floor aside, there is no trusted one-hop path to USD. A derived price is only as good as the anchor it chains through; if the hub is itself unpriced or below the floor, the zero propagates transitively to every spoke that prices through it.
- **Any cold-start or thinly-anchored token**, single-sided or not. A brand-new conventional token whose anchor pool has not yet crossed the floor shows $0 for the same reason, until liquidity accrues.
- **Any token paired only against non-whitelisted assets.** With no trusted anchor in reach, there is nothing for the indexer to price against.

In other words, the $0 is a property of *anchor-side liquidity below the floor, or no whitelisted path to USD*. Single-sided seeding guarantees that condition at rest, but ordinary tokens reach it too.

## Why Uniswap does this — and why it is not a bug

The floor is a deliberate anti-manipulation safeguard, and a reasonable one.

A pool with negligible anchor liquidity has a spot price that costs almost nothing to push. Worse, **a single-sided position can *assert* any price at all with no capital at risk** — seat a worthless token at a tick claiming $1,000 and the geometry pins it there. From pool reserves alone, that is indistinguishable from a legitimately backed token. The floor is Uniswap refusing to print a USD number for that pattern until real, independently-valued liquidity backs it. That protects users who trust the number on the page, and it is the correct conservative default.

The unhappy side effect is a **false negative**: a fully-backed par token, or a floored Manifold token, presents on-chain exactly like the thing the floor is built to reject. The safeguard works as designed; the token is simply collateral damage of a rule written for ordinary pools.

## Is it permanent?

No. It is **adoption-gated, not structural**. As buyers trade in, the anchor side accrues; once it crosses the floor, the derived price populates and the chart begins to show the real number. A pinned, low-volume token may sit at $0 for a long time — possibly indefinitely if it is rarely traded — but this is a cold-start threshold, not a permanent exclusion. Nothing about the token has to change for the display to fix itself; enough trading volume does it.

## A fix that keeps the safeguard

The floor uses *absolute anchor size* as a proxy for "this price is real and hard to move." Some pools satisfy that property by **geometry** instead of size: a single full-supply position in a narrow tick range has a price bounded by construction, and — because the only way to acquire the token is to pay the displayed price into the pool — its circulating (non-pool) supply is always backed by anchor reserves.

That suggests a stricter-where-it-counts replacement: price a sub-floor pool if it can **buy back its entire circulating supply at the displayed price** out of its anchor reserves. A par or floored position passes by construction; an under-collateralized or pumped-thin pool fails. The anti-manipulation guarantee survives, and legitimately backed single-sided tokens stop reading $0. This is a change to Uniswap's indexer, not to any Unispring contract — the tokens are already correct on-chain.

## What to read instead

Until the displayed price catches up, don't read the token-page $0 as "worthless" — any more than you'd read the [$2.3T FDV](/reflector/fdv/) as "valuable." Both are the same single-tick geometry meeting a metric built for ordinary pools.

- **Get the real price from a venue that reads the tick.** GeckoTerminal, Matcha, and most aggregators price these pools correctly. Or simply request a swap quote on Uniswap itself — the quote is right even when the chart is not.
- **Verify the pool directly** on a block explorer: the token side holds the supply, the anchor side holds whatever has been bought in so far, and the tick fixes the price.
- **Judge the token by its mechanics, not its chart.** For a par token the price is [pinned by the corridor](/reflector/mechanics/); for a Manifold token it is [held by the floor](/unispring/manifold/#why-the-floor-holds). Neither depends on the number Uniswap chooses to display.

## Further reading

- [About the FDV](/reflector/fdv/) — the sibling artifact, an absurdly large number from the same geometry
- [Trading volume](/reflector/reputation/volume/) — why a flat, volumeless chart is also moot here
- [Locked & deep liquidity](/reflector/reputation/liquidity/) — why the supply *is* the liquidity
- [Manifold](/unispring/manifold/) — the fair-launch factory and its hub model
- [Peg mechanics](/reflector/mechanics/) — why a par token's price cannot move
