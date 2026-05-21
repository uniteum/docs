---
title: Liquid
weight: 10
bookCollapseSection: true
---

# Liquid Protocol

Liquid is a protocol that allows any ERC-20 token to become "liquid" — wrapped with built-in liquidity pools. Every liquid token is both:

- **A standard ERC-20 token** you can hold and transfer
- **Its own automated market maker (AMM)** with instant swap capability

Key properties:

- **Zero Fees** - The protocol charges no fees on any operation
- **Automatic Liquidity** - Every deposit creates tradeable liquidity via the [2x mint](/liquid/2x-mint) pattern
- **Universal Connectivity** - All liquid tokens connect through Hub, enabling cross-pool swaps
- **Permissionless** - Anyone can wrap any ERC-20 token into a liquid token
- **Immutable** - No governance, no admin keys, no protocol updates
- **Deterministic** - Token addresses are predictable via CREATE2

## How It Works

Each liquid token wraps a backing ERC-20 (solid) and maintains a constant-product AMM pool connected to the Hub token.

### Core Operations

1. **heat** - Deposit solid tokens, receive liquid tokens (creates pool liquidity)
2. **cool** - Burn liquid tokens, withdraw solid backing tokens
3. **sell** - Trade liquid tokens for Hub tokens
4. **buy** - Trade Hub tokens for liquid tokens
5. **Cross-swap** - Trade between any two liquid tokens in a single transaction

### The Temperature Metaphor

| Term | Meaning |
|:-----|:--------|
| **Solid** | The backing ERC-20 token (USDC, DAI, etc.) |
| **Liquid** | The wrapped version with built-in liquidity |
| **Hub** | The central Liquid token (wraps the **genesis** Solid "Uniteum 1" — `1.uniteum.eth`, symbol "1") used for cross-pool routing. This is the original genesis token, distinct from the current Uniteum protocol contract. |
| **Spoke** | Any Liquid token paired with Hub, forming a liquidity pool |
| **Pool** | Spoke tokens held by the contract |
| **Lake** | Hub tokens held by the contract |
| **Mass** | Backing token balance held by the contract |

## Why Liquid?

### n pools instead of n²

Traditional AMMs need separate pools for every token pair. With 100 tokens, that's ~5,000 pairs. With 1,000 tokens, that's ~500,000 pairs.

Liquid uses a star topology: every token connects through Hub.
- 100 tokens = 100 pools
- 1,000 tokens = 1,000 pools

### Automatic Liquidity

When you heat 1,000 solid tokens:
- You receive 1,000 liquid tokens (to hold/trade)
- The pool receives 1,000 liquid tokens (instant liquidity)

No separate LP tokens. No staking. Every deposit creates tradeable depth.

### Zero Fees Forever

The protocol charges zero fees on all operations. This is hardcoded—no governance can add fees later. Developers monetized through initial Hub token allocation, not perpetual rent-seeking.

## Using Liquid via Block Explorers

All operations can be performed through Etherscan's "Write Contract" interface. No custom frontend required.

### Creating a Liquid Token

1. Go to the Hub contract on Etherscan
2. Use `make(IERC20Metadata backing)` with your ERC-20 token address
3. The new liquid token address is in the transaction logs

### Adding Liquidity

1. Approve the liquid contract to spend your backing tokens
2. Call `heat(m, e)` on the liquid contract
3. Receive liquid tokens (2N minted total, split between you and pool based on current ratio)

### Trading

- Call `sell(s)` to trade spokes for Hub
- Call `buy(e)` to trade Hub for spokes
- Call `sellFor(that, s)` to cross-swap between spoke tokens

### Checking Prices

Use the read functions before trading:
- `sells(s)` - Preview hub (lake) received for selling spokes
- `buys(e)` - Preview spokes received for spending hub

## Resources

- [Introduction](/liquid/introduction) - Detailed user guide
- [The 2x Mint](/liquid/2x-mint) - The novel liquidity mechanism, equilibrium, and arbitrage
- [Design](/liquid/design) - Mathematical specification
- [Vision](/liquid/vision) - The trillion-dollar thesis
- [Use Cases](/liquid/use-cases) - Practical applications
- [GitHub Repository](https://github.com/uniteum/liquid)
