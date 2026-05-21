# Uniteum Docs - Project Memory

Repo-local memory index. Per `.claude/rules/always.md`, all project memory for this
repo lives in this directory — never under `~/.claude/projects/...` or any other
out-of-repo path.

## Site structure (current — May 2026)

The site is a Hugo + hugo-book theme docs site published to Cloudflare Pages,
serving six independent peer projects under the `uniteum.one` umbrella:

- `content/solid/` — fair-launch token protocol
- `content/liquid/` — hub-and-spoke liquidity wrapper
- `content/uniteum/` — algebraic-units protocol
- `content/lepton/` — fixed-supply token factory
- `content/unispring/` — Uniswap V4 primitives (Fountain / Manifold)
- `content/reflector/` — sibling 1:1 mirror factory
- `content/locale/` — chain-aware reference-data lookups

Root-level content pages: `content/_index.md` (umbrella landing), `content/legal.md`,
`content/license.md`, `content/glossary.md`, `content/bitsy.md`,
`content/philosophy.md`, `content/why.md`.

### Three-protocol relationship

Solid, Liquid, and Uniteum are **independent peers**. No architectural
dependencies. The Solid "Uniteum 1" token is strategically chosen as backing for
both:

- Liquid Hub token (wraps Solid "Uniteum 1")
- Unit "1" in Uniteum protocol (backed by Solid "Uniteum 1")

These are swappable choices, not requirements.

## Source repos layout

Protocol Solidity sources are **sibling repos** alongside `docs/`, under
`/home/paul/git/uniteum/`:

- `/home/paul/git/uniteum/uniteum/` — Uniteum protocol
- `/home/paul/git/uniteum/solid/` — Solid protocol
- `/home/paul/git/uniteum/liquid/` — Liquid protocol
- `/home/paul/git/uniteum/lepton/` — Lepton factory
- `/home/paul/git/uniteum/unispring/` — Unispring (Fountain/Manifold/Reflector)
- `/home/paul/git/uniteum/locale/` — Locale reference-data lookups
- `/home/paul/git/uniteum/crucible/` — Crucible

> Correction (was wrong in a previous note): the docs repo's `lib/` directory is
> **empty** — it is **not** a parent for protocol submodules. The only git
> submodule in this repo is `themes/hugo-book` (pinned to v13). Look for protocol
> Solidity in the sibling repos above, not in `docs/lib/`.

VS Code Solidity extension shows false-positive squiggles on some imports
(`iliquid`, `reentrancy`, `isolid`) because it doesn't fully resolve
`remappings.txt` for nested projects. This is cosmetic — `forge build` works
fine. Not worth fixing.

## Key conventions

- All content lives under `content/` and uses Hugo frontmatter (`title`,
  `weight`, etc.). Section landing pages are `_index.md`, not `index.md`.
- All data lives under `data/` (Hugo data files). Templates access via
  `hugo.Data` or — preferred from markdown — via the `val`, `addr_table`,
  `fn_table`, and `efn` shortcodes in `layouts/shortcodes/`.
- Cloudflare Pages reads `wrangler.toml`; build command `hugo --minify`, output
  `public/`.
- solc pragma: `^0.8.30` for the original three protocols (Uniteum/Solid/Liquid),
  `^0.8.34` for the newer projects (Lepton/Unispring/Locale/Crucible).
- No redirects needed (low traffic site).

## Project state

- [Deployment networks](canon/deployment-networks.md) — identical addresses on every chain; live on Arbitrum now, mainnet in weeks. Configurability = host swap only, no per-contract address data.
