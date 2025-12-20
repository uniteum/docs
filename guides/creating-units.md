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
status: draft
---

# Creating Units

This guide walks through creating different types of units in Uniteum.

## Creating a Floating Base Unit

To create a floating unit like `foo`:

```solidity
one().multiply("foo")
```

This creates both `foo` and its reciprocal `1/foo`, bound by the invariant.

### Via Etherscan

{% assign current_uniteum = site.data.contracts.uniteum[site.data.contracts.current.uniteum] -%}
1. Go to the {% include etherscan.html address=current_uniteum.mainnet section="writeContract" text="Uniteum contract on Etherscan" %}
2. Connect your wallet
3. Find the `multiply` function
4. Enter your symbol (e.g., `foo`)
5. Execute the transaction

### Symbol Rules

- Maximum 30 characters
- Allowed characters: `a-z`, `A-Z`, `0-9`, `_`, `.`, `-`
- Avoid real-world financial symbols (USD, ETH, MSFT, etc.)

## Creating a Compound Unit

Compound units are created by forging triads where the compound serves as the liquidity unit (geometric mean of reserves).

**Example:** To create `meter/second`, you need the triad `(meter², 1/second², meter/second)` where:
- Reserve units: meter² and 1/second²
- Liquidity unit: meter/second (since √(meter² * 1/second²) = meter/second)

First create the base units:

```solidity
IUnit meter = one().multiply("meter");
IUnit second = one().multiply("second");
```

Then create the squared versions (meter², 1/second²) and forge to create meter/second as the liquidity unit.

Or use the expression syntax which handles this automatically:

```solidity
IUnit meterPerSecond = one().product("meter/second");
```

### Via Etherscan

1. Go to the {% include etherscan.html address=current_uniteum.mainnet section="writeContract" text="Uniteum contract on Etherscan" %}
2. Connect your wallet
3. Find the `product` function (string version)
4. Enter the expression (e.g., `meter/second` or `kg*m/s^2`)
5. Execute the transaction

This automatically creates the necessary intermediate units and sets up the geometric mean relationship.

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
