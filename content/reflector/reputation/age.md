---
title: Age & track record
weight: 6
---
# Age & track record

**The signal:** How long has this token been around? A contract deployed years ago that's still trading, still paying out, still pegged, carries a quiet credibility a fresh deployment can't. "It's been live since 2021 and never broke" is one of the strongest endorsements a token can have.

For an ordinary token, age is a proxy for **survivorship**: every day it *doesn't* rug, depeg, or get drained is a day of evidence that it probably won't tomorrow. You can't inspect the future, so you treat the past as a sample. A long, clean history is a large sample; a fresh deployment is a sample of one block. This is the Lindy intuition — the longer a thing has lasted, the longer you expect it to keep lasting.

The intuition is sound *for tokens whose survival is in question* — tokens that could rug, whose peg depends on someone's continued good behavior, whose history is genuinely informative because the outcome was genuinely uncertain.

## Why it doesn't apply

A [signature token](/reflector/) can't fail in the ways age is meant to rule out, so the passage of time adds no information.

**There's no rug to survive.** Age earns trust by accumulating days-without-disaster. But a par token's disasters — liquidity pull, mint dilution, peg-keeper failure, admin drain — are [structurally impossible](/reflector/reference/#trust-boundary), not merely *avoided so far*. The backing has [no withdrawal path](/reflector/mechanics/#why-the-backing-is-permanent), the supply has no mint function, and the peg is [held by pool geometry](/reflector/mechanics/), not by a keeper that has to keep working. A track record is evidence that a risk hasn't materialized. When the risk can't materialize, the evidence is redundant.

**A one-block-old signature token has the identical guarantee.** Two signature tokens in the same family — one minted a year ago, one minted in the last block — are byte-identical [Coinage](https://github.com/uniteum/lepton) ERC-20s with the same fixed supply, the same corridor, the same locked backing. The older one has done nothing to become safer; the newer one is missing nothing. Their redemption guarantees are equal on day one. The history of the old one tells you about *the backing token's* history, not the signature token's.

So "how long has it been around?" has no bearing on whether a par token will pay out. The answer is fixed at mint and doesn't improve with age.

## Where age does still live

The one place a track record retains meaning is the **backing token**, and the **factory**. A long-lived, battle-tested original (or a long-lived Reflector/Fountain factory and Uniswap V4 underneath it) is genuinely reassuring — but that's reputation accruing to the *original* and the *infrastructure*, not to your individual signature token. See [Audits](/reflector/reputation/audits/) for the same relocation of risk from signature token to factory.

## What to look at instead

Don't wait for a signature token to "prove itself" over time; there's nothing for time to prove. The judgment that replaces it is, once again, about the backing — and the backing's age is the only age worth weighing.

## Further reading

- [Why a signature token needs no reputation](/reflector/reputation/) — the unifying argument
- [Factory reference: trust boundary](/reflector/reference/#trust-boundary) — why the failure modes age guards against can't occur
- [Audits](/reflector/reputation/audits/) — the matching case that risk lives in the factory, not the signature token
