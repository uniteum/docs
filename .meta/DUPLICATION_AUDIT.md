# Documentation Duplication Audit

Generated: 2025-12-19

## Executive Summary

This audit identifies specific content duplication between CLAUDE.md (AI instructions) and user-facing documentation. The goal is to reduce redundancy while preserving CLAUDE.md as a comprehensive knowledge base.

---

## 1. The "1" Token Mechanics

### CLAUDE.md (Lines 43-49)
```
### 1. The "1" Token

- Central liquidity token that mediates all base units
- Primordial supply: 1 billion tokens (minted once in v0.0, this is the ceiling)
- Total "1" supply across all versions ≤ 1 billion
- Current version supply grows through migration from v0.0 (reversible via `unmigrate()`)
- Any particular version will have less than 1 billion until sufficient migration occurs
```

### Duplicated in:

**concepts/units.md (Lines 27-34)**
```
## The "1" Token

At the center is "1"—the dimensionless unit. It mediates all base units and serves as the liquidity backbone of the protocol.

- **Primordial supply:** 1 billion (minted once in v0.0, this is the ceiling for all versions)
- **Supply mechanics:** Current version supply grows through migration from v0.0; total across all versions ≤ 1 billion
- **Role:** Mediates base unit / reciprocal pairs
- **Versions:** v0.0 (genesis ERC-20, primordial supply), current version (full Uniteum features)
```

**economics-of-one.md (Lines 260-277)**
```
### The "1" Supply

The primordial "1" supply of 1 billion was minted once in v0.0 (genesis). This is the ceiling—total "1" across all versions will never exceed this amount.

The current version's "1" supply grows through migration from v0.0. At any given time:
- Total supply across all versions ≤ 1 billion
- Current version supply ≤ 1 billion (less until migration occurs)
- v0.0 supply decreases as users migrate to current version
```

**getting-started.md (Lines 64-65)**
```
**Why migrate?** Genesis "1" (v0.0) is a simple ERC-20 that holds the primordial 1 billion token supply (the ceiling for all versions). The current contract implements all the core Uniteum mechanisms...
```

**concepts/tokenomics.md (Lines 170-185)**
```
### The "1" Supply

The primordial "1" supply of 1 billion was minted once in v0.0 (genesis). This is the ceiling—total "1" across all versions will never exceed this amount.

The current version's "1" supply grows through migration from v0.0. At any given time:
- Total supply across all versions ≤ 1 billion
- Current version supply ≤ 1 billion (less until migration occurs)
- v0.0 supply decreases as users migrate to current version
```

### Recommendation
- **Keep in CLAUDE.md**: Brief bullet point summary (essential context for AI)
- **Canonical user doc**: Make concepts/units.md the authoritative source
- **Other pages**: Reference concepts/units.md instead of re-explaining

---

## 2. Invariant Formula (u·v = w²)

### CLAUDE.md (Lines 52-56, 72)
```
### 2. Units & Reciprocals

- Every unit `U` has reciprocal `1/U`
- Invariant: `sqrt(U_supply * (1/U)_supply) = W_supply` where W is the mediating token
- For base units: W = "1"
- For compound units: W = parent unit

...

Invariant enforcement: `sqrt(a * b) = ab` where lowercase = supplies
```

### Duplicated in:

**concepts/units.md (Lines 92-101)**
```
## Reciprocals

Every unit U has a reciprocal 1/U. They are bound by the invariant:

$$u \cdot v = w^2$$

Where:
- u = supply of U
- v = supply of 1/U
- w = supply of "1" held by the U contract
```

**concepts/forge.md (Lines 29-34, 84-90)**
```
## What Forge Does

Forge transforms tokens within a valid triad while preserving the invariant:

$$u \cdot v = w^2$$

...

## The Invariant Constraint

You can't forge arbitrary amounts. The invariant constrains the relationship:

$$u_1 \cdot v_1 = w_1^2$$
```

**concepts/triads.md (Lines 84-96)**
```
## The Universal Invariant

All triads obey the same invariant:

$$u \cdot v = w^2$$

Where u, v, w are supplies of the three tokens in positional order.
```

