---
title: 0xUSDC
description: Documentation shorthand for the USDC anchored unit
parent: Reference
grand_parent: Uniteum
nav_order: 2

# Metadata
last_updated: 2024-12-18
---

# 0xUSDC (USD Coin)

**Documentation Shorthand:** `0xUSDC`
**Actual Symbol:** `0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48`

## What This Represents

{% assign usdc = site.data.tokens.USDC -%}
In Uniteum documentation, `0xUSDC` is a **readable shorthand** for an anchored unit backed by {% include token.html address=usdc.address text="USD Coin (USDC)" %}.

The actual Uniteum symbol uses the full USDC contract address:
```
{{ usdc.address }}
```

## Backing Token

**USDC Contract:** {% include token.html address=usdc.address text=usdc.address %}

USD Coin is a stablecoin pegged to the US Dollar, issued by Circle. Intended to maintain 1 USDC = $1 USD.

## Anchored Unit Details

**Type:** Anchored (backed 1:1 by real USDC)
**Custodian:** Uniteum contract holding the USDC
**Redeemable:** Yes, burn the anchored unit to retrieve USDC
**Trust Model:** Smart contract custody (unaudited)

## Key Distinctions

| Symbol | Type | Backing |
|--------|------|---------|
| `0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48` | Anchored unit | 1:1 USDC in contract |
| `USDC` (no $) | Floating unit | None (just a label) |
| `USD` (no $) | Floating unit | None (NOT US dollars!) |
| `0xUSDC` | Documentation shorthand | Refers to anchored version |

**Critical:** Floating `USDC` or `USD` ≠ Anchored `0xA0b8...eB48` ≠ Real US Dollars

Anyone can create floating units with labels like "USDC" or "USD". They have NO connection to real stablecoins or US currency.

## Creating This Unit

```solidity
// Get the "1" token contract
IUnit one = IUnit({% include uniteum_address.html %});

// Create anchored USDC unit
IERC20 usdc = IERC20({{ site.data.tokens.USDC.address }});
IUnit usdcUnit = one.anchored(usdc);

// usdcUnit.symbol() returns: "{{ site.data.tokens.USDC.address }}"
```

## Reciprocal Unit: Depeg Hedge

**`1/0xUSDC`** (shorthand) = `1/0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48` (actual)

This is a **synthetic unit** (NOT backed) that acts as an automatic hedge against USDC depeg events.

### Depeg Protection Use Case

**The mechanism:** Price relationship enforced by invariant:
```
price(0xUSDC) × price(1/0xUSDC) = constant
```

When USDC depegs, your `1/0xUSDC` gains offset losses:

| USDC Price | 0xUSDC Value | 1/0xUSDC Value | Hedge Effect |
|------------|-------------|---------------|--------------|
| $1.00 | Parity | Parity | Balanced |
| $0.95 | ↓ 5% | ↑ 5.3% | Slight gain |
| $0.90 | ↓ 10% | ↑ 11.1% | Offset |
| $0.50 | ↓ 50% | ↑ 100% | Strong protection |

**No oracles, no collateral, no liquidations** — the reciprocal relationship is mathematically enforced.

See [Use Cases: Stablecoin Depeg Protection](/uniteum/use-cases/#stablecoin-depeg-protection).

## Example Derivatives

### Ratio Units (Pair Trading)

**`0xWETH/0xUSDC`** — ETH/USD price ratio:
- This token IS the price of ETH in USD terms
- `price(0xWETH/0xUSDC) = price(0xWETH) / price(0xUSDC)`
- Long ETH, short USD in one token
- Arbitrage keeps it aligned with external markets

**`0xWBTC/0xUSDC`** — BTC/USD price ratio:
- Similar to above, for Bitcoin

### Complex Combinations

**`0xWETH^2/0xUSDC`** — Squared ETH exposure vs stable:
- Leveraged long ETH, denominated in USD terms
- If ETH 2x, this goes ~4x

**`1/(0xWETH*0xUSDC)`** — Inverse of ETH price:
- Gains when ETH dumps (priced in USDC)

## Forge Operations

### Minting the Anchored Unit

To create `0xUSDC` tokens:

1. Approve USDC spending to the anchored unit contract
2. Call `forge()` to deposit USDC and mint the anchored unit

The contract takes your USDC (1:1 backing) and mints the anchored unit.

### Redeeming for USDC

To get USDC back:

1. Call `forge()` with negative parameters to burn the anchored unit
2. Receive USDC from the contract

## Stablecoin Considerations

**Why use `0xUSDC` instead of just USDC?**

1. **Composability:** Can create derivatives (`0xWETH/0xUSDC`, ratios, powers)
2. **Depeg hedge:** Access to `1/0xUSDC` for automatic protection
3. **Unified liquidity:** Part of Uniteum's interconnected mesh
4. **Forge operations:** Price control via minting/burning

**Trade-off:** Smart contract custody risk (unaudited) vs benefits above.

## Related Documentation

- [Anchored Units](/uniteum/reference/anchored-units/) — All common shorthands
- [Anchored Units Concept](/uniteum/concepts/units/#anchored-units)
- [Use Cases: Hedging](/uniteum/use-cases/#hedging-with-reciprocals)
- [Economics of "1"](/uniteum/economics-of-one/) — How stablecoin collateral stabilizes "1"

---

**Remember:** In your code, use the full address `0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48`. The `0xUSDC` shorthand is for documentation readability only.
