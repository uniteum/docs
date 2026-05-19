# Lane D — Solid docs (unblocked subset) · MED

**Not blocked.** BLK-1 was investigated and its premise was a misdiagnosis: `data/solids.yml` addresses are all CREATE2-verified correct and `tutorial.md` has no hardcoded addresses/tx hashes (no S1/S2/S4 tasks exist). D1–D4 proceed now. See [blocked.md](blocked.md) BLK-1 — note the *separate* Uniteum genesis-identity decision it surfaced (affects Lane A/B, not Lane D).

- [ ] **D1 (MED)** [content/solid/use-cases/game-currencies.md](../content/solid/use-cases/game-currencies.md) — Remove fictional "base mint / natural regeneration / time-delayed minting / recovery minting" framing (~27-31, 52-55, 64-80). Solid supply fixed once at creation, 100% to pool (`Solid.sol:106`, `Solid.t.sol:122-123,145-171`).
- [ ] **D2 (LOW)** [content/solid/use-cases/gift-certificates.md](../content/solid/use-cases/gift-certificates.md):37 — Reword "allocates supply" → 100% to pool, no maker allocation.
- [ ] **D3 (LOW)** [content/solid/_index.md](../content/solid/_index.md):95,108 + [content/solid/tutorial.md](../content/solid/tutorial.md):153-154 — NOTHING `make`/`made` links `etherscan.io/token/` → `/address/` (NOTHING is a contract; matches rest of Solid pages).
- [ ] **D4 (LOW)** [data/solid.yml](../data/solid.yml) — Add a comment documenting the full alphabetical ABI ordering (incl. `NOTHING`/`SUPPLY`/`zzz_`/inherited ERC20). Indices verified correct — **no value changes**.
