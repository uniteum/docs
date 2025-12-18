---
title: Getting Started
description: >-
  Your first steps with Uniteum: acquire "1" tokens,
  migrate to the current version, and create your first unit.

# Navigation
nav_order: 2
has_children: false

# Taxonomy
categories:
  - getting-started

# Metadata
last_updated: 2024-12-09
status: draft
---

# Getting Started

This guide walks you through your first interactions with Uniteum.

## Prerequisites

- An Ethereum wallet (MetaMask, etc.)
- ETH for gas
- Etherscan for contract interaction (or your preferred method)

## Step 1: Acquire "1" Tokens

The "1" token is the liquidity backbone of Uniteum. You need "1" tokens to create units, forge, and use the full Uniteum feature set.

### One-Step Purchase (Recommended)

{% assign current_kiosk = site.data.contracts.kiosk[site.data.contracts.current.kiosk] -%}
**The easiest way:** Send ETH directly to `{{ current_kiosk.ens }}` (resolves to [`{{ current_kiosk.mainnet }}`](https://etherscan.io/address/{{ current_kiosk.mainnet }}#code)). Your "1" tokens will be returned automatically.

**Alternative:** Call `buy()` on the [Kiosk contract via Etherscan](https://etherscan.io/address/{{ current_kiosk.mainnet }}#writeContract) with ETH attached.

**What happens behind the scenes:**
- The Kiosk buys v0.0 tokens from the genesis Discount Kiosk
- Automatically migrates them to the current version
- Sends you the tokens—ready to use immediately

{% assign genesis_kiosk = site.data.contracts.kiosk.v0_0 -%}
**Alternative (v0.0 only):** Send ETH to `{{ genesis_kiosk.ens }}` (resolves to [`{{ genesis_kiosk.mainnet }}`](https://etherscan.io/address/{{ genesis_kiosk.mainnet }}#code)) to receive v0.0 tokens, then manually migrate (see below).

*(Secondary markets do not yet exist, but if they emerge, you can also acquire "1" tokens there.)*

### Why Buy from the Kiosk?

Beyond supporting ongoing development, you're:
- Acquiring the universal liquidity token for the entire ecosystem
- Taking an early position if the ["1" as value index](/economics-of-one/) hypothesis proves correct
- Enabling yourself to create units, forge, and experiment
- Participating in novel mechanism design from the ground up

The Kiosk uses linear discount pricing—price increases as inventory depletes toward capacity. Early acquisition is cheaper and positions you before broader discovery.

## Step 2: Manual Migration (Optional)

If you already have v0.0 "1" tokens or bought them directly from the genesis Discount Kiosk, you can manually migrate to the current version.

**Why migrate?** Genesis "1" (v0.0) is a simple ERC-20 with a fixed 1 billion token supply. The current contract implements all the core Uniteum mechanisms: algebraic unit composition, forge operations, invariant enforcement, and reciprocal pairs. The v0.0 token exists only as the primordial supply source.

{% assign current_uniteum = site.data.contracts.uniteum[site.data.contracts.current.uniteum] -%}
**Current Uniteum Contract:** [`{{ current_uniteum.mainnet }}`](https://etherscan.io/address/{{ current_uniteum.mainnet }}#writeContract)

### Migration Process

**Step 2a: Approve the current contract**

First, authorize the current Uniteum contract to transfer your v0.0 tokens.

{% assign genesis_uniteum = site.data.contracts.uniteum.v0_0 -%}
1. Go to the [v0.0 "1" contract on Etherscan](https://etherscan.io/address/{{ genesis_uniteum.mainnet }}#writeContract)
2. Connect your wallet
3. Find the `approve` function
4. Enter:
   - `spender`: `{{ current_uniteum.mainnet }}` (the current contract)
   - `amount`: The number of tokens you want to migrate (in wei—multiply by 10^18 for whole tokens)
5. Execute the transaction

**Step 2b: Migrate your tokens**

Now call the migration function to exchange your v0.0 tokens for current version tokens.

1. Go to the [current contract on Etherscan](https://etherscan.io/address/{{ current_uniteum.mainnet }}#writeContract)
2. Connect your wallet
3. Find the `migrate` function
4. Enter the `amount` to migrate (same format as approval—in wei)
5. Execute the transaction

**What happens:** Your v0.0 tokens are transferred to the current contract (held custodially), and you receive an equal amount of current version tokens. The total circulating supply of "1" across both versions remains constant.

### Reversing Migration

Migration is **fully reversible**. If you want to convert current version tokens back to v0.0:

1. Go to the [current contract on Etherscan](https://etherscan.io/address/{{ current_uniteum.mainnet }}#writeContract)
2. Call `unmigrate(amount)`
3. Your current version tokens are burned, and your v0.0 tokens are returned

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
