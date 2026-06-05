---
title: Reflector
weight: 9
bookCollapseSection: true
---
# Reflector

**Your signature on real money.**

A *signature token* is an ERC-20 that wears your name and behaves like the real thing. Pick something to mirror — USDC, ETH, anything you trust. Pick what to call it. Reflector mints the token, backs it 1:1 with the original in a Uniswap V4 pool, and locks the pool so nobody (not even you) can drain it. It trades at par on any DEX. In a wallet, it looks like any other ERC-20. On Etherscan, your name is on the contract.

Reflector is the factory. It takes no fee, requires no capital, and retains no authority. Signature tokens come out the other side.

---

## Things people do with one

**Branded loyalty money.** A restaurant mints `Tokyo Steakhouse Dollar` against USDC and offers 5% off the bill for paying in it. The customer who never comes back still holds redeemable USDC — no points-program liability, no breakage to manage, no expiring balance to argue about. The discount is a marketing decision the merchant can change at will; the dollar is the same dollar everywhere else.

**Gift money with a card on it.** A parent mints `Happy Birthday from Dad`, buys $50 of it, and sends it to a kid. The token is a wallet keepsake and real money at the same time — spendable for USDC anytime, or kept for the message.

**A corporate dollar without becoming a custodian.** A business hands out its own Dollar — Etherscan listing, icon, project link, everything — but every token in circulation is already 100% reserved against real USDC in the pool. There is no float to manage, no liability to disclose, no balance sheet to audit. The token is the brand on the bill; the money is the underlying.

These are three slices of the same shape: **you pick who the token is for, and the protocol pins what it's worth.**

---

## Try one

The flagship USDC-backed signature token is already live. [**Open `Uniteum Dollar` in the Reflector dapp ↗**](https://{{< reflector_dapp_url clone="1xUSDC" name="Uniteum Dollar" >}}) — connect a wallet, swap USDC for it, or mint your own signature token under any name you pick. No Etherscan, no contract calls.

---

## How it works in practice

When you mint a signature token, the entire supply seats into a single-tick Uniswap V4 pool, paired against the original. You put up no capital — the pool starts 100% your token, 0% the original, and the original arrives as buyers swap for your token. To get some of your own, you buy from the same pool. Selling works the same way. The pool *is* the redemption path; there's no separate `redeem()` function.

Two consequences fall out of that geometry:

1. **The peg is hard.** The pool is a single Uniswap tick wide, and Uniswap's swap math cannot cross an empty tick. So the price corridor is exactly `[1.0000, 1.0001)` × the original, enforced by Uniswap itself — no oracle, no keeper, no governance. See [peg mechanics](/reflector/mechanics/).

2. **The backing is permanent.** The pool's V4 position is owned by a [Fountain](/unispring/fountain/) clone with no decrease-liquidity path. The original locked in the pool isn't yours to take back. Neither is anyone else's — the deployer has the same redemption rights as everyone else: trade through the pool.

---

## What it costs to make one

*Making* a signature token costs only gas — no protocol fees, no approvals, no capital locked up to back it. The only money you actually spend is whatever you choose to buy of your own afterward, to hold or gift or distribute.

*Buying* one is a separate question: that's the market price plus the usual DEX swap fee, like any other token.

---

## How it's organized

There's a separate **family** per backing token. Each family is a clone of the Reflector prototype, keyed by `(backing, symbol)`. To set up a new family, someone calls [`make(token, symbol)`](https://{{< escan >}}/address/{{< val "unispring.reflector.address" >}}#writeContract#F{{< val "unispring" "reflector" "write" "make(peg, symbol, variant)" "f" >}}) on the Reflector factory once. By convention the symbol is `1x` + the backing token — `1xUSDC`, `1xWBTC` — but it's whatever the maker types, so a family is only as trustworthy as whoever set it up.

After the family exists, anyone can call [`issue("Some Name")`](https://{{< escan >}}/address/{{< val "unispring.reflector.address" >}}#writeContract#F{{< val "unispring" "reflector" "write" "issue(name, supply, variant)" "f" >}}) inside it to mint a signature token. All signature tokens in a family share the family symbol but each has its own name and its own pool.

The Reflector prototype on mainnet is a special case — it's the family for native ETH itself, with `1xETH` baked into the contract.

---

## How to try it

The friendly path is the [Reflector dapp ↗](https://dapps.uniteum.one/reflector/) — connect a wallet, pick a family, pick a name, sign. The dapp handles `make()` and `issue()` for you under the hood, and pre-fills against the deployed clones for the families that already exist.

Engineers who'd rather skip the frontend can call the contract directly on Etherscan's Write Contract tab. If the family for your backing token already exists, you go straight to `issue(name)`. If not, you'd `make()` it first. Either way you'll need a wallet with a bit of ETH for gas.

For step-by-step walkthroughs, see [Uniteum Ether](/reflector/uniteum-1xeth/) (ETH-backed) and [Uniteum Dollar](/reflector/uniteum-1xusdc/) (USDC-backed).

---

## Before you check it on a price tracker

The fully diluted valuation will look enormous — around $2.3 trillion for ETH-backed signature tokens, 1 billion of the backing for stablecoin-backed ones. That's not a warning sign. See [Why the FDV looks astronomical](/reflector/fdv/) for the reasoning.

---

## Further reading

- [Factory reference](/reflector/reference/) — the factory and operations in full
- [Peg mechanics](/reflector/mechanics/) — why the corridor is hard
- [Par tokens](/reflector/par-tokens/) — directory of signature tokens minted so far
- [About the FDV](/reflector/fdv/) — why the trillion-dollar number is harmless
- [Reputation signals](/reflector/reputation/) — why none of the usual "is this token legit?" checks apply
