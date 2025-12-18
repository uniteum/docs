---
title: Floating Units
description: >-
  Catalog of floating (unbacked) example units used throughout Uniteum documentation,
  with deterministic addresses and deployment instructions.

# Navigation
nav_order: 2
parent: Reference
has_children: false

# Taxonomy
categories:
  - development

# Metadata
last_updated: 2024-12-18
status: published
---

# Floating Units Reference

This page catalogs all floating (unbacked) example units used throughout the Uniteum documentation. These units serve as pedagogical examples and can be deployed on any network for experimentation.

Unlike [anchored units](/reference/anchored-units/), floating units have no external backing—their value emerges purely from liquidity and market consensus.

## Key Properties

- **Deterministic Addresses**: All addresses are calculated using CREATE2 and are identical across all networks (mainnet, Sepolia, etc.)
- **Not Yet Deployed**: These addresses are predicted but units may not be deployed yet
- **Anyone Can Deploy**: Call `one().multiply("symbol")` to deploy any unit
- **Educational Purpose**: These are example units for learning and experimentation

## Quick Reference

{% comment %} Categorize units from flat array {% endcomment %}
{% assign all_units = site.data.example-units.units %}
{% assign base_units = "" | split: "" %}
{% assign reciprocal_units = "" | split: "" %}
{% assign compound_units = "" | split: "" %}
{% for unit in all_units %}
  {% if unit.symbol contains "1/" %}
    {% assign reciprocal_units = reciprocal_units | push: unit %}
  {% elsif unit.symbol contains "*" or unit.symbol contains "/" or unit.symbol contains "^" %}
    {% assign compound_units = compound_units | push: unit %}
  {% else %}
    {% assign base_units = base_units | push: unit %}
  {% endif %}
{% endfor %}

{% assign base_count = base_units | size %}
{% assign reciprocal_count = reciprocal_units | size %}
{% assign compound_count = compound_units | size %}
{% assign foo = base_units | where: "symbol", "foo" | first %}
{% assign one_foo = reciprocal_units | where: "symbol", "1/foo" | first %}
{% assign velocity = compound_units | where: "symbol", "meter/second" | first %}

