---
paths:
  - "**/*.md"
---

## Terminology: token amount representations

When writing or editing documentation in this repo, use the following terms consistently for ERC-20 (and ERC-20-like) token amount representations:

- **decimal amount** — the human-readable value with a decimal point, e.g. `1.5 USDC`. This is the canonical term in this repo for the unscaled, decimal-point representation.
- **integer amount** or **base units** — the on-chain `uint256` value, e.g. `1_500_000` for 1.5 USDC. Either is acceptable; prefer "integer amount" in prose and "base units" when contrasting with named units like `wei`.

### Rules

Both terms are first-class: each has its own glossary entry (`#decimal-amount` and `#integer-amount`). The rules below apply **symmetrically** to both sides.

1. **Use the canonical terms — not synonyms.**
   - Decimal side: use "decimal amount." Do not use "formatted amount," "display amount," "human-readable amount," "scaled amount," "real amount," or "UI amount."
   - Integer side: use "integer amount" or "base units." Do not use "raw amount," "raw value," "smallest unit," "atomic amount," or "base amount." (`wei` is fine, but only when the token actually has 18 decimals.)
   - If you encounter a banned synonym while editing existing content, replace it with the canonical term unless the substitution would be awkward (in which case, flag it rather than forcing it).

2. **Link the first use per page to the glossary.** On each page (each Markdown file), the *first* occurrence of "decimal amount" links to `[decimal amount](/glossary/#decimal-amount)`, and the *first* occurrence of the phrase **"integer amount"** links to `[integer amount](/glossary/#integer-amount)`. The repo's only glossary lives at `content/glossary.md` (site-wide, served at `/glossary/`). Subsequent uses of either term on the same page are plain text — do not link every occurrence. **Never auto-link the bare phrase "base unit"/"base units"** — see the caution below.

   **Caution: "base unit(s)" is overloaded in this repo.** In the Uniteum protocol docs, *base Unit* / *base units* almost always means an atomic symbolic Unit (e.g., `meter`, `second`, `USD`), defined at glossary `#base-unit` — **not** the ERC-20 integer representation. Therefore: (a) when the ERC-20 integer sense is meant, prefer "integer amount" in prose; reserve "base units" for that sense only in tight `wei`-contrast contexts where the meaning is unambiguous; (b) only the phrase "integer amount" carries the first-use `#integer-amount` link — the protocol's "base Unit" usages must keep linking to `#base-unit` (or stay plain) as before.

3. **Do not link inside headings, code blocks, or code spans.** If the first occurrence of a term on a page falls inside a heading or inline code, link the next prose occurrence instead.

4. **Glossary entries do not link to each other or to themselves.** Neither the **Decimal Amount** nor the **Integer Amount** glossary entry may link to itself or to the other entry. Within those entries, the contrasting term stays as *italicized plain text* (e.g., *integer amount*), never a link.

5. **Italicize on definition, not on use.** When a page defines or introduces a term (e.g., "we use *decimal amount* to mean..."), italicize it. In ordinary use, leave it unformatted (aside from the first-use glossary link).

6. **Preserve the contrast.** When one side appears, use the corresponding other-side term consistently within the same document — pair "decimal amount" with "integer amount" or "base units," and don't switch integer-side wording (or fall back to a banned synonym) mid-page.

### Glossary entries

Both entries exist in `content/glossary.md` (anchors `#decimal-amount`, `#integer-amount`), roughly:

> **decimal amount** — The human-readable representation of a token amount, expressed with a decimal point (e.g., `1.5 USDC`). Contrast with *integer amount* (or *base units*), the on-chain `uint256` value scaled by `10^decimals()` (e.g., `1_500_000` for 1.5 USDC with 6 decimals). The two representations encode the same value; conversion requires the token's `decimals()`.

> **integer amount** (also **base units**) — The on-chain `uint256` representation of a token amount, scaled by `10^decimals()` (e.g., `1_500_000` for 1.5 USDC). For 18-decimal tokens the base unit is named `wei`. Contrast with *decimal amount*. The two representations encode the same value; conversion requires the token's `decimals()`.

If either entry is missing, create it to match this wording and notify the user.
