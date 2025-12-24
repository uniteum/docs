---
title: Unit syntax
description: >-
  How Uniteum unit expressions are written, parsed, and rendered canonically.

# Navigation
nav_order: 2
parent: Concepts
has_children: false

# Taxonomy
categories:
  - core
  - units

# Metadata
last_updated: 2024-12-20
version: "0.2"
status: draft
---

# Unit syntax

Uniteum represents Units (ERC-20 tokens) using **symbolic unit expressions**. These expressions are parsed into a structured form and then **canonicalized** so that equivalent expressions map to a single Unit identity.

This page describes the **string syntax** used for unit expressions. For canonicalization rules, see [Canonicalization](/concepts/canonicalization). For how new Units arise from expressions, see [Unit Creation](/concepts/unit-creation).

## What a unit expression names

A unit expression names either:
- a **base Unit** (a single symbol), like `meter` or `USD`
- a **compound Unit** built from other Units, like `meter/second` or `kg*meter/second^2`
- the **identity Unit**, written as `1`
- an **anchored Unit** (prefixed with `$`), like `$0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2` (WETH)

All Units are ERC-20 tokens; the expression describes structure, not magnitude.

## Operators

Unit expressions use three structural operators:

- `*` multiplication (product)
- `/` division (structural reciprocal)
- `^` exponentiation

Examples:
- `meter*second`
- `meter/second`
- `second^2`
- `kg*meter/second^2`

### Precedence

Expressions are interpreted with the following precedence:

1. Exponentiation (`^`)
2. Multiplication and division (`*` and `/`) evaluated left-to-right

Parentheses may be supported by the implementation. Documentation should prefer forms that do not require parentheses.

## Identity

The identity Unit is written as:

```

1

```

Examples:
- `meter*1` canonicalizes to `meter`
- `meter/meter` canonicalizes to `1`

## Multiplication

`*` combines Units into a compound Unit.

Examples:
- `foo*bar`
- `kg*meter`
- `meter*second`

In canonical form, terms are ordered deterministically.

## Division and reciprocals

`/` expresses structural reciprocals.

Examples:
- `1/foo`
- `meter/second`
- `meter/(second^2)` (if parentheses are supported)

Canonical form **never uses negative exponents**. For example, if the parser accepts `foo^-1`, it canonicalizes to `1/foo` (and if the parser does not accept `-`, `foo^-1` is simply invalid input).

## Exponents

A Unit term may be raised to a power with `^`.

Examples:
- `meter^2`
- `second^2`
- `foo^4`

### Rational exponents

Uniteum supports **rational exponents** as part of its symbolic structure. The exact textual encoding of rational exponents is implementation-defined (see `Unit.json`). Documentation should follow the canonical renderer’s output.

Examples of intent (not necessarily exact syntax):
- `meter^(1/2)`
- `foo^(3/2)`

## Canonical form (summary)

Canonical rendering is deterministic. Key rules:

- Identity is written as `1`
- Canonical output never uses negative exponents
- Reciprocals are structural (`1/x`, not `x^-1`)
- Terms are ordered canonically

See [Canonicalization](/concepts/canonicalization) for the normative list.

## Validity vs canonicality

A parser may accept more inputs than the canonical renderer emits.

- **Valid input**: an expression the parser accepts
- **Canonical output**: the unique normalized representation

Documentation and examples should use canonical forms unless explicitly labeled “non-canonical input”.

## Anchored units

**Anchored Units** are backed 1:1 by external ERC-20 tokens. Their syntax uses a `$` prefix followed by the token contract address:

```
$0xTokenAddress
```

### Key properties

- **Format**: `$` + 40-character hexadecimal Ethereum address
- **Backing**: Real ERC-20 tokens held custodially by the Unit contract
- **Value**: Inherits value from the underlying token
- **Creation**: `one().anchored(IERC20(address))`

### Examples

Common anchored units (using shorthand notation for readability):
- `$WETH` → {% include token.html address=site.data.contracts.tokens.weth.mainnet text="<code>$0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2</code>" %}
- `$USDC` → {% include token.html address=site.data.contracts.tokens.usdc.mainnet text="<code>$0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48</code>" %}
- `$USDT` → {% include token.html address=site.data.contracts.tokens.usdt.mainnet text="<code>$0xdAC17F958D2ee523a2206206994597C13D831ec7</code>" %}
- `$WBTC` → {% include token.html address=site.data.contracts.tokens.wbtc.mainnet text="<code>$0x2260FAC5E5542a773Aa44fBCfEDf7C193bc2C599</code>" %}

See [Anchored Units reference](/reference/anchored-units/) for complete list and details.

### Floating vs anchored distinction

**CRITICAL**: An anchored unit like `$WETH` is fundamentally different from a floating unit `WETH`:

- **Anchored** `$0xC02a...56Cc2`: Backed 1:1 by real WETH tokens held by the contract. Custodial, has inherent value.
- **Floating** `WETH`: Just a label with NO connection to the real WETH token. Value emerges only from liquidity/consensus.

This distinction applies to ALL symbols:
- `$USDC` (anchored) has real value from backing tokens
- `USDC` (floating) is just a label with zero inherent value

### Using anchored units in compounds

Anchored units can be combined with other units using the standard operators:

```
$WETH*meter
$USDC/second
$WBTC^2
```

The full address form must be used in canonical expressions.

## Examples

### Base and identity
- `USD` (floating)
- `meter` (floating)
- `1` (identity)

### Anchored units
- {% include token.html address=site.data.contracts.tokens.weth.mainnet text="<code>$0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2</code>" %} (WETH, anchored)
- {% include token.html address=site.data.contracts.tokens.usdc.mainnet text="<code>$0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48</code>" %} (USDC, anchored)

### Compound products
- `foo*bar`
- `kg*meter`

### Ratios
- `meter/second`
- `kg*meter/second^2`

### Reciprocal pair
- `foo*(1/foo)` → canonicalizes to `1`

### Anchored compounds
- {% include token.html address=site.data.contracts.tokens.weth.mainnet text="<code>$0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2</code>" %}`/second` (WETH per second)

## See also

- [Canonicalization](/concepts/canonicalization)
- [Unit Creation](/concepts/unit-creation)
- [Triads](/concepts/triads)
- [Forge](/concepts/forge)
- [Anchored Units Reference](/reference/anchored-units/)
