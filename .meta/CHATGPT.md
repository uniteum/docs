# ChatGPT Collaboration Guide (Normative)

ChatGPT is used for:
- Conceptual consistency (definitions, invariants, terminology)
- Writing/editing docs pages in Hugo markdown (under `content/`)
- Designing “normative” spec text that matches the canonical Solidity sources
- Producing test vectors and checklists (non-code)

Constraints:
- ChatGPT cannot rely on reading Solidity `.sol` files from the project directory.
- Therefore: the docs in this repo (plus the constitution in `PROJECT_CONSTITUTION.md`) are the source of truth for ChatGPT.
- Older versions of this file referenced a `Unit.json` "compiled source bundle" as authoritative. That artifact is **not present in this repo**; treat it as historical context and defer to the constitution and the docs.

Rules:
1. If a rule is not stated in `PROJECT_CONSTITUTION.md` or in the published docs, treat it as non-existent.
2. Canonical forms must match the current Uniteum rules (e.g., no negative exponents in canonical output).
3. Forge is an ERC-20 mint/burn operation across triads; it is not “just parsing”.

Deliverable format:
- Paste-ready markdown files using Hugo frontmatter:
  ```yaml
  ---
  title: Page Title
  weight: 10
  ---
  ```
  Place new pages under the appropriate section of `content/` (e.g. `content/uniteum/...`). Hugo derives the URL from the file path; do not set `permalink`.
- Use Hugo shortcodes (`{{< val ... >}}`, `{{< fn_table ... >}}`, `{{< addr_table ... >}}`, `{{< efn ... >}}`) instead of Jekyll Liquid templating (`{% raw %}{{ site.data.* }}{% endraw %}`, `{% for %}`, `{% assign %}`). See the root `CLAUDE.md` "Hugo Shortcodes" section.
- Keep diffs small and avoid duplicating content across pages; link instead.

What ChatGPT should NOT do:
- Invent parser acceptance rules not explicitly captured in the constitution or docs.
- Assume the Solidity implementation details beyond what the constitution/doc text states.
- Emit Jekyll-era patterns (`layout:`/`permalink:` frontmatter, Liquid templating). Use Hugo equivalents.