**concepts/tokenomics.md (Lines 42-58, 250-259)**
```
## The Invariant

All triads obey:

$$u \cdot v = w^2$$

The product of the two operand supplies equals the square of the mediator supply.

...

## Summary

| Concept | Formula |
|---------|---------|
| Invariant | u · v = w² |
```

### Recommendation
- **Keep in CLAUDE.md**: Brief mention only ("see concepts/tokenomics.md for details")
- **Canonical user doc**: concepts/tokenomics.md (comprehensive mathematical treatment)
- **Other pages**: Reference tokenomics.md for formula details

---

## 3. Price Formula (price(U) = v/u)

### CLAUDE.md (Lines 74-79)
```
**Price Formula:**
- `price(U) = v/u` where v = 1/U supply, u = U supply
- `price(1/U) = u/v` (reciprocal relationship)
- Equal supplies (u = v) → both units trade at parity (price = 1)
- More U (u > v) → U is cheaper, 1/U is more expensive
- Standard constant-product AMM pricing
```

### Duplicated in:

**concepts/tokenomics.md (Lines 122-141, 250-259)**
```
## Price Relationships

Price emerges from supply ratios. For a unit U with reciprocal 1/U:

$$\text{price}(U) = \frac{v}{u}$$

This is denominated in 1/U per U. Intuitively: if there's more 1/U than U in circulation, U is "scarcer" and thus more expensive.

### Price in Terms of the Mediator

Since u · v = w², we can derive:

$$\text{price}(U) = \frac{w^2}{u^2}$$

...

## Summary

| Concept | Formula |
|---------|---------|
| Price of U | v / u |
```

**guides/price-control.md (Lines 26-36)**
```
## Price Mechanics

For a unit U with reciprocal 1/U:

$$\text{price}(U) = \frac{v}{u}$$

Where:
- u = supply of U
- v = supply of 1/U

To change price, change the ratio.
```

**reference/functions.md (Lines 236-243)**
```
**Price Calculation:**
- Price of U = `v / u`
- Price of 1/U = `u / v`
- Equal supplies (u = v) → both trade at parity
```

### Recommendation
- **Keep in CLAUDE.md**: Formula only with note "see concepts/tokenomics.md"
- **Canonical user doc**: concepts/tokenomics.md (full derivation and explanation)
- **Other pages**: Reference or use formula without re-deriving

---

## 4. Forge Triads Beyond (U, 1/U, 1)

### CLAUDE.md (Lines 58-70)
```
### 3. Forge Operation (CRITICAL)

**NOT just (U, 1/U, 1) triads!**

Forge works on ANY algebraically valid triad:
- `(meter, 1/second, meter/second)` — no "1" involved
- `(A, B, A*B)` — direct compound unit creation
- `(U, 1/U, 1)` — traditional reciprocal pair

**This is the price control mechanism:**
- To increase U's price: burn U, mint 1/U (consumes 1)
- To decrease U's price: mint U, burn 1/U (generates 1)
- For compounds: `price(A*B) = price(A) × price(B)` enforced by arbitrage
```

### Duplicated in:

**concepts/triads.md (Lines 24-62)**
```
# Triads

A triad is a valid three-token relationship where forge can operate. Understanding triads unlocks Uniteum's full power.

## Beyond (U, 1/U, 1)

The simplest triad is a base unit with its reciprocal, mediated by "1":

**(foo, 1/foo, 1)**

But this is just one pattern. Forge works on **any algebraically valid triad**.

## Triad Patterns

### Base Unit Triad

**(U, 1/U, 1)**
...

### Compound Formation Triad

**(A, B, A·B)**
...
```

**concepts/forge.md (Lines 23-66)**
```
# Forge

Forge is the universal operation in Uniteum. Every swap, every mint, every burn—all are forge operations.

## What Forge Does

Forge transforms tokens within a valid triad while preserving the invariant:
...
```

### Recommendation
- **Keep in CLAUDE.md**: Key concept emphasis ("NOT just (U, 1/U, 1)") for AI awareness
- **Canonical user doc**: concepts/triads.md (comprehensive pattern catalog)
- **Other pages**: Link to triads.md when mentioning compound forging

