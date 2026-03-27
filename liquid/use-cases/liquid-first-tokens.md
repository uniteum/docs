---
layout: default
title: "Liquid-First Tokens"
parent: "Use Cases"
grand_parent: Liquid
permalink: /liquid/use-cases/liquid-first-tokens/
nav_order: 3
---

# Liquid-First Tokens

Most token developers think of liquidity as something they add later.

Deploy the token. Find an exchange. Seed a pool. Hope for volume.

But with Liquid, liquidity is a single `make` call away. And once you see what that means, the obvious question is: *why not make the liquid version the token people actually use?*

## The idea

Deploy your token with whatever logic it needs — minting schedules, governance hooks, access controls, supply caps. That's your **solid**: the backing token, the one with the rules.

Then wrap it with Liquid.

The **liquid** version is what you hand to users. It trades at parity with the solid, carries built-in AMM liquidity, and connects to every other liquid token through Hub.

Users hold one token. They trade one token. They see one symbol in their wallet.

The backing token still exists, still enforces its rules, and still does everything it was designed to do. It just isn't the thing your users think about.

## Why this works

### Price parity

At equilibrium, 1 liquid = 1 solid. The [2x mint]({{ site.baseurl }}/liquid/2x-mint) mechanism preserves this: every heat deposits solid and mints liquid in equal measure, and every cool burns liquid and returns solid. The math enforces the peg without oracles, governance, or trust.

For end users, the difference between holding the liquid version and holding the solid version is meaningless. The value is the same. The liquid just *does more*.

### Built-in liquidity

A bare ERC-20 has no liquidity until someone builds it. A liquid token has liquidity from its first deposit. Every `heat` creates pool depth automatically — no LP tokens, no staking, no bootstrapping campaigns.

This matters most for new tokens, where liquidity is hardest to find and most expensive to fake.

### No fragmentation

Two versions of the same token competing for attention is strictly worse than one. Liquidity splits. Prices diverge on different venues. Users get confused about which version to hold.

A liquid-first strategy avoids this entirely. The solid is infrastructure. The liquid is the product. There's one token in wallets, one token on dashboards, one price to track.

## Composition

This pattern demonstrates something deeper: the power of separating concerns through composition.

The solid token handles everything that isn't liquidity. Minting logic. Governance. Vesting schedules. Access controls. Revenue splits. Whatever the token's stakeholders need — that's the solid's job.

The liquid token handles everything that is liquidity. Trading. Price discovery. Cross-token swaps through Hub. Instant convertibility.

Neither layer needs to know about the other's internals. The solid doesn't need to understand AMM curves. The liquid doesn't need to understand governance votes. They compose through a single interface: `heat` deposits solid and creates liquid. `cool` burns liquid and returns solid.

This is the same principle that makes Unix pipes, ERC-20 approvals, and HTTP verbs powerful: small, composable interfaces that don't leak implementation details.

A token developer who uses this pattern gets both a richly programmable base layer *and* instant liquidity — without building either one from scratch.

## The pattern

1. **Deploy your backing token** with the logic your project needs. Use [Lepton]({{ site.baseurl }}/lepton/) for a simple fixed-supply token, or write a custom contract with whatever minting, governance, or access control you require.

2. **Wrap it with Liquid.** Call `make(token)` on the Hub contract. This creates a liquid version with its own AMM pool, connected to every other liquid token through Hub.

3. **Seed liquidity.** Call `heat` to deposit backing tokens and create pool depth. The [2x mint]({{ site.baseurl }}/liquid/2x-mint) ensures that every deposit splits evenly between your wallet and the pool.

4. **Distribute the liquid version.** This is what goes in wallets, on dashboards, and into integrations. Users trade it, hold it, and transfer it like any ERC-20.

5. **Use the solid version for governance and mechanics.** Stakeholders who need to interact with the backing token's logic — voting, minting, vesting — work with the solid directly. Everyone else never needs to touch it.

## When to use this

Liquid-first makes sense when:

- Your token will be traded, and you don't want to bootstrap liquidity from zero
- You want a single canonical version of your token in circulation
- Your backing token has custom logic that shouldn't be entangled with market mechanics
- You value composability — keeping liquidity and token logic as separate, independent layers

It's less relevant when:

- The token is purely internal (never traded, never transferred outside a closed system)
- You need the backing token itself to appear in third-party protocols that won't recognize the liquid version

## What emerges

A liquid-first token has properties that neither layer provides alone:

- **Instant tradability** from the liquid layer
- **Programmable rules** from the solid layer
- **Cross-token connectivity** through Hub
- **Zero fees** hardcoded at the protocol level
- **No fragmentation** because users only see one token

The backing token is the engine. The liquid token is the interface. Together, they're a complete token economy — deployed permissionlessly, running immutably, and composing cleanly with everything else in the Liquid network.
