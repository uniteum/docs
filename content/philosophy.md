---
title: Philosophy
description: >-
  Design principles behind all Uniteum protocols:
  immutable, permissionless, cloned, deterministic, trustless math.

# Navigation

# Metadata
weight: 2
---

# Philosophy

The hardest problem in DeFi is knowing what to trust. Code gets
upgraded, fees get switched on, admin keys get compromised. Uniteum
protocols are designed so you don't have to take anyone's word for
anything — every property below is enforced by deployed bytecode,
not promises.

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

Cloning is also a practical optimization. A minimal proxy is 45 bytes
of runtime code — a forwarding stub. Deploying a new Solid or Liquid
spoke costs a fraction of what a full contract deployment would. This
matters when the protocol is designed for thousands of instances.

But the deeper reason is fairness: the same rules apply to everyone,
and no one — including the deployer — can change them.

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

## Simple enough to use directly

Every operation in every protocol is a single function call. There is
no multi-step workflow, no approve-then-execute dance beyond standard
ERC-20 approvals, no off-chain signature required.

This means the contracts are usable directly from a block explorer.
Go to Etherscan, connect a wallet, and call `make`, `heat`, `cool`,
`swap`, or `forge`. No frontend required. No SDK. No CLI.

This is a deliberate constraint. If an operation cannot be expressed
as one clear function call with obvious parameters, it is too
complicated. The protocol should be legible at the contract interface
level — not just to developers, but to anyone who can read a function
signature.

Frontends are conveniences, not requirements. The protocol works
without them.

---

## Composable

Each protocol is independent. Solid does not import Liquid. Liquid
does not depend on Uniteum. They connect through ERC-20 — the only
interface they share with each other and with the rest of Ethereum.

This means:

- **Any ERC-20 can enter.** Liquid wraps any ERC-20. Solid tokens
  are ERC-20s. Lepton tokens are ERC-20s. Each protocol's outputs
  are valid inputs to the others.
- **No walled garden.** A Solid token can be wrapped with Liquid.
  A Lepton token can back a Liquid spoke. A Uniteum unit can
  reference any ERC-20 via anchoring. The protocols compose because
  they speak the same standard, not because they were designed as a
  bundle.
- **External composability.** Because every token is a standard
  ERC-20, it works with Uniswap, Aave, Gnosis Safe, or any other
  contract that accepts ERC-20s. Nothing about these protocols
  requires the rest of the ecosystem to know they exist.

Composability is not a feature that was added. It is a consequence
of building on a shared standard and not adding proprietary
abstractions on top.

---

## Trustless math

Prices and state transitions are determined by verifiable
computation. No trusted oracles, no unverifiable data feeds, no
reliance on honest reporters.

Today, the Uniteum protocols are fully self-contained — prices
emerge from on-chain invariants maintained by arbitrage:

- Solid uses a constant-product invariant with a virtual reserve.
- Liquid uses the constant-product invariant across a hub-and-spoke
  topology.
- Uniteum uses a geometric mean invariant: `√(u · v) = w`.

These are closed-form mathematical relationships. The contracts
enforce them. Arbitrageurs correct deviations.

The principle extends beyond pure on-chain computation. Off-chain
computation is acceptable when its correctness is proven on-chain
— for example, through ZK proofs that the contract can verify
independently. What matters is that correctness never depends on
trusting an external party. If the contract cannot reject bad
inputs through its own verification, the dependency is not
trustless.

---

## Summary

| Principle            | What it means                                      |
|----------------------|----------------------------------------------------|
| Immutable            | No upgrades, no admin, no migration                |
| Permissionless       | Anyone can use every operation                     |
| Zero governance      | No tokens, no votes, no parameter changes          |
| Cloned               | One implementation, identical for all instances    |
| Deterministic        | Same parameters → same address, every chain        |
| Simple               | Every operation is one function call from Etherscan|
| Composable           | Standard ERC-20 in, standard ERC-20 out            |
| Trustless math       | Verifiable computation, no trusted data feeds      |

These are not ideals to strive for. They are properties of the
deployed contracts. You can verify each one by reading the bytecode.

Taken together, these eight properties define what it means for a
contract to be [Bitsy](/bitsy/) — a concrete, testable
standard that any contract can meet.
