---
title: Functions
description: >-
  Contract function reference for Uniteum:
  signatures, parameters, and usage.

# Navigation
nav_order: 2
parent: Reference
has_children: false

# Taxonomy
categories:
  - development

# Metadata
last_updated: 2024-12-09
version: "0.1"
status: draft
---

# Functions

Reference for Uniteum contract functions.

*Detailed function documentation coming soon.*

## Uniteum 0.1 Core Functions

### Unit Creation

#### `multiply(string symbol)`

Creates a symbolic base unit and its reciprocal.

- **Parameters:** `symbol` — Unit name (max 30 chars, alphanumeric + `_.-`)
- **Returns:** Address of created unit
- **Emits:** *TBD*

#### `anchored(IERC20 token)`

Creates an anchored unit backed by an external ERC-20.

- **Parameters:** `token` — Address of backing ERC-20
- **Returns:** Address of created unit
- **Emits:** *TBD*

### Forge Operations

#### `forge(...)`

*Signature and parameters TBD.*

### Migration

#### `migrate(uint256 amount)`

Migrate v0.0 "1" tokens to v0.1.

- **Parameters:** `amount` — Amount of v0.0 tokens to migrate
- **Requirements:** Must have approved v0.1 contract to spend v0.0 tokens
- **Effect:** v0.0 tokens held by contract, v0.1 tokens minted to caller

#### `unmigrate(uint256 amount)`

Reverse migration—return to v0.0.

- **Parameters:** `amount` — Amount of v0.1 tokens to unmigrate
- **Effect:** v0.1 tokens burned, v0.0 tokens returned to caller

## Discount Kiosk Functions

### `buy()`

Purchase genesis "1" tokens at current discount price.

- **Value:** ETH to spend
- **Returns:** Amount of "1" tokens received
- **Pricing:** Linear discount—price decreases as inventory approaches capacity

### `price()`

Current price per "1" token.

- **Returns:** Price in wei

## ERC-20 Standard Functions

All unit tokens implement standard ERC-20:

- `balanceOf(address)`
- `transfer(address, uint256)`
- `approve(address, uint256)`
- `transferFrom(address, address, uint256)`
- `allowance(address, address)`
- `totalSupply()`
