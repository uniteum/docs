---
title: Plain-English intro
weight: 1
---
# Notable — plain-English intro

A plain-English intro to what a Notable is and what you can do with one.

For the technical reference, see [Notable](/notable/). For the peg mechanics, see [Notable — peg mechanics](/notable/mechanics/).

---

## What's a Notable?

A Notable is a custom-named ERC-20 token you create yourself, backed 1:1 by a real token you already trust — USDC, WBTC, ETH, whatever has a Notable family set up for it. You pick the name. It trades within about 0.01% of the original on any DEX that finds the pool, and in a wallet or block explorer it looks like any other ERC-20.

---

## How it works in practice

When you create a Notable, the entire supply starts out seated inside a Uniswap pool, paired against the backing token. You don't put up any capital to create it. To get some, you go to Uniswap (or any major DEX) and buy it — paying in the backing token, or in anything else the DEX can route a path for. Selling works the same way.

---

## What you might do with one

- **A personally labeled gift.** Issue something like "Birthday Cash for Sam" backed by USDC, buy a hundred of them, send to a friend. They can sell for USDC anytime, or hold it as a keepsake.
- **A token for a group, project, or event.** Backed by ETH, USDC, or whatever the family supports — everyone holds the same thing under a name that means something to them.
- **A permanent on-chain artifact.** Fixed supply, hard peg, immutable contract. Once it's issued, it stays put — and unlike most on-chain artifacts, it has real redeemable value.

---

## What it costs

Just gas. No protocol fees, no approvals. The only money you actually spend is whatever you choose to buy of your own Notable to distribute.

---

## How it's organized

There's a separate Notable family per backing token. To set up a new family, someone calls [`make(token, symbol)`](https://etherscan.io/address/{{< val "unispring.notable.address" >}}#writeContract#F{{< val "unispring" "notable" "write" "make(original, symbol)" "f" >}}) on the Notable factory once. By convention the symbol is `1x` + the original — `1xUSDC`, `1xWBTC` — but it's whatever the maker types, so a family is only as trustworthy as whoever set it up.

After the family exists, anyone can call [`issue("Some Name")`](https://etherscan.io/address/{{< val "unispring.notable.address" >}}#writeContract#F{{< val "unispring" "notable" "write" "issue(name)" "f" >}}) inside it to mint their own Notable. They all share the family symbol but each has its own name and its own pool.

The Notable prototype on mainnet is a special case — it's the family for native ETH itself, with `1xETH` baked into the contract.

---

## How to try it

You'd need a wallet with a bit of ETH for gas. Operations happen on Etherscan's Write Contract tab — no special frontend required. If the family for your backing token already exists, you go straight to `issue(name)`. If not, you'd `make()` it first.

For a step-by-step walkthrough of an ETH-backed Notable, see [Uniteum 1xETH](/notable/uniteum-1xeth/). For the equivalent with a non-native original, see [Uniteum 1xUSDC](/notable/uniteum-1xusdc/).

---

## Before you check it on a price tracker

The fully diluted valuation will look enormous — around $2.3 trillion for ETH-backed Notables, 1 billion tokens for stablecoin-backed Notables. That's not a warning sign. See [Why the FDV looks astronomical](/notable/fdv/) for the reasoning.

---

## Further reading

- [Notable](/notable/) — the factory and operations in full
- [Peg mechanics](/notable/mechanics/) — why the corridor is hard
- [About the FDV](/notable/fdv/) — why the trillion-dollar number is harmless
