# Lane E — Lepton docs (unblocked subset) · **HIGH**

Blocked items Lep2/Lep3 (live address) → [blocked.md](blocked.md) BLK-2.

- [ ] **E1 (HIGH)** [content/lepton/_index.md](../content/lepton/_index.md) — Rewrite sigs to `make(name, symbol, decimals, supply, variant)` / `made(maker, name, symbol, decimals, supply, variant)`; fix idempotent-salt formula (line ~54): preimage `abi.encode(maker,name,symbol,decimals_,supply)`, salt = that hash XOR `variant` (`Lepton.sol:29-36,43,78-87`). Add `decimals()` to deployed-token function list (~75).
- [ ] **E2 (HIGH)** [data/lepton.yml](../data/lepton.yml) — Rename keys to corrected signatures; **keep `f: 2` (write/`make`) and `f: 5` (read/`made`)** unchanged (still correct for v3.0.0 ABI); add comment that both are overloaded so F# = alphabetical name position.
