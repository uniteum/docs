# ChatGPT Changes Summary

**Date:** December 23, 2025
**Commits:** 3478c2f..df8334a (collaboration setup through unit-syntax move)

## Overview

ChatGPT made significant contributions focused on **conceptual clarity**, **normative definitions**, and **documentation structure**. The changes establish a rigorous framework for understanding Uniteum's two-layer architecture and provide canonical definitions for all key terms.

## New Files Created

### Core Concept Pages

1. **`concepts/mental-model.md`** (commit 7c73d9b)
   - High-level conceptual overview for understanding Uniteum
   - Key insights: "Units are tokens, not labels", "Triads are the only place economics happens"
   - Establishes mental framework before diving into details

2. **`concepts/unit-syntax.md`** (commit d295936, moved df8334a)
   - Defines string syntax for unit expressions
   - Operators: `*`, `/`, `^`
   - Identity unit: `1`
   - Precedence and canonical form rules

3. **`concepts/unit-creation.md`** (commit 6c11e0e)
   - **Critical separation**: Unit identity creation vs forge operations
   - Layer 1: Symbolic (parsing, canonicalization) - creates ERC-20 contracts
   - Layer 2: Economic (forge) - mints/burns balances
   - Emphasizes this distinction is fundamental to understanding Uniteum

4. **`concepts/canonicalization.md`** (commit d0f1c94)
   - Deterministic normalization rules
   - Ensures unique Unit identities
   - Rules: identity is `1`, no negative exponents, structural reciprocals, canonical ordering

5. **`reference/glossary.md`** (commit 8dc4bf5)
   - Canonical definitions of all terms
   - Normative: definitions here take precedence over informal usage
   - Covers: Unit, Base Unit, Compound Unit, Identity Unit, Reciprocal, Forge, Triad, etc.

### Meta/Normative Documents

