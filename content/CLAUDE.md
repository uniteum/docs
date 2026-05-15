## Terminology: token amount representations

When writing or editing documentation in this repo, use the following terms consistently for ERC-20 (and ERC-20-like) token amount representations:

- **decimal amount** — the human-readable value with a decimal point, e.g. `1.5 USDC`. This is the canonical term in this repo for the unscaled, decimal-point representation.
- **integer amount** or **base units** — the on-chain `uint256` value, e.g. `1_500_000` for 1.5 USDC. Either is acceptable; prefer "integer amount" in prose and "base units" when contrasting with named units like `wei`.

### Rules

1. **Use "decimal amount" — not synonyms.** Do not use "formatted amount," "display amount," "human-readable amount," "scaled amount," "real amount," or "UI amount" in new or edited prose. If you encounter these terms while editing existing content, replace them with "decimal amount" unless the surrounding context makes the substitution awkward (in which case, flag it rather than forcing it).

2. **Link the first use per page to the glossary.** On each page (each Markdown file), the *first* occurrence of "decimal amount" should be a link to the glossary entry: `[decimal amount](/glossary.md#decimal-amount)` (adjust the path to match this repo's glossary location). Subsequent uses on the same page should be plain text — do not link every occurrence.

3. **Do not link inside headings, code blocks, or code spans.** If the first occurrence on a page falls inside a heading or inline code, link the next prose occurrence instead.

4. **Do not link inside the glossary entry itself.** The glossary entry for "decimal amount" should not link to itself.

5. **Italicize on definition, not on use.** When a page defines or introduces the term (e.g., "we use *decimal amount* to mean..."), italicize it. In ordinary use, leave it unformatted (aside from the first-use glossary link).

6. **Preserve the contrast.** When "decimal amount" appears, the corresponding integer-side term ("integer amount" or "base units") should be used consistently within the same document. Do not mix "integer amount" and "raw amount" in the same page.

### Glossary entry

The glossary should contain an entry roughly like:

> **decimal amount** — The human-readable representation of a token amount, expressed with a decimal point (e.g., `1.5 USDC`). Contrast with *integer amount* (or *base units*), the on-chain `uint256` value scaled by `10^decimals()` (e.g., `1_500_000` for 1.5 USDC with 6 decimals). The two representations encode the same value; conversion requires the token's `decimals()`.

If the glossary entry does not exist yet, create it when first needed and notify the user.
