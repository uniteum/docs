# Blocked — investigated; recommendations + residual decisions

All four items were investigated read-only against the sibling source repos
(`io/` prediction artifacts, `broadcast/` JSON, deploy scripts, compiled ABI).
CREATE2 addresses were re-derived locally with `cast`. The protocols are
largely **pre-launch**: most addresses are deterministic predictions, not yet
on-chain. Anything still needing a live chain read is called out as a **Decision**.

**Status legend:** **RESOLVED** = no maintainer action, apply the linked tasks ·
**READY** = recommendation firm, apply unless overridden · **DECISION** =
irreducible maintainer call before the linked tasks.

---

### BLK-3 (Reflector, MED) — **RESOLVED** → unblocks Lane F **F9**

**Finding.** `0x05dD50aD3A40629E62635Ea67Dd17C6a0a3cb388` is the deterministic
output of the committed `unispring/io/USDCReflector/USDCReflector.sh` inputs
(re-derived independently; matches `io/USDCReflector/0x05dD…b388.yml:10`). It
already satisfies the script's own vanity constraint (`addr & mask == target ==
0x05dd50…`) and is already the committed maker across 8+ downstream sibling
deploy scripts (`io/CafeUSDC`, `GoodFood`, `Momma`, `Dad`, `Dadda`, …). The
`USDCReflector.sh:18` "TODO: re-mine — variant is stale" comment is
**contradicted by the artifacts**: the recorded variant already produces a
vanity-conforming address. Not yet on mainnet, but that is by design
(`data/unispring.yml:2`); CREATE2 guarantees the same address at deploy.

**Apply.** Proceed with **F9**: `data/unispring.yml clones.1xUSDC.address` =
`0x05dD50aD3A40629E62635Ea67Dd17C6a0a3cb388`. Corroborates **F6**:
`USDCReflector.sh:15` confirms `clones.1xUSDC.peg_lookup_address` =
`0xC5DC3461ed6653dbC5E6A8bCDcF0354fF178E300` (current `data/unispring.yml:284`
value is stale, exactly as F6 states).

**Decision.** None for the docs. Source-repo hygiene only: the misleading
`USDCReflector.sh:18` comment should be cleared by the maintainer (it is not a
real mining task). Choosing a different vanity than `05dd50…` would be a pure
aesthetic change cascading into 8+ scripts — no correctness reason to.

---

### BLK-1 (Solid) — **DECISION** (original premise was a misdiagnosis) → Lane D **D1–D4 are NOT blocked; proceed**

**Finding — original premise is wrong.** Exactly **one** canonical NOTHING
exists: `0xB1c5929334BF19877faBBFC1CFb3Af8175b131cE`, the `Solid`
implementation/protofactory (`solid/script/Solid.s.sol:18`, salt `0x0`,
constructor `AVOGADRO`; deployed identically on all chains incl. mainnet per
`solid/broadcast/**/run-latest.json`). `0x7D5B…8830` is **not** "a second/bare
NOTHING" — it is an EIP-1167 minimal-proxy **clone** of NOTHING (every Solid
clone delegates to NOTHING, so all of them "look like NOTHING" on-chain; that is
expected, not a duplicate deploy). It is provably the `(name="Uniteum 1",
symbol="1")` clone: re-deriving `salt=keccak256(abi.encode(name,symbol))` + OZ
`predictDeterministicAddress` yields exactly `0x7D5B…8830`. All `data/solids.yml`
addresses (H, He, Hello, "1", Uo, Uo2) were CREATE2-re-derived and are
**correct**. `content/solid/tutorial.md` has **no** hardcoded addresses and
**no** tx hashes — only `{{< val >}}` shortcodes and empty `<!-- TODO -->`
example-hash placeholders.

So the "fix solids.yml / re-derive clones / resolve tutorial tx hashes / Lane D
S1/S2/S4 blocked" framing is void. **Lane D D1–D4 can be done now.** (There are
no S1/S2/S4 tasks; that pointer was spurious.)

**Apply.** Lane D proceeds unblocked. Optional LOW data-hygiene (not rendered):
`data/solids.yml` `Hello.name` is `World` but the token is
name="Hello"/symbol="World"; the `Uo2` key implies symbol "Uo2" but the token is
name="Unobtanium"/symbol="Uo" (distinct from `Uo`=Unobtain**i**um). Adjacent
confirmation for **B1**: `functions.md:446`'s `UPSTREAM_ONE()` value
`0xC833f0B7…39E4` is only the unrelated `UniteumKiosk` contract; correct value is
the genesis `0x7D5B…8830` — B1's fix is right.

**Decision — the real, newly-surfaced issue.** Two *different* contracts are
both documented as "genesis v0.0", with **incompatible supply semantics**:

1. Solid "Uniteum 1" clone `0x7D5B…8830` — supply = AVOGADRO (~6.022e23 base
   units), 100% in a constant-product pool. This is what `data/contracts.yml:13
   genesis`, `getting-started.md:31`, `data/liquids.yml:8 hub.backing`, and the
   live current Uniteum's `UPSTREAM` wiring use.
2. Standalone primordial `uniteum/src/Uniteum.sol` — `name="Uniteum 0.0 1"`,
   mints exactly 1e9 ether to deployer; computed deterministic address
   `0xfe5dEC33a41a20e3A6F4b524713597fa8779d8B1`. Matches the *prose* "simple
   ERC-20 holding the 1-billion primordial supply / migration source" in
   `getting-started.md:45`, `concepts/tokenomics.md:171`,
   `economics-of-one.md:259,517`, `concepts/units.md:29`.

The maintainer must decide which is the canonical genesis. Either way, prose
elsewhere is wrong: if (1), the "1-billion primordial" narrative must be
rewritten; if (2), `data/contracts.yml:13`, `.env GENESIS`, the live `UPSTREAM`
wiring, and `getting-started.md:31` are wrong (and the audit's "keep genesis
unchanged" instruction is itself wrong). This also fixes the documented
`UPSTREAM()`/`UPSTREAM_ONE()` value (B1). **Settles definitively by reading
`UPSTREAM()` on the live current Uniteum `0xace41cf6…b2b090` (mainnet)** — that
return value *is* the genesis by construction. Scope expansion beyond a docs
fix; flag to maintainer. Informs Lane A A3/A6 + Lane B B1 (does not block Lane D).

---

### BLK-2 (Lepton, HIGH) — **DECISION** (target known, not deployed) → Lane E remainder gated

**Finding.** The three addresses are three different *builds*:

- `0x1Eb8dF6040A67025C2aF9a82aB966CCd7bF1e300` — io prediction for **current
  HEAD v3.0.0** source (`lepton/src/Lepton.sol:18 version="3.0.0"`, ABI
  `make(name,symbol,decimals,supply,variant)`). Byte-verified: compiled HEAD
  creation bytecode identical to the io initcode; `cast create2` reproduces the
  address. **Never broadcast on any chain.**
- `0xe5c44386f56ed35f1dbeed0f457424deb741f06c` — actually deployed on mainnet
  (chainid 1, tx `0xfdf408f0…7215`, 2026-04-19) and Sepolia, but **pre-3.0.0**
  (initcode lacks the `version()` selector `54fd4d50`).
- `0x14ae57aed6ac1cd48fa811ed885ab4a4c5e28c42` — the current docs value; an even
  older build (2026-03-23), doubly stale.

So the address matching the v3.0.0 ABI the docs describe (`0x1Eb8dF…e300`) is
**not deployed**, and the only thing on mainnet is pre-3.0.0.

**Apply (once decided).** Recommended target = `0x1Eb8dF…e300`. Add to
`data/contracts.yml`:

```yaml
lepton:
  name: "Lepton Factory"
  description: "Permissionless fixed-supply ERC-20 token factory (v3.0.0)"
  address: "0x1Eb8dF6040A67025C2aF9a82aB966CCd7bF1e300"
