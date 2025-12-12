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

### Buy from the Discount Kiosk

The Discount Kiosk sells genesis "1" tokens (v0.0) at a linear discount—price increases as inventory depletes. Early buyers pay less.

**The easiest way:** Send ETH directly to `buy.0-0.uniteum.eth` (resolves to [`0x55816c3e5d999e2f45ce0146ffd89b2e78a56dc9`](https://etherscan.io/address/0x55816c3e5d999e2f45ce0146ffd89b2e78a56dc9#code)). Your "1" tokens will be returned automatically.

**Alternative:** Call `buy()` on the [Kiosk contract via Etherscan](https://etherscan.io/address/0x55816c3e5d999e2f45ce0146ffd89b2e78a56dc9#writeContract) with ETH attached, or acquire "1" tokens through secondary markets if available.

#### Why Buy from the Kiosk?

Beyond supporting ongoing development, you're:
- Acquiring the universal liquidity token for the entire ecosystem
- Taking an early position if the ["1" as value index](/economics-of-one/) hypothesis proves correct
- Enabling yourself to create units, forge, and experiment
- Participating in novel mechanism design from the ground up

The Kiosk uses linear discount pricing—price increases as inventory depletes toward capacity. Early acquisition is cheaper and positions you before broader discovery.

## Step 2: Migrate to v0.1

Genesis "1" (v0.0) is a simple ERC-20 with a fixed 1 billion token supply. To access Uniteum's full functionality—creating units, forging, building compound units—you need to migrate to v0.1.

**Why migrate?** The v0.1 contract implements all the core Uniteum mechanisms: algebraic unit composition, forge operations, invariant enforcement, and reciprocal pairs. The v0.0 token exists only as the primordial supply source.

**Uniteum 0.1 Contract:** [`0x9df9b0501e8f6c05623b5b519f9f18b598d9b253`](https://etherscan.io/address/0x9df9b0501e8f6c05623b5b519f9f18b598d9b253#writeContract)

### Migration Process

**Step 2a: Approve the v0.1 contract**

First, you need to authorize the Uniteum 0.1 contract to transfer your v0.0 tokens.

1. Go to the [v0.0 "1" contract on Etherscan](https://etherscan.io/address/0xC833f0B7cd7FC479DbbF6581EB4eEFc396Cf39E4#writeContract)
2. Connect your wallet
3. Find the `approve` function
4. Enter:
   - `spender`: `0x9df9b0501e8f6c05623b5b519f9f18b598d9b253` (the v0.1 contract)
   - `amount`: The number of tokens you want to migrate (in wei—multiply by 10^18 for whole tokens)
5. Execute the transaction

**Step 2b: Migrate your tokens**

Now call the migration function to exchange your v0.0 tokens for v0.1 tokens.

1. Go to the [v0.1 contract on Etherscan](https://etherscan.io/address/0x9df9b0501e8f6c05623b5b519f9f18b598d9b253#writeContract)
2. Connect your wallet
3. Find the `migrate` function
4. Enter the `amount` to migrate (same format as approval—in wei)
5. Execute the transaction

**What happens:** Your v0.0 tokens are transferred to the v0.1 contract (held custodially), and you receive an equal amount of v0.1 tokens. The total circulating supply of "1" across both versions remains constant.

### Reversing Migration

Migration is **fully reversible**. If you want to convert v0.1 tokens back to v0.0:

1. Go to the [v0.1 contract on Etherscan](https://etherscan.io/address/0x9df9b0501e8f6c05623b5b519f9f18b598d9b253#writeContract)
2. Call `unmigrate(amount)`
3. Your v0.1 tokens are burned, and your v0.0 tokens are returned

This reversibility ensures that the v0.0 supply remains liquid and accessible, even as features evolve.

## Step 3: Create Your First Unit

*Detailed guide coming soon. See [Creating Units](/guides/creating-units/).*

## Step 4: Forge

*Detailed guide coming soon. See [Forging](/guides/forging/).*

## Next Steps

- [Concepts](/concepts/) — Understand the mechanics
- [Safety](/safety/) — Know the risks

---

Uniteum, "1", and related marks are trademarks. See [Legal](/legal/) for details.
