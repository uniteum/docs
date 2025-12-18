---
title: $WBTC
description: Documentation shorthand for the WBTC anchored unit
parent: Anchored Units
nav_order: 4

# Metadata
last_updated: 2024-12-18
---

# $WBTC (Wrapped Bitcoin)

**Documentation Shorthand:** `$WBTC`
**Actual Symbol:** `$0x2260FAC5E5542a773Aa44fBCfEDf7C193bc2C599`

## What This Represents

In Uniteum documentation, `$WBTC` is a **readable shorthand** for an anchored unit backed by [Wrapped Bitcoin (WBTC)](https://etherscan.io/address/0x2260FAC5E5542a773Aa44fBCfEDf7C193bc2C599).

The actual Uniteum symbol uses the full WBTC contract address:
```
$0x2260FAC5E5542a773Aa44fBCfEDf7C193bc2C599
```

## Backing Token

**WBTC Contract:** [`0x2260FAC5E5542a773Aa44fBCfEDf7C193bc2C599`](https://etherscan.io/address/0x2260FAC5E5542a773Aa44fBCfEDf7C193bc2C599)

Wrapped Bitcoin is Bitcoin represented as an ERC-20 token on Ethereum. 1 WBTC = 1 BTC, backed by Bitcoin held by custodians.

## Anchored Unit Details

**Type:** Anchored (backed 1:1 by real WBTC)
**Custodian:** Uniteum contract holding the WBTC
**Redeemable:** Yes, burn the anchored unit to retrieve WBTC
**Trust Model:** Smart contract custody (unaudited)

## Key Distinctions

| Symbol | Type | Backing |
|--------|------|---------|
| `$0x2260FAC5E5542a773Aa44fBCfEDf7C193bc2C599` | Anchored unit | 1:1 WBTC in contract |
| `WBTC` (no $) | Symbolic unit | None (just a label) |
| `BTC` (no $) | Symbolic unit | None (NOT Bitcoin!) |
| `$WBTC` | Documentation shorthand | Refers to anchored version |

## Creating This Unit

```solidity
// Get the "1" token contract
IUnit one = IUnit({% include uniteum_address.html %});

// Create anchored WBTC unit
IERC20 wbtc = IERC20({{ site.data.contracts.tokens.wbtc.mainnet }});
IUnit wbtcUnit = one.anchored(wbtc);

// wbtcUnit.symbol() returns: "${{ site.data.contracts.tokens.wbtc.mainnet }}"
```

## Reciprocal Unit

**`1/$WBTC`** (shorthand) = `1/$0x2260FAC5E5542a773Aa44fBCfEDf7C193bc2C599` (actual)

Synthetic unit providing inverse BTC exposure. If BTC dumps, `1/$WBTC` gains.

## Example Derivatives

### Crypto Basket

**`$WETH*$WBTC`** — Diversified ETH+BTC exposure:
- `price($WETH*$WBTC) = price($WETH) × price($WBTC)`
- Gains when either asset pumps
- Permissionless crypto index

**`$WETH*$WBTC*$LINK`** — Three-token basket:
- Add more assets for further diversification

### Relative Value Trading

**`$WBTC/$WETH`** — BTC/ETH price ratio:
- Don't care about USD price
- Only care about BTC vs ETH
- Oracle-free pair trading
- Long BTC, short ETH in one token

**`$WETH/$WBTC`** — Inverse ratio (ETH/BTC):
- Long ETH, short BTC

### Power Perpetuals

**`$WBTC^2`** — Squared Bitcoin exposure:
- If BTC 2x → this goes 4x
- Leverage without borrowing

**`$WBTC^2/$USDC`** — Squared BTC vs stable:
- Leveraged BTC exposure denominated in USD terms

## Correlation Trading

Bitcoin and Ethereum often move together but not perfectly:

**Long `$WBTC/$WETH`, short `$WBTC*$WETH`:**
- Profits when correlation between BTC and ETH changes
- If they diverge (BTC up, ETH down or vice versa), gain
- If they move together, neutral

See [Use Cases: Correlation Trading](/use-cases/#correlation-trading).

## Related Documentation

- [Token Reference](/reference/anchored-units/) — All common shorthands
- [$WETH](/reference/anchored-units/weth/) — Ethereum counterpart
- [Use Cases: Multi-Token Derivatives](/use-cases/#multi-token-derivatives)
- [Economics of "1"](/economics-of-one/) — How BTC collateral affects system value

---

**Remember:** In your code, use the full address `$0x2260FAC5E5542a773Aa44fBCfEDf7C193bc2C599`. The `$WBTC` shorthand is for documentation readability only.