6. **`.meta/PROJECT_CONSTITUTION.md`** (commit d295936)
   - **Normative** - authoritative alongside Unit.json
   - Defines scope (what's in/out of scope)
   - Canonical form rules
   - Parser acceptance vs canonical rendering

7. **`.meta/CHATGPT.md`** (commit 3478c2f)
   - ChatGPT collaboration guidelines
   - What ChatGPT can/cannot do
   - Constraints: cannot read .sol files, relies on Unit.json + docs

8. **`.meta/HANDOFF_TEMPLATE.md`** (commit 3478c2f)
   - Template for handing off work between Claude and ChatGPT
   - Sections: Goal, Authoritative constraints, Files to touch, Definition of done

## Files Modified

### `concepts/forge.md` (commit 9335f33)

**Key changes:**
- Clarified that geometric-mean Unit is a **first-class ERC-20**, not a computed value
- Emphasized **w² = u · v** constraint (w's supply is constrained, not derived)
- Improved language around "reserve units" vs "geometric-mean Unit" roles
- Added emphasis: "Forging is not just trading—it is market making through invariant-constrained minting and burning"

**Conceptual shift:**
- Before: Could be read as "liquidity unit is calculated from reserves"
- After: Clear that geometric-mean Unit has its own supply, constrained by invariant

### `concepts/triads.md` (commit 87c14a2)

**Key changes:**
- Emphasized **local invariants** - each triad has one, NO global invariant
- Clarified terminology: "reserve" and "geometric-mean" are **conventional roles**, not fundamental
- Restructured to show common triad patterns more clearly
- Added "Triad Roles (Conventional)" section
- Improved "Valid vs Invalid Triads" with both constraints clearly listed

**Conceptual shift:**
- Before: Could be read as triads having special global properties
- After: Crystal clear that invariants are strictly local, global coherence is emergent

## Key Conceptual Contributions

### 1. Two-Layer Architecture

ChatGPT established a **fundamental distinction** that was previously implicit:

**Layer 1: Unit Identity Creation** (symbolic/structural)
- Parsing expressions
- Multiplication, reciprocals
- Canonicalization
- Creates ERC-20 contracts
- Does NOT mint balances or affect prices

**Layer 2: Forge Operations** (economic)
- Mints/burns balances of existing Units
- Operates on triads
- Changes prices through supply changes
- Never creates new Unit identities

This separation is now **normative** and should be maintained in all documentation.

### 2. Terminology Precision

**Geometric-Mean Unit** (preferred) vs "Liquidity Unit" (acceptable for intuition)
- Emphasizes it's a first-class ERC-20 with its own supply
- Supply is **constrained** by invariant w² = u · v, not computed on demand
- Can serve different roles in different triads

**Local Invariants** (not "the invariant")
- Each triad enforces one local invariant
- NO global invariant exists
- Global coherence emerges from arbitrage

**Identity Unit: `1`** (not "unity")
- PROJECT_CONSTITUTION.md specifies `1` as canonical name
- This is a normative change from earlier informal "unity"

### 3. Canonical Form Rules

From PROJECT_CONSTITUTION.md:

1. Identity unit is named `1`
2. Canonical form never uses negative exponents
3. Reciprocals are structural: `1/x` (not `x^-1`)
4. Terms are ordered canonically (deterministic)
5. Exponent division uses `:` (e.g., `foo^2:3` = foo^(2/3))

**Parser vs Canonical:**
- Parser may accept non-canonical input (e.g., `bar^-1`)
- Canonical output is always deterministic (e.g., `1/bar`)
- Documentation should use canonical forms unless labeled otherwise

### 4. Normative Hierarchy

ChatGPT established authoritative sources in order:

1. **Unit.json** - compiled source bundle / implementation intent
2. **PROJECT_CONSTITUTION.md** - normative rules and scope
3. Other docs - non-normative unless explicitly stated

This hierarchy should guide all documentation and code decisions.

## Integration with CLAUDE.md

Updated CLAUDE.md to include:

1. **Collaboration Context** section - explains Claude/ChatGPT division of labor
2. **Terminology alignment** - preferred terms, notation conventions
3. **Two Distinct Layers** section - emphasizes Layer 1 vs Layer 2
4. **Canonicalization Rules** section - summarizes normative rules
5. **Key Documentation Added by ChatGPT** - lists new pages with descriptions
6. Updated terminology throughout:
   - "geometric-mean Unit" instead of just "liquidity unit"
   - Emphasis on local vs global invariants
   - Capital "Unit" for Uniteum Units vs generic tokens

## Style and Voice

ChatGPT's contributions use:

- **Precise, formal language** - normative definitions
- **Clear structure** - sections with clear headings
- **Emphasis blocks** - "CRITICAL", "IMPORTANT", "Normative"
- **Consistent terminology** - defined in glossary, used consistently
- **Separation of concerns** - one concept per page
- **Cross-references** - extensive linking to related concepts

## What ChatGPT Did NOT Change

- Contract code or implementation details
- Practical examples with Etherscan links
- Getting started guides
- Economics or value hypotheses
- Distribution strategy
- Anchored unit reference pages

These remain in Claude's domain.

## Recommendations for Future Collaboration

1. **Conceptual work → ChatGPT**
   - Normative definitions
   - Terminology consistency
   - Mental models and frameworks
   - Spec text matching Unit.json

2. **Practical work → Claude**
   - Code implementation
   - Contract interactions
   - Etherscan examples
   - Getting started tutorials
   - Deployment scripts

3. **Handoffs**
   - Use `.meta/HANDOFF_TEMPLATE.md`
   - Clearly state which layer (Layer 1 vs Layer 2)
   - Reference normative sources (Unit.json, PROJECT_CONSTITUTION.md)

4. **Terminology**
   - Follow glossary definitions
   - Use preferred terms from CLAUDE.md alignment section
   - Note when using "conventional" vs "fundamental" language

## Summary

ChatGPT's changes establish a **rigorous conceptual foundation** for Uniteum documentation. The key insight is the **two-layer architecture** (identity creation vs forge operations) and the emphasis on **local invariants with emergent global behavior**. These contributions should be treated as **normative** and referenced when making future documentation or implementation decisions.

**Most Important Takeaway:**
Unit identity creation (Layer 1) is fundamentally separate from forge operations (Layer 2). Keeping this distinction clear prevents conceptual confusion and enables correct reasoning about the system.
