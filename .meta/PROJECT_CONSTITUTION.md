# Uniteum Units — Project Constitution (Normative)

This project defines a **symbolic unit system** for Ethereum smart contracts.

## Normative sources

The following are authoritative, in this order:

1. **Unit.json** (the compiled source bundle / canonical reference for implementation intent)
2. **This document** (normative rules and scope)
3. Other docs in this project (non-normative unless explicitly stated)

If a feature or rule is **not** represented in Unit.json **and** not stated here, assume it **does not exist**.

## Scope

In scope:
- Naming and composing symbolic units (e.g. `kg*m/s^2`, `MSFT/USD`)
- Canonical ordering of compound units
- Exponents in compound unit expressions (including rational exponents)

Out of scope:
- Quantitative conversion between units
- Dimensional analysis / validation
- Numerical operations on quantities
- Prefixing systems (no `k`, `milli`, etc.)
- Alternative orderings / ordinals beyond the canonical ordering
- “Multiple equivalent renderings” as a first-class feature

## Canonical form rules

These rules define the *canonical string* form:

- The identity unit is named **`unity`**.
- Canonical form **never uses negative exponents**.
- Reciprocals are expressed structurally (e.g. `1/bar`, not `bar^-1`).
- Terms are ordered canonically (lexical ordering of packed terms, per implementation).
- Canonical rendering is deterministic: the same unit produces exactly one canonical string.

## Parser acceptance vs canonical rendering

The parser may accept non-canonical strings, but:
- Any normalization / canonicalization must render to canonical form.
- Docs and examples in this repo should use canonical form unless explicitly labeled “non-canonical input”.

## Implementation constraints (important)

Terms are represented as `uint256` where:
- The **first 31 bytes** encode the base symbol (or an address term marker + address)
- The **lowest byte(s)** encode the exponent (a rational exponent encoding)

This layout supports lexical canonical ordering of terms and efficient merging.
