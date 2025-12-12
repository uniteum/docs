---
title: Creating Units
description: >-
  How to create base units, compound units, and anchored units
  in Uniteum.

# Navigation
nav_order: 1
parent: Guides
has_children: false

# Taxonomy
categories:
  - getting-started
  - tokens

# Metadata
last_updated: 2024-12-09
version: "0.1"
status: draft
---

# Creating Units

This guide walks through creating different types of units in Uniteum.

## Creating a Symbolic Base Unit

To create a symbolic unit like `foo`:

```solidity
one().multiply("foo")
```

This creates both `foo` and its reciprocal `1/foo`, bound by the invariant.

### Via Etherscan

1. Go to the [Uniteum 0.1 contract](https://etherscan.io/address/0x9df9b0501e8f6c05623b5b519f9f18b598d9b253#writeContract): `0x9df9b0501e8f6c05623b5b519f9f18b598d9b253`
2. Navigate to "Write Contract"
3. Connect your wallet
4. Find the `multiply` function
5. Enter your symbol (e.g., `foo`)
6. Execute the transaction

### Symbol Rules

- Maximum 30 characters
- Allowed characters: `a-z`, `A-Z`, `0-9`, `_`, `.`, `-`
- Avoid real-world financial symbols (USD, ETH, MSFT, etc.)

## Creating a Compound Unit

To create `meter/second`:

```solidity
IUnit meter = one().multiply("meter");
IUnit second = one().multiply("second");
IUnit meterPerSecond = meter.multiply(second.reciprocal());
```

Or use the expression syntax:

```solidity
IUnit meterPerSecond = one().multiply("meter/second");
```

### Via Etherscan

1. Go to the [Uniteum 0.1 contract](https://etherscan.io/address/0x9df9b0501e8f6c05623b5b519f9f18b598d9b253#writeContract)
2. Navigate to "Write Contract"
3. Connect your wallet
4. Find the `multiply` function (string version)
5. Enter the expression (e.g., `meter/second` or `kg*m/s^2`)
6. Execute the transaction

## Creating an Anchored Unit

To create a unit backed by USDT:

```solidity
one().anchored(IERC20(0xdAC17F958D2ee523a2206206994597C13D831ec7))
```

### Via Etherscan

*Detailed steps coming soon.*

### Anchored Unit Risks

- You trust the Unit contract to hold backing
- Underlying token risk passes through
- See [Safety](/safety/) for full risk disclosure

## Address Prediction

Unit addresses are deterministic via CREATE2. You can predict an address before creation:

*Details coming soon.*

## Next Steps

After creating a unit, you'll want to:

- [Forge](/guides/forging/) to add liquidity
- Understand [Price Control](/guides/price-control/)
