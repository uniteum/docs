---
title: Reputation signals
weight: 7
bookCollapseSection: true
---
# Why a signature token needs no reputation

Before you touch an ordinary token, you check it out. Who's behind it? Is the contract audited? Is the liquidity locked? How many holders, how much volume, how long has it been around, is it listed anywhere? Each of these is a **reputation signal** — and each is really a proxy for one question:

> *If I put value into this token, will I be able to get it back out — or will someone rug, dilute, or abandon it first?*

You check reputation because an ordinary token's worth is **discretionary**. It depends on people keeping promises and on a market continuing to care. You can't see the future, so you reach for proxies: a doxxed team is *probably* less likely to run; a locked LP *probably* won't be pulled; a long track record *probably* means it won't rug tomorrow. Probably. The signals are educated guesses about human behavior.

A [signature token](/reflector/) is different in kind. Its value is **mechanical**, not discretionary. Every unit is redeemable 1:1 for a real backing token through a Uniswap pool whose entire supply is locked and that [nobody — including the deployer — can unwind](/reflector/mechanics/#why-the-backing-is-permanent). The supply is fixed at mint, no authority is retained, and the [1-basis-point corridor](/reflector/mechanics/) is enforced by pool geometry, not by anyone's good behavior.

So the trust question is already answered — by construction, in the contract, the same way for every signature token ever minted. And once the question is answered, the proxies that estimate the answer have nothing left to do.

This section takes the ten signals people use to judge a token, one page each. For each it asks the same three things: what the signal really measures, why an ordinary token needs it, and why it's either **moot or actively misleading** when pointed at a par token.

## The signals

| Signal | The trust question it proxies | Why it's moot for a signature token |
|:--|:--|:--|
| [The team behind it](/reflector/reputation/team/) | Will the people run or rug? | No one retains authority; the deployer is powerless |
| [Audits](/reflector/reputation/audits/) | Does the code hide a rug? | The trust surface is geometric and tiny; every signature token is byte-identical |
| [Locked & deep liquidity](/reflector/reputation/liquidity/) | Will the liquidity be pulled? | The supply *is* the liquidity, locked with no withdrawal path |
| [Holder distribution](/reflector/reputation/holders/) | Will a whale dump on me? | A whale can't push price below the floor |
| [Trading volume](/reflector/reputation/volume/) | Can I get out when I want? | The pool is always there at par; you never need volume to exit |
| [Age & track record](/reflector/reputation/age/) | Has it survived without rugging? | It can't rug at any age; a one-block-old signature token has the same guarantee |
| [Listings & rankings](/reflector/reputation/listings/) | Has a gatekeeper vetted it? | Listings vet discretionary risk that isn't here; rankings mislead |
| [Community & social proof](/reflector/reputation/community/) | Will demand hold up? | Value doesn't depend on anyone caring |
| [Tokenomics & supply controls](/reflector/reputation/tokenomics/) | Will I be diluted? | There is nothing to dilute with — fixed supply, no mint, no treasury |
| [Brand, name & ticker](/reflector/reputation/brand/) | Is this the "real" one? | The name is vanity; only the address and the backing carry weight |

## The one thing that does matter

Stripping away reputation doesn't make a signature token risk-free. It relocates *all* of the risk to a single place: **the backing token**. A signature token inherits every risk of the original it mirrors — if the backing depegs, freezes, or fails, the signature token follows it down. The peg only promises that the signature token tracks the original; it makes no promise about the original itself.

So the checklist collapses from a dozen fuzzy human-behavior proxies to two mechanical facts you can verify directly:

1. **The peg holds** — verifiable from the pool, not from anyone's word. See [Peg mechanics](/reflector/mechanics/).
2. **The backing is sound** — the only judgment call left, and it's a judgment about the *original*, not the signature token.

That's the whole point of the section: a par token doesn't ask you to trust it, so it doesn't need to earn a reputation.

## Further reading

- [Reflector](/reflector/) — what a par token is and how to use one
- [Peg mechanics](/reflector/mechanics/) — why the corridor is hard and the backing permanent
- [About the FDV](/reflector/fdv/) — why the headline valuation is harmless
- [The $0 price display](/unispring/price-display/) — why a tracker can show $0, and why it isn't a defect
- [Par tokens](/reflector/par-tokens/) — the directory of signature tokens minted so far