---

## 5. Anchored vs Floating Units

### CLAUDE.md (Lines 81-97)
```
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
```

### Duplicated in:

**concepts/units.md (Lines 63-88)**
```
### Anchored Units

**Format:** `$0xTokenAddress`

**Example:** `$0xdAC17F958D2ee523a2206206994597C13D831ec7` (USDT)

Anchored units are backed 1:1 by an external ERC-20 token. The backing tokens are held by the Unit contract.

- ✅ Real value, redeemable
- ⚠️ Custodial—you trust the contract
- Created via: `one().anchored(IERC20(address))`

### Floating Units

**Format:** Up to 30 characters, `[a-zA-Z0-9_.-]+`

**Examples:** `foo`, `meter`, `acme`, `widget`

Floating units have no backing. They're just labels. Value emerges from liquidity and consensus.

- ❌ Not pegged to anything real
- ❌ No collateral
- ✅ Permissionless creation
- Created via: `one().multiply("symbol")`

**Warning:** A floating unit named `USD` has no connection to US dollars. Avoid real-world financial symbols to prevent confusion.
```

**reference/anchored-units/index.md (Lines 22-56)**
```
# Anchored Units

## Documentation Convention

Throughout Uniteum documentation, we use **readable shorthands** like `$WETH`, `$USDC`, `$WBTC` for clarity in examples and explanations.

**IMPORTANT:** These are NOT the actual symbols. Anchored units use full contract addresses.

### Why Shorthands?

**Actual anchored unit format:**
```
$0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2
```

This is accurate but unwieldy in documentation. Reading paragraphs full of 42-character hexadecimal addresses hurts comprehension.

**Shorthand format:**
```
$WETH
```

This is readable and matches how developers think about tokens, while clearly indicating "anchored unit" with the `$` prefix.

### The Critical Distinction

| Format | What It Is | Backing |
|--------|-----------|---------|
| `$WETH` (shorthand) | Documentation convenience | Refers to `$0xC02a...56Cc2` |
| `$0xC02a...56Cc2` (actual) | Real anchored unit symbol | 1:1 backed by WETH |
| `WETH` (no $) | Floating unit | NO backing, just a label |

**Floating `WETH` ≠ Anchored `$0xC02a...56Cc2`**
```

### Recommendation
- **Keep in CLAUDE.md**: Core distinction and format rules (AI needs to know this for writing docs)
- **Canonical user doc**: reference/anchored-units/index.md (full explanation of shorthands and distinction)
- **concepts/units.md**: Keep as introduction, but link to reference/anchored-units for details

---

## 6. ENS Structure

### CLAUDE.md (Lines 21-39)
```
## ENS Structure

Owned by `0xd441...6401`:

```
uniteum.eth
├── 0-0.uniteum.eth → Genesis "1" (v0.0, see _data/contracts.yml)
│   └── buy.0-0.uniteum.eth → Genesis Kiosk
├── [version].uniteum.eth → Current "1" (see current.uniteum in _data/contracts.yml)
│   └── buy.[version].uniteum.eth → Current Kiosk
├── eoa.uniteum.eth → 0x6056...496e
│   ├── 0.eoa.uniteum.eth → 0xff96...1004 (main deployer)
│   ├── 1.eoa.uniteum.eth → 0x215a...7003
│   ├── 2.eoa.uniteum.eth → 0xc935...8971
│   └── 3.eoa.uniteum.eth → (reserved)
├── deployer.uniteum.eth → 0x2613...878a (Safe multisig)
├── vault.uniteum.eth → 0xebca...77d8
└── ens.uniteum.eth → 0x6056...496e
```
```

### Duplicated in:

