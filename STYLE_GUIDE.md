# Uniteum Documentation Style Guide

## Etherscan Link Conventions

### General Principles

1. **Context determines display text**: Use human-readable names in tutorials/narratives, addresses in technical reference tables
2. **Network clarity**: Always make clear whether links point to Mainnet or Sepolia
3. **Section anchors**: Use appropriate Etherscan section anchors based on user intent
4. **Consistency**: Follow the patterns below throughout all documentation

---

## Link Text Patterns

### Pattern A: Human-Readable (Narrative/Tutorial)

**When to use:**
- Introducing contracts in educational content
- Creating call-to-action links
- Step-by-step tutorials
- General documentation where address isn't critical

**Format:**
```liquid
{% include etherscan.html
   address="0x5bA96211E3679FDcc7047a5c64d40A4Dd3fBdAD7"
   section="writeContract"
   text="Uniteum 0.4 '1' contract" %}
```

**Examples:**
- "Go to the [Uniteum contract](https://etherscan.io/address/0x5bA...#writeContract)"
- "You can [buy '1' tokens from the Discount Kiosk](https://etherscan.io/address/0xffA...#writeContract)"
- "Check the [current Uniteum contract](https://etherscan.io/address/0x5bA...#code)"

---

### Pattern B: Address Display (Reference Tables)

**When to use:**
- Contract deployment tables
- Technical reference sections
- When showing both Mainnet and Sepolia
- When verification/precision matters

**Format:**
```liquid
| Contract | Mainnet | Sepolia |
|----------|---------|---------|
| {{ current_uniteum.name }} | {% include etherscan.html address=current_uniteum.mainnet section="code" text=current_uniteum.mainnet %} | {% include etherscan.html address=current_uniteum.sepolia network="sepolia" section="code" text=current_uniteum.sepolia %} |
```

