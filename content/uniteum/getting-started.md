---
title: Getting Started
description: >-
  Your first steps with Uniteum: acquire "1" tokens,
  migrate to the current version, and create your first unit.

# Navigation

# Taxonomy

# Metadata
weight: 2
---

# Getting Started

This guide walks you through your first interactions with Uniteum.

## Prerequisites

- An Ethereum wallet (MetaMask, etc.)
- ETH for gas
- Etherscan for contract interaction (or your preferred method)

## Step 1: Acquire "1" Tokens

The "1" token is the liquidity backbone of Uniteum. You need "1" tokens to create units, forge, and use the full Uniteum feature set.

### How to Get "1" Tokens

The genesis "1" token is a [Solid](/solid/) token — [Uniteum 1](/solid/uniteum-1/). You can buy it directly from the contract's built-in pool by sending ETH:

1. Go to the {{< etherscan address="0x7D5B1349157335aEEB929080a51003B529758830" section="writeContract" text="Uniteum 1 contract on Etherscan" >}}
2. Connect your wallet
3. Find the **`buy`** function
4. In the **payable amount** field, enter the ETH to spend (e.g., `0.1`)
5. Click **Write** and confirm

This gives you genesis "1" tokens (v0.0). To use the full Uniteum feature set (forge, unit creation, etc.), migrate them to the current version using the process below.

### Migration from v0.0

If you have v0.0 "1" tokens, you can migrate them to the current version.

**Why migrate?** Genesis "1" (v0.0) is a simple ERC-20 that holds the primordial 1 billion token supply (the ceiling for all versions). The current contract implements all the core Uniteum mechanisms: algebraic unit composition, forge operations, invariant enforcement, and reciprocal pairs. The v0.0 token exists only as the primordial supply source.

**Current Uniteum Contract:** {{< etherscan address="0xace41cf6d750d7ba06f4de57ac9e063246b2b090" section="code" text="0xace41cf6d750d7ba06f4de57ac9e063246b2b090" >}}

### Migration Process

**Step 2a: Approve the current contract**

First, authorize the current Uniteum contract to transfer your v0.0 tokens.

1. Go to the {{< etherscan address="0x7D5B1349157335aEEB929080a51003B529758830" section="writeContract" text="v0.0 '1' contract on Etherscan" >}}
2. Connect your wallet
3. Find the `approve` function
4. Enter:
   - `spender`: `{{< val "contracts.uniteum.address" >}}` (the current contract)
   - `amount`: The number of tokens you want to migrate (in wei—multiply by 10^18 for whole tokens)
5. Execute the transaction

**Step 2b: Migrate your tokens**

Now call the migration function to exchange your v0.0 tokens for current version tokens.

1. Go to the {{< etherscan address="0xace41cf6d750d7ba06f4de57ac9e063246b2b090" section="writeContract" text="current Uniteum contract on Etherscan" >}}
2. Connect your wallet
3. Find the `migrate` function
4. Enter the `amount` to migrate (same format as approval—in wei)
5. Execute the transaction

**What happens:** Your v0.0 tokens are transferred to the current contract (held custodially), and you receive an equal amount of current version tokens. The total circulating supply of "1" across both versions remains constant (and never exceeds the 1 billion ceiling).

### Reversing Migration

Migration is **fully reversible**. If you want to convert current version tokens back to v0.0:

1. Go to the {{< etherscan address="0xace41cf6d750d7ba06f4de57ac9e063246b2b090" section="writeContract" text="current Uniteum contract on Etherscan" >}}
2. Call `unmigrate(amount)`
3. Your current version tokens are burned, and your v0.0 tokens are returned

This reversibility ensures that the v0.0 supply remains liquid and accessible, even as features evolve.

## Step 3: Create Your First Unit

*Detailed guide coming soon. See [Creating Units](/uniteum/guides/creating-units/).*

## Step 4: Forge

*Detailed guide coming soon. See [Forging](/uniteum/guides/forging/).*

## Next Steps

- [Concepts](/uniteum/concepts/) — Understand the mechanics
- [Safety](/uniteum/safety/) — Know the risks

---

Uniteum, "1", and related marks are trademarks. See [Legal](/legal/) for details.
