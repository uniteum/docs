---
title: Triads
description: >-
  Valid three-token relationships in Uniteum. Every forge operates on
  (U, V, √(U·V)) subject to a local geometric-mean invariant.

# Navigation
nav_order: 3
parent: Concepts
has_children: false

# Taxonomy
categories:
  - core
  - trading

# Metadata
last_updated: 2024-12-20
version: "0.2"
status: draft
---

# Triads

{: .note }
> For forge mechanics, see [Forge](/concepts/forge/).  
> For invariant mathematics, see [Tokenomics](/concepts/tokenomics/).

A **triad** is a valid three-Unit relationship on which forge can operate.

Every triad links three ERC-20 Units whose supplies are constrained by a **local geometric-mean invariant**. Forge never operates outside a triad.

## The Geometric-Mean Structure

Every forge triad follows the pattern:

**(U, V, √(U·V))**

Where:
- **U and V** are two Units in the triad (often treated as reserves by convention)
- **√(U·V)** is the geometric-mean Unit associated with the pair

The geometric-mean Unit is a **first-class ERC-20 Unit**.  
Its supply is **constrained by the invariant**, not derived on demand from U and V.

## Local Invariant (Normative)

All triads obey the same invariant:

$$\sqrt{u \cdot v} = w$$

Or equivalently:

$$u \cdot v = w^2$$

Where:
- **u, v** = supplies of the two Units in the triad
- **w** = supply of the geometric-mean Unit

This invariant is enforced **strictly and locally per triad**.

{: .note }
> **There is no higher-order invariant.**  
> Uniteum enforces no constraint spanning multiple triads.  
> Global behavior emerges solely from overlapping triads and arbitrage.

## Triad Roles (Conventional)

In examples and intuition:
- U and V are often called *reserve Units*
- √(U·V) is often called the *liquidity* or *geometric-mean Unit*

These roles are **conventional, not fundamental**.  
A Unit may act as a reserve in one triad and a geometric-mean Unit in another.

## Common Triad Patterns

### Reciprocal Pair Triad

**(U, 1/U, 1)**

- Units: U and its reciprocal
- Geometric-mean Unit: `1`, since √(U · 1/U) = 1

Examples:
- (foo, 1/foo, 1)
- (meter, 1/meter, 1)

This pattern connects all Units through `1`.

{: .note }
> Although `1` commonly appears as the geometric-mean Unit here, it may also appear as a reserve in other triads.

---

### Compound-Unit Creation Triads

A compound Unit may appear as the geometric-mean Unit of a triad.

**Pattern:**  
To obtain **A^p · B^q**, the corresponding triad is:

```

(A^(2p), B^(2q), A^p · B^q)

```

Examples:

**(meter², second², meter·second)**  
**(meter², 1/second², meter/second)**  
**(foo², bar², foo·bar)**

In each case, the compound Unit is a **Unit identity** created separately (see [Unit Creation](/concepts/unit-creation)) and participates economically through the triad.

---

### Compound Reciprocal Triad

Compound Units also have reciprocal triads:

**(A·B, 1/(A·B), 1)**

Examples:
- (meter/second, second/meter, 1)
- (foo·bar, 1/(foo·bar), 1)

---

### Power-Structured Triads

By choosing appropriate Units, triads can express **non-linear price exposure**.

Examples:

**(1, meter², meter)**  
- √(1 · meter²) = meter  
- Produces linear exposure to meter²

**(1, foo⁴, foo²)**  
- √(1 · foo⁴) = foo²  
- Produces squared exposure to foo⁴

Fractional exponents follow the same structure, provided the Units exist.

{: .note }
> These behaviors arise from **geometric-mean constraints**, not from a separate “power-perpetual” primitive.

## Multi-Path Trading

Because Units may participate in many triads, there are often multiple forge paths between two Units.

**Example: exposure to meter/second**

**Direct path**
1. Forge (meter², 1/second², meter/second)

**Indirect path**
1. Forge (meter, 1/meter, 1)
2. Forge (second, 1/second, 1)
3. Combine through additional triads

Different paths may have different costs. Arbitrageurs exploit discrepancies, enforcing price consistency across the mesh.

## Mesh Topology

Triads form a **mesh**:

- Every base Unit connects to `1`
- Compound Units connect through their creation triads
- Units may act in multiple roles across triads
- No single triad is privileged

This enables:
- Arbitrage-driven price discovery
- Liquidity sharing across the system
- Custom non-linear exposures
- No reliance on external oracles

## Valid vs Invalid Triads

A triad is valid only if **both** conditions hold:

### 1. Geometric-Mean Relationship

√(U · V) = W

✅ (meter², 1/second², meter/second)  
❌ (meter, 1/second, meter/second)

### 2. Distinct Units

U ≠ V

✅ (1, meter², meter)  
❌ (bar, bar, bar)

The contract enforces both constraints. Invalid triads revert.

## Summary

- Triads are the **only context** in which forge operates
- Each triad enforces one local invariant
- There is **no global invariant**
- Global coherence emerges from overlapping triads and arbitrage
