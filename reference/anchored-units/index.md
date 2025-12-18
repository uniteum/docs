---
title: Anchored Units
description: >-
  Common anchored token shorthands used in documentation and their
  actual address-based symbols.

# Navigation
parent: Reference
nav_order: 1
has_children: true

# Taxonomy
categories:
  - reference
  - tokens

# Metadata
last_updated: 2024-12-18
status: reference
---

# Anchored Units

## Documentation Convention

Throughout Uniteum documentation, we use **readable shorthands** like `$WETH`, `$USDC`, `$WBTC` for clarity in examples and explanations.

**IMPORTANT:** These are NOT the actual symbols. Anchored units use full contract addresses.

### Why Shorthands?

**Actual anchored unit format:**
```
$0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2
```

This is accurate but unwieldy in documentation. Reading paragraphs full of 42-character hexadecimal addresses hurts comprehension.

**Shorthand format:**
```
$WETH
```

This is readable and matches how developers think about tokens, while clearly indicating "anchored unit" with the `$` prefix.

### The Critical Distinction

| Format | What It Is | Backing |
|--------|-----------|---------|
| `$WETH` (shorthand) | Documentation convenience | Refers to `$0xC02a...56Cc2` |
| `$0xC02a...56Cc2` (actual) | Real anchored unit symbol | 1:1 backed by WETH |
| `WETH` (no $) | Floating unit | NO backing, just a label |

**Floating `WETH` ≠ Anchored `$0xC02a...56Cc2`**

A floating unit with the label "WETH" has zero connection to actual Wrapped Ether. It's an unbacked token that happens to use that name.

## Common Anchored Token Shorthands

Click any shorthand to see its actual symbol, backing token details, and usage examples.

| Shorthand | Token Name | Actual Symbol (first 10 & last 4) | Mainnet Contract |
|-----------|------------|-----------------------------------|------------------|
| [$WETH](/reference/anchored-units/weth/) | Wrapped Ether | `$0xC02aaA39...56Cc2` | [View on Etherscan](https://etherscan.io/address/0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2) |
| [$USDC](/reference/anchored-units/usdc/) | USD Coin | `$0xA0b86991...eB48` | [View on Etherscan](https://etherscan.io/address/0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48) |
| [$USDT](/reference/anchored-units/usdt/) | Tether USD | `$0xdAC17F95...1ec7` | [View on Etherscan](https://etherscan.io/address/0xdAC17F958D2ee523a2206206994597C13D831ec7) |
| [$WBTC](/reference/anchored-units/wbtc/) | Wrapped BTC | `$0x2260FAC5...2C599` | [View on Etherscan](https://etherscan.io/address/0x2260FAC5E5542a773Aa44fBCfEDf7C193bc2C599) |
| [$DAI](/reference/anchored-units/dai/) | Dai Stablecoin | `$0x6B175474...cB4` | [View on Etherscan](https://etherscan.io/address/0x6B175474E89094C44Da98b954EedeAC495271d0F) |

## How to Read Documentation Examples

When you see:

> "Create `$WETH^2` for squared exposure to ETH price movements"

Understand this as:

> "Create an anchored unit using WETH's contract address (`$0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2`), then create its squared compound unit for leveraged exposure"

The shorthand keeps examples readable. Click the links for technical accuracy.

## Creating Anchored Units

To create any anchored unit:

```solidity
IUnit one = IUnit({% include uniteum_address.html %});
IERC20 token = IERC20(0x...); // The ERC-20 you want to anchor
IUnit anchoredUnit = one.anchored(token);
```

The resulting unit's symbol will be `$0x...` (the full token address).

See [Creating Units](/guides/creating-units/) for detailed instructions.

## Predicting Anchored Unit Addresses

Anchored unit addresses are deterministically computed via CREATE2:

```solidity
IUnit one = IUnit({% include uniteum_address.html %});
address predictedAddress = one.anchoredPredict(IERC20(tokenAddress));
```

This allows you to reference anchored units before they're created.

## Why Address-Based Symbols?

**Unambiguous:** `$0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2` uniquely identifies WETH mainnet contract.

**No naming conflicts:** Multiple tokens could claim "WETH" as a floating unit. Addresses are unique.

**Programmatically verifiable:** Code can validate the backing token by reading the address.

**Cross-chain clarity:** Same token on different networks has different addresses, preventing confusion.

## Related Documentation

- [Floating Units](/reference/floating-units/) — Example unbacked units for testing
- [Anchored vs Floating Units](/concepts/units/#anchored-vs-symbolic)
- [Creating Anchored Units](/guides/creating-units/#anchored-units)
- [Use Cases](/use-cases/) — Examples using these tokens
- [Economics of "1"](/economics-of-one/) — How anchored collateral affects system value

---

**Remember:** When implementing in code or interacting with contracts, always use full addresses. Shorthands are for documentation readability only.
