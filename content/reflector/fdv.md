---
title: About the FDV
weight: 3
---
# Why a signature token's FDV looks astronomical

When you look up a Reflector signature token on a price tracker, the fully diluted valuation will look insane. For an ETH-backed signature token it's roughly **$2.3 trillion**. For a USDC- or other stablecoin-backed signature token it's **1 billion of that token** — $1 billion for USD stables. Other backing tokens scale the same way: 1 billion of whatever the original is, valued at whatever a billion of that token is worth.

These numbers are real. They are not warning signs. This page explains why.

---

## Where the number comes from

Every Reflector signature token mints a fixed supply whose [decimal amount](/glossary/#decimal-amount) is 1 billion tokens, scaled on-chain by the backing token's `decimals()`. The peg holds the price tightly close to 1:1 against the original, so the FDV simplifies to:

```
FDV ≈ 1,000,000,000 × (price of one backing token)
```

| Backing token | Approx FDV (in backing units) | Approx FDV (USD) |
|:---|:---|:---|
| ETH | 1 billion ETH | ~$2.3 trillion |
| USDC, USDT, DAI, etc. | 1 billion of that stable | $1 billion |
| Any other ERC-20 | 1 billion of that token | a billion × spot price |

Why a billion? It's an artifact of how the supply is sized to fit Uniswap V4's tick geometry. The Reflector factory mints an [integer amount](/glossary/#integer-amount) of `10²⁷` for any original with 18 or more decimals, and scales down by a factor of 10 per decimal below 18 — which keeps the decimal amount at a billion across originals. See [Peg mechanics](/reflector/mechanics/) for the geometric reasoning.

---

## Why the giant number is harmless

For an ordinary token, a giant FDV is a warning. It usually means a small fraction of supply is circulating and the rest sits in a treasury, vesting contract, or insider wallet — ready to dump on holders later.

A signature token inverts that picture. **Every single token of supply is already in the pool**, seated in a Uniswap position whose principal nobody — including the deployer — can withdraw. There is:

- No team allocation
- No vesting schedule, no unlocks
- No treasury
- No mint authority
- No insider stash

The FDV is a theoretical ceiling no one could come close to reaching. To buy a meaningful fraction of supply, you'd have to swap in an equally meaningful fraction of the original — for an ETH-backed signature token, that would mean putting up more than all the ETH in existence. Long before this happened, the pool would have run out of original to absorb (the pool's math caps fills inside the seeded tick).

The number you see exists because the pool needs a billion units of the new token sitting on the bid side to give buyers something to swap into. That's it. It's a supply scoreboard, not a debt overhang.

---

## Why isn't supply just smaller?

A smaller supply would look more "normal" but doesn't help users. The peg corridor is set by Uniswap tick geometry, not by total supply. A signature token with only 1,000 units would peg the same way — but each unit would represent a much larger share of the pool, so a single buy would deplete more of the bid side and Uniswap-routed depth would feel artificially thin.

A billion-unit supply gives the pool enough granularity that ordinary swap sizes barely move the inventory. From a trader's perspective, a signature token behaves like a deep-liquidity wrapped version of the original.

---

## What to look at instead

If you're using a Reflector signature token, the FDV column is something to ignore. The numbers that actually matter are:

- **Spot price** — should be 1:1 with the original, within 1 bp
- **Pool depth** — how much you can swap before slippage matters
- **The backing token** — the signature token inherits all of the original's risks

The FDV figure on a tracker is correct, just irrelevant.

---

## Further reading

- [Plain-English intro](/reflector/)
- [Factory reference](/reflector/reference/) — the factory and operations
- [Peg mechanics](/reflector/mechanics/) — why the corridor is hard
- [Reputation signals](/reflector/reputation/) — why the FDV rank, and every other reputation metric, is moot here
