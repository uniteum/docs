---
title: $USDC
description: Documentation shorthand for the USDC anchored unit
parent: Anchored Units
nav_order: 2

# Metadata
last_updated: 2024-12-18
---

# $USDC (USD Coin)

**Documentation Shorthand:** `$USDC`
**Actual Symbol:** `$0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48`

## What This Represents

In Uniteum documentation, `$USDC` is a **readable shorthand** for an anchored unit backed by [USD Coin (USDC)](https://etherscan.io/address/0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48).

The actual Uniteum symbol uses the full USDC contract address:
```
$0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48
```

## Backing Token

**USDC Contract:** [`0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48`](https://etherscan.io/address/0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48)

USD Coin is a stablecoin pegged to the US Dollar, issued by Circle. Intended to maintain 1 USDC = $1 USD.

## Anchored Unit Details

**Type:** Anchored (backed 1:1 by real USDC)
**Custodian:** Uniteum contract holding the USDC
**Redeemable:** Yes, burn the anchored unit to retrieve USDC
**Trust Model:** Smart contract custody (unaudited)

## Key Distinctions

| Symbol | Type | Backing |
|--------|------|---------|
| `$0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48` | Anchored unit | 1:1 USDC in contract |
| `USDC` (no $) | Symbolic unit | None (just a label) |
| `USD` (no $) | Symbolic unit | None (NOT US dollars!) |
| `$USDC` | Documentation shorthand | Refers to anchored version |

**Critical:** Symbolic `USDC` or `USD` ≠ Anchored `$0xA0b8...eB48` ≠ Real US Dollars

Anyone can create symbolic units with labels like "USDC" or "USD". They have NO connection to real stablecoins or US currency.

## Creating This Unit

```solidity
// Get the "1" token contract
IUnit one = IUnit({% include uniteum_address.html %});

// Create anchored USDC unit
IERC20 usdc = IERC20({{ site.data.contracts.tokens.usdc.mainnet }});
IUnit usdcUnit = one.anchored(usdc);

// usdcUnit.symbol() returns: "${{ site.data.contracts.tokens.usdc.mainnet }}"
```

## Reciprocal Unit: Depeg Hedge

**`1/$USDC`** (shorthand) = `1/$0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48` (actual)

This is a **synthetic unit** (NOT backed) that acts as an automatic hedge against USDC depeg events.

### Depeg Protection Use Case

**The mechanism:** Price relationship enforced by invariant:
```
price($USDC) × price(1/$USDC) = constant
```

When USDC depegs, your `1/$USDC` gains offset losses:

| USDC Price | $USDC Value | 1/$USDC Value | Hedge Effect |
|------------|-------------|---------------|--------------|
| $1.00 | Parity | Parity | Balanced |
| $0.95 | ↓ 5% | ↑ 5.3% | Slight gain |
| $0.90 | ↓ 10% | ↑ 11.1% | Offset |
| $0.50 | ↓ 50% | ↑ 100% | Strong protection |

**No oracles, no collateral, no liquidations** — the reciprocal relationship is mathematically enforced.

See [Use Cases: Stablecoin Depeg Protection](/use-cases/#stablecoin-depeg-protection).

## Example Derivatives

### Ratio Units (Pair Trading)

**`$WETH/$USDC`** — ETH/USD price ratio:
- This token IS the price of ETH in USD terms
- `price($WETH/$USDC) = price($WETH) / price($USDC)`
- Long ETH, short USD in one token
- Arbitrage keeps it aligned with external markets

**`$WBTC/$USDC`** — BTC/USD price ratio:
- Similar to above, for Bitcoin

### Complex Combinations

**`$WETH^2/$USDC`** — Squared ETH exposure vs stable:
- Leveraged long ETH, denominated in USD terms
- If ETH 2x, this goes ~4x

**`1/($WETH*$USDC)`** — Inverse of ETH price:
- Gains when ETH dumps (priced in USDC)

## Forge Operations

### Minting the Anchored Unit

To create `$USDC` tokens:

1. Approve USDC spending to the anchored unit contract
2. Call `forge()` to deposit USDC and mint the anchored unit

The contract takes your USDC (1:1 backing) and mints the anchored unit.

### Redeeming for USDC

To get USDC back:

1. Call `forge()` with negative parameters to burn the anchored unit
2. Receive USDC from the contract

## Stablecoin Considerations

**Why use `$USDC` instead of just USDC?**

1. **Composability:** Can create derivatives (`$WETH/$USDC`, ratios, powers)
2. **Depeg hedge:** Access to `1/$USDC` for automatic protection
3. **Unified liquidity:** Part of Uniteum's interconnected mesh
4. **Forge operations:** Price control via minting/burning

**Trade-off:** Smart contract custody risk (unaudited) vs benefits above.

## Related Documentation

- [Token Reference](/reference/anchored-units/) — All common shorthands
- [Anchored Units Concept](/concepts/units/#anchored-units)
- [Use Cases: Hedging](/use-cases/#hedging-with-reciprocals)
- [Economics of "1"](/economics-of-one/) — How stablecoin collateral stabilizes "1"

---

**Remember:** In your code, use the full address `$0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48`. The `$USDC` shorthand is for documentation readability only.
