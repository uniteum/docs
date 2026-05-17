---
title: Reflector
weight: 13
bookCollapseSection: true
---
# Reflector

**Mint your own ERC-20, pegged 1:1 to a token you already trust.**

You put up no capital to create it, pay no protocol fees, and end up with a token whose backing nobody — not even you — can rug, dilute, or unwind. This page walks through what that means and what you can do with one, in plain English. Engineers who want the full factory mechanics should head to the [Factory reference](/reflector/reference/) and [Peg mechanics](/reflector/mechanics/).

---

## What's a Reflector issue?

A Reflector issue is a custom-named ERC-20 token you create yourself, backed 1:1 by a real token you already trust — USDC, WBTC, ETH, whatever has a Reflector family set up for it. You pick the name. It trades within about 0.01% of the original on any DEX that finds the pool, and in a wallet or block explorer it looks like any other ERC-20.

---

## How it works in practice

When you create a Reflector issue, the entire supply starts out seated inside a Uniswap pool, paired against the backing token. You don't put up any capital to create it. To get some, you go to Uniswap (or any major DEX) and buy it — paying in the backing token, or in anything else the DEX can route a path for. Selling works the same way.

---

## What you might do with one

- **A personally labeled gift.** Issue something like "Birthday Cash for Sam" backed by USDC, buy a hundred of them, send to a friend. They can sell for USDC anytime, or hold it as a keepsake.
- **A token for a group, project, or event.** Backed by ETH, USDC, or whatever the family supports — everyone holds the same thing under a name that means something to them.
- **A permanent on-chain artifact.** Fixed supply, hard peg, immutable contract. Once it's issued, it stays put — and unlike most on-chain artifacts, it has real redeemable value.

---

## What it costs to create one

*Creating* an issue costs only gas — no protocol fees, no approvals, no capital locked up to back it. (*Buying* one is a separate question: that's just the market price plus the usual DEX swap fee, like any other token.)

So the only money you actually spend is whatever you choose to buy of your own issue afterward — to hold, gift, or distribute.

---

## How it's organized

There's a separate Reflector family per backing token. To set up a new family, someone calls [`make(token, symbol)`](https://etherscan.io/address/{{< val "unispring.reflector.address" >}}#writeContract#F{{< val "unispring" "reflector" "write" "make(peg, symbol)" "f" >}}) on the Reflector factory once. By convention the symbol is `1x` + the backing token — `1xUSDC`, `1xWBTC` — but it's whatever the maker types, so a family is only as trustworthy as whoever set it up.

After the family exists, anyone can call [`issue("Some Name")`](https://etherscan.io/address/{{< val "unispring.reflector.address" >}}#writeContract#F{{< val "unispring" "reflector" "write" "issue(name)" "f" >}}) inside it to mint their own issue. They all share the family symbol but each has its own name and its own pool.

The Reflector prototype on mainnet is a special case — it's the family for native ETH itself, with `1xETH` baked into the contract.

---

## How to try it

You'd need a wallet with a bit of ETH for gas. Operations happen on Etherscan's Write Contract tab — no special frontend required. If the family for your backing token already exists, you go straight to `issue(name)`. If not, you'd `make()` it first.

For a step-by-step walkthrough of an ETH-backed issue, see [Uniteum 1xETH](/reflector/uniteum-1xeth/). For the equivalent with a non-native original, see [Uniteum 1xUSDC](/reflector/uniteum-1xusdc/).

---

## Before you check it on a price tracker

The fully diluted valuation will look enormous — around $2.3 trillion for ETH-backed issues, 1 billion tokens for stablecoin-backed issues. That's not a warning sign. See [Why the FDV looks astronomical](/reflector/fdv/) for the reasoning.

---

## Further reading

- [Factory reference](/reflector/reference/) — the factory and operations in full
- [Peg mechanics](/reflector/mechanics/) — why the corridor is hard
- [About the FDV](/reflector/fdv/) — why the trillion-dollar number is harmless
