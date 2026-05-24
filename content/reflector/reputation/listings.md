---
title: Listings & rankings
weight: 7
---
# Listings & rankings

**The signal:** Is the token listed on a major exchange? Does it appear on CoinGecko or CoinMarketCap with a logo, a description, a market-cap rank? Listings are a gatekeeper's stamp: someone with a reputation to protect agreed to carry it, which implies they did *some* diligence. Rank is the follow-on — where the token sits on the leaderboard by market cap or volume.

For an ordinary token, both are proxies for legitimacy:

- **A listing says "vetted."** A centralized exchange or a major tracker has a review process. Passing it filters out the most obvious scams, so a listing borrows the gatekeeper's credibility.
- **A rank says "significant."** A top-200 market cap implies a real, liquid, widely-held asset; an unranked token implies the opposite.

## Why it doesn't apply

A [Reflector issue](/reflector/) breaks both — the listing tells you nothing it should, and the ranking tells you something false.

**A listing vets discretionary risk that a par token doesn't carry.** Exchange and tracker review processes are built to catch the failure modes of *ordinary* tokens: hidden mint functions, owner backdoors, fake teams, unlocked liquidity. A par token has [none of those surfaces](/reflector/reference/#trust-boundary) for a gatekeeper to find or miss. So a listing can't add safety it already has by construction, and the *absence* of a listing can't subtract any. An unlisted Reflector issue is exactly as redeemable as a listed one — and many issues (a personal gift token, a one-off for an event) will never be submitted anywhere, by design.

There's also a structural reason listings come slowly or not at all: **anyone can mint a fresh issue, and there are unbounded many of them.** Trackers and exchanges curate scarce, individually-notable assets. A factory that lets anyone stamp a new ERC-20 in one transaction produces exactly what a curator filters out. That's the factory working as intended, not a mark against any issue.

**The ranking actively misleads.** Where a par token *does* appear on a tracker, it shows up with an [astronomical fully diluted valuation](/reflector/fdv/) — roughly $2.3 trillion for an ETH-backed issue, a billion of the backing token for a stablecoin-backed one. A naïve leaderboard would rank a brand-new gift token above most real projects on Earth. The number is correct and completely irrelevant; it's an artifact of the [billion-unit supply sized to fit Uniswap's tick geometry](/reflector/fdv/#where-the-number-comes-from), every unit of which sits in the pool. Reading rank off it is reading a scoreboard that's measuring the wrong game.

## What to look at instead

Don't treat a listing as a safety check or a ranking as a measure of significance. The legitimacy a listing is supposed to confer is already in the contract:

- **Verify the issue's address directly** on the block explorer — the [par-tokens directory](/reflector/par-tokens/) links each one, and the [factory reference](/reflector/reference/#how-to-use-it) shows how addresses are deterministic in `(clone, name)`.
- **Ignore the FDV rank entirely.** See [About the FDV](/reflector/fdv/) for why.

## Further reading

- [Why a Reflector issue needs no reputation](/reflector/reputation/) — the unifying argument
- [About the FDV](/reflector/fdv/) — why the headline valuation, and any ranking built on it, is harmless
- [Brand, name & ticker](/reflector/reputation/brand/) — why finding the right token is an address question, not a listing question
