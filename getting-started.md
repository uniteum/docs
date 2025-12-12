---
title: Getting Started
description: >-
  Your first steps with Uniteum: acquire "1" tokens,
  migrate to v0.1, and create your first unit.

# Navigation
nav_order: 2
has_children: false

# Taxonomy
categories:
  - getting-started

# Metadata
last_updated: 2024-12-09
version: "0.1"
status: draft
---

# Getting Started

This guide walks you through your first interactions with Uniteum.

## Prerequisites

- An Ethereum wallet (MetaMask, etc.)
- ETH for gas
- Etherscan for contract interaction (or your preferred method)

## Step 1: Acquire "1" Tokens

The "1" token is the liquidity backbone of Uniteum. You need it to create and forge units.

### Option A: Discount Kiosk (Recommended)

The Discount Kiosk sells genesis "1" tokens (v0.0) at a linear discount—price increases as inventory depletes. Early buyers pay less.

**Contract:** [`0x55816c3e5d999e2f45ce0146ffd89b2e78a56dc9`](https://etherscan.io/address/0x55816c3e5d999e2f45ce0146ffd89b2e78a56dc9#writeContract)

1. Go to the [Kiosk contract on Etherscan](https://etherscan.io/address/0x55816c3e5d999e2f45ce0146ffd89b2e78a56dc9#writeContract)
2. Call `buy()` with ETH attached
3. Receive v0.0 "1" tokens

#### Why Buy from the Kiosk?

Beyond supporting ongoing development, you're:
- Acquiring the universal liquidity token for the entire ecosystem
- Taking an early position if the ["1" as value index](/economics-of-one/) hypothesis proves correct
- Enabling yourself to create units, forge, and experiment
- Participating in novel mechanism design from the ground up

The Kiosk uses linear discount pricing—price increases as inventory depletes toward capacity. Early acquisition is cheaper and positions you before broader discovery.

### Option B: Secondary Market

If available on DEXes, you can acquire "1" tokens there.

## Step 2: Migrate to v0.1

Genesis "1" (v0.0) is a simple ERC-20. To use Uniteum features, migrate to v0.1.

**Uniteum 0.1 Contract:** [`0x9df9b0501e8f6c05623b5b519f9f18b598d9b253`](https://etherscan.io/address/0x9df9b0501e8f6c05623b5b519f9f18b598d9b253#writeContract)

1. Approve the [v0.1 contract](https://etherscan.io/address/0x9df9b0501e8f6c05623b5b519f9f18b598d9b253#writeContract) to spend your v0.0 tokens
2. Call `migrate(amount)` on the v0.1 contract
3. Your v0.0 tokens are held; you receive v0.1 tokens

Migration is reversible via `unmigrate()`.

## Step 3: Create Your First Unit

*Detailed guide coming soon. See [Creating Units](/guides/creating-units/).*

## Step 4: Forge

*Detailed guide coming soon. See [Forging](/guides/forging/).*

## Next Steps

- [Concepts](/concepts/) — Understand the mechanics
- [Safety](/safety/) — Know the risks

---

Uniteum, "1", and related marks are trademarks. See [Legal](/legal/) for details.