**reference/ens.md (Lines 26-57)**
```
## Hierarchy

{% assign current_uniteum = site.data.contracts.uniteum[site.data.contracts.current.uniteum] -%}
{% assign genesis_uniteum = site.data.contracts.uniteum.v0_0 -%}
{% assign current_kiosk = site.data.contracts.kiosk[site.data.contracts.current.kiosk] -%}
{% assign genesis_kiosk = site.data.contracts.kiosk.v0_0 -%}
```
uniteum.eth
├── {{ genesis_uniteum.ens }}          → {{ genesis_uniteum.mainnet }}
│   │                           ({{ genesis_uniteum.name }} - genesis)
│   └── {{ genesis_kiosk.ens }}  → {{ genesis_kiosk.mainnet }}
│                               ({{ genesis_kiosk.name }})
│
├── {{ current_uniteum.ens }}          → {{ current_uniteum.mainnet }}
│   │                           ({{ current_uniteum.name }})
│   └── {{ current_kiosk.ens }}  → {{ current_kiosk.mainnet }}
│                               ({{ current_kiosk.name }})
│
├── eoa.uniteum.eth          → 0x6056...496e
│   ├── 0.eoa.uniteum.eth    → 0xff96a8c70dcc85a0cc4d690bfc02166a90e71004
│   │                           (main deployer)
│   ├── 1.eoa.uniteum.eth    → 0x215a...7003
│   ├── 2.eoa.uniteum.eth    → 0xc935...8971
│   └── 3.eoa.uniteum.eth    → (reserved)
│
├── deployer.uniteum.eth     → 0x2613...878a
│                               (Safe multisig)
│
├── vault.uniteum.eth        → 0xebca...77d8
│
└── ens.uniteum.eth          → 0x6056...496e
```
```

### Recommendation
- **Remove from CLAUDE.md**: Full hierarchy diagram
- **Replace with**: "See reference/ens.md for complete ENS structure"
- **Canonical user doc**: reference/ens.md (uses dynamic contract data from YAML)

---

## 7. Forge Sign Convention

### CLAUDE.md (Lines 127-130)
```
**Sign Convention for Forge:**
- Positive `du`/`dv` values: mint units to caller
- Negative `du`/`dv` values: burn units from caller
- Critical for understanding forge operations
```

### Duplicated in:

**reference/functions.md (Lines 42-48)**
```
**Parameters:**
- `du` — Signed change of caller's unit balance
  - Positive: mint units to caller
  - Negative: burn units from caller
- `dv` — Signed change of caller's reciprocal balance (1/U)
  - Positive: mint reciprocal to caller
  - Negative: burn reciprocal from caller
```

### Recommendation
- **Keep in CLAUDE.md**: Brief reminder (AI needs to know for explaining code)
- **Canonical user doc**: reference/functions.md (detailed parameter documentation)
- **No duplication issue**: This is appropriately minimal in CLAUDE.md

---

## 8. Contract Implementation Details

### CLAUDE.md (Lines 114-146)
```
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
```

### Duplicated in:

**reference/functions.md (Lines 420-456)**
```
## Constants & Immutables

### `ONE_SYMBOL`

Constant string for "1" token symbol.

**Value:** `"1"`

---

### `NAME_PREFIX`

Prefix for all unit names.

**Value:** Version-specific (e.g., `"Uniteum 0.3 "` for current version)

**Example:** Unit "meter" has name "Uniteum 0.3 meter" (on current version)

---

### `ONE_MINTED`

Immutable value tracking the total original "1" supply minted in genesis.

**Type:** `uint256`

**Note:** Total "1" supply will never exceed this value

---

### `UPSTREAM_ONE()`

Address of v0.0 "1" token accepted for migration.

**Returns:** ERC-20 address of upstream "1"

**Value:** [`0xC833f0B7cd7FC479DbbF6581EB4eEFc396Cf39E4`](https://etherscan.io/address/0xC833f0B7cd7FC479DbbF6581EB4eEFc396Cf39E4#code) (v0.0)
```

### Recommendation
- **Keep in CLAUDE.md**: All implementation details (AI needs context for technical questions)
- **Canonical user doc**: reference/functions.md (complete technical reference)
- **Acceptable duplication**: CLAUDE.md provides context, functions.md provides precision

---

## 9. Key Functions Quick Reference

