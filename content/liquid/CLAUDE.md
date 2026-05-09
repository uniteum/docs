# CLAUDE.md - Liquid Protocol Docs

Protocol-specific guidance for Liquid documentation pages.

## Key Protocol Concepts

- **Hub-and-spoke model** = Central "Hub" liquid token (wraps Solid "Uniteum 1") connects all other liquids
- **Heat/Cool** = Deposit backing token (heat) or withdraw it (cool) — wrapping/unwrapping with AMM
- **Buy/Sell** = Trade spoke tokens against hub tokens via constant-product AMM
- **Cross-swaps** = `sellFor()` swaps between two spoke tokens using hub as intermediary

## Terminology

| Term | Meaning |
|------|---------|
| Solid | Backing token (the underlying ERC-20) |
| Liquid | Wrapped token with built-in liquidity |
| Hub | Central Liquid token (wraps "Uniteum 1", symbol "1") |
| Spoke | Any non-hub Liquid token |
| Mass | Backing tokens held by contract |
| Pool | Spoke tokens held by contract |
| Lake | Hub tokens held by contract |

## Doc Structure

```
liquid/
├── index.md          ← Protocol landing page
├── introduction.md   ← What Liquid is and why
├── design.md         ← Technical design
├── 2x-mint.md        ← 2x mint mechanism, equilibrium, and arbitrage
└── use-cases/        ← Use-case pages
```

## Key Distinction

Liquid is **NOT** the algebraic Unit protocol. No symbolic algebra, no forge triads, no rational exponents. It is a straightforward constant-product AMM with token wrapping and cross-pool swaps via a hub intermediary.
