# CLAUDE.md - Uniteum Project

## Project Overview

Uniteum is an algebraic liquidity protocol on Ethereum where ERC-20 tokens have dimensional units (like physical quantities: m/s, kg*m, etc.) or floating units (USD, BTC, foo). Units compose algebraically, and price consistency is maintained through arbitrage-enforced forge operations rather than oracles.

**Key Innovation:** Multi-dimensional constant-product AMM where algebraic relationships create liquidity pools. Forge operations work on triads (U, V, √(U·V)) where the geometric-mean Unit is √(U·V), creating a mesh topology of arbitrage paths.

## Collaboration Context

This project uses both **Claude** and **ChatGPT** for documentation and development:

- **ChatGPT** focuses on: conceptual consistency, normative spec text, Jekyll markdown pages, terminology
- **Claude** focuses on: code implementation, contract interactions, technical reference, examples

**Key collaboration files:**
- `.meta/CHATGPT.md` - ChatGPT's guidelines and constraints
- `.meta/PROJECT_CONSTITUTION.md` - Normative rules (authoritative alongside Unit.json)
- `.meta/HANDOFF_TEMPLATE.md` - Template for handoffs between AI assistants

**Authoritative sources (in order):**
1. Unit.json (compiled source bundle / canonical reference for implementation intent)
2. `.meta/PROJECT_CONSTITUTION.md` (normative rules and scope)
3. Other docs in this project (non-normative unless explicitly stated)

## Deployed Contracts

Current contract addresses are maintained in `_data/contracts.yml`. Key contracts:

- **Current Uniteum "1"**: Use `site.data.contracts.current.uniteum` to get current version key, then access `site.data.contracts.uniteum[current_version]`
- **Genesis Uniteum "1"**: See `site.data.contracts.uniteum.v0_0` (original supply - this is stable)
- **Current Kiosk**: Use `site.data.contracts.current.kiosk` to get current version key, then access `site.data.contracts.kiosk[current_version]`

**IMPORTANT**: Never hardcode version keys like `v0_3`. Always use the `site.data.contracts.current.*` pointers to get the current version dynamically.

All contracts use Nick's deterministic deployer (same addresses across networks).

## ENS Structure

See [reference/ens.md](/reference/ens/) for the complete ENS naming hierarchy. Key points:
- All names under `uniteum.eth`
- Version format: `{major}-{minor}.uniteum.eth` (e.g., `0-1.uniteum.eth`)
- Current and genesis "1" tokens have dedicated ENS names with Kiosk subdomains

## Core Mechanisms

### 1. The "1" Token

- Universal liquidity unit for all reciprocal pairs (U, 1/U, 1)
- Special property: √(U * 1/U) = 1 for any unit U
- Primordial supply: 1 billion tokens (minted once in v0.0, this is the ceiling for all versions)
- Current version supply grows through migration from v0.0 (reversible)
- Can also serve as reserve in triads like (1, U², U) where √(1 * U²) = U

See [concepts/units.md](/concepts/units/) for complete "1" token mechanics and [economics-of-one.md](/economics-of-one/) for value hypotheses.

### 2. Units & Reciprocals

- Every unit `U` has reciprocal `1/U`
- Invariant: `√(u · v) = w` where u, v are reserve unit supplies and w is liquidity unit supply
- Equivalently: `u · v = w²`
- For reciprocal pairs (U, 1/U): "1" serves as the liquidity unit, so √(u · v) = 1's supply
- For compound units: the geometric mean unit serves as the liquidity unit

See [concepts/tokenomics.md](/concepts/tokenomics/) for complete invariant mathematics and derivations.

### 3. Forge Operation (CRITICAL)

**Forge Triad Structure:**

Every forge operation works on a triad of three units: two **reserve units** (by convention) and one **geometric-mean Unit**. The geometric-mean Unit is always √(U·V) where U and V are the other two units in the triad.

**IMPORTANT TERMINOLOGY (ChatGPT normative language):**
- The geometric-mean Unit is a **first-class ERC-20 Unit** with its own supply
- Its supply is **constrained by the invariant** (w² = u · v), not computed on demand
- "Reserve units" and "geometric-mean Unit" are **conventional roles**, not fundamental distinctions
- The same Unit can be a reserve in one triad and a geometric-mean Unit in another

