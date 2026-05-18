# Documentation Audit — Remediation Checklist

**Generated:** 2026-05-18 · **Method:** 7 parallel analysis agents comparing `content/` + `data/` against sibling implementation repos under `/home/paul/git/uniteum/`.
**Status:** Analysis complete. No fixes applied yet.

> Mark `[x]` as tasks complete. Lanes A–H touch disjoint file sets and can be executed in parallel by separate agents/people. The only shared file is `content/uniteum/CLAUDE.md` (owned by Lane A).

---

## Root causes (why these findings cluster)

1. **Stale root `CLAUDE.md` (Jekyll → Hugo).** Describes `_data/`, `site.data.*`, Liquid `{% raw %}{% for %}{% endraw %}` tables, `index.md`, GitHub Pages, solc 0.8.30, a non-existent `Unit.json`. Repo is Hugo (`content/`, `data/`, shortcodes, Cloudflare, solc 0.8.34). Highest leverage — keeps re-introducing doc errors.
2. **Missing `variant` parameter.** Lepton, Reflector, Locale are all `Prototype`/Bitsy-based and gained a trailing `uint256 variant` (XOR'd into the CREATE2 salt). All three docs predate it → documented signatures cause failed transactions.
3. **Deployed addresses drifted.** Lepton factory, Reflector/Fountain prototypes, 1xUSDC peg-lookup, locale USDC lookup, Solid "Uniteum 1" identity — wrong or unverifiable. Several need a human decision (see Blocked).
4. **Uniteum forge sign error.** One conceptual mistake (wrong "1" cash-flow direction, omitted floating-pair ×2 factor, treating invariant `w` as custodied "1") propagated across `forge.md`, `tokenomics.md`, `economics-of-one.md` with concretely wrong arithmetic.

**Suggested order:** Lane H first (stops future drift), then A–G in parallel.

---

## Lane A — Uniteum protocol docs · **HIGH**

Owns [content/uniteum/CLAUDE.md](content/uniteum/CLAUDE.md) (Lane B hands off its CLAUDE.md notes here).

- [ ] **A1 (HIGH)** [content/uniteum/concepts/forge.md](content/uniteum/concepts/forge.md) — Rewrite "Two Directions" / "Forge as Swap" (lines ~43-71, 80-89): positive `du`/`dv` mint U & 1/U and **consume** "1" (`dw` negative); reverse releases "1". Replace "1 transfers from the contract to you" with minted/burned (per `Unit.sol:75-88,170-176`, `Forge.t.sol:33`).
- [ ] **A2 (HIGH)** [content/uniteum/concepts/tokenomics.md](content/uniteum/concepts/tokenomics.md) — Introduce floating-pair doubling `dw = 2·(w₀−w₁)`; fix numeric example (+100/+100 → **−200** "1", not +100) and asymmetric example (≈ −245); fix "receive w₁−w₀" wording.
- [ ] **A3 (HIGH)** [content/uniteum/economics-of-one.md](content/uniteum/economics-of-one.md), [content/uniteum/concepts/anchored-stability.md](content/uniteum/concepts/anchored-stability.md), [content/uniteum/concepts/units.md](content/uniteum/concepts/units.md) — Correct "w = '1' locked" framing: `invariant()` returns `(u,v,w)` with `w=√(u·v)` (geometric-mean of reserve bookkeeping), **not** custodied "1"; "1" is minted/burned globally on ONE; drop "sum w across units = total locked 1" methodology (`Unit.sol:52-56,132-176`).
- [ ] **A4 (MED)** [content/uniteum/known-issues.md](content/uniteum/known-issues.md) — Downgrade "✅ Forge operations with compound units" to ⚠️ incomplete (`Unit.sol:124-129`; compound path operates `(this,reciprocal,ONE)` only, no reserve-transfer + √(U·V) mint).
- [ ] **A5 (LOW)** [content/uniteum/concepts/unit-syntax.md](content/uniteum/concepts/unit-syntax.md) — Clarify anchored symbol is the 42-char `0x`-prefixed EIP-55 string (not "40-character").
- [ ] **A6 (LOW)** [content/uniteum/_index.md](content/uniteum/_index.md) + tokenomics.md — Soften "implements 0.5 power perpetuals" → "enables/intends (cross-power value not contract-enforced in v1)" (`IUnit.sol:45-48`).
- [ ] **A7 (MED+LOW)** [content/uniteum/CLAUDE.md](content/uniteum/CLAUDE.md) — Consolidated CLAUDE.md fixes: (a) correct "IMPORTANT NOTE ON FORGE BEHAVIOR" compound-forge mechanics; (b) qualify "no transfers" — anchored units transfer the external token on mint/burn; (c) correct `ONE_MINTED` note (0 on Unit clones; 1B is genesis-only, not an enforced ceiling); (d) add `dw` ×0/×1/×2 scaling note; (e) replace `site.data.X` → Hugo `{{< val "X" >}}` / `data/X.yml`, convert Liquid quick-ref block to shortcodes; (f) fix WBTC shorthand line to EIP-55. *(b/c/d/f handed off from Lane B.)*

---

## Lane B — Uniteum reference + token data · **HIGH**

- [ ] **B1 (HIGH)** [content/uniteum/reference/functions.md](content/uniteum/reference/functions.md) — Rename section `UPSTREAM_ONE()` → `UPSTREAM()`; value is the genesis address (`contracts.genesis.address` via shortcode), **not** `0xC833f0B7…39E4` (which appears nowhere in source). On-chain `UPSTREAM()` = `0x7D5B1349157335aEEB929080a51003B529758830`.
- [ ] **B2 (MED)** functions.md — Add events `Migrate(address indexed user, uint256 amount)` / `Unmigrate(...)` to Events section; note `migrate` also emits `Forge` (`IUnit.sol:304-311`, `Unit.sol:391,399`). (The unused `Migrated`/`Unmigrated` in `IMigratable.sol` are dead code — document the emitted pair.)
- [ ] **B3 (MED)** functions.md — Document that both `forgeQuote` overloads scale returned `dw` by non-anchored side count (×2 both floating, ×1 one anchored, ×0 both). *(Mirror note → Lane A A7d.)*
- [ ] **B4 (MED)** functions.md — Correct `ONE_MINTED`: it's `0` on the deployed Unit/clones (unset immutable); the 1B figure is the separate genesis token's fixed supply, not an enforced ceiling. *(Mirror note → Lane A A7c.)*
- [ ] **B5 (MED)** Normalize WBTC to valid EIP-55 `0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599` (lowercase `e` in `…fBCfeDf7…`) in [data/tokens.yml](data/tokens.yml), [data/unit-inputs.yml](data/unit-inputs.yml) (both WBTC keys), [content/uniteum/reference/anchored-units/wbtc.md](content/uniteum/reference/anchored-units/wbtc.md), [content/uniteum/reference/anchored-units/_index.md](content/uniteum/reference/anchored-units/_index.md). `data/units.yml` is already correct. *(CLAUDE.md shorthand line → Lane A A7f.)*

---

## Lane C — Liquid docs · **HIGH** · self-contained, no data changes

- [ ] **C1 (HIGH)** [content/liquid/tutorial.md](content/liquid/tutorial.md) — Remove "(the one with just `uint256 u`)" qualifiers (lines ~209, 217); document the only form `cool(u, e)` (`Liquid.sol:71,86`); instruct `e = 0` for liquid-only exit.
- [ ] **C2 (LOW)** tutorial.md:213 — Relabel `cools` first return `(s)` → `(m)` (returns `(uint256 m, uint256 p)`).
- [ ] **C3 (HIGH)** [content/liquid/design.md](content/liquid/design.md) — Rewrite "Inverse Operations" / "Cross-Instance Swaps / Four variants" (lines ~134-170): only `buy(e)`, `sell(s)`, `sellFor(that,s)`, `sellsFor(that,s)` exist. Remove `buyWith`, specify-output inverse, `buy(A,B)`/`sell(A,B)` matrix (`Liquid.sol:96-128`).
- [ ] **C4 (MED)** [content/liquid/introduction.md](content/liquid/introduction.md) — Normalize all cool refs to `cool(u, e)` (lines ~189 `cool(s,e)` wrong param, 194, 512; prose 74, 82, 516); note `e=0` for liquid-only exit.
- [ ] **C5 (MED)** introduction.md:544-545 — Fix `Heat`/`Cool` event sigs to 5 fields: `Heat(ILiquid,uint256,uint256,uint256,uint256)`, `Cool(ILiquid,uint256,uint256,uint256,uint256)` (`ILiquid.sol:133,137`).
- [ ] **C6 (MED)** introduction.md:452 — Replace cool redemption formula with `m = u·T / (2·(T−P))` (`Liquid.sol:78`) or drop the explicit formula.
- [ ] **C7 (LOW)** design.md:567-577 + introduction.md:94,437 — Note `sells` ceiling-rounds (`e = E − (E·S + E − 1)/(S+s)`) so the invariant never decreases (`Liquid.sol:98`).
- [ ] **C8 (LOW)** design.md:651-656 — Empty-lake (`E=0`) sell **reverts** (uint underflow), not "yields zero hub".
- [ ] **C9 (LOW)** [content/liquid/2x-mint-formal.md](content/liquid/2x-mint-formal.md) §3.2 + [content/liquid/2x-mint.md](content/liquid/2x-mint.md) — Scope the analysis to `e=0`; state deployed sigs are `heat(m,e)`/`cool(u,e)`.
- [ ] **C10 (LOW)** introduction.md:578 — Drop/upd. stale "src/Liquid.sol (241 lines)" (actual 185).
- [ ] **C11 (LOW)** [content/liquid/_index.md](content/liquid/_index.md) — Clarify Hub backing is the **genesis** Solid "Uniteum 1" (`liquids.yml hub.backing` = `contracts.yml genesis`), distinct from the current Uniteum token. No data change.

---

## Lane D — Solid docs (unblocked subset) · MED

> Blocked items S1/S2/S4 → see Blocked section.

- [ ] **D1 (MED)** [content/solid/use-cases/game-currencies.md](content/solid/use-cases/game-currencies.md) — Remove fictional "base mint / natural regeneration / time-delayed minting / recovery minting" framing (lines ~27-31, 52-55, 64-80). Solid supply is fixed once at creation, 100% to pool (`Solid.sol:106`, `Solid.t.sol:122-123,145-171`).
- [ ] **D2 (LOW)** [content/solid/use-cases/gift-certificates.md](content/solid/use-cases/gift-certificates.md):37 — Reword "allocates supply" → 100% to pool, no maker allocation.
- [ ] **D3 (LOW)** [content/solid/_index.md](content/solid/_index.md):95,108 + [content/solid/tutorial.md](content/solid/tutorial.md):153-154 — NOTHING `make`/`made` links `etherscan.io/token/` → `/address/` (NOTHING is a contract, not a token; matches the rest of the Solid pages).
- [ ] **D4 (LOW)** [data/solid.yml](data/solid.yml) — Add a comment documenting the full alphabetical ABI ordering (incl. `NOTHING`/`SUPPLY`/`zzz_`/inherited ERC20). Indices verified correct — **no value changes**.

---

## Lane E — Lepton docs (unblocked subset) · **HIGH**

> Blocked items Lep2/Lep3 (live address) → see Blocked section.

- [ ] **E1 (HIGH)** [content/lepton/_index.md](content/lepton/_index.md) — Rewrite `make`/`made` sigs to `make(name, symbol, decimals, supply, variant)` / `made(maker, name, symbol, decimals, supply, variant)`; fix the idempotent-salt formula (line ~54): preimage `abi.encode(maker,name,symbol,decimals_,supply)`, salt = that hash XOR `variant` (`Lepton.sol:29-36,43,78-87`). Add `decimals()` to the deployed-token function list (line ~75).
- [ ] **E2 (HIGH→data)** [data/lepton.yml](data/lepton.yml) — Rename keys to corrected signatures; **keep `f: 2` (write/`make`) and `f: 5` (read/`made`)** unchanged (still correct for v3.0.0 ABI); add a comment that both are overloaded so F# = alphabetical name position.

---

## Lane F — Unispring / Reflector · **HIGH** (mostly `data/unispring.yml`)

> Sp6 (1xUSDC clone vanity finality) → confirm in Blocked before committing.

- [ ] **F1 (HIGH)** [data/unispring.yml](data/unispring.yml) — `reflector.address` and `clones.1xETH.address` → `0xBDbd6217ADFe1f3AE9fd4eC4D82d62A3a9baE090` (`unispring/io/Reflector/…e090.yml`). `0x3131cE…0080` appears in no artifact.
- [ ] **F2 (HIGH)** data/unispring.yml — `fountain.address` → `0xF00c0C30CE13f01c77C1F8d60Fc1146014B4E090`; delete/correct the bogus `fountain.clones.fountain1` block (Reflector uses the Fountain *prototype* directly as placer).
- [ ] **F3 (HIGH)** data/unispring.yml + [content/reflector/reference.md](content/reflector/reference.md), [content/reflector/_index.md](content/reflector/_index.md), [content/reflector/uniteum-1xeth.md](content/reflector/uniteum-1xeth.md), [content/reflector/uniteum-1xusdc.md](content/reflector/uniteum-1xusdc.md), [content/reflector/mechanics.md](content/reflector/mechanics.md), [content/unispring/mimicry.md](content/unispring/mimicry.md) — Add trailing `variant` to all Reflector sigs: `issue(name,variant)`, `issued(name,variant)`, `make(peg,symbol,variant)`, `made(peg,symbol,variant)` (`Reflector.sol:84,91,118,132`). Document `variant` (vanity nonce; pass `0`). Fix `mimicry.md:15` "signature unchanged" claim.
- [ ] **F4 (MED)** data/unispring.yml — v0.9.0 → **v0.9.3** in comments/version refs (deployed bytecode reports 0.9.3; local `src/Reflector.sol` is behind — see FYI).
- [ ] **F5 (MED)** data/unispring.yml — `read."made(peg, symbol)".f` `5` → **`4`**; rewrite gap-rationale comment (read gaps: F2 `encode`, F5 `made(bytes,…)`, F6 `made(bytes32,…)`; write gap: F3 `make(bytes,…)`).
- [ ] **F6 (HIGH)** data/unispring.yml — `clones.1xUSDC.peg_lookup_address` → `0xC5DC3461ed6653dbC5E6A8bCDcF0354fF178E300` (`USDCReflector.sh:15`).
- [ ] **F7 (MED)** [content/unispring/_index.md](content/unispring/_index.md):8 + data/unispring.yml:2 header + content/reflector/reference.md:34 — Update "not yet deployed" wording: Reflector + Fountain + USDCReflector are deployed; Manifold/Neutrino stack is not.
- [ ] **F8 (LOW)** [content/unispring/mimicry-mechanics.md](content/unispring/mimicry-mechanics.md) — Confirm it's a proper redirect stub (like `mimicry.md`) or remove.
- [ ] **F9 (MED, see Blocked BLK-3)** data/unispring.yml — `clones.1xUSDC.address` → `0x05dD50aD3A40629E62635Ea67Dd17C6a0a3cb388` *pending variant-finality confirmation*.

---

## Lane G — Locale · **HIGH**

> Loc5 F# re-derivation + Loc6 USDC address need on-chain/Etherscan verification → see Blocked BLK-4.

- [ ] **G1 (HIGH)** [content/locale/_index.md](content/locale/_index.md) + [content/locale/deterministic-lookup.md](content/locale/deterministic-lookup.md) — Replace fictional `KeyValue[]` API with real `make(Entry[] entries, uint256 variant)` / `made(...) returns (bool exists, address home, bytes32 salt)` (`AddressLookup.sol:28-41`, `Prototype.sol:53`).
- [ ] **G2 (HIGH)** same two files — Correct salt to `keccak256(encode(entries)) ^ bytes32(variant)`; explain `variant` (`AddressLookup.t.sol:74-97`).
- [ ] **G3 (HIGH)** same two files — Fix `zzInit(bytes calldata args, uint256) onlyProto`; chainid selection happens **inside** `zzInit` per contract family (AddressLookup/StringLookup pick the matching-chainid entry; Uint→* store all entries).
- [ ] **G4 (MED)** content/locale/_index.md — Expand the contract table to 4 rows incl. **`StringLookup`**; split into two behavioral families (single-chainid `value` vs full-map `keyAt[]`/`valueOf`).
- [ ] **G5 (HIGH→data, see BLK-4)** [data/locale.yml](data/locale.yml) — Rewrite signature keys to real `Entry[],variant`; re-derive every `f` from the verified Etherscan page; sync `{{< val >}}` keys in `_index.md`.
- [ ] **G6 (HIGH, see BLK-4)** content/locale/_index.md:97 + data/locale.yml — Verify or remove the hardcoded USDC lookup `0xfE52eC4D…592e8` (matches no `io/` artifact); move to data + reference via `{{< val >}}`.

---

## Lane H — Meta / site-wide · **HIGH** (do first — stops future drift)

- [ ] **H1 (HIGH)** [CLAUDE.md](CLAUDE.md) — Rewrite for Hugo: real `content/` tree (incl. `_index.md`, `bitsy.md`, `philosophy.md`, `why.md`, `reflector/`); `_data/` → `data/`; `site.data.*` → `{{< val >}}`/`hugo.Data`; replace Jekyll Liquid table patterns with actual shortcodes (`fn_table`, `addr_table`, `val`, `efn`, `reflector_clones`); solc 0.8.30 → 0.8.34; Tech Stack → Hugo + hugo-book + Cloudflare; fix domain line; reconcile/remove dangling `Unit.json` authoritative-source claim; bump "Last Updated".
- [ ] **H2 (MED)** `.meta/CHATGPT.md`, `.meta/PROJECT_CONSTITUTION.md` — Jekyll → Hugo; mark `Unit.json` historical/external or point to the real canonical source; optionally archive stale `*_SUMMARY.md`/audit snapshots.
- [ ] **H3 (MED)** Project memory note (`.claude/memory/MEMORY.md` per `always.md`) — Correct "source repos are submodules under `docs/lib/`": `docs/lib/` is **empty**; sources are sibling repos under `/home/paul/git/uniteum/`; only submodule is `themes/hugo-book`.
- [ ] **H4 (MED)** [content/legal.md](content/legal.md) — Fix stale "deployed in version 0.1" (line 34) and "Last updated: December 2024" (line 58); make version-agnostic / reference data.
- [ ] **H5 (LOW)** content/legal.md — Broaden disclaimer/third-party scope from Uniteum-only to all six projects (or state Uniteum scope explicitly + note the others).
- [ ] **H6 (MED)** [content/bitsy.md](content/bitsy.md):143-154 — Add **Locale** and **Unispring** rows to the practice table (both are `Prototype`/Bitsy-based per `_index.md:97`).

---

## Blocked — need decision/verification before completing

- [ ] **BLK-1 (Solid, HIGH)** — `0x7D5B1349157335aEEB929080a51003B529758830` is on-chain a bare `NOTHING`-type contract but is labeled Solid "Uniteum 1" in `data/solids.yml` *and* Uniteum genesis in `data/contracts.yml`. Two byte-identical NOTHING deployments exist (`0xB1c5929334BF19877faBBFC1CFb3Af8175b131cE` vs `0x7D5B…8830`). **Decide:** which is the canonical NOTHING; what is the real Solid "Uniteum 1" clone address (or does it not exist yet)? Then fix `data/solids.yml`, re-derive all clone addresses (H/He/Hello/"1"/Uo/Uo2), and resolve `content/solid/tutorial.md` example tx hashes (S1/S2/S4). Keep `data/contracts.yml` genesis entry unchanged.
- [ ] **BLK-2 (Lepton, HIGH)** — io artifact = `0x1Eb8dF6040A67025C2aF9a82aB966CCd7bF1e300` (v3.0.0); `broadcast/run-latest.json` = `0xe5c4…f06c`; docs use stale `0x14ae57aed6ac1cd48fa811ed885ab4a4c5e28c42` (pre-3.0.0 ABI). **Decide:** which is live on mainnet. Then replace the 4 occurrences in `content/lepton/_index.md`, add a `lepton:` entry to `data/contracts.yml`, and switch the markdown to `{{< val "contracts.lepton.address" >}}` (Lep2/Lep3).
- [ ] **BLK-3 (Reflector, MED)** — `USDCReflector.sh:18` flags the 1xUSDC vanity variant "stale — TODO re-mine". **Confirm** `0x05dD50aD3A40629E62635Ea67Dd17C6a0a3cb388` is final before applying Lane F F9.
- [ ] **BLK-4 (Locale, HIGH)** — Hardcoded USDC lookup `0xfE52eC4D4Ac10b5b0718614AA0077F2920f592e8` matches no `locale/io/` artifact. **Provide** the real canonical USDC AddressLookup clone address and re-derive `data/locale.yml` F# from the verified Etherscan page for `0x6adD49A791fF1dDDcd91f0AFCB70Cd91c81821ca` (unblocks G5/G6).
- [ ] **FYI (not a docs fix)** — Deployed Reflector bytecode reports **v0.9.3**; local `src/Reflector.sol` is still **v0.9.0**. Source lags deployment (commits `2ef5f5d`, `aa8e506`). Flag to maintainer.

---

## Verified consistent (no action — recorded so they aren't re-investigated)

- `data/contracts.yml` Uniteum/genesis/helper/deployer addresses match on-chain; genesis `name()` = "Uniteum 1"; current = "Uniteum-0.7 1".
- `data/units.yml` predicted addresses (sampled `foo`, `meter/second`, anchored WETH) match on-chain `product()`.
- `data/liquid.yml` Write **and** Read F# indices correct under the repo's Etherscan ASCII-ordering convention.
- `data/solid.yml` F# indices correct (re-derived from verified ABI).
- `data/liquids.yml` `hub.address` = `liquid/io/prod/1/Liquid.json`; `data/locale.yml` `address` matches `locale/broadcast/.../run-latest.json`.
- `data/unispring.yml` Manifold/Neutrino addresses intentionally blank (undeployed).
- Liquid 2x-mint ratio-preservation proofs, equilibrium, "approval only for heat", CREATE2 determinism — all match `Liquid.sol` + invariant suite.
- Fountain/Manifold/Reflector peg mechanics prose matches `unispring/src/*.sol` + `ReflectorFork.t.sol`.
- Uniteum: version string, ONE ceiling on genesis, migrate/unmigrate reversibility, canonicalization, reciprocal/identity rules, error set, reentrancy guard — match.
- `content/glossary.md` alphabetical order + "Par Token"/amount-terminology rule compliance — compliant.
- Solid docs correctly describe `solid/src/Solid.sol`; `unisolid` is an unrelated arbitrage bot (not a docs concern).
