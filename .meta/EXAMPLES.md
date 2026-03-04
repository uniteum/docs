# Working Examples — Design Patterns

Convention for writing worked examples and tutorials across this documentation site.

## What "Working" Means

Every example must be **reproducible on-chain** — real addresses, real transactions, real results. No hypothetical numbers or placeholder addresses.

## Three Example Patterns

Use the pattern that best fits the material. A single page can combine patterns.

### Pattern 1: Narrative Use Case

Lead with a human problem, not protocol mechanics. Use a character to ground the abstract.

**Structure:**
1. **Hook** — A relatable problem (one paragraph)
2. **Character** — Who is doing this and why
3. **Mechanism** — How the protocol solves it, woven into the story (not a spec dump)
4. **Trust signal** — What the character *cannot* do (immutability, no admin keys)
5. **Outcome** — The surprising social or economic effect

**Benchmark:** `solid/use-cases/gift-certificates.md` (Mara's story)

**When to use:** Introducing a protocol to non-technical readers, showing *why* someone would care, use-case pages.

**Key principles:**
- Show, don't spec — concrete scenarios over feature lists
- The mechanism should feel inevitable, not clever
- End on what happens, not what could happen

### Pattern 2: How-To Tutorial

Step-by-step walkthrough of a specific on-chain operation using Etherscan.

**Structure:**
1. **Goal** — One sentence: what you'll accomplish
2. **Prerequisites** — What you need before starting (tokens, approvals, wallet)
3. **Preview** — Read-only check of the expected result (`sells()`, `buys()`, `made()`)
4. **Action** — Numbered steps on Etherscan's Write Contract interface
5. **What happened** — Concrete outcomes with real numbers
6. **Verify** — Read Contract link to confirm state change

**Benchmark:** `liquid/introduction.md` (Heat, Cool, Sell, Buy, Cross-swap sections)

**When to use:** Teaching a specific operation, "try it yourself" guides, getting-started pages.

**Key principles:**
- Always preview before executing (read before write)
- Every write step links to a real example transaction
- State what happens if the operation fails (zero balance, unapproved, etc.)

### Pattern 3: Conceptual Example

Show how a mechanism works through price tables, relationships, and comparison to alternatives.

**Structure:**
1. **Setup** — Define the tokens/units/pools involved
2. **Scenario** — A market condition or user action
3. **Table** — Show concrete numbers across states (before, during, after)
4. **Why this is novel** — Comparison to traditional approaches (with checkmarks/crosses)

**Benchmark:** `uniteum/use-cases.md` (Hedging with Reciprocals section)

**When to use:** Explaining economic mechanics, price relationships, arbitrage dynamics, protocol comparisons.

**Key principles:**
- Tables with real numbers beat prose explanations
- Show the traditional approach first, then show how this is different
- Be honest about unknowns

## Consistency Rules

These apply across all patterns:

1. **Voice:** Second person ("you"), present tense, imperative for instructions
2. **Verification:** Every state-changing action has a way to confirm the result on-chain
3. **Prerequisites first:** Always state what the reader needs before starting
4. **Real data:** Use actual on-chain values and addresses, not round hypothetical amounts
5. **Transaction links:** Link to real example transactions where possible
6. **Safety:** Mention risks, failure modes, and what *cannot* happen (immutability guarantees)

## Data Requirements

Working examples need real on-chain data. Store these in `_data/` files following the conventions in `_data/CLAUDE.md`:

- **Contract addresses** — deployed contracts referenced in examples
- **Example transactions** — real tx hashes demonstrating each operation

When developing examples, use `TODO` placeholders for values that must come from actual deployments:

```yaml
address: "TODO"  # Contract address (fill from Etherscan)
tx: "TODO"       # Example transaction hash
```

## Page Ordering

Within an examples section, order by increasing complexity:

1. **Simplest single operation** — one function call
2. **Round-trip** — do and undo (buy + sell, wrap + unwrap)
3. **Multi-step workflow** — chained operations
4. **Advanced/exploratory** — strategies, emergent patterns

---

**Last Updated:** 2026-03
