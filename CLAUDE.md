# CLAUDE.md - Uniteum Docs Site

Protocol-specific guidance lives in `content/uniteum/CLAUDE.md`, `content/solid/CLAUDE.md`, and `content/liquid/CLAUDE.md`. This file covers shared site-wide conventions.

## Project Overview

This documentation site (uniteum.one) covers a family of **independent peer projects** published under the Uniteum umbrella:

1. **Solid** — A protocol for making tokens with fair launch, built-in trading pools, and permanent price floors. Standalone, no dependencies on the other protocols.
2. **Liquid** — A protocol that wraps ERC-20 tokens with built-in AMM liquidity via a hub-and-spoke model. Standalone protocol.
3. **Uniteum** — An algebraic liquidity protocol where ERC-20 tokens have dimensional units (like physical quantities: m/s, kg*m, etc.) or floating units (USD, BTC, foo). Units compose algebraically, and price consistency is maintained through arbitrage-enforced forge operations rather than oracles.
4. **Lepton** — A fixed-supply ERC-20 token factory.
5. **Unispring** — A family of permissionless Uniswap V4 primitives: the Fountain V4-position owner, the Manifold fair-launch factory, and the Reflector sibling 1:1 mirror factory.
6. **Locale** — Immutable reference-data lookups at deterministic addresses, chain-aware (same address everywhere, contents vary per chain).

**Key Innovation (Uniteum):** Multi-dimensional constant-product AMM where algebraic relationships create liquidity pools. Forge operations work on triads (U, V, √(U·V)) where the geometric-mean Unit is √(U·V), creating a mesh topology of arbitrage paths.

**Relationship between protocols:** All six are **independent peers**, not layers. Solid, Liquid, and Uniteum share an ecosystem and a strategic token choice: the **Solid "Uniteum 1"** token is used as:
- The backing token for the **Liquid Hub** (Solid → Liquid)
- The backing token for **Unit "1"** in the Uniteum protocol (Solid → Uniteum)

These are **strategic choices** to concentrate value and stability around the Solid "Uniteum 1" token — not architectural dependencies. Either protocol could use a different backing token.

All six protocols are **Bitsy contracts** — immutable, permissionless, governance-free prototype/factory contracts. See [content/bitsy.md](content/bitsy.md) for the formal definition.

## Site Structure

The site is built with **Hugo** + the **hugo-book** theme. All published pages live under `content/`. Sections use `_index.md` for the landing page rather than `index.md`.

```
content/
├── _index.md             ← Site landing page (uniteum.one/)
├── glossary.md           ← Site-wide glossary (served at /glossary/)
├── legal.md              ← Site-wide legal
├── license.md            ← Site-wide license
├── bitsy.md              ← Bitsy contract definition (eight properties)
├── philosophy.md         ← Design philosophy behind the protocols
├── why.md                ← Motivation / pitch
├── uniteum/              ← Uniteum protocol docs
│   ├── _index.md
│   ├── getting-started.md
│   ├── economics-of-one.md
│   ├── use-cases.md
│   ├── safety.md
│   ├── known-issues.md
│   ├── CLAUDE.md         ← Protocol-specific Claude rules
│   ├── concepts/
│   ├── guides/
│   ├── reference/
│   ├── research/
│   └── examples/
├── solid/                ← Solid protocol docs (peer)
│   ├── _index.md
│   ├── CLAUDE.md
│   ├── protocol.md
│   ├── tutorial.md
│   ├── nothing.md
│   ├── uniteum-1.md
│   └── use-cases/
├── liquid/               ← Liquid protocol docs (peer)
│   ├── _index.md
│   ├── CLAUDE.md
│   ├── introduction.md
│   ├── design.md
│   ├── tutorial.md
│   ├── vision.md
│   ├── 2x-mint.md
│   ├── 2x-mint-formal.md
│   └── use-cases/
├── lepton/               ← Lepton factory docs (peer)
│   └── _index.md
├── unispring/            ← Unispring docs (Fountain + Manifold + Reflector)
│   ├── _index.md
│   ├── fountain.md
│   ├── manifold.md
│   ├── mimicry.md
│   └── mimicry-mechanics.md
├── reflector/            ← Reflector docs (sibling 1:1 mirror factory)
│   ├── _index.md
│   ├── mechanics.md
│   ├── reference.md
│   ├── fdv.md
│   ├── uniteum-1xeth.md
│   └── uniteum-1xusdc.md
└── locale/               ← Locale reference-data docs (peer)
    ├── _index.md
    └── deterministic-lookup.md
```

