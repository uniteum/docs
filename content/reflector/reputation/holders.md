---
title: Holder distribution
weight: 4
---
# Holder distribution

**The signal:** How many holders does the token have, and how is it spread? A healthy-looking token has thousands of wallets and no single address holding a dangerous slice. A dangerous-looking one has ten holders, or one whale sitting on 40% of supply. Block explorers put a "Holders" count and a top-holders table right on the token page for exactly this reason.

For an ordinary token, distribution is a proxy for two fears:

- **Concentration → dump risk.** If one wallet holds a huge fraction, it can sell into the market and crater the price on everyone else.
- **Few holders → it's not real.** A token nobody holds is either brand new, abandoned, or a setup.

Both fears are downstream of the same thing: an ordinary token's price is a *consensus* that a big seller can break, and a thin holder base is a consensus that barely exists.

## Why it doesn't apply

A [Reflector issue](/reflector/) has no price consensus to break, so concentration carries no threat.

**A whale can't dump on you.** The price lives inside a [hard 1-basis-point corridor](/reflector/mechanics/) — it cannot fall below `1.0000×` the backing token, ever, because there's no liquidity below the seeded tick for a sell to push into. A holder of 90% of supply selling all of it doesn't crash the price; they walk it down the corridor and bottom out at the floor, handing every remaining holder a redemption at par. The worst a whale can do is *redeem their own tokens*. There is no mechanism by which one holder's exit damages another's.

**A low holder count means nothing.** A Reflector issue is frequently *supposed* to have one holder. If you mint "Birthday Cash for Sam," buy a hundred, and send them to one friend, the explorer shows two or three holders total — and that's the design working, not a red flag. The token is exactly as redeemable with one holder as with a million. Holder count measures popularity, and a par token's safety doesn't depend on popularity.

**The count is gameable anyway.** Holder numbers are trivial to inflate by dusting wallets, so even where they mean something they mean less than they look. For a par token they mean nothing to begin with.

## A note on the FDV table's cousin

The same explorer page that misreads a par token's [FDV](/reflector/fdv/) also misreads its holder distribution: it will flag "1 holder owns 100%" early in an issue's life as a concentration warning. It's describing the gift you just minted, not a risk. The metric is correct; the interpretation it invites is wrong.

## What to look at instead

Ignore both the holder count and the concentration table. Neither can tell you anything a par token's mechanics don't already guarantee. What replaces them:

- **The floor holds at par** — so no holder, however large, can sell below it. See [Peg mechanics](/reflector/mechanics/).
- **The backing token** — the only thing whose health actually affects you.

## Further reading

- [Why a Reflector issue needs no reputation](/reflector/reputation/) — the unifying argument
- [About the FDV](/reflector/fdv/) — the sibling metric that also misleads on a par token
- [Trading volume](/reflector/reputation/volume/) — the related "can I get out?" question
