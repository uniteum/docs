---
title: Philosophy
description: >-
  Design principles behind all Uniteum protocols:
  immutable, permissionless, cloned, deterministic, math-only.

# Navigation
nav_order: 2
has_children: false

# Metadata
last_updated: 2026-03-27
status: draft
---

# Philosophy

Uniteum protocols share a set of design commitments. These are not
aspirations — they are properties enforced by the deployed bytecode.

---

## Immutable

No contract in the Uniteum ecosystem has an upgrade mechanism, an admin
key, or a migration path. Once deployed, the rules are permanent.

This is not a limitation. It is the point.

Upgradeable contracts ask users to trust that the operator will act in
their interest. Immutable contracts remove the question entirely. The
code you read today is the code that runs tomorrow, next year, and as
long as Ethereum exists.

There is no multisig that can change fee parameters. There is no
governance vote that can redirect funds. There is no emergency pause.

If a bug is found, a new protocol can be deployed. The old one remains
as it was. Users migrate voluntarily or not at all.

---

## Permissionless

Anyone can create a Solid token, wrap an ERC-20 with Liquid, forge
a Uniteum unit, or deploy a Lepton token. There is no whitelist,
no approval process, no KYC gate.

Permissionlessness means the protocol cannot discriminate. It also
means it cannot curate. That is an acceptable tradeoff — curation
belongs at the interface layer, not the protocol layer.

The contracts expose the same operations to every address. No function
checks `msg.sender` against a privileged list. No role grants elevated
access.

---

## Zero governance

There are no governance tokens. There are no DAOs. There are no
parameter knobs.

Governance is a mechanism for changing rules after deployment. These
protocols have no rules that can be changed. Fee structures are
hardcoded. Reserve ratios are set at creation. Pool mechanics are
fixed in the implementation.

This eliminates an entire category of risk: the risk that someone
with enough votes or enough tokens can alter the system in their
favor. There is no one to lobby, no proposal to submit, no vote
to buy.

---

## Cloned, not configured

Every Solid is a minimal proxy clone of
[NOTHING](/solid/nothing/) — the single implementation contract that
defines all Solid behavior. Every Liquid spoke is a clone of Hub.
Every Lepton token is a clone of its prototype.

This means:

- **Identical rules.** Every instance runs the same logic. There are
  no special cases, no per-instance parameters that alter behavior,
  no hidden flags.
- **Shared fate.** If the implementation is sound, every clone is
  sound. If the implementation has a flaw, every clone shares that
  flaw. There is no pretending one instance is safer than another.
- **Fairness by construction.** No instance can be granted privileged
  logic. The maker of a token operates under the same code as every
  other participant.

Cloning is not a gas optimization. It is a commitment: the same
rules apply to everyone, and no one — including the deployer — can
change them.

---

## Deterministic

All Uniteum contracts use CREATE2 for deployment. The address of a
contract is derived from its parameters — name, symbol, backing token,
or other inputs. The same parameters produce the same address on every
EVM chain.

This has practical consequences:

- **Predictable addresses.** You can compute a contract's address
  before it exists. Interfaces, indexers, and other contracts can
  reference it by address without waiting for deployment.
- **Idempotent deployment.** Deploying the same token twice is not
  an error — it is a no-op. The address already exists.
- **Cross-chain consistency.** The same Solid, Liquid spoke, or
  Lepton token lives at the same address on Mainnet, Arbitrum,
  Base, or any other EVM chain.

Determinism removes coordination overhead. There is no registry to
consult, no deployer to ask, no canonical chain to check.

---

## Pure math

Prices in Uniteum protocols are not set by oracles, keepers, or
external feeds. They emerge from on-chain invariants maintained by
arbitrage.

- Solid uses a constant-product invariant with a virtual reserve.
- Liquid uses the constant-product invariant across a hub-and-spoke
  topology.
- Uniteum uses a geometric mean invariant: `√(u · v) = w`.

These are closed-form mathematical relationships. The contracts
enforce them. Arbitrageurs correct deviations. No off-chain
infrastructure is required.

This makes the protocols self-contained. They do not depend on data
feeds that can be manipulated, delayed, or shut down. The math is
the mechanism.

---

## Summary

| Principle            | What it means                                      |
|----------------------|----------------------------------------------------|
| Immutable            | No upgrades, no admin, no migration                |
| Permissionless       | Anyone can use every operation                     |
| Zero governance      | No tokens, no votes, no parameter changes          |
| Cloned               | One implementation, identical for all instances    |
| Deterministic        | Same parameters → same address, every chain        |
| Pure math            | On-chain invariants, no oracles                    |

These are not ideals to strive for. They are properties of the
deployed contracts. You can verify each one by reading the bytecode.