### CLAUDE.md (Lines 346-385)
```
## Key Functions Reference

This is a quick reference. See IUnit.sol for complete signatures and documentation.

**Core Operations:**
- `forge(IUnit V, int256 du, int256 dv)` - Mint/burn unit combinations maintaining invariants
- `forge(int256 du, int256 dv)` - Simplified forge with reciprocal
- `forgeQuote(...)` - Preview forge results before execution (view function)

**IMPORTANT NOTE ON FORGE BEHAVIOR:** There are two distinct forge mechanics that need clear documentation:
1. **Reciprocal forging via "1"** (U, 1/U, 1 triad): Only mints/burns tokens, no transfers
2. **Compound forging** (A, B, A*B triad): Mints/burns the product unit AND transfers the constituent units custodially to/from the caller during the forge operation

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
```

### Duplicated in:

**reference/functions.md (Complete file, 638 lines)**

Full detailed documentation of every function, parameter, return value, example, etc.

### Recommendation
- **Keep in CLAUDE.md**: Quick reference (AI needs fast lookup)
- **Canonical user doc**: reference/functions.md (comprehensive API reference)
- **Acceptable duplication**: Quick reference vs detailed docs serve different purposes

---

## 10. Anchored Unit Shorthands List

### CLAUDE.md (Lines 261-266)
```
Common anchored unit shorthands (all have dedicated reference pages):
- [$WETH](/reference/anchored-units/weth/) = `$0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2`
- [$USDC](/reference/anchored-units/usdc/) = `$0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48`
- [$USDT](/reference/anchored-units/usdt/) = `$0xdAC17F958D2ee523a2206206994597C13D831ec7`
- [$WBTC](/reference/anchored-units/wbtc/) = `$0x2260FAC5E5542a773Aa44fBCfEDf7C193bc2C599`
- [$DAI](/reference/anchored-units/dai/) = `$0x6B175474E89094C44Da98b954EedeAC495271d0F`
```

### Duplicated in:

**reference/anchored-units/index.md (Lines 58-68)**
```
| Shorthand | Token Name | Actual Symbol (first 10 & last 4) | Mainnet Contract |
|-----------|------------|-----------------------------------|------------------|
| [$WETH](/reference/anchored-units/weth/) | Wrapped Ether | `$0xC02aaA39...56Cc2` | [View on Etherscan](https://etherscan.io/address/0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2) |
| [$USDC](/reference/anchored-units/usdc/) | USD Coin | `$0xA0b86991...eB48` | [View on Etherscan](https://etherscan.io/address/0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48) |
| [$USDT](/reference/anchored-units/usdt/) | Tether USD | `$0xdAC17F95...1ec7` | [View on Etherscan](https://etherscan.io/address/0xdAC17F958D2ee523a2206206994597C13D831ec7) |
| [$WBTC](/reference/anchored-units/wbtc/) | Wrapped BTC | `$0x2260FAC5...2C599` | [View on Etherscan](https://etherscan.io/address/0x2260FAC5E5542a773Aa44fBCfEDf7C193bc2C599) |
| [$DAI](/reference/anchored-units/dai/) | Dai Stablecoin | `$0x6B175474...cB4` | [View on Etherscan](https://etherscan.io/address/0x6B175474E89094C44Da98b954EedeAC495271d0F) |
```

### Recommendation
- **Keep in CLAUDE.md**: The list (AI needs to know shorthands for writing examples)
- **Canonical user doc**: reference/anchored-units/index.md (authoritative mapping with Etherscan links)
- **Acceptable duplication**: AI reference vs user reference serve different needs

---

## Summary of Recommended Actions

### 1. Remove from CLAUDE.md (Replace with References)

**High-priority removals:**

- ✂️ **Full ENS hierarchy diagram** → Replace with: "See [reference/ens.md](/reference/ens/) for complete structure"
- ✂️ **Distribution Strategy details** (lines 180-187) → Reference: "See [getting-started.md](/getting-started/) for acquisition and migration"

**Medium-priority streamlining:**

- 📝 **"1" Token section**: Reduce to 2-3 bullets, add "See [concepts/units.md](/concepts/units/) for details"
- 📝 **Invariant formulas**: Mention briefly, reference [concepts/tokenomics.md](/concepts/tokenomics/)
- 📝 **Price formulas**: Brief mention, reference [concepts/tokenomics.md](/concepts/tokenomics/)

