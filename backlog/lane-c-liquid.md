# Lane C — Liquid docs · **HIGH** · self-contained, no data changes

- [ ] **C1 (HIGH)** [content/liquid/tutorial.md](../content/liquid/tutorial.md) — Remove "(the one with just `uint256 u`)" qualifiers (lines ~209, 217); document the only form `cool(u, e)` (`Liquid.sol:71,86`); `e = 0` for liquid-only exit.
- [ ] **C2 (LOW)** tutorial.md:213 — Relabel `cools` first return `(s)` → `(m)` (returns `(uint256 m, uint256 p)`).
- [ ] **C3 (HIGH)** [content/liquid/design.md](../content/liquid/design.md) — Rewrite "Inverse Operations" / "Cross-Instance Swaps / Four variants" (~134-170): only `buy(e)`, `sell(s)`, `sellFor(that,s)`, `sellsFor(that,s)` exist (`Liquid.sol:96-128`). Remove `buyWith`, specify-output inverse, `buy(A,B)`/`sell(A,B)`.
- [ ] **C4 (MED)** [content/liquid/introduction.md](../content/liquid/introduction.md) — Normalize all cool refs to `cool(u, e)` (lines ~189 wrong param `cool(s,e)`, 194, 512; prose 74, 82, 516); note `e=0`.
- [ ] **C5 (MED)** introduction.md:544-545 — Fix `Heat`/`Cool` to 5 fields: `Heat(ILiquid,uint256,uint256,uint256,uint256)`, `Cool(ILiquid,uint256,uint256,uint256,uint256)` (`ILiquid.sol:133,137`).
- [ ] **C6 (MED)** introduction.md:452 — Replace cool redemption formula with `m = u·T / (2·(T−P))` (`Liquid.sol:78`) or drop the explicit formula.
- [ ] **C7 (LOW)** design.md:567-577 + introduction.md:94,437 — Note `sells` ceiling-rounds (`e = E − (E·S + E − 1)/(S+s)`) so invariant never decreases (`Liquid.sol:98`).
- [ ] **C8 (LOW)** design.md:651-656 — Empty-lake (`E=0`) sell **reverts** (uint underflow), not "yields zero hub".
- [ ] **C9 (LOW)** [content/liquid/2x-mint-formal.md](../content/liquid/2x-mint-formal.md) §3.2 + [content/liquid/2x-mint.md](../content/liquid/2x-mint.md) — Scope analysis to `e=0`; state deployed sigs `heat(m,e)`/`cool(u,e)`.
- [ ] **C10 (LOW)** introduction.md:578 — Drop/upd. stale "src/Liquid.sol (241 lines)" (actual 185).
- [ ] **C11 (LOW)** [content/liquid/_index.md](../content/liquid/_index.md) — Clarify Hub backing is the **genesis** Solid "Uniteum 1" (`liquids.yml hub.backing` = `contracts.yml genesis`), distinct from current Uniteum. No data change.
