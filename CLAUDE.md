# CLAUDE.md - Uniteum Project

## Project Overview

Uniteum is an algebraic liquidity protocol on Ethereum where ERC-20 tokens have dimensional units (like physical quantities: m/s, kg*m, etc.) or symbolic units (USD, BTC, foo). Units compose algebraically, and price consistency is maintained through arbitrage-enforced forge operations rather than oracles.

**Key Innovation:** Multi-dimensional constant-product AMM where algebraic relationships create liquidity pools. Forge operations work on any valid triad (not just U/1/U but also A/B/A*B), creating mesh topology of arbitrage paths.

## Deployed Contracts

| Contract | Mainnet | Sepolia |
|----------|---------|---------|
| Uniteum 0.1 "1" | [`0x9df9b0501e8f6c05623b5b519f9f18b598d9b253`](https://etherscan.io/address/0x9df9b0501e8f6c05623b5b519f9f18b598d9b253#code) | [`0x9df9b0501e8f6c05623b5b519f9f18b598d9b253`](https://sepolia.etherscan.io/address/0x9df9b0501e8f6c05623b5b519f9f18b598d9b253#code) |
| Uniteum 0.0 "1" (genesis) | [`0xC833f0B7cd7FC479DbbF6581EB4eEFc396Cf39E4`](https://etherscan.io/address/0xC833f0B7cd7FC479DbbF6581EB4eEFc396Cf39E4#code) | [`0xC833f0B7cd7FC479DbbF6581EB4eEFc396Cf39E4`](https://sepolia.etherscan.io/address/0xC833f0B7cd7FC479DbbF6581EB4eEFc396Cf39E4#code) |
| Discount Kiosk | [`0x55816c3e5d999e2f45ce0146ffd89b2e78a56dc9`](https://etherscan.io/address/0x55816c3e5d999e2f45ce0146ffd89b2e78a56dc9#code) | [`0x55816c3e5d999e2f45ce0146ffd89b2e78a56dc9`](https://sepolia.etherscan.io/address/0x55816c3e5d999e2f45ce0146ffd89b2e78a56dc9#code) |

Deployment uses Nick's deterministic deployer (same addresses across networks).

## ENS Structure

Owned by `0xd441...6401`:

```
uniteum.eth
├── 0-0.uniteum.eth → 0xC833...39E4 (genesis "1")
│   └── buy.0-0.uniteum.eth → 0x5581...6dc9 (Discount Kiosk)
├── 0-1.uniteum.eth → 0x9df9...b253 (Uniteum 0.1 "1")
├── eoa.uniteum.eth → 0x6056...496e
│   ├── 0.eoa.uniteum.eth → 0xff96...1004 (main deployer)
│   ├── 1.eoa.uniteum.eth → 0x215a...7003
│   ├── 2.eoa.uniteum.eth → 0xc935...8971
│   └── 3.eoa.uniteum.eth → (reserved)
├── deployer.uniteum.eth → 0x2613...878a (Safe multisig)
├── vault.uniteum.eth → 0xebca...77d8
└── ens.uniteum.eth → 0x6056...496e
```

## Core Mechanisms

### 1. The "1" Token

- Central liquidity token that mediates all base units
- Total fixed supply: 1 billion tokens (minted in v0.0)
- Can migrate from v0.0 → v0.1 via `migrate(amount)` (reversible via `unmigrate()`)

### 2. Units & Reciprocals

- Every unit `U` has reciprocal `1/U`
- Invariant: `sqrt(U_supply * (1/U)_supply) = W_supply` where W is the mediating token
- For base units: W = "1"
- For compound units: W = parent unit

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

Invariant enforcement: `sqrt(a * b) = ab` where lowercase = supplies

**Price Formula:**
- `price(U) = v/u` where v = 1/U supply, u = U supply
- `price(1/U) = u/v` (reciprocal relationship)
- Equal supplies (u = v) → both units trade at parity (price = 1)
- More U (u > v) → U is cheaper, 1/U is more expensive
- Standard constant-product AMM pricing

### 4. Anchored vs Symbolic Units

**Anchored Units:**
- Format: `$0xTokenAddress` (e.g., `$0xdAC17F958D2ee523a2206206994597C13D831ec7` for USDT)
- Backed 1:1 by external ERC-20 held by the Unit contract
- Real value, custodial
- Created via: `one().anchored(IERC20(address))`

**Symbolic Units:**
- Format: 30 chars max, `[a-zA-Z0-9_.-]+` (e.g., `USD`, `MSFT`, `kg`, `foo`)
- NO connection to real-world entities (MSFT ≠ Microsoft stock!)
- Value emerges from liquidity/consensus only
- Created via: `one().multiply("symbol")`

**IMPORTANT:** Symbolic "USD" has zero inherent connection to US dollars. It's just a label.

**Note on Terminology:** The contract code uses "anchored" and "unanchored" terminology (see IUnit.sol), but this documentation uses "anchored" and "symbolic" for clarity. They are equivalent: unanchored = symbolic.

### 5. Compound Units

- Created by algebraic composition: `meter*second`, `ETH/USD`, `foo^2\3` (rational exponents)
- Operators: `*` (multiply), `/` (divide), `^` (power), `\` (divide in exponent)
- Example: `kg*m/s^2` = force unit
- Address deterministically predicted via CREATE2 from symbol hash

### 6. Multi-Dimensional Arbitrage

With units A, B, A*B:
- Can forge: A + B → A*B (direct, no "1")
- Can forge: A → 1 → 1/B → A/B (indirect via "1")
- Multiple paths create arbitrage mesh
- Price consistency emerges from profit-seeking

### 7. Key Contract Implementation Details

**ONE_MINTED Constant:**
- Immutable value tracking total original "1" supply minted
- Total "1" supply will never exceed this value
- Set at deployment, provides supply ceiling

**Name Prefix:**
- All units are prefixed with "Uniteum 0.1 " in their ERC-20 name
- Example: "Uniteum 0.1 meter"

**Sign Convention for Forge:**
- Positive `du`/`dv` values: mint units to caller
- Negative `du`/`dv` values: burn units from caller
- Critical for understanding forge operations

**Exponent Division:**
- Uses `\` character for division in exponents (not `/`)
- Example: `foo^2\3` means foo^(2/3)
- Simplifies parsing (avoids confusion with unit division)

**Reentrancy Protection:**
- Uses transient storage (EIP-1153) for reentrancy guards
- Applied to all forge operations
- Gas-efficient modern pattern

**UPSTREAM_ONE:**
- Points to v0.0 "1" token for migration
- Enables reversible migrate/unmigrate between versions
- Immutable, set at v0.1 deployment

## Project Status

### Current Phase

- **Version:** 0.1 (experimental, unaudited)
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
- **Docs repo:** github.com/uniteum/docs

## Common Commands

```bash
forge build
forge test
forge test -vvv          # verbose output
forge script <script>    # deployment scripts
```

## Distribution Strategy

1. **Genesis Supply:** 1B "1" tokens (v0.0)
   - 900M → Discount Kiosk (public sale)
   - 100M → Deployer Safe (reserve)
2. **Kiosk:** Linear discount pricing (price ↓ as inventory → capacity)
3. **Migration:** Users buy v0.0, migrate to v0.1 for full features

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
- `sqrt(u * v) = w` for every unit pair
- `sqrt(a * b) = ab` for compound units
- Infinite interconnected pools
- One operation (forge) handles all swaps, minting, burning
- No oracles, no collateral requirements for synthetics

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
- Distinguish clearly between anchored and symbolic units
- Explain forge triads beyond just (U, 1/U, 1)
- Use dimensional analysis analogies (physics helps intuition)
- Link related concepts bidirectionally
- Provide "try it yourself" steps

**Anchored Unit Notation Convention:**

For documentation readability, use shorthand notation like `$WETH`, `$USDC`, `$WBTC` in explanations and examples, BUT:

- **Link first occurrence** to token reference pages (e.g., `[$WETH](/tokens/weth/)`)
- Add callout at top of page: "We use [$WETH](/tokens/weth/), [$USDC](/tokens/usdc/), etc. as readable shorthands. See [Token Reference](/tokens/) for actual symbols."
- In technical reference or code examples, show real addresses
- Emphasize the distinction: symbolic `WETH` ≠ anchored `$0xC02a...56Cc2`

Common anchored unit shorthands (all have dedicated reference pages):
- [$WETH](/tokens/weth/) = `$0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2`
- [$USDC](/tokens/usdc/) = `$0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48`
- [$USDT](/tokens/usdt/) = `$0xdAC17F958D2ee523a2206206994597C13D831ec7`
- [$WBTC](/tokens/wbtc/) = `$0x2260FAC5E5542a773Aa44fBCfEDf7C193bc2C599`
- [$DAI](/tokens/dai/) = `$0x6B175474E89094C44Da98b954EedeAC495271d0F`

**Token Reference Pages:** Located in `/tokens/` directory. Each page explains:
- The shorthand vs actual symbol
- What the token is backed by (with Etherscan link)
- Symbolic vs anchored distinction
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

## Key Concepts to Emphasize

### What Users Often Misunderstand

1. **Symbolic ≠ synthetic:** `USD` symbol doesn't track real USD price
2. **Forge beyond reciprocals:** Can forge any valid triad, not just (U, 1/U, 1)
3. **Price control mechanism:** Forging IS how you influence prices
4. **No collateral needed:** For symbolic units, just liquidity through forging
5. **Compound units:** Their prices are arbitrage-enforced, not set by oracles

### Critical Distinctions

- **Anchored tokens:** Real backing, custodial, trust in contract
- **Symbolic tokens:** No backing, trust in liquidity/mechanism
- **Genesis "1" (v0.0):** Simple ERC-20, no Uniteum features, primordial supply
- **Uniteum "1" (v0.1):** Full-featured, accepts migration from v0.0

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
- ✅ Note that code uses "unanchored" but docs say "symbolic"
- ✅ Use correct price formula: price(U) = v/u

### Don't:

- ❌ Claim symbolic units have inherent value/backing
- ❌ Over-promise stability or safety
- ❌ Forget to mention audit status (unaudited)
- ❌ Assume only (U, 1/U, 1) forge triads exist
- ❌ Use jargon without explanation

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
- `anchor()` - Get backing token for anchored units (returns zero address for symbolic)
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

---

**Last Updated:** December 2024
**Creator:** Paul Reinholdtsen (reinholdtsen.eth)