| Unit Type | Count | Example |
|-----------|-------|---------|
| Base Units | {{ base_count }} | [`foo`](https://etherscan.io/token/{{ foo.address }}) |
| Reciprocals | {{ reciprocal_count }} | [`1/foo`](https://etherscan.io/token/{{ one_foo.address }}) |
| Compounds | {{ compound_count }} | [`meter/second`](https://etherscan.io/token/{{ velocity.address }}) |

## Base Units

{% assign generic = "" | split: "" %}
{% assign physics = "" | split: "" %}
{% assign gaming = "" | split: "" %}
{% assign symbolic = "" | split: "" %}
{% for unit in base_units %}
  {% if unit.symbol == "foo" or unit.symbol == "bar" or unit.symbol == "baz" or unit.symbol == "acme" or unit.symbol == "widget" %}
    {% assign generic = generic | push: unit %}
  {% elsif unit.symbol == "meter" or unit.symbol == "second" or unit.symbol == "kilogram" or unit.symbol == "kg" %}
    {% assign physics = physics | push: unit %}
  {% elsif unit.symbol == "sword" or unit.symbol == "shield" %}
    {% assign gaming = gaming | push: unit %}
  {% elsif unit.symbol == "USD" or unit.symbol == "ETH" or unit.symbol == "BTC" or unit.symbol == "MSFT" %}
    {% assign symbolic = symbolic | push: unit %}
  {% endif %}
{% endfor %}

### Generic/Abstract Examples

| Symbol | Address | Description |
|--------|---------|-------------|
{% for unit in generic -%}
| [`{{ unit.symbol }}`](https://etherscan.io/token/{{ unit.address }}) | `{{ unit.address }}` | {{ unit.description }} |
{% endfor %}

### Physics/Dimensional Units

| Symbol | Address | Description |
|--------|---------|-------------|
{% for unit in physics -%}
| [`{{ unit.symbol }}`](https://etherscan.io/token/{{ unit.address }}) | `{{ unit.address }}` | {{ unit.description }} |
{% endfor %}

### Gaming/Community Examples

| Symbol | Address | Description |
|--------|---------|-------------|
{% for unit in gaming -%}
| [`{{ unit.symbol }}`](https://etherscan.io/token/{{ unit.address }}) | `{{ unit.address }}` | {{ unit.description }} |
{% endfor %}

### Symbolic Real-World Assets

{: .warning }
> **These are symbolic units with NO inherent value or backing.**
> They have NO connection to real-world assets despite their names.

| Symbol | Address | Description |
|--------|---------|-------------|
{% for unit in symbolic -%}
| [`{{ unit.symbol }}`](https://etherscan.io/token/{{ unit.address }}) | `{{ unit.address }}` | {{ unit.description }} |
{% endfor %}

## Reciprocal Units

| Symbol | Address | Base Unit |
|--------|---------|-----------|
{% for unit in reciprocal_units -%}
{% assign base_symbol = unit.symbol | replace: "1/", "" -%}
{% assign base_unit = base_units | where: "symbol", base_symbol | first -%}
| [`{{ unit.symbol }}`](https://etherscan.io/token/{{ unit.address }}) | `{{ unit.address }}` | [`{{ base_symbol }}`](https://etherscan.io/token/{{ base_unit.address }}) |
{% endfor %}

## Compound Units

{% assign products = "" | split: "" %}
{% assign ratios = "" | split: "" %}
{% assign complex = "" | split: "" %}
{% assign powers = "" | split: "" %}
{% for unit in compound_units %}
  {% if unit.symbol == "kg*m/s^2" %}
    {% assign complex = complex | push: unit %}
  {% elsif unit.symbol contains "^" %}
    {% assign powers = powers | push: unit %}
  {% elsif unit.symbol contains "/" %}
    {% assign ratios = ratios | push: unit %}
  {% elsif unit.symbol contains "*" %}
    {% assign products = products | push: unit %}
  {% endif %}
{% endfor %}

### Simple Products

{: .note }
> **Canonical Form**: Terms in compound units are alphabetically sorted.
> Example: `foo*bar` becomes `bar*foo` in canonical form.

| Symbol | Canonical | Address | Description |
|--------|-----------|---------|-------------|
{% for unit in products -%}
| {% if unit.symbol != unit.canonical %}`{{ unit.symbol }}`{% else %}[`{{ unit.symbol }}`](https://etherscan.io/token/{{ unit.address }}){% endif %} | {% if unit.symbol != unit.canonical %}[`{{ unit.canonical }}`](https://etherscan.io/token/{{ unit.address }}){% else %}`{{ unit.canonical }}`{% endif %} | `{{ unit.address }}` | {{ unit.description }} |
{% endfor %}

### Ratios/Division

| Symbol | Address | Description |
|--------|---------|-------------|
{% for unit in ratios -%}
| [`{{ unit.symbol }}`](https://etherscan.io/token/{{ unit.address }}) | `{{ unit.address }}` | {{ unit.description }} |
{% endfor %}

### Complex Combinations

| Symbol | Address | Description |
|--------|---------|-------------|
{% for unit in complex -%}
| [`{{ unit.symbol }}`](https://etherscan.io/token/{{ unit.address }}) | `{{ unit.address }}` | {{ unit.description }} |
{% endfor %}

### Powers/Exponents

{: .note }
> **Exponent Division**: Uses `\` character for division in exponents.
> Example: `foo^2\3` means foo^(2/3)

| Symbol | Address | Description |
|--------|---------|-------------|
{% for unit in powers -%}
| [`{{ unit.symbol }}`](https://etherscan.io/token/{{ unit.address }}) | `{{ unit.address }}` | {{ unit.description }} |
{% endfor %}

## How to Deploy

These units are not automatically deployed. To deploy any unit:

### Using Etherscan (mainnet or Sepolia)

1. Go to [Uniteum 0.1 on Etherscan](https://etherscan.io/address/0x9df9b0501e8f6c05623b5b519f9f18b598d9b253#writeContract)
2. Connect your wallet
3. Call `multiply(string expression)` with the symbol (e.g., `"foo"`)
4. The unit will be deployed to its deterministic address
5. View the newly deployed unit at the predicted address

### Using cast (command line)

```bash
# Predict address (read-only, no gas cost)
cast call 0x9df9b0501e8f6c05623b5b519f9f18b598d9b253 \
  "product(string)(address,string)" "foo" \
  --rpc-url https://eth.llamarpc.com

# Deploy (requires wallet and gas)
cast send 0x9df9b0501e8f6c05623b5b519f9f18b598d9b253 \
  "multiply(string)(address)" "foo" \
  --rpc-url https://eth.llamarpc.com \
  --private-key $PRIVATE_KEY
```

### Using ethers.js

```javascript
const uniteum = new ethers.Contract(
  "0x9df9b0501e8f6c05623b5b519f9f18b598d9b253",
  uniteumABI,
  signer
);

// Deploy foo
const tx = await uniteum.multiply("foo");
await tx.wait();

// Get address
const [address, canonical] = await uniteum.product("foo");
console.log(`foo deployed to: ${address}`);
```

## Batch Deployment Script

To deploy all example units at once, use the provided script:

```bash
cd /path/to/uniteum/docs
./scripts/deploy-examples.sh
```

Or deploy to Sepolia testnet for experimentation:

```bash
./scripts/deploy-examples.sh --network sepolia
```

## See Also

- [Anchored Units](/reference/anchored-units/) - Real ERC-20 backed units
- [Creating Units Guide](/guides/creating-units/) - How to create your own units
- [Contracts Reference](/reference/contracts/) - Contract addresses and interfaces
