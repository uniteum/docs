# Verified consistent — no action

Recorded so these aren't re-investigated.

- `data/contracts.yml` Uniteum/genesis/helper/deployer addresses match on-chain; genesis `name()` = "Uniteum 1"; current = "Uniteum-0.7 1".
- `data/units.yml` predicted addresses (sampled `foo`, `meter/second`, anchored WETH) match on-chain `product()`.
- `data/liquid.yml` Write **and** Read F# indices correct under the repo's Etherscan ASCII-ordering convention.
- `data/solid.yml` F# indices correct (re-derived from verified ABI).
- `data/liquids.yml` `hub.address` = `liquid/io/prod/1/Liquid.json`; `data/locale.yml` `address` = `locale/broadcast/.../run-latest.json`.
- `data/unispring.yml` Manifold/Neutrino addresses intentionally blank (undeployed).
- Liquid 2x-mint ratio-preservation proofs, equilibrium, "approval only for heat", CREATE2 determinism — match `Liquid.sol` + invariant suite.
- Fountain/Manifold/Reflector peg mechanics prose matches `unispring/src/*.sol` + `ReflectorFork.t.sol`.
- Uniteum: version string, ONE ceiling on genesis, migrate/unmigrate reversibility, canonicalization, reciprocal/identity rules, error set, reentrancy guard — match.
- `content/glossary.md` alphabetical order + "Par Token"/amount-terminology rule compliance — compliant.
- Solid docs correctly describe `solid/src/Solid.sol`; `unisolid` is an unrelated arbitrage bot (not a docs concern).
