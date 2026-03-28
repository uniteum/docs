# CLAUDE.md - Uniteum Project

Protocol-specific guidance lives in `uniteum/CLAUDE.md`, `solid/CLAUDE.md`, and `liquid/CLAUDE.md`. This file covers shared site-wide conventions.

## Project Overview

This documentation site (uniteum.one) covers **three independent protocols** under the Uniteum umbrella:

1. **Solid** — A protocol for making tokens with fair launch, built-in trading pools, and permanent price floors. Standalone, no dependencies on the other protocols.
2. **Liquid** — A protocol that wraps ERC-20 tokens with built-in AMM liquidity via a hub-and-spoke model. Standalone protocol.
3. **Uniteum** — An algebraic liquidity protocol where ERC-20 tokens have dimensional units (like physical quantities: m/s, kg*m, etc.) or floating units (USD, BTC, foo). Units compose algebraically, and price consistency is maintained through arbitrage-enforced forge operations rather than oracles.

**Key Innovation (Uniteum):** Multi-dimensional constant-product AMM where algebraic relationships create liquidity pools. Forge operations work on triads (U, V, √(U·V)) where the geometric-mean Unit is √(U·V), creating a mesh topology of arbitrage paths.

**Relationship between protocols:** The three protocols are **independent peers**, not layers. They share an ecosystem and a strategic token choice: the **Solid "Uniteum 1"** token is used as:
- The backing token for the **Liquid Hub** (Solid → Liquid)
- The backing token for **Unit "1"** in the Uniteum protocol (Solid → Uniteum)

These are **strategic choices** to concentrate value and stability around the Solid "Uniteum 1" token — not architectural dependencies. Either protocol could use a different backing token.

## Site Structure

The site is organized as three peer protocol sections plus shared root-level pages:

```
uniteum.one/
├── index.md              ← Umbrella landing page for all three protocols
├── legal.md              ← Site-wide legal (root level)
├── license.md            ← Site-wide license (root level)
├── uniteum/              ← Uniteum protocol docs
│   ├── index.md
│   ├── getting-started.md
│   ├── economics-of-one.md
│   ├── use-cases.md
│   ├── safety.md
│   ├── known-issues.md
│   ├── concepts/
│   ├── guides/
│   ├── reference/
│   └── examples/
├── solid/                ← Solid protocol docs (peer)
│   ├── index.md
│   ├── protocol.md
│   └── use-cases/
└── liquid/               ← Liquid protocol docs (peer)
    ├── index.md
    ├── introduction.md
    ├── design.md
    └── use-cases/
```

**Path convention:** All Uniteum-specific content lives under `/uniteum/`. Solid under `/solid/`. Liquid under `/liquid/`. Only truly site-wide pages (legal, license, landing page) remain at root.

## Collaboration Context

This project uses both **Claude** and **ChatGPT** for documentation and development:

- **ChatGPT** focuses on: conceptual consistency, normative spec text, Jekyll markdown pages, terminology
- **Claude** focuses on: code implementation, contract interactions, technical reference, examples

**Key collaboration files:**
- `.meta/CHATGPT.md` - ChatGPT's guidelines and constraints
- `.meta/PROJECT_CONSTITUTION.md` - Normative rules (authoritative alongside Unit.json)
- `.meta/HANDOFF_TEMPLATE.md` - Template for handoffs between AI assistants
- `.meta/EXAMPLES.md` - Cross-protocol convention for worked examples (load when creating/editing examples)

**Authoritative sources (in order):**
1. Unit.json (compiled source bundle / canonical reference for implementation intent)
2. `.meta/PROJECT_CONSTITUTION.md` (normative rules and scope)
3. Other docs in this project (non-normative unless explicitly stated)

## Deployed Contracts

Current contract addresses are maintained in `_data/contracts.yml`. Key contracts:

- **Current Uniteum "1"**: `site.data.contracts.uniteum` (flat, no version indirection)
- **Genesis Uniteum "1"**: `site.data.contracts.genesis` (original v0.0 supply)
- **Helper**: `site.data.contracts.helper`
- **Deployer**: `site.data.contracts.deployer`

