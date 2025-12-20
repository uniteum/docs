---
title: $USDT
description: Documentation shorthand for the USDT anchored unit
parent: Anchored Units
nav_order: 3

# Metadata
last_updated: 2024-12-18
---

# $USDT (Tether USD)

**Documentation Shorthand:** `$USDT`
**Actual Symbol:** `$0xdAC17F958D2ee523a2206206994597C13D831ec7`

## What This Represents

{% assign usdt = site.data.contracts.tokens.usdt -%}
In Uniteum documentation, `$USDT` is a **readable shorthand** for an anchored unit backed by {% include token.html address=usdt.mainnet text="Tether USD (USDT)" %}.

The actual Uniteum symbol uses the full USDT contract address:
```
${{ usdt.mainnet }}
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
| `$0xdAC17F958D2ee523a2206206994597C13D831ec7` | Anchored unit | 1:1 USDT in contract |
| `USDT` (no $) | Floating unit | None (just a label) |
| `$USDT` | Documentation shorthand | Refers to anchored version |

## Creating This Unit

```solidity
// Get the "1" token contract
IUnit one = IUnit({% include uniteum_address.html %});

// Create anchored USDT unit
IERC20 usdt = IERC20({{ site.data.contracts.tokens.usdt.mainnet }});
IUnit usdtUnit = one.anchored(usdt);

// usdtUnit.symbol() returns: "${{ site.data.contracts.tokens.usdt.mainnet }}"
```

## Reciprocal Unit

**`1/$USDT`** (shorthand) = `1/$0xdAC17F958D2ee523a2206206994597C13D831ec7` (actual)

Synthetic unit (not backed) that provides depeg hedge similar to `1/$USDC`.

See [$USDC: Depeg Protection](/reference/anchored-units/usdc/#reciprocal-unit-depeg-hedge) for mechanism details.

## Example Use Cases

### Stablecoin Arbitrage

With both [$USDC](/reference/anchored-units/usdc/) and `$USDT` anchored:

**`$USDC/$USDT`** — USDC/USDT price ratio:
- Should trade near 1.0 when both pegged
- Deviations create arbitrage opportunity
- Useful for stablecoin pair trading

### Diversified Stable Basket

**`$USDC*$USDT*$DAI`** — Multi-stablecoin exposure:
- Reduces single-stablecoin risk
- Diversified peg reliance

## Related Documentation

- [Anchored Units](/reference/anchored-units/) — All common shorthands
- [$USDC](/reference/anchored-units/usdc/) — Similar stablecoin with detailed examples
- [Use Cases: Hedging](/use-cases/#hedging-with-reciprocals)

---

**Remember:** In your code, use the full address `$0xdAC17F958D2ee523a2206206994597C13D831ec7`. The `$USDT` shorthand is for documentation readability only.
