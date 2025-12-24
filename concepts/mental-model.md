---
title: Mental Model
description: >-
  A high-level way to think about Units, triads, and forge in Uniteum.

# Navigation
nav_order: 1
parent: Concepts
has_children: false

# Taxonomy
categories:
  - core
  - overview

# Metadata
last_updated: 2024-12-20
version: "0.2"
status: draft
---

# Mental Model

This page explains how to **think about Uniteum** without diving into formulas or implementation details.

If you understand this page, the rest of the documentation should feel consistent rather than surprising.

---

## Units are tokens, not labels

In Uniteum, a **Unit is an ERC-20 token**.

- `meter`, `second`, `USD`, `meter/second`, and `1` are all tokens
- Each has a total supply and balances
- None of them are “just symbols”

The symbolic expression of a Unit defines **how it relates to other Units**, not how it behaves numerically.

---

## Units are related by structure, not conversion

There is no notion of:
- converting meters to seconds
- dimensional correctness
- numerical scale

Instead, Units are connected by **symbolic structure**:
- multiplication
- reciprocals
- geometric means

These structures define **price relationships**, not physical meaning.

---

## Triads are the only place economics happens

Forge never operates on a single Unit or an arbitrary pair.

It always operates on a **triad**:

```

(U, V, √(U·V))

```

Each triad:
- links three ERC-20 Units
- enforces one local geometric-mean invariant
- is economically independent of all other triads

There is **no global invariant** across the system.

---

## Forge moves value, it does not create meaning

**Forge** is the only economic operation.

Through forge:
- balances are minted
- balances are burned
- balances are exchanged

All while preserving the triad’s invariant.

Forge does **not**:
- create new Unit identities
- interpret symbols
- perform conversion

Forge only moves value through relationships that already exist.

---

## New Units come from structure, not from forge

New Unit identities are created by:
- parsing symbolic expressions
- multiplying Units
- forming reciprocals
- canonicalizing the result

This process determines **what Units exist**.

Forge determines **how value flows between them**.

Keeping these two ideas separate is essential.

---

## The mesh emerges automatically

Because Units can appear in many triads:
- as reserves in one triad
- as geometric-mean Units in another

All triads together form a **mesh**.

In this mesh:
- there are often multiple paths between two Units
- different paths may imply different prices
- arbitrage aligns prices across the system

There is no central pool, no routing table, and no oracle.

---

## “1” is just another Unit — but a special one

The identity Unit `1`:
- is an ERC-20 token
- appears naturally as the geometric mean of reciprocal pairs
- connects the entire system

`1` is not privileged by special rules.  
It is central because of structure, not exception.

---

## Everything is local, consistency is global

Uniteum enforces:
- **local rules only** (one invariant per triad)

Yet achieves:
- **global coherence** (via arbitrage across the mesh)

This is the core design idea.

Nothing in Uniteum “knows” the whole system —  
but the system remains coherent anyway.

---

## If you remember only one thing

> **Units define relationships.  
> Triads define constraints.  
> Forge moves value.  
> The mesh does the rest.**

---

## Where to go next

- [Forge](/concepts/forge)
- [Triads](/concepts/triads)
- [Unit Creation](/concepts/unit-creation)
- [Canonicalization](/concepts/canonicalization)
- [Glossary](/reference/glossary)
