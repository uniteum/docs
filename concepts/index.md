---
title: Concepts
description: >-
  Core concepts behind Uniteum: units, forge operations,
  triads, tokenomics, and arbitrage.

# Navigation
nav_order: 4
has_children: true

# Taxonomy
categories:
  - core

# Metadata
last_updated: 2024-12-09
version: "0.1"
status: draft
---

# Concepts

This section explains how Uniteum works.

## Core Ideas

Uniteum is built on a few interlocking concepts:

1. **[Units](/concepts/units/)** — Tokens with dimensional types that compose algebraically
2. **[Forge](/concepts/forge/)** — The single operation that creates, destroys, and swaps tokens
3. **[Triads](/concepts/triads/)** — Valid three-token relationships, not just (U, 1/U, 1)
4. **[Tokenomics](/concepts/tokenomics/)** — The invariant `u · v = w²` and its implications
5. **[Arbitrage](/concepts/arbitrage/)** — How price consistency emerges from profit-seeking

## The Big Picture

Traditional AMMs have isolated pools. Uniswap's ETH/USDC pool knows nothing about its ETH/DAI pool.

Uniteum is different. Every unit connects to "1" through its reciprocal. Compound units connect to their constituents. The result is a **mesh** of interconnected pools, all governed by the same invariant.

When prices diverge anywhere in the mesh, arbitrage opportunities appear. Profit-seekers close the gaps. Prices converge—without oracles.

## Reading Order

If you're new, we recommend:

1. Start with [Units](/concepts/units/) to understand the token types
2. Read [Forge](/concepts/forge/) to see the core operation
3. Then [Triads](/concepts/triads/) to see forge's full generality
4. Then [Tokenomics](/concepts/tokenomics/) for the math
5. Finally [Arbitrage](/concepts/arbitrage/) to see how it all connects
