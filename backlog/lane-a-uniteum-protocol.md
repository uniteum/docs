# Lane A — Uniteum protocol docs · **HIGH**

Owns [content/uniteum/CLAUDE.md](../content/uniteum/CLAUDE.md). Lane B delegates its CLAUDE.md notes here (see A7). No other lane touches these files.

- [x] **A1 (HIGH)** [content/uniteum/concepts/forge.md](../content/uniteum/concepts/forge.md) — Rewrite "Two Directions" / "Forge as Swap" (lines ~43-71, 80-89): positive `du`/`dv` mint U & 1/U and **consume** "1" (`dw` negative); reverse releases "1". Replace "1 transfers from the contract to you" with minted/burned (`Unit.sol:75-88,170-176`, `Forge.t.sol:33`).
- [x] **A2 (HIGH)** [content/uniteum/concepts/tokenomics.md](../content/uniteum/concepts/tokenomics.md) — Introduce floating-pair doubling `dw = 2·(w₀−w₁)`; fix numeric example (+100/+100 → **−200** "1", not +100) and asymmetric (≈ −245); fix "receive w₁−w₀" wording.
- [x] **A3 (HIGH)** [content/uniteum/economics-of-one.md](../content/uniteum/economics-of-one.md), [content/uniteum/concepts/anchored-stability.md](../content/uniteum/concepts/anchored-stability.md), [content/uniteum/concepts/units.md](../content/uniteum/concepts/units.md) — Correct "w = '1' locked": `invariant()` returns `(u,v,w)` with `w=√(u·v)` (geometric mean of reserve bookkeeping), not custodied "1"; "1" minted/burned globally on ONE; drop "sum w across units = total locked 1" (`Unit.sol:52-56,132-176`).
- [x] **A4 (MED)** [content/uniteum/known-issues.md](../content/uniteum/known-issues.md) — Downgrade "✅ Forge operations with compound units" to ⚠️ incomplete (`Unit.sol:124-129`: compound path operates `(this,reciprocal,ONE)` only).
- [x] **A5 (LOW)** [content/uniteum/concepts/unit-syntax.md](../content/uniteum/concepts/unit-syntax.md) — Clarify anchored symbol is the 42-char `0x`-prefixed EIP-55 string (not "40-character").
- [x] **A6 (LOW)** [content/uniteum/_index.md](../content/uniteum/_index.md) + tokenomics.md — Soften "implements 0.5 power perpetuals" → "enables/intends (cross-power value not contract-enforced in v1)" (`IUnit.sol:45-48`).
- [x] **A7 (MED+LOW)** [content/uniteum/CLAUDE.md](../content/uniteum/CLAUDE.md) — Consolidated CLAUDE.md corrections, split below. *(A7b/c/d/f delegated from Lane B.)*
  - [x] **A7a (MED)** Correct the "IMPORTANT NOTE ON FORGE BEHAVIOR" section's compound-forge mechanics (compound path operates `(this, reciprocal, ONE)` only — consistent with A4).
  - [x] **A7b (LOW)** Qualify the "no transfers" claim — anchored units transfer the external token on mint/burn.
  - [x] **A7c (MED)** Correct the `ONE_MINTED` note: `0` on deployed Unit clones (unset immutable); the 1B figure is the separate genesis token's fixed supply, not an enforced ceiling. *(delegated from Lane B B4.)*
  - [x] **A7d (MED)** Add the `dw` ×0/×1/×2 scaling note (scaled by non-anchored side count: ×2 both floating, ×1 one anchored, ×0 both anchored). *(delegated from Lane B B3.)*
  - [x] **A7e (LOW)** Replace `site.data.X` → `{{< val "X" >}}` / `data/X.yml`; convert the Liquid quick-ref block to shortcodes.
  - [x] **A7f (LOW)** Fix the WBTC shorthand to valid EIP-55 `0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599`. *(delegated from Lane B B5.)*