**Result:**
| Contract | Mainnet | Sepolia |
|----------|---------|---------|
| Uniteum 0.4 '1' | [0x5bA96...](https://etherscan.io/address/0x5bA...#code) | [0x5bA96...](https://sepolia.etherscan.io/address/0x5bA...#code) |

---

### Pattern C: Both Networks Inline (Compact)

**When to use:**
- Quick reference sections
- When both networks matter equally
- Compact listings

**Format:**
```liquid
**Uniteum 0.4 '1'**:
{% include etherscan.html address="0x5bA..." text="Mainnet" section="code" %} |
{% include etherscan.html address="0x5bA..." network="sepolia" text="Sepolia" section="code" %}
```

**Result:**
**Uniteum 0.4 '1'**: [Mainnet](https://etherscan.io/...) | [Sepolia](https://sepolia.etherscan.io/...)

---

## Network Selection

### Default Network by Section

- **Main documentation pages** → Mainnet
- **Getting Started / Tutorials** → Mainnet (with optional Sepolia note)
- **Developer / Testing sections** → Show both, prefer Sepolia in examples
- **Contract reference tables** → Always show both

### Network Display in Tables

When showing both networks in tables:
- Column 1: Contract name/description
- Column 2: Mainnet address (as link)
- Column 3: Sepolia address (as link)
- Both addresses should link to the same section anchor (usually `#code`)

---

## Etherscan Section Anchors

Choose section anchors based on user intent:

### `#code` - Verified Source Code
**Use for:**
- Contract deployment tables
- Technical reference
- "View the contract" type links
- When you want users to verify/audit code

**Example:**
```liquid
{% include etherscan.html address="..." section="code" text="View contract" %}
```

### `#writeContract` - Interactive Write Functions
**Use for:**
- Tutorials with step-by-step instructions
- "Try it yourself" sections
- When guiding users to execute transactions
- Call-to-action links (buy, forge, create)

**Example:**
```liquid
{% include etherscan.html address="..." section="writeContract" text="Buy '1' tokens" %}
```

### `#readContract` - Query Contract State
**Use for:**
- Checking balances
- Reading invariants
- Exploring contract state
- Educational examples about reading data

**Example:**
```liquid
{% include etherscan.html address="..." section="readContract" text="Check your balance" %}
```

### `#events` - Event Logs
**Use for:**
- Explaining event emissions
- Tracking historical operations
- Debugging scenarios

**Example:**
```liquid
{% include etherscan.html address="..." section="events" text="View forge events" %}
```

### No anchor - General Contract Page
**Use for:**
- First introduction to a contract
- When section doesn't matter
- General overview contexts

**Example:**
```liquid
{% include etherscan.html address="..." text="Contract overview" %}
```

---

## Link Types: Contracts vs Tokens

### Contracts
Use `/address/` path with section anchors:

```liquid
{% include etherscan.html
   address="0x5bA96211E3679FDcc7047a5c64d40A4Dd3fBdAD7"
   section="code"
   text="Uniteum 0.4 '1'" %}
```

→ `https://etherscan.io/address/0x5bA96211E3679FDcc7047a5c64d40A4Dd3fBdAD7#code`

### Unit Tokens
Use `/token/` path (no section anchor needed):

```markdown
[foo](https://etherscan.io/token/0x966108210F3B2eC0f01B646a61Ce7D8F1aDE7430)
```

**Note:** Unit tokens should link to the token page for holder lists, transfers, etc.

### Transactions
Use `/tx/` path with `type="tx"`:

```liquid
{% include etherscan.html
   address="0xabcd1234..."
   type="tx"
   text="View this forge transaction" %}
```

→ `https://etherscan.io/tx/0xabcd1234...`

---

## Specific Use Case Examples

### 1. Tutorial Step: Forging

```markdown
1. Go to the {% include etherscan.html
      address=current_uniteum.mainnet
      section="writeContract"
      text="Uniteum contract on Etherscan" %}
2. Connect your wallet
3. Find the `forge` function
4. Enter your amounts and execute
```

### 2. Contract Reference Table

```liquid
{% assign current_uniteum = site.data.contracts.uniteum[site.data.contracts.current.uniteum] -%}
{% assign current_kiosk = site.data.contracts.kiosk[site.data.contracts.current.kiosk] -%}

| Contract | Mainnet | Sepolia |
|----------|---------|---------|
| {{ current_uniteum.name }} | {% include etherscan.html address=current_uniteum.mainnet section="code" text=current_uniteum.mainnet %} | {% include etherscan.html address=current_uniteum.sepolia network="sepolia" section="code" text=current_uniteum.sepolia %} |
| {{ current_kiosk.name }} | {% include etherscan.html address=current_kiosk.mainnet section="code" text=current_kiosk.mainnet %} | {% include etherscan.html address=current_kiosk.sepolia network="sepolia" section="code" text=current_kiosk.sepolia %} |
```

### 3. Call to Action

```liquid
If this work interests you and you'd like to participate: the best way to contribute is to
{% include etherscan.html
   address="0xffAcC47570dfE1B1980b0475b13Fb07479CEf7EA"
   section="writeContract"
   text="buy \"1\" tokens from the Discount Kiosk" %}.
```

### 4. Unit Token Reference

```markdown
**foo**: A floating unit created via `one().multiply("foo")`.
[View on Etherscan](https://etherscan.io/token/0x966108210F3B2eC0f01B646a61Ce7D8F1aDE7430)
```

### 5. Transaction Example

```liquid
Here's an example forge transaction:
{% include etherscan.html
   address="0x1234abcd..."
   type="tx"
   text="Forge operation on Mainnet" %}
```

### 6. Checking Invariants

```markdown
You can verify the invariant by {% include etherscan.html
   address=current_uniteum.mainnet
   section="readContract"
   text="reading the current supplies" %}.
```

---

## Data-Driven Links

Always use `_data/contracts.yml` for contract addresses:

### ✅ CORRECT (Dynamic, version-safe)
```liquid
{% assign current_uniteum = site.data.contracts.uniteum[site.data.contracts.current.uniteum] -%}
{% include etherscan.html
   address=current_uniteum.mainnet
   section="code"
   text=current_uniteum.name %}
```

### ❌ INCORRECT (Hardcoded, will break on version updates)
```liquid
{% include etherscan.html
   address="0x210C655F8a51244bA7607726DeAdEB5866723D87"
   text="Uniteum 0.3 '1'" %}
```

**Exception:** Hardcoded addresses are acceptable for:
- Genesis contracts (v0.0) that will never change
- External tokens (WETH, USDC, etc.) that are standard
- Historical transaction examples

---

## Address Display Length

### Full Address
Use in reference tables where precision matters:
```
0x5bA96211E3679FDcc7047a5c64d40A4Dd3fBdAD7
```

### Shortened Address
Use in compact displays or when space is limited:
```
0x5bA96...BdAD7
```

**Note:** Etherscan automatically shows full address on hover, so shortened is fine for most uses.

---

## Common Pitfalls to Avoid

### ❌ DON'T: Mix networks without labels
```markdown
The contract is at [0x5bA96...](mainnet-link) and [0x5bA96...](sepolia-link)
```
**Problem:** Unclear which is which

### ✅ DO: Label networks clearly
```markdown
**Mainnet**: [0x5bA96...](mainnet-link)
**Sepolia**: [0x5bA96...](sepolia-link)
```

---

### ❌ DON'T: Omit section anchors when intent matters
```markdown
Go to the [Uniteum contract](https://etherscan.io/address/0x5bA...)
```
**Problem:** Users land on overview, not the write/read functions they need

### ✅ DO: Include appropriate section anchor
```markdown
Go to the [Uniteum contract](https://etherscan.io/address/0x5bA...#writeContract)
```

---

### ❌ DON'T: Use token path for contracts or vice versa
```markdown
[Uniteum](https://etherscan.io/token/0x5bA96...) ← WRONG
[foo unit](https://etherscan.io/address/0x966108...) ← WRONG
```

### ✅ DO: Use correct path type
```markdown
[Uniteum](https://etherscan.io/address/0x5bA96...) ← Correct (contract)
[foo unit](https://etherscan.io/token/0x966108...) ← Correct (token)
```

---

## Visual Enhancements (Optional)

### Network Badges (Just the Docs theme)

```markdown
{: .label .label-blue }
Mainnet

{: .label .label-purple }
Sepolia
```

### Emoji Network Indicators

```markdown
🔵 Mainnet: [0x5bA96...](link)
🟣 Sepolia: [0x5bA96...](link)
```

**Use sparingly** - only when visual distinction adds clarity.

---

## Summary Checklist

When adding an Etherscan link, ask:

1. **Who is the audience?** (Tutorial reader vs developer reference)
   - Tutorial → human-readable text
   - Reference → show address

2. **What network?** (Mainnet, Sepolia, or both)
   - Main docs → Mainnet
   - Testing → Sepolia or both
   - Reference → both in table

3. **What action?** (Read, write, view code, see transaction)
   - Write/execute → `#writeContract`
   - View code → `#code`
   - Query state → `#readContract`
   - Transaction → `type="tx"`

4. **Is this a contract or token?**
   - Contract → `/address/` with sections
   - Token → `/token/` without sections

5. **Is the address dynamic?** (Could change with versions)
   - Yes → use `site.data.contracts`
   - No (external/historical) → hardcode OK

---

**Last Updated:** 2024-12-20
