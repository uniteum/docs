---
title: Par tokens
weight: 6
---
# Par tokens

Every [Reflector issue](/reflector/reference/) is a **par token**: an ERC-20 that trades *at par* — 1:1 — with the original it mirrors, inside a hard one-basis-point corridor. Its price never falls below `1.0×` the original and never rises above `1.0001×`, because its entire supply sits in a single-tick Uniswap V4 position that no one can unwind. See [peg mechanics](/reflector/mechanics/) for why the corridor is hard.

This page is the directory of every par token minted so far, grouped by [family](/reflector/reference/#how-the-factory-is-laid-out). For each one: its block-explorer contract page, where to trade it, and a deep link that opens it in the [Uniteum Reflector dapp](https://dapps.uniteum.one/reflector/).

{{< reflector_pars >}}

## Reading the table

- **Family** — the clone symbol. `1xETH` issues are pegged 1:1 to native ETH; `1xUSDC` issues to chain-local USDC. Issues in a family share one symbol and one peg corridor but are otherwise independent ERC-20s, each with its own address and pool.
- **Contract** — the issue's own ERC-20 on the block explorer. The network selector in the sidebar switches the explorer host.
- **Markets** — buy or sell on any V4-aware venue. The pool *is* the redemption path: `original → issue` to acquire, `issue → original` to redeem. There is no separate redeem function. Market links point to the chain each token is live on, not the selected explorer network.
- **Dapp** — opens the token in the [Reflector dapp](https://dapps.uniteum.one/reflector/), pre-filled with its family contract, name, and vanity variant.

The two flagship par tokens have full walkthroughs: [Uniteum Ether](/reflector/uniteum-1xeth/) (ETH-backed) and [Uniteum Dollar](/reflector/uniteum-1xusdc/) (USDC-backed).

## Mint your own

Every token above is something you can make yourself — pick a name, send one transaction, no capital required. To add a par token against a backing that already has a family, call [`issue(name)`](/reflector/reference/#how-to-use-it) on that clone; to start a new family, [`make(original, symbol)`](/reflector/reference/#how-to-use-it) it first. The [Uniteum Ether walkthrough](/reflector/uniteum-1xeth/#mint-your-own-personalized-1xeth) shows the native-ETH case end to end.

## Further reading

- [Factory reference](/reflector/reference/) — the factory and its operations in full
- [Peg mechanics](/reflector/mechanics/) — why the 1-bp corridor is hard
- [About the FDV](/reflector/fdv/) — why the headline valuation is harmless
- [Reputation signals](/reflector/reputation/) — why none of the usual token-vetting checks apply