All our contracts use deterministic deployment (same address on all networks). Use `.address` to access. See `_data/CLAUDE.md` for the address field convention (single `address` for our contracts, per-network fields for external contracts).

**IMPORTANT**: No version indirection. Access data directly: `site.data.contracts.uniteum.address`.

## Project Status

### Current Phase

- **Version:** See `site.data.contracts.uniteum.version` (experimental, unaudited)
- **Status:** Deployed, ready for launch/announcement
- **Risk:** Novel mechanism, smart contract risk, no audit
- **Goal:** Publish for experimentation and discovery of emergent properties

### Creator

- Solo developer: Paul Reinholdtsen (reinholdtsen.eth)
- GitHub: github.com/uniteum
- ENS: 0.eoa.uniteum.eth

### Tech Stack

- **Contracts:** Solidity 0.8.30, Foundry (forge), OpenZeppelin
- **Architecture:** Minimal proxy clones (EIP-1167), deterministic deployment
- **Development:** VSCode, GitHub
- **Documentation:** Jekyll, GitHub Pages
- **Domain:** uniteum.one → uniteum.github.io
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

- Never hardcode values that exist in `_data/` files — always reference the data
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
- Contract deployment table: `[0x9df9b0501e8f6c05623b5b519f9f18b598d9b253](https://etherscan.io/address/0x9df9b0501e8f6c05623b5b519f9f18b598d9b253#code)` (display full address)
- Unit token reference: `[foo](https://etherscan.io/token/0x966108210F3B2eC0f01B646a61Ce7D8F1aDE7430)` (descriptive anchor text)
- Tutorial forge step: `[Uniteum contract](https://etherscan.io/address/0x9df9b0501e8f6c05623b5b519f9f18b598d9b253#writeContract)` (descriptive anchor text)
- Checking invariants: `[read the invariant](https://etherscan.io/address/0x9df9b0501e8f6c05623b5b519f9f18b598d9b253#readContract)` (descriptive anchor text)
- Example transaction: `[This forge transaction](https://etherscan.io/tx/0xabcd1234...)` (use full tx hash in URL, can shorten display text)

### Data-Driven Function Reference Tables

Tutorial quick reference tables are **data-driven** — function names, Etherscan F# indices, and descriptions live in `_data/<protocol>.yml`, not hardcoded in markdown.

**Data file schema** (`_data/<protocol>.yml`) — one file per protocol, maps keyed by function signature:
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

**Table pattern** (quick reference — iterates the map):
```markdown
{% raw %}{% for f in site.data.<protocol>.write %}| [`{{ f[0] }}`](...#writeContract#F{{ f[1].f }}){:target="_blank"} | {{ f[1].description }} |
{% endfor %}{% endraw %}
```

**Inline pattern** (tutorial body — random access by function name):
```markdown
{% raw %}{% assign fn = site.data.<protocol> %}
[sell](https://etherscan.io/address/{{spoke.address}}#writeContract#F{{ fn.write["sell(s)"].f }}){:target="_blank"}{% endraw %}
```

**Verifying F# indices:** Open the contract on Etherscan, select Read/Write Contract tab, and count the function's alphabetical position. Etherscan sorts all public/external functions alphabetically (including inherited ERC20 functions like `approve`, `transfer`, `balanceOf`, etc.).

**Current data files:**
- `_data/liquid.yml` — Liquid protocol functions (includes ERC-20 functions at Liquid-specific positions)
- `_data/solid.yml` — Solid protocol functions
- `_data/lepton.yml` — Lepton protocol functions

❌ WRONG: Hardcoded F# indices in markdown (inline or tables)
❌ WRONG: Combining read and write functions in one table
❌ WRONG: Using arrays in the YAML (use maps keyed by function signature)
✅ CORRECT: Maps keyed by function signature, enabling both iteration and random access
✅ CORRECT: Separate Write and Read tables, driven by `_data/<protocol>.yml`

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

**Last Updated:** March 2026
**Creator:** Paul Reinholdtsen (reinholdtsen.eth)
