---
title: Bitsy
description: >-
  A Bitsy contract is a prototype — immutable, permissionless,
  governance-free, cloned, deterministic, direct, composable, and
  trustless-math — from which anyone can make clones. An open
  standard for minimal, permanent on-chain primitives.

# Navigation

# Metadata
weight: 3
---

# Bitsy

A **Bitsy contract** is a prototype/factory: a single contract
deployed once, from which anyone can create clones permissionlessly.
The prototype satisfies eight properties — the concrete, testable
form of the [design philosophy](/philosophy/) behind the Uniteum
protocols.

Clones delegate to the prototype's code via EIP-1167, so they
inherit its immutability. But a clone may carry mutable per-instance
state, owners (mutable or immutable), or even internal governance —
whatever the prototype's code encodes once and for all. The control
plane has to be baked into the prototype; clone users consent to
the rules the prototype already fixes.

The term is not trademarked. Anyone can build Bitsy contracts.
If a prototype meets the criteria below, it qualifies — regardless
of who deployed it or what ecosystem it belongs to.

---

## The eight properties

### 1. Immutable

No upgrade mechanism on the prototype. No admin key that alters
prototype behavior. No proxy that can be repointed. No
`selfdestruct`. The prototype's bytecode at deployment is the
bytecode forever — and since clones delegate to it, they can't
be upgraded either.

**Test:** Is there any address, key, or governance process that can
alter the prototype's logic after deployment? If yes, it is not
Bitsy.

### 2. Permissionless

Anyone can create a clone. Every external function on the
prototype's factory surface — `make()`, `made()` — is callable
by every address. No whitelist, no role check, no `onlyOwner`
on the factory or on any prototype-scope behavior.

Per-clone access control is fine: a clone whose owner gates its
own setters doesn't compromise the prototype's permissionlessness,
since the rules are fixed by the prototype's code and clone users
opt into them.

**Test:** Does any prototype-scope function check `msg.sender`
against a privileged list? If yes, it is not Bitsy.

### 3. Zero governance

No governance over the prototype. No voting on prototype behavior,
no adjustable prototype-scope parameters. Fee rates, reserve ratios,
and behavioral rules that apply to every clone are constants baked
into the prototype's bytecode.

Per-clone governance is a different matter: a clone may have its
own voters, proposals, and quorum — whatever the prototype encodes.
Mob is the canonical example. The Mob prototype has no governance;
each mob (clone) runs its own internal vote.

**Test:** Is there any process that can change parameters baked
into the prototype? If yes, it is not Bitsy.

### 4. Cloned

Every instance is an EIP-1167 minimal proxy of the prototype.
Clones share the prototype's code; they may carry their own
per-instance state, initialized once via `zzInit()` at clone
creation. Two clones run the same code under the same rules,
even if they hold different values within those rules.

**Test:** Do instances run different code? If yes, it is not
Bitsy. (Different per-instance *state* is fine.)

### 5. Deterministic

Deployed via CREATE2. The contract address is derived from its
parameters. Same parameters produce the same address on every
EVM-compatible chain.

**Test:** Can you compute the contract's address before deployment
from its inputs alone? If not, it is not Bitsy.

### 6. Direct

Every operation is a single function call. No multi-step workflows
beyond standard ERC-20 approvals. Usable from a block explorer
without a frontend, SDK, or off-chain signature.

**Test:** Does using the contract require a frontend, a relayer,
or an off-chain step? If yes, it is not Bitsy.

### 7. Composable

The contract operates through well-defined interfaces. Where it
produces tokens, those tokens are standard ERC-20s. Where it
exposes other functionality, it does so through public functions
with clear inputs and outputs — no off-chain coordination, no
proprietary coupling, no requirement that callers use a specific
SDK or wrapper.

**Test:** Can other contracts interact with this contract using
only its public interface, without proprietary adapters or
off-chain steps? If not, it is not Bitsy.

### 8. Trustless math

Prices and state transitions are determined by verifiable
computation — on-chain invariants, or off-chain computation
whose correctness is proven on-chain (e.g. ZK proofs). No
trusted oracles, no unverifiable data feeds, no reliance on
honest reporters. If an external input is used, its correctness
must be independently verifiable by the contract itself.

Arbitrage remains the primary correctness mechanism for pricing.
Where external data is needed, the contract must be able to
reject invalid inputs through proof verification — not trust
that the inputs are honest.

**Test:** Does the contract depend on any data whose correctness
requires trusting an external party? If yes, it is not Bitsy.

---

## Bitsy contracts in practice

Every Uniteum protocol is Bitsy:

| Protocol                       | Implementation              | Instances are clones of         |
|--------------------------------|-----------------------------|---------------------------------|
| [Solid](/solid/)               | Constant-product AMM with virtual reserve | [NOTHING](/solid/nothing/) |
| [Liquid](/liquid/)             | Hub-and-spoke AMM with 2x mint           | Hub                        |
| [Uniteum](/uniteum/)           | Geometric mean triads                    | The Uniteum contract       |
| [Lepton](/lepton/)             | Fixed-supply token factory               | Lepton prototype           |

These are not the only contracts that could qualify. Any contract
that passes all eight tests is Bitsy, whether or not it has
any connection to Uniteum.

---

## Why this matters

Bitsy contracts have a specific trust model: **trust the math,
not the operator.** There is no operator.

This eliminates entire categories of risk:

- **Rug pulls** — there is no admin key to drain funds.
- **Governance attacks** — there is no governance to capture.
- **Upgrade risk** — there is no upgrade path to exploit.
- **Oracle manipulation** — there are no trusted data feeds to manipulate.
- **Censorship** — there is no whitelist to exclude you from.

What remains is **code risk**: the possibility that the math itself
is wrong. That risk cannot be eliminated. It can only be managed
by keeping the code simple enough to read, and by deploying
immutably so the code you audit is the code that runs.

---

## Relationship to the design philosophy

The eight Bitsy properties are the formalized, testable version
of the [design philosophy](/philosophy/) that guided the Uniteum
protocols. The philosophy page explains *why* these choices were
made. This page defines *what* the choices are, concretely enough
that anyone can check whether a given contract qualifies.

---

## Using the term

If you deploy a contract that satisfies all eight properties, you
can call it Bitsy. No permission needed. No registry. No
certification process.

The value of the term depends on it meaning something specific.
A prototype that is "mostly Bitsy" or "Bitsy except for
governance" is not Bitsy. The properties are binary and the
list is closed — they apply to the prototype. What clones do
within the rules the prototype encodes is separate.