**Path convention:** All Uniteum-specific content lives under `content/uniteum/`. Solid under `content/solid/`. Liquid under `content/liquid/`. Lepton under `content/lepton/`. Unispring under `content/unispring/`. Reflector under `content/reflector/`. Locale under `content/locale/`. Only truly site-wide pages (glossary, legal, license, bitsy, philosophy, why, landing) remain at the top of `content/`. The glossary is site-wide and must stay alphabetized — see `.claude/rules/glossary.md`.

## Collaboration Context

This project uses both **Claude** and **ChatGPT** for documentation and development:

- **ChatGPT** focuses on: conceptual consistency, normative spec text, Hugo markdown pages, terminology
- **Claude** focuses on: code implementation, contract interactions, technical reference, examples

**Key collaboration files:**
- `.meta/CHATGPT.md` - ChatGPT's guidelines and constraints
- `.meta/PROJECT_CONSTITUTION.md` - Normative rules (Uniteum protocol scope)
- `.meta/HANDOFF_TEMPLATE.md` - Template for handoffs between AI assistants
- `.meta/EXAMPLES.md` - Cross-protocol convention for worked examples (load when creating/editing examples)

**Authoritative sources (in order):**
1. The Solidity source in the sibling repos under `/home/paul/git/uniteum/` (one per protocol — `uniteum/`, `solid/`, `liquid/`, `lepton/`, `unispring/`, `locale/`, `crucible/`). The on-chain bytecode is the ultimate authority; the source repos mirror that.
2. `.meta/PROJECT_CONSTITUTION.md` (normative rules and scope for the Uniteum-protocol symbolic unit system specifically)
3. Other docs in this project (non-normative unless explicitly stated)

> **Note on `Unit.json`:** Older `.meta/` documents reference a `Unit.json` "compiled source bundle" as an authoritative source. That artifact is **not present** in this repo. Treat it as historical context; defer to the Solidity sources and the constitution instead.

## Deployed Contracts

Current contract addresses are maintained in **`data/`** (Hugo data files), one YAML file per protocol — `data/contracts.yml`, `data/solid.yml`, `data/liquid.yml`, `data/lepton.yml`, `data/unispring.yml`, `data/locale.yml`, etc.

Key Uniteum-protocol contracts (in `data/contracts.yml`):

- **Current Uniteum "1"**: `contracts.uniteum` (flat, no version indirection)
- **Genesis Uniteum "1"**: `contracts.genesis` (original v0.0 supply)
- **Helper**: `contracts.helper`
- **Deployer**: `contracts.deployer`

All our contracts use deterministic deployment (same address on all networks). Use `.address` to access. See `data/CLAUDE.md` (if present) for the address field convention (single `address` for our contracts, per-network fields for external contracts).

**IMPORTANT**: No version indirection. Access data directly: `contracts.uniteum.address`.

## Project Status

### Current Phase

- **Status:** Deployed, ready for launch/announcement (Uniteum/Solid/Liquid/Lepton); Unispring & Reflector in draft / pre-deploy.
- **Risk:** Novel mechanism, smart contract risk, no audit
- **Goal:** Publish for experimentation and discovery of emergent properties

The current Uniteum version label lives in the data (e.g. `contracts.uniteum.name` is "Uniteum-0.7 1"). Reference data — don't hardcode versions in prose.

### Creator

- Solo developer: Paul Reinholdtsen (reinholdtsen.eth)
- GitHub: github.com/uniteum
- ENS: 0.eoa.uniteum.eth

### Tech Stack

