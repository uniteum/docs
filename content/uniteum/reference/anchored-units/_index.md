---
title: Anchored Units
description: >-
  Common anchored token shorthands used in documentation and their
  actual address-based symbols.

# Navigation

# Taxonomy

# Metadata
weight: 1
---

# Anchored Units


> **Anchored units are not yet fully implemented.** The deposit and withdrawal mechanics need further work, and it may not be possible to get them working as currently designed. The reference information below describes intended behavior. Floating units and their forge operations work today.

## Documentation Convention

Throughout Uniteum documentation, we use **readable shorthands** like `0xWETH`, `0xUSDC`, `0xWBTC` for clarity in examples and explanations.

**IMPORTANT:** These are NOT the actual symbols. Anchored units use full contract addresses.

### Why Shorthands?

**Actual anchored unit format:**
```
0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2
```

This is accurate but unwieldy in documentation. Reading paragraphs full of 42-character hexadecimal addresses hurts comprehension.

**Shorthand format:**
```
0xWETH
```

This is readable and matches how developers think about tokens, while clearly indicating "anchored unit" with the `0x` prefix convention.

### The Critical Distinction

| Format | What It Is | Backing |
|--------|-----------|---------|
| `0xWETH` (shorthand) | Documentation convenience | Refers to `0xC02a...56Cc2` |
| `0xC02a...56Cc2` (actual) | Real anchored unit symbol | 1:1 backed by WETH |
| `WETH` (no 0x) | Floating unit | NO backing, just a label |

**Floating `WETH` ≠ Anchored `0xC02a...56Cc2`**

A floating unit with the label "WETH" has zero connection to actual Wrapped Ether. It's an unbacked token that happens to use that name.

## Common Anchored Token Shorthands

Click any shorthand to see its actual symbol, backing token details, and usage examples.
| Shorthand | Token Name | Actual Symbol (first 10 & last 4) | Mainnet Contract |
|-----------|------------|-----------------------------------|------------------|
| [0xWETH](/uniteum/reference/anchored-units/weth/) | Wrapped Ether | `0xC02aaA39...56Cc2` | {{< token address=weth.address text="View on Etherscan" >}} |
| [0xUSDC](/uniteum/reference/anchored-units/usdc/) | USD Coin | `0xA0b86991...eB48` | {{< token address=usdc.address text="View on Etherscan" >}} |
| [0xUSDT](/uniteum/reference/anchored-units/usdt/) | Tether USD | `0xdAC17F95...1ec7` | {{< token address=usdt.address text="View on Etherscan" >}} |
| [0xWBTC](/uniteum/reference/anchored-units/wbtc/) | Wrapped BTC | `0x2260FAC5...2C599` | {{< token address=wbtc.address text="View on Etherscan" >}} |
| [0xDAI](/uniteum/reference/anchored-units/dai/) | Dai Stablecoin | `0x6B175474...cB4` | {{< token address=dai.address text="View on Etherscan" >}} |

## How to Read Documentation Examples

When you see:

> "Create `0xWETH^2` for squared exposure to ETH price movements"

Understand this as:

> "Create an anchored unit using WETH's contract address (`0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2`), then create its squared compound unit for leveraged exposure"

The shorthand keeps examples readable. Click the links for technical accuracy.

## Creating Anchored Units

To create any anchored unit:

```solidity
IUnit one = IUnit({{< uniteum_address >}});
IERC20 token = IERC20(0x...); // The ERC-20 you want to anchor
IUnit anchoredUnit = one.anchored(token);
```

The resulting unit's symbol will be `0x...` (the full token address).

See [Creating Units](/uniteum/guides/creating-units/) for detailed instructions.

## Predicting Anchored Unit Addresses

Anchored unit addresses are deterministically computed via CREATE2:

```solidity
IUnit one = IUnit({{< uniteum_address >}});
address predictedAddress = one.anchoredPredict(IERC20(tokenAddress));
```

This allows you to reference anchored units before they're created.

## Why Address-Based Symbols?

**Unambiguous:** `0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2` uniquely identifies WETH mainnet contract.

**No naming conflicts:** Multiple tokens could claim "WETH" as a floating unit. Addresses are unique.

**Programmatically verifiable:** Code can validate the backing token by reading the address.

**Cross-chain clarity:** Same token on different networks has different addresses, preventing confusion.

## Related Documentation

- [Floating Units](/uniteum/reference/floating-units/) — Example unbacked units for testing
- [Anchored vs Floating Units](/uniteum/concepts/units/#floating-units)
- [Creating Anchored Units](/uniteum/guides/creating-units/#anchored-units)
- [Use Cases](/uniteum/use-cases/) — Examples using these tokens
- [Economics of "1"](/uniteum/economics-of-one/) — How anchored collateral affects system value

---

**Remember:** When implementing in code or interacting with contracts, always use full addresses. Shorthands are for documentation readability only.
