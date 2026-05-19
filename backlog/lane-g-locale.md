# Lane G — Locale · **HIGH**

G5 F# re-derivation + G6 USDC address need on-chain/Etherscan verification → [blocked.md](blocked.md) BLK-4.

- [ ] **G1 (HIGH)** [content/locale/_index.md](../content/locale/_index.md) + [content/locale/deterministic-lookup.md](../content/locale/deterministic-lookup.md) — Replace fictional `KeyValue[]` API with real `make(Entry[] entries, uint256 variant)` / `made(...) returns (bool exists, address home, bytes32 salt)` (`AddressLookup.sol:28-41`, `Prototype.sol:53`).
- [ ] **G2 (HIGH)** same two files — Correct salt to `keccak256(encode(entries)) ^ bytes32(variant)`; explain `variant` (`AddressLookup.t.sol:74-97`).
- [ ] **G3 (HIGH)** same two files — Fix `zzInit(bytes calldata args, uint256) onlyProto`; chainid selection happens **inside** `zzInit` per family (AddressLookup/StringLookup pick matching-chainid entry; Uint→* store all entries).
- [ ] **G4 (MED)** content/locale/_index.md — Expand contract table to 4 rows incl. **`StringLookup`**; split into two behavioral families (single-chainid `value` vs full-map `keyAt[]`/`valueOf`).
- [ ] **G5 (HIGH, BLK-4)** [data/locale.yml](../data/locale.yml) — Rewrite signature keys to real `Entry[],variant`; re-derive every `f` from the verified Etherscan page; sync `{{< val >}}` keys in `_index.md`.
- [ ] **G6 (HIGH, BLK-4)** content/locale/_index.md:97 + data/locale.yml — Verify or remove hardcoded USDC lookup `0xfE52eC4D…592e8` (matches no `io/` artifact); move to data + reference via `{{< val >}}`.
