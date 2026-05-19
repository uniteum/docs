# Lane F — Unispring / Reflector · **HIGH** (mostly `data/unispring.yml`)

F9 unblocked — BLK-3 **resolved** ([blocked.md](blocked.md)): `0x05dD…b388` is the committed, vanity-conforming prediction; apply F9 as written.

- [ ] **F1 (HIGH)** [data/unispring.yml](../data/unispring.yml) — `reflector.address` + `clones.1xETH.address` → `0xBDbd6217ADFe1f3AE9fd4eC4D82d62A3a9baE090` (`unispring/io/Reflector/…e090.yml`). `0x3131cE…0080` is in no artifact.
- [ ] **F2 (HIGH)** data/unispring.yml — `fountain.address` → `0xF00c0C30CE13f01c77C1F8d60Fc1146014B4E090`; delete/correct bogus `fountain.clones.fountain1` (Reflector uses the Fountain prototype directly as placer).
- [ ] **F3 (HIGH)** data/unispring.yml + [content/reflector/reference.md](../content/reflector/reference.md), [content/reflector/_index.md](../content/reflector/_index.md), [content/reflector/uniteum-1xeth.md](../content/reflector/uniteum-1xeth.md), [content/reflector/uniteum-1xusdc.md](../content/reflector/uniteum-1xusdc.md), [content/reflector/mechanics.md](../content/reflector/mechanics.md), [content/unispring/mimicry.md](../content/unispring/mimicry.md) — Add trailing `variant` to all Reflector sigs: `issue(name,variant)`, `issued(name,variant)`, `make(peg,symbol,variant)`, `made(peg,symbol,variant)` (`Reflector.sol:84,91,118,132`). Document `variant` (vanity nonce; pass `0`). Fix `mimicry.md:15` "signature unchanged" claim.
- [ ] **F4 (MED)** data/unispring.yml — v0.9.0 → **v0.9.3** in comments/version refs (deployed bytecode = 0.9.3).
- [ ] **F5 (MED)** data/unispring.yml — `read."made(peg, symbol)".f` `5` → **`4`**; rewrite gap comment (read gaps: F2 `encode`, F5 `made(bytes,…)`, F6 `made(bytes32,…)`; write gap: F3 `make(bytes,…)`).
- [ ] **F6 (HIGH)** data/unispring.yml — `clones.1xUSDC.peg_lookup_address` → `0xC5DC3461ed6653dbC5E6A8bCDcF0354fF178E300` (`USDCReflector.sh:15`).
- [ ] **F7 (MED)** [content/unispring/_index.md](../content/unispring/_index.md):8 + data/unispring.yml:2 header + content/reflector/reference.md:34 — "not yet deployed" wording: Reflector + Fountain + USDCReflector deployed; Manifold/Neutrino stack not.
- [ ] **F8 (LOW)** [content/unispring/mimicry-mechanics.md](../content/unispring/mimicry-mechanics.md) — Confirm proper redirect stub (like `mimicry.md`) or remove.
- [ ] **F9 (MED)** data/unispring.yml — `clones.1xUSDC.address` → `0x05dD50aD3A40629E62635Ea67Dd17C6a0a3cb388`. *BLK-3 resolved: address is the committed, vanity-conforming CREATE2 prediction; no longer pending.*
