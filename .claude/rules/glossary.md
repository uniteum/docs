---
paths:
  - "content/glossary.md"
---

## Glossary: alphabetical order

The site-wide glossary lives at `content/glossary.md` (served at `/glossary/`). It
applies to the whole documentation site, not just Uniteum — do not move it back
under a protocol section.

### Rule

**Term entries must be listed in alphabetical order by heading.** When adding,
renaming, or editing a term, place it (or move it) into its correct alphabetical
position. Never append a new term to the end.

**Sort key:** the `## ` heading text, compared case-insensitively, ignoring
backticks and any trailing parenthetical qualifier. Examples of the key used for
ordering:

- `## Identity Unit (\`1\`)` → sort as `identity unit`
- `## Reserve Unit (Conventional)` → sort as `reserve unit`
- `## Geometric-Mean Unit` → sort as `geometric-mean unit`

A shorter heading that is a prefix of a longer one sorts first (`## Unit` before
`## Unit Creation`).

### Structural sections are exempt (not sorted into the alphabetical run)

These keep their fixed position and are **not** part of the alphabetized
sequence:

- The intro prose and the sentence noting entries are alphabetical (before the
  first `---`) stays at the **top**.
- `## Non-Goals` and `## See also` stay at the **bottom**, in that order, after
  the last alphabetized term. Any future scope/navigational section (not a term
  definition) also belongs here, not in the alphabetical run.

### When editing

- After any change to the term list, re-verify the entries are still in order
  end-to-end — an out-of-place entry is a rule violation even if you didn't
  introduce it; fix it while you're there.
- Keep the existing `---` separator between every section.
- The **Decimal Amount** and **Integer Amount** entries are governed
  additionally by `amounts.md` — keep their wording in sync with that rule.
