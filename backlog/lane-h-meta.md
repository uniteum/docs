# Lane H — Meta / site-wide · **HIGH** (do first — stops future drift)

- [ ] **H1 (HIGH)** [CLAUDE.md](../CLAUDE.md) — Rewrite root CLAUDE.md for Hugo, split below. Do these as one editing pass but track sub-items independently.
  - [ ] **H1a (HIGH)** Rewrite the Site Structure tree to the real `content/` layout (incl. `_index.md`, `bitsy.md`, `philosophy.md`, `why.md`, `reflector/`).
  - [ ] **H1b (HIGH)** `_data/` → `data/` throughout.
  - [ ] **H1c (HIGH)** `site.data.*` → `{{< val >}}` / `hugo.Data`.
  - [ ] **H1d (HIGH)** Replace Jekyll Liquid table patterns with the actual shortcodes (`fn_table`, `addr_table`, `val`, `efn`, `reflector_clones`).
  - [ ] **H1e (MED)** solc 0.8.30 → 0.8.34.
  - [ ] **H1f (MED)** Tech Stack section → Hugo + hugo-book + Cloudflare.
  - [ ] **H1g (LOW)** Fix the domain line.
  - [ ] **H1h (MED)** Reconcile or remove the dangling `Unit.json` authoritative-source claim.
  - [ ] **H1i (LOW)** Bump "Last Updated".
- [ ] **H2 (MED)** `.meta/CHATGPT.md`, `.meta/PROJECT_CONSTITUTION.md` — Jekyll → Hugo; mark `Unit.json` historical/external or point to real canonical source; optionally archive stale `*_SUMMARY.md`/audit snapshots.
- [ ] **H3 (MED)** Project memory note (`.claude/memory/MEMORY.md` per `always.md`) — Correct "source repos are submodules under `docs/lib/`": `docs/lib/` is **empty**; sources are sibling repos under `/home/paul/git/uniteum/`; only submodule is `themes/hugo-book`.
- [ ] **H4 (MED)** [content/legal.md](../content/legal.md) — Fix stale "deployed in version 0.1" (line 34) and "Last updated: December 2024" (line 58); make version-agnostic / reference data.
- [ ] **H5 (LOW)** content/legal.md — Broaden disclaimer/third-party scope from Uniteum-only to all six projects (or state Uniteum scope explicitly + note the others).
- [ ] **H6 (MED)** [content/bitsy.md](../content/bitsy.md):143-154 — Add **Locale** and **Unispring** rows to the practice table (both `Prototype`/Bitsy-based per `_index.md:97`).
