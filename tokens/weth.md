---
title: $WETH
description: Documentation shorthand for the WETH anchored unit
parent: Token Reference
nav_order: 1

# Metadata
last_updated: 2024-12-11
version: "0.1"
---

# $WETH (Wrapped Ether)

**Documentation Shorthand:** `$WETH`
**Actual Symbol:** `$0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2`

## What This Represents

In Uniteum documentation, `$WETH` is a **readable shorthand** for an anchored unit backed by [Wrapped Ether (WETH)](https://etherscan.io/address/0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2).

The actual Uniteum symbol uses the full WETH contract address:
```
$0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2
```

## Backing Token

**WETH Contract:** [`0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2`](https://etherscan.io/address/0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2)

Wrapped Ether is ETH converted to an ERC-20 token for DeFi compatibility. 1 WETH = 1 ETH, redeemable 1:1.

## Anchored Unit Details

**Type:** Anchored (backed 1:1 by real WETH)
**Custodian:** Uniteum contract holding the WETH
**Redeemable:** Yes, burn the anchored unit to retrieve WETH
**Trust Model:** Smart contract custody (unaudited)

## Key Distinctions

| Symbol | Type | Backing |
|--------|------|---------|
| `$0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2` | Anchored unit | 1:1 WETH in contract |
| `WETH` (no $) | Symbolic unit | None (just a label) |
| `$WETH` | Documentation shorthand | Refers to anchored version |

**Critical:** Symbolic `WETH` ≠ Anchored `$0xC02a...56Cc2`

A symbolic unit with the label "WETH" has NO connection to real Wrapped Ether. Anyone can create it. It's worthless unless consensus gives it value.

## Creating This Unit

```solidity
// Get the "1" token contract
IUnit one = IUnit(0x9df9b0501e8f6c05623b5b519f9f18b598d9b253);

// Create anchored WETH unit
IERC20 weth = IERC20(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
IUnit wethUnit = one.anchored(weth);

// wethUnit.symbol() returns: "$0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2"
```

## Reciprocal Unit

Every anchored unit has a reciprocal:

**`1/$WETH`** (shorthand) = `1/$0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2` (actual)

This is a **synthetic unit** (NOT backed by WETH). Its price is the inverse of the WETH unit's price, enforced by the invariant.

### Hedging Use Case

Hold both `$WETH` and `1/$WETH`:

| WETH Price | $WETH Value | 1/$WETH Value | Net Effect |
|------------|-------------|---------------|------------|
| $2000 | 1× | 1× | Balanced |
| $3000 | ↑ 50% | ↓ 33% | Net gain |
| $1000 | ↓ 50% | ↑ 100% | Hedge offsets |

See [Use Cases: Hedging with Reciprocals](/use-cases/#hedging-with-reciprocals) for details.

## Example Derivatives

### Power Perpetuals

**`$WETH^2`** — Squared WETH exposure:
- Price relationship: `price($WETH^2) = price($WETH)²`
- If WETH 2x → `$WETH^2` goes 4x
- Leverage without borrowing or liquidation

**`1/$WETH^2`** — Inverse squared:
- Convex hedge against WETH dumps
- If WETH drops 50% → this gains 300%

### Multi-Token Combinations

**`$WETH/$USDC`** — ETH/USD price ratio itself:
- Not tracking the price, IS the price
- Long ETH, short USD in one token

**`$WETH*$WBTC`** — Diversified crypto basket:
- Gains when either pumps
- `price($WETH*$WBTC) = price($WETH) × price($WBTC)`

**`$WETH^2/$USDC`** — Squared ETH vs USD:
- Leveraged ETH exposure relative to stablecoin
- Custom convexity profile

See [Use Cases: Power Perpetuals](/use-cases/#power-perpetuals) and [Multi-Token Derivatives](/use-cases/#multi-token-derivatives).

## Forge Operations

### Minting the Anchored Unit

To create `$WETH` tokens:

1. Approve WETH spending to the anchored unit contract
2. Call `forge()` with positive parameters to mint

The contract takes your WETH (1:1 backing) and mints the anchored unit.

### Redeeming for WETH

To get WETH back:

1. Call `forge()` with negative parameters to burn the anchored unit
2. Receive WETH from the contract

See [Forging Guide](/guides/forging/) for detailed instructions.

## Related Documentation

- [Token Reference](/tokens/) — All common shorthands
- [Anchored Units Concept](/concepts/units/#anchored-units)
- [Creating Anchored Units](/guides/creating-units/#anchored-units)
- [Use Cases](/use-cases/) — What you can build
- [Economics of "1"](/economics-of-one/) — How WETH collateral affects system value

---

**Remember:** In your code, use the full address `$0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2`. The `$WETH` shorthand is for documentation readability only.
