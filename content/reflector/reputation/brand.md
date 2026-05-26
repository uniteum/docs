---
title: Brand, name & ticker
weight: 10
---
# Brand, name & ticker

**The signal:** Does the token have the *right* name and ticker? When you go to buy `USDC` or `UNI`, the symbol is how you find it and the brand is what you're trusting. A recognizable name carries the project's whole reputation in a few characters; an impostor with a near-identical ticker is a classic scam.

For an ordinary token, the name and ticker are a proxy for **identity** — *am I dealing with the real project, or a copy?* This matters because an ordinary token's value is tied to a specific issuer's promises, so getting the wrong token with the right-looking name means trusting the wrong people. The defense is to learn which brand is legitimate and check the symbol against it.

But the symbol was never a reliable identifier. Anyone can deploy an ERC-20 with any `name` and `symbol` they like; ticker collisions and lookalike scams exist precisely because the on-chain symbol field is caller-supplied and unenforced. On an ordinary token, the brand is asked to do identity work that the symbol can't actually guarantee.

## Why it doesn't apply

A [signature token](/reflector/) doesn't ask the name to carry trust at all — and makes that explicit rather than pretending otherwise.

**The name is vanity by design.** When you call [`issue("Happy Birthday from Dad")`](/reflector/reference/#how-to-use-it), the name is whatever you typed. The symbol is the family's — `1xUSDC`, `1xETH` — and that too is [whatever the family's maker typed](/reflector/reference/#naming-convention); the `1x` convention is convention, not enforcement. Two people can mint different-named signature tokens under the same symbol and get two genuinely separate tokens. The name distinguishes signature tokens for humans; it confers nothing.

**Authority lives in the address and the backing, not the brand.** What makes a par token redeemable isn't its name — it's that its specific contract address holds a [fixed supply against a locked pool](/reflector/reputation/liquidity/) of a specific backing token. A copy with an identical name is simply a *different* token with its *own* backing; it can't drain or impersonate yours, because there's no shared issuer whose reputation a lookalike could hijack. The thing a brand normally protects — "the issuer's promises" — doesn't exist here, so there's nothing for a lookalike to steal.

This inverts the usual posture. On an ordinary token, an unfamiliar or duplicated name is a warning. On a par token it's expected: the name is a label, the address is the identity, and the backing is the value. A signature token called "USDC" wouldn't be dangerous *or* valuable on account of the name — only its address and what backs it would tell you anything.

## The one identity check that matters

Because the name proves nothing, verifying a par token is purely an **address** exercise — and a tractable one, because signature-token addresses are [deterministic in `(clone, name)`](/reflector/reference/#how-the-factory-is-laid-out). You can compute the address a signature token *should* have and confirm the token you're looking at is that one. The [par-tokens directory](/reflector/par-tokens/) lists the canonical address for each signature token, and registries check token-info updates against the [deployer address](/reflector/reference/#how-to-use-it), not the name.

## What to look at instead

Don't trust the name or ticker to tell you what you've got. Check:

- **The contract address** against the [par-tokens directory](/reflector/par-tokens/) or the deterministic prediction.
- **The backing token** the address actually pegs to — that's the value, regardless of what the signature token is called.

## Further reading

- [Why a signature token needs no reputation](/reflector/reputation/) — the unifying argument
- [Listings & rankings](/reflector/reputation/listings/) — why finding the right token is an address question, not a listing one
- [Factory reference: naming convention](/reflector/reference/#naming-convention) — how names and symbols are assigned