**Triad format:** `(U, V, √(U·V))` where:
- U and V are the **reserve units** (conventional terminology: the units being exchanged)
- √(U·V) is the **geometric-mean Unit** (conventional terminology: mediates the exchange, like Uniswap LP tokens)

**Examples of valid triads:**
- `(U, 1/U, 1)` — reciprocal pair with "1" as liquidity unit (since √(U * 1/U) = 1)
- `(meter², 1/second², meter/second)` — creates meter/second as liquidity unit (since √(meter² * 1/second²) = meter/second)
- `(foo², bar², foo*bar)` — creates foo*bar as liquidity unit (since √(foo² * bar²) = foo*bar)
- `(1, meter², meter)` — "1" as reserve unit (since √(1 * meter²) = meter)

**Connection to Power Perps:**

This geometric mean structure implements **arbitrary power perpetuals** (see [Paradigm research](https://www.paradigm.xyz/2024/03/everything-is-a-perp)).

**Examples:**
- `(U, 1/U, 1)` → 0.5 power perp (like Uniswap LP: √(U * 1/U) = 1)
- `(1, m², m)` → 1.0 power perp (linear exposure to m²)
- `(1, m^4, m²)` → 2.0 power perp (squared exposure to m^4)
- `(A^p, B^q, A^(p/2)*B^(q/2))` → Custom power perps with any rational exponent

This generalizes beyond Uniswap's 0.5 power perp to support arbitrary convexity profiles.

**This is the price control mechanism:**
- To increase U's price: burn U, mint 1/U (consumes "1")
- To decrease U's price: mint U, burn 1/U (generates "1")
- For compound units: `price(A^p*B^q)` enforced by arbitrage across triads

**Invariant enforcement:** `√(u · v) = w` where:
- u, v are reserve unit supplies
- w is geometric-mean Unit supply

**Local vs Global Invariants (ChatGPT emphasis):**
- Each triad enforces **one local invariant**: u · v = w²
- There is **NO global invariant** spanning multiple triads
- Global price consistency emerges from **arbitrage across overlapping triads**
- This is fundamental to the mesh topology design

**Price Formula:**
- `price(U) = v/u` where v = 1/U supply, u = U supply (see [concepts/tokenomics.md](/concepts/tokenomics/) for derivation)
- Equal supplies → parity; more U → U cheaper, 1/U more expensive

### 4. Anchored vs Floating Units

**Anchored Units:**
- Format: `$0xTokenAddress` (e.g., `$0xdAC17F958D2ee523a2206206994597C13D831ec7` for USDT)
- Backed 1:1 by external ERC-20 held by the Unit contract
- Real value, custodial
- Created via: `one().anchored(IERC20(address))`

**Floating Units:**
- Format: 30 chars max, `[a-zA-Z0-9_.-]+` (e.g., `USD`, `MSFT`, `kg`, `foo`)
- NO connection to real-world entities (MSFT ≠ Microsoft stock!)
- Value emerges from liquidity/consensus only
- Created via: `one().multiply("symbol")`

**IMPORTANT:** Floating "USD" has zero inherent connection to US dollars. It's just a label.

**Note on Terminology:** The contract code uses "anchored" and "unanchored" terminology (see IUnit.sol), but this documentation uses "anchored" and "floating" for clarity. They are equivalent: unanchored = floating.

### 5. Compound Units

**Creation through Geometric Mean Forging:**

Compound units are created by forging triads where the compound unit serves as the liquidity unit. To create any compound unit `A^p*B^q`, you forge the triad where it appears as the geometric mean of the reserves.

**Pattern:** To create `A^p*B^q`, forge `(A^(2p), B^(2q), A^p*B^q)`

**Examples:**
- Create `meter*second`: forge `(meter², second², meter*second)` since √(meter² * second²) = meter*second
- Create `meter/second`: forge `(meter², 1/second², meter/second)` since √(meter² * 1/second²) = meter/second
- Create `foo^(2/3)`: forge `(foo^(4/3), 1, foo^(2/3))` since √(foo^(4/3) * 1) = foo^(2/3)

**Algebraic notation:**
- Operators: `*` (multiply), `/` (divide), `^` (power), `:` (divide in exponent)
- Example: `kg*m/s^2` = force unit, `foo^2:3` = foo^(2/3)
- Address deterministically predicted via CREATE2 from symbol hash

### 6. Multi-Dimensional Arbitrage

**Arbitrage Paths through Geometric Mean Triads:**

The geometric mean structure creates multiple interconnected paths for achieving the same outcome, enabling arbitrage to enforce price consistency.

**Example: Creating exposure to A/B**

Multiple valid triads can involve the same units in different roles:
- **Direct path:** Forge `(A², 1/B², A/B)` — A/B serves as liquidity unit
- **Indirect path:** Forge `(A, 1/A, 1)` to exchange A for "1", then forge `(B, 1/B, 1)` to exchange "1" for 1/B
- **Compound path:** Create intermediate units and chain multiple forges

**Price Consistency through Arbitrage:**

Since the same unit can serve as a reserve in one triad and a liquidity unit in another, arbitrageurs will exploit any price inconsistencies across these paths. This creates a self-balancing mesh topology where:
- Liquidity flows through geometric mean relationships
- No oracles needed—prices emerge from invariant enforcement
- Multi-hop arbitrage paths keep all units aligned

### 7. Key Contract Implementation Details

**ONE_MINTED Constant:**
- Immutable value tracking the primordial "1" supply ceiling (1 billion)
- Total "1" supply across all versions will never exceed this value
- For current version: acts as maximum possible supply (reached only if 100% migration from v0.0)
- Set at deployment, provides supply ceiling

**Name Prefix:**
- All units are prefixed with version name (e.g., "Uniteum 0.3 ") in their ERC-20 name
- Example: "Uniteum 0.3 meter"
- Version prefix comes from contract deployment

**Sign Convention for Forge:**
- Positive `du`/`dv` values: mint units to caller
- Negative `du`/`dv` values: burn units from caller
- Critical for understanding forge operations

**Exponent Division:**
- Uses `:` character for division in exponents (not `/`)
- Example: `foo^2:3` means foo^(2/3)
- Simplifies parsing (avoids confusion with unit division and escaping issues)

**Reentrancy Protection:**
- Uses transient storage (EIP-1153) for reentrancy guards
- Applied to all forge operations
- Gas-efficient modern pattern

**UPSTREAM_ONE:**
- Points to v0.0 "1" token for migration
- Enables reversible migrate/unmigrate between versions
- Immutable, set at contract deployment

**UnitHelper Contract:**
- Helper contract for batch operations on units
- Deployed at same address across networks (deterministic deployment)
- See `site.data.contracts.helper` in contracts.yml for addresses
- Key functions:
  - `multiply(IUnit unit, string[] expressions)` - Create multiple units in one transaction
  - `product(IUnit unit, string[] expressions)` - Predict multiple unit addresses (view-only)
- Useful for deploying many units efficiently or batch address prediction
- Example: Deploy foo, bar, baz in single transaction by calling `helper.multiply(one, ["foo", "bar", "baz"])`

### 8. Two Distinct Layers (ChatGPT Framework)

**CRITICAL CONCEPTUAL SEPARATION:**

ChatGPT has established a clear framework distinguishing two layers that are often confused:

**Layer 1: Unit Identity Creation** (symbolic, structural)
- Determines **which Units exist** as ERC-20 contracts
- Parsing symbolic expressions (e.g., "m/s^2")
- Multiplication and reciprocal operations
- Canonicalization (deterministic normalization)
- Does NOT mint/burn balances
- Does NOT affect prices
- See [concepts/unit-creation.md](/concepts/unit-creation/)

**Layer 2: Forge Operations** (economic, balance changes)
- Mints and burns balances of **existing Units**
- Operates on triads with geometric-mean invariants
- Changes prices through supply changes
- Never creates new Unit identities
- See [concepts/forge.md](/concepts/forge/)

**Why this matters:**
- Confusing these layers leads to incorrect mental models
- Unit creation is permissionless and gas-efficient (just creates contracts)
- Economic impact only happens through forge
- A Unit can exist without any supply (no one has forged it yet)

### 9. Canonicalization Rules (ChatGPT Normative)

From `.meta/PROJECT_CONSTITUTION.md` and [concepts/canonicalization.md](/concepts/canonicalization/):

**Canonical Form Rules:**
- The identity unit is named **`1`** (not "unity" - this is a recent clarification)
- Canonical form **never uses negative exponents**
- Reciprocals are expressed structurally (e.g., `1/bar`, not `bar^-1`)
- Terms are ordered canonically (lexical ordering of packed terms)
- Canonical rendering is deterministic: same unit → exactly one canonical string
- Exponent division uses `:` character (e.g., `foo^2:3` means foo^(2/3))

**Parser vs Canonical:**
- Parser may accept non-canonical input (e.g., `bar^-1`)
- All output must use canonical form (e.g., `1/bar`)
- Documentation should use canonical forms unless explicitly labeled

### 10. Terminology: Reserve Units and Geometric-Mean Units

**Understanding Triad Positions:**

Every forge operation involves three units in specific roles:

**Reserve Units (U and V):**
- The two units being exchanged in a forge operation
- Called "reserve units" by analogy to AMM reserves (the x and y in x*y=k)
- Can be any valid units, including "1"
- In function calls: one is `this` (the calling contract), the other is parameter `V`

**Liquidity Unit (√(U*V)):**
- The geometric mean of the two reserve units
- Mediates the exchange between reserve units (analogous to Uniswap LP tokens)
- Its supply follows the invariant: `√(u * v) = w` where u, v are reserve supplies, w is liquidity supply
- Can be "1" for reciprocal pairs, or any compound unit like `meter/second`

**Triad Validity Constraints:**
1. **Geometric mean**: √(U * V) must equal W
   - Example: `(1, m², m)` is valid because √(1 * m²) = m ✓
   - Example: `(1, m, m)` is invalid because √(1 * m) = √m ≠ m ✗
2. **No duplicate reserves**: U ≠ V (reserve units must be different)
   - Example: `(bar, bar, bar)` is invalid even though √(bar * bar) = bar (duplicate reserves)
   - Raises `DuplicateUnits()` error

Units can occupy different roles in different triads, enabling multi-role composition.

**Example:**
In triad `(meter², 1/second², meter/second)`:
- Reserve units: meter² and 1/second²
- Liquidity unit: meter/second (since √(meter² * 1/second²) = meter/second)

**Multi-Role Composition:**
The same unit can serve different roles in different triads:
- `meter/second` is a liquidity unit in `(meter², 1/second², meter/second)`
- `meter/second` could be a reserve unit in `(meter²/second², kg², kg*meter/second)`

This multi-role capability creates the interconnected mesh topology of liquidity.

## Project Status

### Current Phase

- **Version:** See `site.data.contracts.current.uniteum` (experimental, unaudited)
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

## Common Commands

```bash
forge build
forge test
forge test -vvv          # verbose output
forge script <script>    # deployment scripts
```

## Distribution Strategy

See [getting-started.md](/getting-started/) for complete acquisition and migration instructions. Key points:
- Genesis supply: 1B "1" tokens (primordial ceiling for all versions)
- Available via Discount Kiosk with linear discount pricing
- Current version supply grows through migration from v0.0 (reversible)

## Design Philosophy

### Core Principles

- **No oracles:** Prices emerge from forge operations and arbitrage
- **Algebraic composition:** Units multiply/divide like dimensional analysis
- **Liquidity = price control:** Forging is market making
- **Mathematical constraints = economic constraints:** Invariants enforce price relationships
- **Permissionless:** Anyone can create units, forge, arbitrage
- **Minimalist:** Simple primitives, complex emergent behavior

### What Makes This Novel

Traditional AMM: `x * y = k` (one pool, two tokens, isolated)

Uniteum:
- `√(u * v) = w` for every forge triad (two reserves, one liquidity unit)
- Liquidity units are geometric means: √(U*V) mediates U and V
- Units can serve as reserves in one triad, liquidity in another
- Infinite interconnected pools through multi-role composition
- One operation (forge) handles all swaps, minting, burning
- Implements **arbitrary power perps** via geometric mean structure (generalizes Uniswap's 0.5 power perps)
- No oracles, no collateral requirements for synthetics

## Key Documentation Added by ChatGPT

The following pages provide normative definitions and conceptual framework:

### Core Conceptual Pages

1. **[Mental Model](/concepts/mental-model/)** - High-level way to think about Uniteum
   - "Units are tokens, not labels"
   - "Triads are the only place economics happens"
   - "Everything is local, consistency is global"

2. **[Unit Syntax](/concepts/unit-syntax/)** - How unit expressions are written
   - Operators: `*`, `/`, `^`
   - Identity unit: `1`
   - Precedence rules

3. **[Unit Creation](/concepts/unit-creation/)** - How Unit identities come into existence
   - **Separate from forge** (this is critical)
   - Parsing, multiplication, reciprocals
   - Canonicalization

4. **[Canonicalization](/concepts/canonicalization/)** - Normalization rules
   - Ensures uniqueness of Unit identities
   - No negative exponents in canonical form
   - Deterministic rendering

5. **[Glossary](/reference/glossary/)** - Canonical definitions
   - Unit, Base Unit, Compound Unit
   - Identity Unit, Reciprocal
   - Forge, Triad, Geometric-Mean Unit
   - Invariant, Mesh, Arbitrage

### Meta/Normative Documents

1. **`.meta/PROJECT_CONSTITUTION.md`** - Normative rules
   - Authoritative alongside Unit.json
   - Defines scope (what's in/out)
   - Canonical form rules

2. **`.meta/CHATGPT.md`** - ChatGPT collaboration guide
   - What ChatGPT can/cannot do
   - Constraints and deliverable format

3. **`.meta/HANDOFF_TEMPLATE.md`** - Template for AI handoffs
   - Goal, constraints, files to touch
   - Definition of done

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

### Documentation Structure

```
uniteum.one/
├── Introduction (what/why/how)
├── Getting Started (practical first steps)
├── Concepts (forge, units, invariants, composition)
├── Operations (creating units, forging, price control)
├── Examples (concrete use cases with transactions)
├── Technical Reference (contracts, functions, addresses)
├── Use Cases (speculation on possibilities)
└── Safety & Risks (disclaimers, experimental status)
```

### Writing Guidelines

- Lead with concrete examples before theory
- Include Etherscan transaction links for everything
- Distinguish clearly between anchored and floating units
- **Explain geometric mean triads:** All forges use `(U, V, √(U*V))` structure
- **Emphasize liquidity unit role:** Units serve different roles in different triads
- **Show the "1" constraint:** "1" only in liquidity position, never as reserve
- Use dimensional analysis analogies (physics helps intuition)
- Link related concepts bidirectionally
- Provide "try it yourself" steps
- Reference power perp connection for theoretical grounding

**Unit Expression Formatting:**

When displaying unit expressions (base units, compound units, or anchored units), the entire expression is a single syntactic entity and must be formatted as such:

- ✅ CORRECT: `meter/second`, `$WETH/second`, `foo*bar^2`
- ❌ WRONG: `meter`/`second`, {% include token.html ... %}`/second`, `foo*`bar`^2`

**Key principle:** Never split a unit expression across formatting boundaries. If using code formatting, links, or Jekyll includes, the entire compound expression should be treated as one unit.

**Examples:**
- Simple compound: `meter/second` (not `meter`/`second`)
- With links: Use `<code>$0xC02a...56Cc2/second</code>` as the link text (not `<code>$0xC02a...56Cc2</code>` followed by `/second`)
- In prose: "The unit `kg*meter/second^2` represents force" (not "The unit `kg*meter`/`second^2`...")

**CRITICAL: Three Distinct Entities for Tokens**

When working with tokens like WETH, there are THREE distinct entities that must NOT be confused:

1. **External ERC-20 Token Contract** - `0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2`
   - This is the actual WETH contract on Ethereum
   - Lives in `site.data.contracts.tokens.weth.mainnet`
   - Link using: `{% include token.html address=site.data.contracts.tokens.weth.mainnet %}`
   - This is what backs the anchored unit

2. **Anchored Uniteum Unit** - `$0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2`
   - This is the Uniteum Unit that wraps the external WETH token 1:1
   - Has its own address (different from the WETH contract!)
   - Stored in `site.data.example_units` as symbol `$0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2`
   - Link using: `{% include unit.html symbol="$0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2" %}`
   - The `$` prefix indicates it's an anchored Unit

3. **Floating WETH Unit** - `WETH`
   - This is a Uniteum Unit with the symbol "WETH" (NO $ prefix, NO address)
   - Has ZERO connection to real WETH or the WETH contract
   - Just a label/symbol, value emerges only from liquidity
   - Stored in `site.data.example_units` as symbol `WETH` (if it exists)
   - Link using: `{% include unit.html symbol="WETH" %}`

**Linking Rules:**

- External token (0xC02a...): Use `token.html` with address from `contracts.tokens.*.mainnet`
- Anchored Unit ($0xC02a...): Use `unit.html` with symbol including `$` prefix
- Floating Unit (WETH): Use `unit.html` with symbol (no `$` prefix)

**Common Mistakes to Avoid:**

- ❌ **CRITICAL:** Using `token.html` for anchored Units
  - Example wrong: `{% include token.html address=site.data.contracts.tokens.weth.mainnet text="$0xC02a..." %}`
  - **Why wrong:** This links to the external WETH contract (0xC02a...), NOT the anchored Uniteum Unit
  - **Correct:** `{% include unit.html symbol="$0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2" %}`
- ❌ Linking `$0xC02a...` to the WETH contract (they're different contracts!)
- ❌ Treating `WETH` (floating) as if it has connection to real WETH
- ❌ Confusing the external token address with the anchored Unit address

**Quick Reference - Which Include to Use:**

```liquid
{%- comment -%} External WETH token contract (0xC02a...) - NOT anchored Unit {%- endcomment -%}
{% include token.html address=site.data.contracts.tokens.weth.mainnet %}

{%- comment -%} Anchored Uniteum Unit ($0xC02a...) - The wrapper Unit {%- endcomment -%}
{% include unit.html symbol="$0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2" %}

{%- comment -%} Floating Uniteum Unit (WETH) - No connection to real WETH {%- endcomment -%}
{% include unit.html symbol="WETH" %}
```

**Anchored Unit Notation Convention:**

For documentation readability, use shorthand notation like `$WETH`, `$USDC`, `$WBTC` in explanations and examples, BUT:

- **Link first occurrence** to token reference pages (e.g., `[$WETH](/reference/anchored-units/weth/)`)
- Add callout at top of page: "We use [$WETH](/reference/anchored-units/weth/), [$USDC](/reference/anchored-units/usdc/), etc. as readable shorthands. See [Anchored Units](/reference/anchored-units/) for actual symbols."
- In technical reference or code examples, show real addresses
- Emphasize the distinction: floating `WETH` ≠ anchored `$0xC02a...56Cc2` ≠ WETH contract `0xC02a...56Cc2`

Common anchored unit shorthands (all have dedicated reference pages):
- [$WETH](/reference/anchored-units/weth/) = anchored Unit `$0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2` (backed by WETH contract)
- [$USDC](/reference/anchored-units/usdc/) = anchored Unit `$0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48` (backed by USDC contract)
- [$USDT](/reference/anchored-units/usdt/) = anchored Unit `$0xdAC17F958D2ee523a2206206994597C13D831ec7` (backed by USDT contract)
- [$WBTC](/reference/anchored-units/wbtc/) = anchored Unit `$0x2260FAC5E5542a773Aa44fBCfEDf7C193bc2C599` (backed by WBTC contract)
- [$DAI](/reference/anchored-units/dai/) = anchored Unit `$0x6B175474E89094C44Da98b954EedeAC495271d0F` (backed by DAI contract)

**Anchored Unit Pages:** Located in `/reference/anchored-units/` directory. Each page explains:
- The shorthand vs actual symbol
- What the token is backed by (with Etherscan link to the external token contract)
- Floating vs anchored distinction
- Example derivatives and use cases
- How to create the anchored unit

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
- **Contracts** (Uniteum, Kiosk, etc.): Use `/address/<ADDRESS>#code`
  - Example: `https://etherscan.io/address/0x9df9b0501e8f6c05623b5b519f9f18b598d9b253#code`
- **Unit Tokens** (foo, bar, meter, etc.): Use `/token/<ADDRESS>`
  - Example: `https://etherscan.io/token/0x966108210F3B2eC0f01B646a61Ce7D8F1aDE7430`

**Examples:**
- Contract deployment table: `[0x9df9b0501e8f6c05623b5b519f9f18b598d9b253](https://etherscan.io/address/0x9df9b0501e8f6c05623b5b519f9f18b598d9b253#code)` (display full address)
- Unit token reference: `[foo](https://etherscan.io/token/0x966108210F3B2eC0f01B646a61Ce7D8F1aDE7430)` (descriptive anchor text)
- Tutorial forge step: `[Uniteum contract](https://etherscan.io/address/0x9df9b0501e8f6c05623b5b519f9f18b598d9b253#writeContract)` (descriptive anchor text)
- Checking invariants: `[read the invariant](https://etherscan.io/address/0x9df9b0501e8f6c05623b5b519f9f18b598d9b253#readContract)` (descriptive anchor text)
- Example transaction: `[This forge transaction](https://etherscan.io/tx/0xabcd1234...)` (use full tx hash in URL, can shorten display text)

## Terminology Alignment (Claude ↔ ChatGPT)

To ensure consistency between AI assistants, use these aligned terms:

### Preferred Terms (ChatGPT normative)

| Use This | Not This | Why |
|----------|----------|-----|
| **geometric-mean Unit** | "liquidity unit" (acceptable for intuition) | Emphasizes it's a first-class ERC-20, not derived |
| **Unit** (capital U) | "token" (when referring to Uniteum tokens) | Distinguishes Uniteum Units from generic ERC-20s |
| **identity Unit** or **`1`** | "unity" | PROJECT_CONSTITUTION.md specifies `1` |
| **triad** | "pool" or "pair" | Accurate (three units, not two) |
| **local invariant** | "the invariant" | Emphasizes no global invariant exists |
| **Unit identity creation** | "creating a unit" (ambiguous) | Separates from forge/minting |
| **canonical form** | "normalized form" | Matches PROJECT_CONSTITUTION.md |
| **structural reciprocal** | "inverse" | Emphasizes it's a distinct Unit, not math operation |

### Context-Dependent Terms

- **"Reserve units"** and **"geometric-mean Unit"** are **conventional roles** in a triad, not fundamental properties
- The same Unit can be a reserve in one triad and geometric-mean Unit in another
- Use these terms for intuition and examples, but note they're conventional

### Symbol Notation

- Use `·` (middle dot) for multiplication in mathematical notation: `√(U·V)`
- Use `*` for multiplication in code/expressions: `foo*bar`
- Use `:` for exponent division: `foo^2:3` means foo^(2/3)
- Avoid `^-1` for reciprocals; use `1/foo` instead

## Key Concepts to Emphasize

### What Users Often Misunderstand

1. **Floating ≠ synthetic:** `USD` symbol doesn't track real USD price
2. **Geometric mean triads:** All forges use `(U, V, √(U*V))` structure—the liquidity unit is always the geometric mean
3. **Liquidity units vs reserves:** Same unit can be a reserve in one triad, liquidity unit in another
4. **Triad validity:** Two constraints apply: (1) √(U*V) = W and (2) U ≠ V (no duplicate reserves)
5. **Why `(bar, bar, bar)` fails:** Even though √(bar * bar) = bar, duplicate reserves violate constraint #2
6. **Creating compounds:** To create `A*B`, forge `(A², B², A*B)` where A*B is the liquidity unit
7. **Price control mechanism:** Forging IS how you influence prices
8. **No collateral needed:** For floating units, just liquidity through forging

### Critical Distinctions

- **Anchored units:** Real backing, custodial, trust in contract
- **Floating units:** No backing, trust in liquidity/mechanism
- **Genesis "1" (v0.0):** Simple ERC-20, no Uniteum features, primordial supply
- **Current Uniteum "1":** Full-featured, accepts migration from v0.0

## When Writing Code or Docs

### Do:

- ✅ Reference actual contract addresses and ENS names
- ✅ Link contract addresses to Etherscan with appropriate section anchors (#code, #writeContract, #readContract)
- ✅ Use context-appropriate Etherscan links (mainnet vs sepolia, specific sections)
- ✅ Link to specific transactions as examples (full tx hash URLs)
- ✅ Explain both the math AND the economics
- ✅ Acknowledge unknowns ("This is experimental...")
- ✅ Use analogies (physics, traditional finance, gaming)
- ✅ Show multiple ways to accomplish things (direct vs indirect forge paths)
- ✅ Document sign convention for forge parameters (+mint, -burn)
- ✅ Note that code uses "unanchored" but docs say "floating"
- ✅ Use correct price formula: price(U) = v/u
- ✅ Use correct triad structure: `(U, V, √(U*V))` with geometric mean as liquidity unit
- ✅ Explain reserve units vs liquidity unit roles
- ✅ Emphasize geometric mean constraint: √(U*V) must equal W

### Don't:

- ❌ Claim floating units have inherent value/backing
- ❌ Over-promise stability or safety
- ❌ Forget to mention audit status (unaudited)
- ❌ Show invalid triads that violate geometric mean (e.g., `(A, B, A*B)` should be `(A², B², A*B)`)
- ❌ Claim "1" cannot be a reserve unit (it can, e.g., `(1, m², m)`)
- ❌ Use jargon without explanation

## Key Functions Reference

This is a quick reference. See IUnit.sol for complete signatures and documentation.

**Core Operations:**
- `forge(IUnit V, int256 du, int256 dv)` - Mint/burn unit combinations maintaining invariants
- `forge(int256 du, int256 dv)` - Simplified forge with reciprocal
- `forgeQuote(...)` - Preview forge results before execution (view function)

**IMPORTANT NOTE ON FORGE BEHAVIOR:** There are two distinct forge mechanics:
1. **Reciprocal forging via "1"** (U, 1/U, 1 triad): Only mints/burns tokens, no transfers. "1" serves as liquidity unit.
2. **Compound unit forging** (e.g., (A², B², A*B) triad): Mints/burns the liquidity unit (A*B) AND transfers the reserve units (A² and B²) custodially to/from the caller during the forge operation.

**Note on triad structure:** All valid triads follow `(U, V, √(U*V))` where √(U*V) is the liquidity unit (geometric mean).

**Unit Creation:**
- `multiply(string symbol)` - Create base unit from "1"
- `multiply(IUnit multiplier)` - Create compound from two units
- `product(string expression)` - Parse and create compound from expression (e.g., "m/s^2")
- `product(IUnit multiplier)` - Alternative to multiply
- `anchored(IERC20 token)` - Create anchored unit backed by external token

**Query Functions:**
- `invariant()` - Get current (u, v, w) supplies
- `invariant(uint256 u, uint256 v)` - Calculate w from supplies
- `invariant(IUnit V)` - Get invariant for compound unit pair
- `reciprocal()` - Get reciprocal unit address
- `anchor()` - Get backing token for anchored units (returns zero address for floating)
- `anchoredPredict(IERC20 token)` - Predict anchored unit address
- `anchoredSymbol(IERC20 token)` - Get symbol format for anchored unit

**Errors:**
- `DuplicateUnits()` - Attempted forge with same unit twice
- `FunctionCalledOnOne()` - Operation not allowed on "1" token
- `FunctionNotCalledOnOne()` - Operation must be called on "1" token
- `NegativeSupply(IUnit, int256)` - Forge would create negative supply
- `ReentryForbidden()` - Reentrancy attempt detected

**Events:**
- `UnitCreate(...)` - Emitted when new unit is created
- `Forge(...)` - Emitted when forge operation completes

## Open Questions (For Discovery)

These are things that haven't been fully verified/explored:

1. **Scale behavior:** What happens with hundreds of interconnected units?
2. **Price stability:** Do compound units actually track product of constituents?
3. **Arbitrage efficiency:** How quickly do prices converge?
4. **Edge cases:** What breaks? What surprising patterns emerge?
5. **Gas costs:** At what scale does forging become prohibitive?
6. **Liquidity dynamics:** How does "1" supply affect entire system?

Treat these as research questions, not solved problems.

## Self-Improvement Protocol

**CRITICAL:** When you make mistakes or the user corrects your understanding, IMMEDIATELY update this CLAUDE.md file to prevent repeating the same mistake.

### When to Update CLAUDE.md:

1. **After being corrected** - If the user points out a mistake in your approach
2. **When discovering ambiguity** - If you realize existing guidance is unclear or incomplete
3. **When establishing new patterns** - If the user provides new conventions to follow
4. **When creating new tools/includes** - Document how and when to use them

### How to Update:

1. **Identify the root cause** - What knowledge was missing or wrong?
2. **Add clear guidance** - Write explicit rules with examples
3. **Include anti-patterns** - Show what NOT to do (with ❌)
4. **Test your understanding** - Verify the new guidance would prevent the mistake

### Example Pattern:

When you realize you've been doing X wrong:
```markdown
**[Topic Name]:**

✅ CORRECT: [What to do]
❌ WRONG: [What not to do]

**Why:** [Explanation]
**Examples:** [Concrete examples]
```

**Remember:** This file is your persistent memory. If you don't update it, you'll repeat the same mistakes.

---

**Last Updated:** December 2024
**Creator:** Paul Reinholdtsen (reinholdtsen.eth)