# Lane B — Uniteum reference + token data · **HIGH**

Do **not** edit `content/uniteum/CLAUDE.md` — those notes are delegated to Lane A (A7 b/c/d/f).

- [x] **B1 (HIGH)** [content/uniteum/reference/functions.md](../content/uniteum/reference/functions.md) — Rename `UPSTREAM_ONE()` → `UPSTREAM()`; value is the genesis address (`contracts.genesis.address` via shortcode) = `0x7D5B1349157335aEEB929080a51003B529758830`, **not** `0xC833f0B7…39E4` (appears nowhere in source).
- [x] **B2 (MED)** functions.md — Add events `Migrate(address indexed user, uint256 amount)` / `Unmigrate(...)`; note `migrate` also emits `Forge` (`IUnit.sol:304-311`, `Unit.sol:391,399`). `Migrated`/`Unmigrated` in `IMigratable.sol` are dead code.
- [x] **B3 (MED)** functions.md — Document that both `forgeQuote` overloads scale returned `dw` by non-anchored side count (×2 both floating, ×1 one anchored, ×0 both). *(Mirror note → Lane A A7d.)*
- [x] **B4 (MED)** functions.md — Correct `ONE_MINTED`: `0` on deployed Unit/clones (unset immutable); 1B is the separate genesis token's fixed supply, not an enforced ceiling. *(Mirror note → Lane A A7c.)*
- [x] **B5 (MED)** Normalize WBTC to valid EIP-55 `0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599` (lowercase `e` in `…fBCfeDf7…`) in [data/tokens.yml](../data/tokens.yml), [data/unit-inputs.yml](../data/unit-inputs.yml) (both WBTC keys), [content/uniteum/reference/anchored-units/wbtc.md](../content/uniteum/reference/anchored-units/wbtc.md), [content/uniteum/reference/anchored-units/_index.md](../content/uniteum/reference/anchored-units/_index.md). `data/units.yml` already correct. *(CLAUDE.md shorthand line → Lane A A7f.)*
