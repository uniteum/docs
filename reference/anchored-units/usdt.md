---
title: 0xUSDT
description: Documentation shorthand for the USDT anchored unit
parent: Anchored Units
nav_order: 3

# Metadata
last_updated: 2024-12-18
---

# 0xUSDT (Tether USD)

**Documentation Shorthand:** `0xUSDT`
**Actual Symbol:** `0xdAC17F958D2ee523a2206206994597C13D831ec7`

## What This Represents

{% assign usdt = site.data.tokens.usdt -%}
In Uniteum documentation, `0xUSDT` is a **readable shorthand** for an anchored unit backed by {% include token.html address=usdt.mainnet text="Tether USD (USDT)" %}.

The actual Uniteum symbol uses the full USDT contract address:
```
{{ usdt.mainnet }}
```

## Backing Token

**USDT Contract:** {% include token.html address=usdt.mainnet text=usdt.mainnet %}

Tether USD is the largest stablecoin by market cap, pegged to the US Dollar. Intended to maintain 1 USDT = $1 USD.

## Anchored Unit Details

**Type:** Anchored (backed 1:1 by real USDT)
**Custodian:** Uniteum contract holding the USDT
**Redeemable:** Yes, burn the anchored unit to retrieve USDT
**Trust Model:** Smart contract custody (unaudited)

## Key Distinctions

| Symbol | Type | Backing |
|--------|------|---------|
| `0xdAC17F958D2ee523a2206206994597C13D831ec7` | Anchored unit | 1:1 USDT in contract |
| `USDT` (no $) | Floating unit | None (just a label) |
| `0xUSDT` | Documentation shorthand | Refers to anchored version |

## Creating This Unit

```solidity
// Get the "1" token contract
IUnit one = IUnit({% include uniteum_address.html %});

// Create anchored USDT unit
IERC20 usdt = IERC20({{ site.data.tokens.usdt.mainnet }});
IUnit usdtUnit = one.anchored(usdt);

// usdtUnit.symbol() returns: "{{ site.data.tokens.usdt.mainnet }}"
```

## Reciprocal Unit

**`1/0xUSDT`** (shorthand) = `1/0xdAC17F958D2ee523a2206206994597C13D831ec7` (actual)

Synthetic unit (not backed) that provides depeg hedge similar to `1/0xUSDC`.

See [0xUSDC: Depeg Protection](/reference/anchored-units/usdc/#reciprocal-unit-depeg-hedge) for mechanism details.

## Example Use Cases

### Stablecoin Arbitrage

With both [0xUSDC](/reference/anchored-units/usdc/) and `0xUSDT` anchored:

**`0xUSDC/0xUSDT`** — USDC/USDT price ratio:
- Should trade near 1.0 when both pegged
- Deviations create arbitrage opportunity
- Useful for stablecoin pair trading

### Diversified Stable Basket

**`0xUSDC*0xUSDT*0xDAI`** — Multi-stablecoin exposure:
- Reduces single-stablecoin risk
- Diversified peg reliance

## Related Documentation

- [Anchored Units](/reference/anchored-units/) — All common shorthands
- [0xUSDC](/reference/anchored-units/usdc/) — Similar stablecoin with detailed examples
- [Use Cases: Hedging](/use-cases/#hedging-with-reciprocals)

---

**Remember:** In your code, use the full address `0xdAC17F958D2ee523a2206206994597C13D831ec7`. The `0xUSDT` shorthand is for documentation readability only.
