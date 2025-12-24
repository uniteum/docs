# ChatGPT Collaboration Guide (Normative)

ChatGPT is used for:
- Conceptual consistency (definitions, invariants, terminology)
- Writing/editing docs pages in Jekyll markdown
- Designing “normative” spec text that matches Unit.json
- Producing test vectors and checklists (non-code)

Constraints:
- ChatGPT cannot rely on reading Solidity `.sol` files from the project directory.
- Therefore: Unit.json + docs in this repo are the source of truth for ChatGPT.

Rules:
1. If a rule is not present in Unit.json and not stated in docs, treat it as non-existent.
2. Canonical forms must match the current Uniteum rules (e.g., no negative exponents in canonical output).
3. Forge is an ERC-20 mint/burn operation across triads; it is not “just parsing”.

Deliverable format:
- Paste-ready markdown files with frontmatter:
  layout: page
  title:
  permalink: (lowercase, no trailing slash)
- Keep diffs small and avoid duplicating content across pages; link instead.

What ChatGPT should NOT do:
- Invent parser acceptance rules not explicitly captured in docs/Unit.json.
- Assume the Solidity implementation details beyond what Unit.json/doc text states.
