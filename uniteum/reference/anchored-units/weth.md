---
title: 0xWETH
description: Documentation shorthand for the WETH anchored unit
parent: Reference
grand_parent: Uniteum
nav_order: 1

# Metadata
last_updated: 2024-12-18
---

# 0xWETH (Wrapped Ether)

**Documentation Shorthand:** `0xWETH`
**Actual Symbol:** `{{ site.data.tokens.weth.mainnet }}`

## What This Represents

{% assign weth = site.data.tokens.weth -%}
In Uniteum documentation, `0xWETH` is a **readable shorthand** for an anchored unit backed by {% include token.html address=weth.mainnet text="Wrapped Ether (WETH)" %}.

The actual Uniteum symbol uses the full WETH contract address:
```
{{ weth.mainnet }}
```

## Backing Token

**WETH Contract:** {% include token.html address=weth.mainnet text=weth.mainnet %}

Wrapped Ether is ETH converted to an ERC-20 token for DeFi compatibility. 1 WETH = 1 ETH, redeemable 1:1.

## Anchored Unit Details

**Type:** Anchored (backed 1:1 by real WETH)
**Custodian:** Uniteum contract holding the WETH
**Redeemable:** Yes, burn the anchored unit to retrieve WETH
**Trust Model:** Smart contract custody (unaudited)

## Key Distinctions

| Symbol | Type | Backing |
|--------|------|---------|
| `{{ site.data.tokens.weth.mainnet }}` | Anchored unit | 1:1 WETH in contract |
| `WETH` (no $) | Floating unit | None (just a label) |
| `0xWETH` | Documentation shorthand | Refers to anchored version |

**Critical:** Floating `WETH` ≠ Anchored `{{ site.data.tokens.weth.mainnet | slice: 0, 6 }}...{{ site.data.tokens.weth.mainnet | slice: -4, 4 }}`

A floating unit with the label "WETH" has NO connection to real Wrapped Ether. Anyone can create it. It's worthless unless consensus gives it value.

## Creating This Unit

```solidity
// Get the "1" token contract
IUnit one = IUnit({% include uniteum_address.html %});

// Create anchored WETH unit
IERC20 weth = IERC20({{ site.data.tokens.weth.mainnet }});
IUnit wethUnit = one.anchored(weth);

// wethUnit.symbol() returns: "{{ site.data.tokens.weth.mainnet }}"
```

## Reciprocal Unit

Every anchored unit has a reciprocal:

**`1/0xWETH`** (shorthand) = `1/{{ site.data.tokens.weth.mainnet }}` (actual)

This is a **synthetic unit** (NOT backed by WETH). Its price is the inverse of the WETH unit's price, enforced by the invariant.

### Hedging Use Case

Hold both `0xWETH` and `1/0xWETH`:

| WETH Price | 0xWETH Value | 1/0xWETH Value | Net Effect |
|------------|-------------|---------------|------------|
| $2000 | 1× | 1× | Balanced |
| $3000 | ↑ 50% | ↓ 33% | Net gain |
| $1000 | ↓ 50% | ↑ 100% | Hedge offsets |

See [Use Cases: Hedging with Reciprocals](/uniteum/use-cases/#hedging-with-reciprocals) for details.

## Example Derivatives

### Power Perpetuals

**`0xWETH^2`** — Squared WETH exposure:
- Price relationship: `price(0xWETH^2) = price(0xWETH)²`
- If WETH 2x → `0xWETH^2` goes 4x
- Leverage without borrowing or liquidation

**`1/0xWETH^2`** — Inverse squared:
- Convex hedge against WETH dumps
- If WETH drops 50% → this gains 300%

### Multi-Token Combinations

**`0xWETH/0xUSDC`** — ETH/USD price ratio itself:
- Not tracking the price, IS the price
- Long ETH, short USD in one token

**`0xWETH*0xWBTC`** — Diversified crypto basket:
- Gains when either pumps
- `price(0xWETH*0xWBTC) = price(0xWETH) × price(0xWBTC)`

**`0xWETH^2/0xUSDC`** — Squared ETH vs USD:
- Leveraged ETH exposure relative to stablecoin
- Custom convexity profile

See [Use Cases: Power Perpetuals](/uniteum/use-cases/#power-perpetuals) and [Multi-Token Derivatives](/uniteum/use-cases/#multi-token-derivatives).

## Forge Operations

### Minting the Anchored Unit

To create `0xWETH` tokens:

1. Approve WETH spending to the anchored unit contract
2. Call `forge()` with positive parameters to mint

The contract takes your WETH (1:1 backing) and mints the anchored unit.

### Redeeming for WETH

To get WETH back:

1. Call `forge()` with negative parameters to burn the anchored unit
2. Receive WETH from the contract

See [Forging Guide](/uniteum/guides/forging/) for detailed instructions.

## Related Documentation

- [Anchored Units](/uniteum/reference/anchored-units/) — All common shorthands
- [Anchored Units Concept](/uniteum/concepts/units/#anchored-units)
- [Creating Anchored Units](/uniteum/guides/creating-units/#anchored-units)
- [Use Cases](/uniteum/use-cases/) — What you can build
- [Economics of "1"](/uniteum/economics-of-one/) — How WETH collateral affects system value

---

**Remember:** In your code, use the full address `{{ site.data.tokens.weth.mainnet }}`. The `0xWETH` shorthand is for documentation readability only.
