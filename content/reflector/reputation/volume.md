---
title: Trading volume
weight: 5
---
# Trading volume & momentum

**The signal:** How much is this token traded? Daily volume, the shape of the chart, whether it's trending up and to the right. High volume reads as "alive and liquid"; a flat, volumeless chart reads as "dead, or a trap."

For an ordinary token, volume is a proxy for one practical fear and one speculative hope:

- **The fear: can I actually get out?** A token with no volume has no buyers. You might hold something nominally worth $1,000 that you can't sell for anything close, because the moment you try, there's no one on the other side and the price collapses. Volume is your evidence that an exit exists.
- **The hope: is this going up?** Momentum traders read volume and trend as a signal of where the price goes next. This only makes sense for a token whose price is *free to move*.

## Why it doesn't apply

A [signature token](/reflector/) defeats both readings, because its price is pinned and its exit is structural.

**You never need volume to exit.** The whole anxiety behind "is there volume?" is "will there be a buyer when I want out?" For a par token the buyer is the pool, always, at par. Every unit is redeemable 1:1 against the backing token by [trading through the pool itself](/reflector/reference/#how-to-use-it) — there's no separate counterparty to wait for. A signature token that has done *zero* trades since it was minted is exactly as redeemable as one doing millions a day. Volume measures how often people have used the exit; it says nothing about whether the exit is open. On a par token, the exit is always open.

**Momentum is meaningless inside a 1-bp band.** Price can't trend. It's confined to [`[1.0000, 1.0001)` × the backing token](/reflector/mechanics/), a corridor one basis point wide. There is no chart pattern to read, no breakout, no "up and to the right" — the line is, by design, flat against the original. A par token isn't a momentum instrument and was never meant to be.

**Volume is the easiest metric to fake.** Wash trading — a wallet trading with itself to manufacture volume — is endemic precisely because volume drives attention. So even where volume *seems* to mean something, it's the metric most likely to be fabricated. A par token sidesteps the whole game: there's nothing to pump, so there's no reason to fake the volume, and no reason to read it.

## What to look at instead

Forget the volume figure and the chart. The questions they're standing in for are already answered:

- **Can I exit?** Always, at par, through the pool. See [how to use it](/reflector/reference/#how-to-use-it).
- **Where's the price going?** Nowhere — that's the point. See [Peg mechanics](/reflector/mechanics/).

The one number worth a glance is [pool depth](/reflector/reputation/liquidity/) — how large a single swap you can do before slippage matters — which is about the *size* of a trade, not whether trading is happening at all.

## Further reading

- [Why a signature token needs no reputation](/reflector/reputation/) — the unifying argument
- [Locked & deep liquidity](/reflector/reputation/liquidity/) — depth, the part of this that does matter
- [Peg mechanics](/reflector/mechanics/) — why there's no chart to trend
