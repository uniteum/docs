---
title: Tokenomics & supply controls
weight: 9
---
# Tokenomics & supply controls

**The signal:** What's the supply schedule? Is there a mint function, and who can call it? How much went to the team, to investors, to a treasury — and on what vesting cliffs and unlock dates? What's the emission rate? Sophisticated buyers read a token's "tokenomics" the way an equity analyst reads a cap table, because it tells them how much of their position can be **diluted out from under them**, and by whom, and when.

For an ordinary token this is among the most important checks, because the dangerous levers are all here:

- **A live mint function** means someone can print more supply and dilute every holder.
- **Team and investor allocations** sitting outside circulation are a future sell wall — the "low float, high FDV" setup where a small circulating supply props up a price that collapses when unlocks hit.
- **Emissions** (staking rewards, liquidity mining) dilute holders continuously to pay newcomers.

Reading tokenomics is forecasting *who gets to issue claims against your share, and when.*

## Why it doesn't apply

A [signature token](/reflector/) has no tokenomics in this sense. There are no levers, because the supply is settled completely at the moment of mint.

- **No mint function.** The signature token is a [Coinage](https://github.com/uniteum/lepton) ERC-20 with a supply fixed at deployment. Nobody — deployer included — can ever increase it. Dilution by issuance is not restricted; it is *absent*.
- **No allocations, no vesting, no unlocks.** There is no team slice, no investor tranche, no treasury held back to release later. The [entire supply is seated in the pool](/reflector/reputation/liquidity/) in the same transaction that creates the token. There is no float-versus-fully-diluted gap, because float *is* fully diluted on day one.
- **No emissions.** Nothing is minted over time to reward anyone. The only ongoing flow is the [0.01% swap fee](/reflector/reference/#trust-boundary), which comes out of trade volume — not out of new supply, and not out of holders' shares.

So every question tokenomics analysis exists to answer resolves to the same trivial answer: the supply is what it is, it can't change, and no one holds a claim to expand it. There's no cap table to read because there's only one line on it, locked.

## The supply number itself

A par token *does* have a conspicuous supply figure — about a billion units, producing an [enormous fully diluted valuation](/reflector/fdv/). For an ordinary token that figure would be the centerpiece of a tokenomics critique: huge FDV, who's holding the unlocks? For a par token it's inert. Every one of those billion units is already in the pool, backed and redeemable; none is waiting in a vesting contract to be sold into you. The [FDV page](/reflector/fdv/) covers why the headline number is a supply scoreboard, not a debt overhang — that's the same point this signal would otherwise raise, so it isn't repeated here.

## What to look at instead

There's no supply schedule to model and no unlock calendar to track. What replaces the entire exercise:

- **Supply is fixed and fully in the pool** — verifiable from the contract and the [trust boundary](/reflector/reference/#trust-boundary).
- **The backing token's *own* tokenomics** — if the original has a mint function or unlock schedule, the signature token inherits that exposure indirectly. The only cap table worth reading is the original's.

## Further reading

- [Why a signature token needs no reputation](/reflector/reputation/) — the unifying argument
- [About the FDV](/reflector/fdv/) — why the billion-unit supply and its valuation are harmless
- [The team behind it](/reflector/reputation/team/) — the matching "who holds power over the token?" question