### 2. Keep in CLAUDE.md (Essential AI Context)

**Must keep (no alternatives):**

- ✅ **Writing Guidelines** (lines 242-303) — Meta-instructions for AI
- ✅ **Linking Contract Addresses** (lines 275-303) — How to format Etherscan links
- ✅ **Anchored Unit Notation Convention** (lines 252-273) — Documentation shorthand rules
- ✅ **Do/Don't lists** (lines 324-344) — Content policy guardrails
- ✅ **Key Concepts to Emphasize** (lines 305-320) — Common user misconceptions
- ✅ **Documentation Approach** (lines 211-240) — Audience, voice, structure

**Should keep (AI needs for answering questions):**

- ✅ **Key Functions Quick Reference** (lines 346-385) — Fast lookup
- ✅ **Anchored unit shorthands list** (lines 261-266) — AI needs to know for examples
- ✅ **Contract implementation details** (lines 114-146) — Technical context
- ✅ **Sign convention** (lines 127-130) — Critical for explaining forge
- ✅ **Forge triad emphasis** (lines 58-70) — Common misunderstanding to avoid

### 3. Consolidate User Docs

**Economics of "1" page overlaps:**

economics-of-one.md and concepts/tokenomics.md both explain "1" supply mechanics (lines 170-185 duplicated word-for-word).

**Recommended fix:**
- Keep full explanation in concepts/tokenomics.md (canonical technical source)
- In economics-of-one.md, add brief reference: "For supply mechanics details, see [Tokenomics](/concepts/tokenomics/). Here we focus on value hypotheses..."

**Anchored units explanation:**

Appears in 3 places:
- concepts/units.md (introduction)
- reference/anchored-units/index.md (comprehensive reference)
- use-cases.md (brief mention)

**Recommended fix:**
- concepts/units.md: Keep introduction, link to reference/anchored-units for details
- reference/anchored-units/index.md: Keep as authoritative source
- use-cases.md: Brief mention with link, no re-explanation

---

## Metrics

### Duplication Statistics

| Topic | CLAUDE.md Lines | User Doc Instances | Recommendation |
|-------|----------------|-------------------|----------------|
| "1" Token Mechanics | 7 lines | 4 pages | Streamline CLAUDE, consolidate user docs |
| Invariant Formula | 5 lines | 4 pages | Brief mention in CLAUDE, canonical in tokenomics |
| Price Formula | 6 lines | 3 pages | Brief mention in CLAUDE, canonical in tokenomics |
| Forge Triads | 13 lines | 2 pages | Keep emphasis in CLAUDE, details in triads.md |
| Anchored vs Floating | 17 lines | 3 pages | Keep rules in CLAUDE, details in reference |
| ENS Structure | 19 lines | 1 page | Remove from CLAUDE, reference ens.md |
| Implementation Details | 33 lines | 1 page | Keep in CLAUDE (essential context) |
| Functions Quick Ref | 40 lines | 1 page (638 lines) | Keep in CLAUDE (different purpose) |

### Word Count Analysis

- **CLAUDE.md**: ~3,000 words (including meta-instructions)
- **User-facing docs**: ~15,000 words total
- **Estimated duplication**: ~20% overlap (600 words)
- **After streamlining**: Target <10% overlap (300 words)

---

## Conclusion

The duplication between CLAUDE.md and user docs is **intentional and largely appropriate**, with these exceptions:

1. **ENS hierarchy diagram** — Should be dynamic in user docs only
2. **"1" token supply mechanics** — Over-explained across 4 user pages
3. **Invariant/price formulas** — Repeated too many times in user docs

The majority of CLAUDE.md content is **meta-instructions** that don't belong in user docs:
- Writing style guidelines
- Linking conventions
- Documentation structure
- Do/Don't policies

**Primary action**: Streamline CLAUDE.md by removing the ENS diagram and reducing redundant explanations, while keeping essential AI context intact.

**Secondary action**: Consolidate user docs by making one page canonical for each concept and having others reference it rather than re-explain.