- **Contracts:** Solidity (`pragma ^0.8.30` for the original Uniteum/Solid/Liquid protocols, `^0.8.34` for newer projects — Lepton/Unispring/Locale/Crucible), Foundry (forge), OpenZeppelin
- **Architecture:** Minimal proxy clones (EIP-1167), deterministic deployment via CREATE2
- **Development:** VSCode, GitHub
- **Documentation:** [Hugo](https://gohugo.io/) with the [hugo-book](https://github.com/alex-shpak/hugo-book) theme (pinned to v13, vendored under `themes/hugo-book` as a git submodule)
- **Hosting:** Cloudflare Pages (configured in `wrangler.toml`; build command `hugo --minify`, output directory `public/`)
- **Domain:** uniteum.one (CNAME) → Cloudflare Pages
- **Main repo:** github.com/uniteum/uniteum
- **Docs repo:** github.com/uniteum/docs

## Documentation Approach

### Target Audience

- Crypto-native developers
- DeFi experimenters and researchers
- Technical sophistication assumed
- NOT targeting mainstream/beginners initially

### Voice & Style

- **Technical but accessible:** Precise without being academic
- **Show, don't just tell:** Concrete examples, Etherscan links
- **Emphasize novelty:** This is experimental, invite exploration
- **Honest about unknowns:** "We don't know what emerges at scale"
- **Safety-conscious:** Clear risk disclosures

### Writing Guidelines

- Never hardcode values that exist in `data/` files — always reference the data via the `val` shortcode or other data-driven shortcodes
- Lead with concrete examples before theory
- Include Etherscan transaction links for everything
- Link related concepts bidirectionally
- Provide "try it yourself" steps

### Linking Contract Addresses

**ALWAYS link contract addresses to Etherscan with context-appropriate anchors:**

**Network Selection:**
- Main documentation → Mainnet (etherscan.io)
- Developer/testing sections → Sepolia (sepolia.etherscan.io)
- When showing both networks, clearly label each

**Etherscan Section Anchors:**
- `#code` - Verified source code (deployment tables, technical reference)
- `#writeContract` - Interactive write functions (tutorials, "try it yourself")
- `#readContract` - Query contract state (exploring invariants, checking balances)
- `#events` - Event logs and transaction history
- No anchor - General contract overview page
- Specific transaction: Full tx hash link (e.g., `https://etherscan.io/tx/0x...`)

**Link Format by Type:**
- **Contracts** (Uniteum, Helper, etc.): Use `/address/<ADDRESS>#code`
  - Example: `https://etherscan.io/address/0x9df9b0501e8f6c05623b5b519f9f18b598d9b253#code`
- **Unit Tokens** (foo, bar, meter, etc.): Use `/token/<ADDRESS>`
  - Example: `https://etherscan.io/token/0x966108210F3B2eC0f01B646a61Ce7D8F1aDE7430`

**Examples:**
- Contract deployment table: `` [`0x9df9b0501e8f6c05623b5b519f9f18b598d9b253`](https://etherscan.io/address/0x9df9b0501e8f6c05623b5b519f9f18b598d9b253#code) `` (display full address)
- Unit token reference: `[foo](https://etherscan.io/token/0x966108210F3B2eC0f01B646a61Ce7D8F1aDE7430)` (descriptive anchor text)
- Tutorial forge step: `[Uniteum contract](https://etherscan.io/address/0x9df9b0501e8f6c05623b5b519f9f18b598d9b253#writeContract)` (descriptive anchor text)
- Checking invariants: `[read the invariant](https://etherscan.io/address/0x9df9b0501e8f6c05623b5b519f9f18b598d9b253#readContract)` (descriptive anchor text)
- Example transaction: `[This forge transaction](https://etherscan.io/tx/0xabcd1234...)` (use full tx hash in URL, can shorten display text)

**Prefer the shortcodes over hand-rolled URLs** whenever the address or function lives in `data/`. The shortcodes below resolve addresses, build URLs, and keep templates consistent.

### Hugo Shortcodes (use these instead of Liquid templating)

The site has a small set of shortcodes in `layouts/shortcodes/`. Use them to keep markdown driven by `data/` and free of hand-built URLs.

| Shortcode | What it does |
|:----------|:-------------|
| `val` | Generic `hugo.Data` lookup. `{{< val "contracts.uniteum.address" >}}` or `{{< val "solids" "1" "address" >}}` for keys with dots/digits. |
| `addr_table` | Renders a markdown table of `name`/`address` rows from a data map, with Etherscan links. `{{< addr_table data="contracts" >}}`. |
| `fn_table` | Renders the read- or write-function quick reference table for a protocol. `{{< fn_table proto="liquid" kind="write" token="liquids.hub.address" type="token" >}}`. |
| `efn` | Single Etherscan function link as raw HTML (works inside list items, table cells). Accepts `addr`, `fn` (dotted path) or `fn_path`+`fn_key`, plus `section`, `type`, `text`. |
| `reflector_clones` | Renders the Reflector "Deployed instances" section from `data/unispring.yml`'s `reflector.clones` map. |
| `contract`, `contract_table`, `token`, `unit`, `units_table`, `etherscan`, `genesis_address`, `genesis_name`, `uniteum_address`, `uniteum_name`, `references` | Other helpers — see `layouts/shortcodes/` for each one's parameters. |

**Anti-patterns (DO NOT use — these are Jekyll-era patterns and won't render in Hugo):**

- ❌ `{% raw %}{{ site.data.contracts.uniteum.address }}{% endraw %}` — use `{{</* val "contracts.uniteum.address" */>}}`
- ❌ `{% for f in site.data.liquid.write %}…{% endfor %}` — use `{{</* fn_table proto="liquid" kind="write" token="liquids.hub.address" */>}}`
- ❌ `{% assign fn = site.data.liquid %}` — use `{{</* val ... */>}}` or `{{</* efn ... */>}}`
- ❌ Trailing `{:target="_blank"}` Kramdown attribute syntax — Hugo's Goldmark doesn't render this. Use the `efn` shortcode if you need `target="_blank"`.

### Data-Driven Function Reference Tables

Tutorial quick reference tables are **data-driven** — function names, Etherscan F# indices, and descriptions live in `data/<protocol>.yml`, not hardcoded in markdown.

**Data file schema** (`data/<protocol>.yml`) — maps keyed by function signature:

```yaml
write:                    # functions on the Write Contract tab
  "buy(m)":               # key = function signature (used as link text)
    f: 3                  # Etherscan F# index
    description: "..."    # short description
read:                     # functions on the Read Contract tab
  "pool()":
    f: 13
    description: "..."
```

**Table pattern (preferred):** use the `fn_table` shortcode — it iterates the map and emits a markdown table with correctly-anchored Etherscan links.

```markdown
{{</* fn_table proto="liquid" kind="write" token="liquids.hub.address" type="token" */>}}
```

**Inline pattern (preferred):** use the `efn` shortcode for random access by function name inside prose, lists, or other table cells.

```markdown
{{</* efn addr="liquids.hub.address" fn_path="liquid.write" fn_key="sell(s)" section="writeContract" type="token" text="sell" */>}}
```

**Verifying F# indices:** Open the contract on Etherscan, select Read/Write Contract tab, and count the function's alphabetical position. Etherscan sorts all public/external functions alphabetically (including inherited ERC20 functions like `approve`, `transfer`, `balanceOf`, etc.).

**Current data files:**
- `data/liquid.yml` — Liquid protocol functions (includes ERC-20 functions at Liquid-specific positions)
- `data/solid.yml` — Solid protocol functions
- `data/lepton.yml` — Lepton protocol functions
- `data/unispring.yml` — Unispring (Fountain / Manifold / Reflector) functions
- `data/locale.yml` — Locale protocol functions

❌ WRONG: Hardcoded F# indices in markdown (inline or tables)
❌ WRONG: Combining read and write functions in one table
❌ WRONG: Using arrays in the YAML (use maps keyed by function signature)
✅ CORRECT: Maps keyed by function signature, enabling both iteration and random access
✅ CORRECT: Separate Write and Read tables, driven by `data/<protocol>.yml` via `fn_table`

## Self-Improvement Protocol

**CRITICAL:** When you make mistakes or the user corrects your understanding, IMMEDIATELY update the relevant CLAUDE.md file to prevent repeating the same mistake.

### When to Update:

1. **After being corrected** - If the user points out a mistake in your approach
2. **When discovering ambiguity** - If you realize existing guidance is unclear or incomplete
3. **When establishing new patterns** - If the user provides new conventions to follow
4. **When creating new tools/includes** - Document how and when to use them

### How to Update:

1. **Identify the root cause** - What knowledge was missing or wrong?
2. **Choose the right file** - Shared conventions → root CLAUDE.md, protocol-specific → protocol CLAUDE.md
3. **Add clear guidance** - Write explicit rules with examples
4. **Include anti-patterns** - Show what NOT to do (with ❌)

### Example Pattern:

When you realize you've been doing X wrong:
```markdown
**[Topic Name]:**

✅ CORRECT: [What to do]
❌ WRONG: [What not to do]

**Why:** [Explanation]
**Examples:** [Concrete examples]
```

**Remember:** These files are your persistent memory. If you don't update them, you'll repeat the same mistakes.

---

**Last Updated:** May 2026
**Creator:** Paul Reinholdtsen (reinholdtsen.eth)
