---
title: Anchored units and impermanent gain

# Navigation
nav_order: 2
parent: Concepts
has_children: false

# Taxonomy
categories:
  - core
  - units

# Metadata
permalink: /concepts/anchored-units
-----------------------------------

Uniteum can treat an external ERC-20 (like wBTC or WETH) as an **anchored Unit**: a Unit whose “meaning” is pegged to an outside token balance rather than being purely endogenous.

The simplest anchored setup is the **reciprocal triad**:

* **(U, 1/U, 1)**

where `U` is the anchored Unit, `1/U` is its reciprocal Unit, and `1` is the identity Unit that connects the system. Triads are the only place economics happens in Uniteum, and forge is the only operation that moves balances across a triad.   

## The anchored use case

In an anchored reciprocal triad, the design goal is that **the system balances the external token exposure on both sides**:

* `1` (as the mediator in the triad) ends up holding some amount of the external token backing `U`
* and `1` also ends up being the natural counterparty to `1/U` exposure

Intuitively: the triad is structured so that `U` and `1/U` are the two “reserve” sides, and `1` is the shared liquidity backbone that connects them to the rest of the mesh.  

This creates a clean primitive: **an anchored Unit, its reciprocal, and `1`** — a three-token relationship you can forge through, and therefore trade through.

## Impermanent gain (the complement of impermanent loss)

If someone holds **equal exposure** to an anchored Unit and its reciprocal (think “balanced long and balanced inverse”), then changes in the anchored token’s external value can produce a phenomenon that’s the mirror image of LP impermanent loss:

* In a typical constant-product AMM, price movement causes LPs to “sell the winner” and “buy the loser,” often resulting in **impermanent loss** versus holding.
* In this anchored reciprocal setup, a holder who maintains **balanced exposure across `U` and `1/U`** can experience **impermanent gain** as the external value moves, because the structure rewards the act of continually rebalancing between a unit and its reciprocal.

The key behavioral point is the same as in AMMs: **you don’t get the gain “for free” unless you rebalance**. The gain becomes *realized* when the holder uses forge paths to move back toward their preferred balance, effectively locking in the change.

## Rebalancing turns holders into “fee-less” liquidity providers

A holder who repeatedly rebalances between `U` and `1/U` to harvest this impermanent gain is doing the economic job usually done by fee-seeking LPs:

* they supply the inventory that makes trades possible,
* they absorb price movement,
* and they keep the system near equilibrium through their own incentive to rebalance.

But instead of being paid via explicit swap fees, their reward is **the rebalance capture itself** (net of gas/MEV/transaction costs). In other words, the “LP role” and the “arbitrage role” collapse into the same actor: the person harvesting impermanent gain is also the person enforcing price consistency.  

## Two-step swaps through `1`

Once `U` and `1/U` are connected to `1`, any two anchored Units can trade by routing through `1`:

* swap `$BTC` exposure → `1`
* swap `1` → `$ETH` exposure

So a “BTC → ETH” trade is internally just two forge-driven moves that pass through the shared mediator. That’s how Uniteum gets a constant-product-AMM-like routing behavior without requiring bespoke pools for every pair: the mesh already exists, and `1` is the common connective tissue.  

## Why this can work without explicit fees

You don’t need to charge explicit fees for a market to function if there is a reliable, permissionless reward for keeping the system near equilibrium.

Here, the incentive is:

* external price movement creates rebalance opportunities for holders of the anchored/reciprocal pair,
* those holders take actions (via forge paths) that push the system back toward equilibrium,
* and that behavior provides the effective liquidity that makes routing through `1` usable.

In effect: **the system’s “liquidity provision” is funded by volatility itself**, not by per-trade fees.

## Practical notes

* This strategy is only attractive if the harvested impermanent gain exceeds transaction costs (gas, MEV/frontrunning, and operational overhead).
* Because Uniteum is a mesh of local triads (no global invariant), consistency is enforced by participants taking advantage of cross-path discrepancies.  
* The details of how anchored units are represented and created (syntactically and structurally) remain separate from forge economics: Units define relationships; triads define constraints; forge moves balances.  

## See also

* [Mental Model](/concepts/mental-model)
* [Triads](/concepts/triads)
* [Forge](/concepts/forge)
* [Tokenomics](/concepts/tokenomics)