```

Then replace the stale address in `content/lepton/_index.md` — 5 lines: **66**
(×2: display + URL), **72**, **73**, **102** — with
`{{< val "contracts.lepton.address" >}}`. (E1/E2 separately handle the ABI
rename in prose + `data/lepton.yml`; F-indices `f:2`/`f:5` stay per E2.)

**Decision.** v3.0.0 Lepton must be **deployed** (run `lepton/io/Lepton/Lepton.sh`,
confirm mainnet `0x1Eb8dF…e300`, verify `version()=="3.0.0"` on Etherscan) before
it can be documented as live — OR an editorial call to ship marking it
"predicted, pending deployment." Lane E remainder (Lep2/Lep3) stays gated on
this; the target address itself is no longer in question.

---

### BLK-4 (Locale, HIGH) — **DECISION** (target known, not finalized) → Lane G **G5/G6** gated; G1–G4 proceed

**Finding.** `0xfE52eC4D4Ac10b5b0718614AA0077F2920f592e8` is **real but stale** —
a clone of the *retired legacy* AddressLookup prototype
`0x6adD49A791fF1dDDcd91f0AFCB70Cd91c81821ca`, deployed on mainnet 2026-03-19
(`locale/broadcast/AddressLookupMake.s.sol/1/run-latest.json`). The source was
then refactored (`KeyValue→Entry`, `keyValues→entries`, calldata), retiring that
prototype. The **current** prototype is
`0xaDDb841F7f2D4176C480E3734448047ad83FE300`
(`locale/io/AddressLookup/…yml`). The intended new canonical USDC clone is
predicted at **`0xC5DC3461ed6653dbC5E6A8bCDcF0354fF178E300`** (a clone of the
current prototype, authored in the sibling `uniswap-lookup` repo — the same
contract Reflector pegs to in BLK-3). It is **not deployed**, and
`uniswap-lookup/io/USDC/USDC.sh:13-17` flags its vanity params as stale/needing
re-mine for the new deployer (mirrors BLK-3's pattern, but here the artifact is
*not* yet vanity-conforming).

`data/locale.yml` is wrong on every count (fictional `keyValues` sigs,
nonexistent `PROTO()`, wrong F#). Corrected from the compiled ABI: non-overloaded
indices are reliable — Read F1 `encode(...)`, F5 `proto()`, F6 `value()`, F7
`version()`; Write F3 `zzInit(...)`. Overloaded `make`/`made` positions (Read
F2–F4, Write F1–F2) need visual confirmation on the verified Etherscan page —
exactly what G5 calls for.

**Apply.** G1–G4 (signature/prose rewrites to the real `Entry[],variant` ABI)
proceed now from source. G5/G6 partially actionable: rewrite `data/locale.yml`
keys to real signatures and set the reliable F#; replace
`content/locale/_index.md:97` hardcode by moving the address to
`data/locale.yml` + `{{< val >}}`.

**Decision.** (1) Which prototype docs should describe — current
`0xaDDb841F…e300` (recommended, matches `io/`) vs. legacy `0x6adD49A7…` (live on
mainnet today); repo is mid-migration. (2) Finalize + deploy the USDC clone
(`0xC5DC3461…E300` is provisional until its vanity is re-mined for the new
deployer and broadcast — same maintainer action as BLK-3, but unlike BLK-3 not
yet resolved). (3) Visually confirm overloaded `make`/`made` F# ordering on the
verified Etherscan page (G5).

---

**Cross-links.** BLK-3 and BLK-4 both involve
`0xC5DC3461ed6653dbC5E6A8bCDcF0354fF178E300` (USDC Lookup): the Reflector peg
target (BLK-3, confirmed final) and the Locale USDC clone (BLK-4, provisional).
The same vanity-finality question recurs — resolved in BLK-3 (already
conforming), open in BLK-4 (not yet conforming). BLK-1's genesis-identity
question informs Lane A (A3/A6) and Lane B (B1).
