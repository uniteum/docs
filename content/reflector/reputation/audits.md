---
title: Audits
weight: 2
---
# Audits

**The signal:** Has the contract been audited? By whom? Is the report public? A clean audit from a respected firm is shorthand for "experts looked for the ways this code could lose or steal your money, and didn't find a fatal one."

For an ordinary token the audit question is doing real work, because an ordinary token is a *bespoke contract*. It may carry a mint function, an owner role, a pausable transfer, a hidden fee-on-transfer, an upgradeable proxy — any of which is a lever someone could pull against holders. The audit's job is to enumerate those levers and judge whether they're safe. Every new token is a new attack surface, so every new token wants its own audit.

## Why it doesn't apply

A [signature token](/reflector/) is not a bespoke contract. It's a stamped output of a factory, and that changes what an audit could even tell you.

**Every signature token is byte-identical.** A signature token is a [Coinage](https://github.com/uniteum/lepton) ERC-20 with no custom logic — no mint, no owner, no pause, no upgrade. The deployed code is the same for "Happy Birthday from Dad" as for any other signature token in the family; only the name, decimals, and supply differ. Auditing one signature token audits all of them. There is no per-token surface to review, because there is no per-token code.

**The peg isn't enforced by auditable cleverness.** A wrapped token's peg usually depends on logic that *could* be wrong — a rebalance keeper, an oracle read, a redemption function with edge cases. A signature token has none of that. The corridor is held by [Uniswap V4's own swap math](/reflector/mechanics/#why-the-band-cant-be-broken): there is no liquidity outside the seeded tick, and V4 cannot cross an empty tick. The guarantee is geometric. There is no peg-keeping code to find a bug in, because there is no peg-keeping code.

So the thing an audit checks for — discretionary levers and clever logic that might fail — has been designed out, not reviewed and blessed.

## Be honest about the residual risk

This is not a claim that there is *no* smart-contract risk. It relocates the risk and shrinks it:

- The **factory** (the [Reflector prototype](/reflector/reference/) and the [Fountain](/unispring/fountain/) primitive it builds on) is real code that could, in principle, contain a flaw. It is shared by every signature token, so it's the one thing worth scrutinizing — once, for all signature tokens.
- **Uniswap V4** is a dependency. The peg is exactly as sound as V4's core accounting.
- These are [Bitsy contracts](/bitsy/): immutable, unaudited prototype code. The [project status](/) is explicit that there is no formal audit and the mechanism is novel.

The point isn't "audits are unnecessary." It's that a *per-token* audit is meaningless — the unit of review is the factory, not the token — and that the surface a token audit normally guards (mint, owner, upgrade, peg logic) doesn't exist on a signature token to begin with.

## What to look at instead

Read the factory once: the [peg mechanics](/reflector/mechanics/) and the [REFLECTOR.md](https://github.com/uniteum/unispring/blob/main/REFLECTOR.md) peg argument tell you everything a per-token audit couldn't. After that, the only remaining risk lives in the backing token.

## Further reading

- [Why a signature token needs no reputation](/reflector/reputation/) — the unifying argument
- [Peg mechanics](/reflector/mechanics/) — the geometric guarantee an audit would otherwise check
- [Bitsy contracts](/bitsy/) — what "immutable, governance-free prototype" means
