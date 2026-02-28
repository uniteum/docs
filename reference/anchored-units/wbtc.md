---
title: 0xWBTC
description: Documentation shorthand for the WBTC anchored unit
parent: Anchored Units
nav_order: 4

# Metadata
last_updated: 2024-12-18
---

# 0xWBTC (Wrapped Bitcoin)

**Documentation Shorthand:** `0xWBTC`
**Actual Symbol:** `$0x2260FAC5E5542a773Aa44fBCfEDf7C193bc2C599`

## What This Represents

{% assign wbtc = site.data.tokens.wbtc -%}
In Uniteum documentation, `0xWBTC` is a **readable shorthand** for an anchored unit backed by {% include token.html address=wbtc.mainnet text="Wrapped Bitcoin (WBTC)" %}.

The actual Uniteum symbol uses the full WBTC contract address:
```
${{ wbtc.mainnet }}
```

## Backing Token

**WBTC Contract:** {% include token.html address=wbtc.mainnet text=wbtc.mainnet %}

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
| `WBTC` (no $) | Floating unit | None (just a label) |
| `BTC` (no $) | Floating unit | None (NOT Bitcoin!) |
| `0xWBTC` | Documentation shorthand | Refers to anchored version |

## Creating This Unit

```solidity
// Get the "1" token contract
IUnit one = IUnit({% include uniteum_address.html %});

// Create anchored WBTC unit
IERC20 wbtc = IERC20({{ site.data.tokens.wbtc.mainnet }});
IUnit wbtcUnit = one.anchored(wbtc);

// wbtcUnit.symbol() returns: "${{ site.data.tokens.wbtc.mainnet }}"
```

## Reciprocal Unit

**`1/0xWBTC`** (shorthand) = `1/$0x2260FAC5E5542a773Aa44fBCfEDf7C193bc2C599` (actual)

Synthetic unit providing inverse BTC exposure. If BTC dumps, `1/0xWBTC` gains.

## Example Derivatives

### Crypto Basket

**`0xWETH*0xWBTC`** — Diversified ETH+BTC exposure:
- `price(0xWETH*0xWBTC) = price(0xWETH) × price(0xWBTC)`
- Gains when either asset pumps
- Permissionless crypto index

**`0xWETH*0xWBTC*0xLINK`** — Three-token basket:
- Add more assets for further diversification

### Relative Value Trading

**`0xWBTC/0xWETH`** — BTC/ETH price ratio:
- Don't care about USD price
- Only care about BTC vs ETH
- Oracle-free pair trading
- Long BTC, short ETH in one token

**`0xWETH/0xWBTC`** — Inverse ratio (ETH/BTC):
- Long ETH, short BTC

### Power Perpetuals

**`0xWBTC^2`** — Squared Bitcoin exposure:
- If BTC 2x → this goes 4x
- Leverage without borrowing

**`0xWBTC^2/0xUSDC`** — Squared BTC vs stable:
- Leveraged BTC exposure denominated in USD terms

## Correlation Trading

Bitcoin and Ethereum often move together but not perfectly:

**Long `0xWBTC/0xWETH`, short `0xWBTC*0xWETH`:**
- Profits when correlation between BTC and ETH changes
- If they diverge (BTC up, ETH down or vice versa), gain
- If they move together, neutral

See [Use Cases: Correlation Trading](/use-cases/#correlation-trading).

## Related Documentation

- [Anchored Units](/reference/anchored-units/) — All common shorthands
- [0xWETH](/reference/anchored-units/weth/) — Ethereum counterpart
- [Use Cases: Multi-Token Derivatives](/use-cases/#multi-token-derivatives)
- [Economics of "1"](/economics-of-one/) — How BTC collateral affects system value

---

**Remember:** In your code, use the full address `$0x2260FAC5E5542a773Aa44fBCfEDf7C193bc2C599`. The `0xWBTC` shorthand is for documentation readability only.
