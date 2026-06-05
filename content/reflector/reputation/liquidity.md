---
title: Locked & deep liquidity
weight: 3
---
# Locked & deep liquidity

**The signal:** How much liquidity backs the token, and is it *locked*? Traders check the size of the pool (can I get in and out without moving the price?) and whether the liquidity provider tokens are time-locked or burned (can the team yank the pool and leave holders with nothing?).

These two questions carry an enormous share of an ordinary token's trust weight. The classic rug is a **liquidity pull**: a team seeds a pool, lets buyers in, then withdraws the paired asset and disappears, collapsing the price to zero. So holders look for a lock contract, a burn address, a vesting timer — evidence that *somebody promised not to do that*, and arranged for the promise to be hard to break.

A liquidity lock is a promise with a deadline. It's better than nothing, but it's still a claim about what a human won't do — and locks expire, get re-deployed, or turn out to have an admin escape.

## Why it doesn't apply

A [signature token](/reflector/) doesn't lock its liquidity. Its liquidity *is* the token, and it was never withdrawable to begin with.

When a signature token is minted, **its entire supply is seated into a single-tick Uniswap V4 position** paired against the backing token. There is no separate "team allocation" sitting outside the pool, no LP tokens held in a wallet somewhere. The pool isn't a place the token's value is *parked*; the pool is *where the token lives*.

And that position cannot be unwound:

- It's owned by a [Fountain](/unispring/fountain/) clone that **exposes no decrease-liquidity path** — there is no function, for anyone, to pull principal out. See [why the backing is permanent](/reflector/mechanics/#why-the-backing-is-permanent).
- The deployer holds no special claim on it. They redeem the same way everyone does: by trading through the pool.

So "is the liquidity locked?" isn't a meaningful question, because locking is the wrong verb. Nothing was ever placed where it *could* be pulled. The guarantee isn't a timer that someone set; it's the absence of a withdrawal function.

## What about depth?

Depth — how much you can trade before slippage bites — is the half of this signal that does mean something, but it works differently for a par token.

A signature token is minted with a [large fixed supply — about a billion units by default](/reflector/fdv/), all of it on the bid side of the pool. That deliberately large supply gives the pool enough granularity that ordinary swap sizes barely move the inventory. From a trader's seat, the signature token behaves like a deep-liquidity wrapped version of the original.

But depth here is bounded by the backing on the *other* side of the corridor. As people buy, real backing accumulates in the pool; you can always sell back into exactly that. You're never depending on a third-party market maker to be there — the redemption path is the pool itself, at par, by construction.

## What to look at instead

Don't hunt for a lock contract; there isn't one and doesn't need to be. The two facts that replace the whole "is the liquidity safe?" investigation:

1. **No withdrawal path exists** — verifiable from the [Fountain](/unispring/fountain/) clone, not promised by anyone.
2. **The corridor holds at par** — see [Peg mechanics](/reflector/mechanics/).

## Further reading

- [Why a signature token needs no reputation](/reflector/reputation/) — the unifying argument
- [Peg mechanics: why the backing is permanent](/reflector/mechanics/#why-the-backing-is-permanent)
- [About the FDV](/reflector/fdv/) — why the billion-unit supply is a depth feature, not a warning
