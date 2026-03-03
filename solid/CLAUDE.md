# CLAUDE.md - Solid Protocol Docs

Protocol-specific guidance for Solid documentation pages. See `lib/solid/CLAUDE.md` for contract mechanics, formulas, and development workflow.

## Voice & Tone (Solid-specific)

Solid docs target a **curious non-expert** audience. Unlike Uniteum docs (which assume crypto-native readers), Solid content should be accessible to people unfamiliar with blockchain, AMMs, or Solidity.

Key principles from `lib/solid/CLAUDE.md`:
- **Lead with what people can do**, not how the protocol works internally
- **Use plain language first** — introduce concepts in everyday terms, then offer technical depth
- **Show, don't spec** — concrete scenarios and stories over feature lists
- **Be honest and direct** — don't oversell
- The [gift-certificates](use-cases/gift-certificates.md) page (Mara's story) is the benchmark for tone

## Key Protocol Concepts

- **Solid tokens** = ERC-20 tokens with built-in constant-product AMM trading against native currency (ETH)
- **NOTHING** = Base factory instance that creates all Solids
- **Fair launch** = Creator gets 0% of tokens; 100% goes to pool; creator can buy first
- **Price floor** = Virtual 1 ETH ensures sell price never falls below starting price
- **Deterministic addresses** = CREATE2 based on name+symbol

## Doc Structure

```
solid/
├── index.md          ← Protocol landing page
├── protocol.md       ← Technical protocol description
└── use-cases/        ← Narrative use-case pages
    └── gift-certificates.md
```
