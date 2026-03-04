# Working Examples Convention

Cross-protocol convention for worked examples across Solid, Liquid, and Uniteum.

## What "Working" Means

Every example must be **reproducible on-chain** — real addresses, real transactions, real results. No hypothetical numbers or placeholder addresses.

## Required Data Per Protocol

Each protocol needs a data file in `_data/` with its example ingredients:

### Contract Addresses

| Protocol | What's Needed |
|----------|---------------|
| **Solid** | Solid contract address, at least 1-2 deployed token addresses |
| **Liquid** | Hub address, 2-3 spoke addresses with their backing tokens |
| **Uniteum** | Uniteum contract address (already in `contracts.yml`), 2-3 Unit token addresses |

### Example Transactions

Each protocol should have **real transaction hashes** for its core operations:

| Protocol | Core Operations |
|----------|----------------|
| **Solid** | `buy`, `sell`, token creation |
| **Liquid** | `heat`, `cool`, `buy`, `sell`, `sellFor`, `make` |
| **Uniteum** | `forge`, `multiply`, `divide`, unit creation |

Store these in the protocol's data file (e.g., `_data/liquid-examples.yml`).

### Data File Pattern

```yaml
# _data/{protocol}-examples.yml
#
# Schema: each example is keyed by a short slug.
# Fields:
#   tx:          transaction hash
#   network:     mainnet | sepolia
#   operation:   protocol operation name (heat, forge, buy, etc.)
#   description: one-line human summary
#   params:      key-value pairs of function inputs (optional)

heat-first:
  tx: "0xabc123..."
  network: mainnet
  operation: heat
  description: "First heat of 1,000 USDC into liquid-USDC"
  params:
    solid: "1000000000"
    token: "USDC"
```

## Example Page Structure

All example pages across protocols should follow this template:

```markdown
---
title: [Example Title]
parent: Examples
grand_parent: [Protocol]
nav_order: N
---

# [Example Title]

> One-line summary of what this example demonstrates.

## Prerequisites

- What tokens/contracts the reader needs
- Links to acquire them (with Etherscan #writeContract links)

## Setup

Starting balances/state, with links to verify on-chain.

## Steps

### Step 1: [Operation Name]

**What we're doing:** [Plain English]

**On Etherscan:**
1. Go to [contract](link#writeContract)
2. Find `functionName`
3. Enter: `param1` = value, `param2` = value
4. Confirm transaction

**What happened:**
- [Concrete result with real numbers]
- [Link to example transaction](etherscan.io/tx/0x...)

**Verify:** [Read contract link to confirm state change]

### Step 2: ...

## Result

Final state summary with verification links.

## What to Try Next

Links to related examples or operations.
```

## Cross-Protocol Consistency Rules

1. **Same voice:** Second person ("you"), present tense, imperative for instructions
2. **Same verification pattern:** Every state-changing step has a "Verify:" line linking to Etherscan #readContract
3. **Same prerequisite pattern:** Always state what the reader needs before starting
4. **Real numbers:** Use actual on-chain values, not round hypothetical amounts
5. **Transaction links:** Every write operation links to a real example transaction
6. **Error cases:** Mention what happens if the operation fails (insufficient balance, unapproved, etc.)

## Network Strategy

- **Primary examples:** Mainnet (real value, production state)
- **"Try it yourself" variants:** Sepolia (safe to experiment)
- **Label clearly:** Always state which network an example targets
- Use the Etherscan include helpers from `.meta/STYLE_GUIDE.md`

## Directory Structure

```
{protocol}/
└── examples/
    ├── index.md              ← Overview + links to individual examples
    ├── first-{operation}.md  ← Simplest operation (entry point)
    ├── {workflow}.md         ← Multi-step workflow
    └── ...
```

## Ordering Convention

1. **Simplest single operation** (buy a token, heat, forge a pair)
2. **Round-trip** (buy + sell, heat + cool, forge + unforge)
3. **Multi-step workflow** (cross-swap, arbitrage path, dimensional chain)
4. **Advanced/exploratory** (strategies, emergent patterns)

---

**Last Updated:** 2026-03
