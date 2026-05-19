# Documentation Audit — Index

**Generated:** 2026-05-18 · **Method:** 7 parallel analysis agents comparing `content/` + `data/` against sibling implementation repos under `/home/paul/git/uniteum/`.
**Status:** Analysis complete. No fixes applied yet.

One file per lane so concurrent owners don't contend on the same checklist. This README carries the cross-lane connective tissue.

## Lane index

| Lane | File | Scope | Sev | Blocked? |
|---|---|---|---|---|
| A | [lane-a-uniteum-protocol.md](lane-a-uniteum-protocol.md) | Uniteum concepts/protocol; owns `content/uniteum/CLAUDE.md` | HIGH | no |
| B | [lane-b-uniteum-reference.md](lane-b-uniteum-reference.md) | Uniteum reference + token data | HIGH | no |
| C | [lane-c-liquid.md](lane-c-liquid.md) | Liquid docs | HIGH | no |
| D | [lane-d-solid.md](lane-d-solid.md) | Solid docs (unblocked subset) | MED | partial → blocked.md |
| E | [lane-e-lepton.md](lane-e-lepton.md) | Lepton docs (unblocked subset) | HIGH | partial → blocked.md |
| F | [lane-f-unispring-reflector.md](lane-f-unispring-reflector.md) | Unispring / Reflector | HIGH | F9 → blocked.md |
| G | [lane-g-locale.md](lane-g-locale.md) | Locale | HIGH | G5/G6 → blocked.md |
| H | [lane-h-meta.md](lane-h-meta.md) | Meta / site-wide | HIGH | no |
| — | [blocked.md](blocked.md) | Decisions/verification needed (one owner) | — | — |
| — | [verified-consistent.md](verified-consistent.md) | Confirmed correct — do not re-investigate | — | — |

**Suggested order:** Lane H first (stops future drift), then A–G in parallel.

## Cross-lane coordination

- **`content/uniteum/CLAUDE.md` is shared by Lanes A and B.** Lane A owns the file. Lane B's CLAUDE.md-related notes (ONE_MINTED, `dw` ×0/×1/×2 scaling, WBTC EIP-55 shorthand line) are delegated to Lane A task **A7**. Lane B must not edit that file.
- No other file is touched by more than one lane.

## Root causes (why the ~60 findings cluster)

1. **Stale root `CLAUDE.md` (Jekyll → Hugo).** Describes `_data/`, `site.data.*`, Liquid `{% raw %}{% for %}{% endraw %}` tables, `index.md`, GitHub Pages, solc 0.8.30, a non-existent `Unit.json`. Repo is Hugo (`content/`, `data/`, shortcodes, Cloudflare, solc 0.8.34). Highest leverage — `always.md` mandates self-correcting CLAUDE.md, so every stale pattern keeps re-introducing doc errors. → **Lane H**.
2. **Missing `variant` parameter.** Lepton, Reflector, Locale are all `Prototype`/Bitsy-based and gained a trailing `uint256 variant` (XOR'd into the CREATE2 salt). All three docs predate it → documented signatures cause failed transactions. → **Lanes E, F, G**.
3. **Deployed addresses drifted.** Lepton factory, Reflector/Fountain prototypes, 1xUSDC peg-lookup, locale USDC lookup, Solid "Uniteum 1" identity — wrong or unverifiable. Several need a human decision. → **blocked.md**.
4. **Uniteum forge sign error.** One conceptual mistake (wrong "1" cash-flow direction, omitted floating-pair ×2 factor, treating invariant `w` as custodied "1") propagated across `forge.md`, `tokenomics.md`, `economics-of-one.md`. → **Lane A**.

## FYI (not a docs fix)

Deployed Reflector bytecode reports **v0.9.3**; local `unispring/src/Reflector.sol` is still **v0.9.0**. Source lags deployment (commits `2ef5f5d`, `aa8e506`). Flag to maintainer.
