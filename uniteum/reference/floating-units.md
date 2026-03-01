---
title: Floating Units
description: >-
  Catalog of floating (unbacked) example units used throughout Uniteum documentation,
  with deterministic addresses and deployment instructions.

# Navigation
nav_order: 2
parent: Reference
grand_parent: Uniteum
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

Unlike [anchored units](/uniteum/reference/anchored-units/), floating units have no external backing—their value emerges purely from liquidity and market consensus.

## Key Properties

- **Deterministic Addresses**: All addresses are calculated using CREATE2 and are identical across all networks (mainnet, Sepolia, etc.)
- **Not Yet Deployed**: These addresses are predicted but units may not be deployed yet
- **Anyone Can Deploy**: Call `one().multiply("symbol")` to deploy any unit
- **Educational Purpose**: These are example units for learning and experimentation

## Quick Reference

{% comment %} Categorize units from hash {% endcomment %}
{% assign base_units = "" | split: "" %}
{% assign reciprocal_units = "" | split: "" %}
{% assign compound_units = "" | split: "" %}
{% for pair in site.data.units %}
  {% assign sym = pair[0] %}
  {% if sym contains "1/" %}
    {% assign reciprocal_units = reciprocal_units | push: pair %}
  {% elsif sym contains "*" or sym contains "/" or sym contains "^" %}
    {% assign compound_units = compound_units | push: pair %}
  {% else %}
    {% assign base_units = base_units | push: pair %}
  {% endif %}
{% endfor %}

{% assign base_count = base_units | size %}
{% assign reciprocal_count = reciprocal_units | size %}
{% assign compound_count = compound_units | size %}
{% assign foo = site.data.units["foo"] %}
{% assign one_foo = site.data.units["1/foo"] %}
{% assign velocity = site.data.units["meter/second"] %}

| Unit Type | Count | Example |
|-----------|-------|---------|
| Base Units | {{ base_count }} | [`foo`](https://etherscan.io/token/{{ foo.address }}){:target="_blank"} |
| Reciprocals | {{ reciprocal_count }} | [`1/foo`](https://etherscan.io/token/{{ one_foo.address }}){:target="_blank"} |
| Compounds | {{ compound_count }} | [`meter/second`](https://etherscan.io/token/{{ velocity.address }}){:target="_blank"} |


## Base Units

{% assign generic = "" | split: "" %}
{% assign physics = "" | split: "" %}
{% assign gaming = "" | split: "" %}
{% assign floating_examples = "" | split: "" %}
{% for pair in base_units %}
  {% assign sym = pair[0] %}
  {% if sym == "foo" or sym == "bar" or sym == "baz" or sym == "acme" or sym == "widget" %}
    {% assign generic = generic | push: pair %}
  {% elsif sym == "meter" or sym == "second" or sym == "kilogram" or sym == "kg" %}
    {% assign physics = physics | push: pair %}
  {% elsif sym == "sword" or sym == "shield" %}
    {% assign gaming = gaming | push: pair %}
  {% elsif sym == "USD" or sym == "ETH" or sym == "BTC" or sym == "MSFT" %}
    {% assign floating_examples = floating_examples | push: pair %}
  {% endif %}
{% endfor %}

### Generic/Abstract Examples

| Symbol | Address | Description |
|--------|---------|-------------|
{% for pair in generic -%}
| [`{{ pair[0] }}`](https://etherscan.io/token/{{ pair[1].address }}){:target="_blank"} | `{{ pair[1].address }}` | {{ pair[1].description }} |
{% endfor %}

### Physics/Dimensional Units

| Symbol | Address | Description |
|--------|---------|-------------|
{% for pair in physics -%}
| [`{{ pair[0] }}`](https://etherscan.io/token/{{ pair[1].address }}){:target="_blank"} | `{{ pair[1].address }}` | {{ pair[1].description }} |
{% endfor %}

### Gaming/Community Examples

| Symbol | Address | Description |
|--------|---------|-------------|
{% for pair in gaming -%}
| [`{{ pair[0] }}`](https://etherscan.io/token/{{ pair[1].address }}){:target="_blank"} | `{{ pair[1].address }}` | {{ pair[1].description }} |
{% endfor %}

### Floating Real-World Asset Examples

{: .warning }
> **These are floating units with NO inherent value or backing.**
> They have NO connection to real-world assets despite their names.

| Symbol | Address | Description |
|--------|---------|-------------|
{% for pair in floating_examples -%}
| [`{{ pair[0] }}`](https://etherscan.io/token/{{ pair[1].address }}){:target="_blank"} | `{{ pair[1].address }}` | {{ pair[1].description }} |
{% endfor %}

## Reciprocal Units

| Symbol | Address | Base Unit |
|--------|---------|-----------|
{% for pair in reciprocal_units -%}
{% assign base_symbol = pair[0] | replace: "1/", "" -%}
{% assign base_unit = site.data.units[base_symbol] -%}
| [`{{ pair[0] }}`](https://etherscan.io/token/{{ pair[1].address }}){:target="_blank"} | `{{ pair[1].address }}` | [`{{ base_symbol }}`](https://etherscan.io/token/{{ base_unit.address }}){:target="_blank"} |
{% endfor %}

## Compound Units

{% assign products = "" | split: "" %}
{% assign ratios = "" | split: "" %}
{% assign complex = "" | split: "" %}
{% assign powers = "" | split: "" %}
{% for pair in compound_units %}
  {% assign sym = pair[0] %}
  {% if sym == "kg*m/s^2" %}
    {% assign complex = complex | push: pair %}
  {% elsif sym contains "^" %}
    {% assign powers = powers | push: pair %}
  {% elsif sym contains "/" %}
    {% assign ratios = ratios | push: pair %}
  {% elsif sym contains "*" %}
    {% assign products = products | push: pair %}
  {% endif %}
{% endfor %}

### Simple Products

{: .note }
> **Canonical Form**: Terms in compound units are alphabetically sorted.
> Example: `foo*bar` becomes `bar*foo` in canonical form.

| Symbol | Canonical | Address | Description |
|--------|-----------|---------|-------------|
{% for pair in products -%}
| {% if pair[0] != pair[1].canonical %}`{{ pair[0] }}`{% else %}[`{{ pair[0] }}`](https://etherscan.io/token/{{ pair[1].address }}){:target="_blank"}{% endif %} | {% if pair[0] != pair[1].canonical %}[`{{ pair[1].canonical }}`](https://etherscan.io/token/{{ pair[1].address }}){:target="_blank"}{% else %}`{{ pair[1].canonical }}`{% endif %} | `{{ pair[1].address }}` | {{ pair[1].description }} |
{% endfor %}

### Ratios/Division

| Symbol | Address | Description |
|--------|---------|-------------|
{% for pair in ratios -%}
| [`{{ pair[0] }}`](https://etherscan.io/token/{{ pair[1].address }}){:target="_blank"} | `{{ pair[1].address }}` | {{ pair[1].description }} |
{% endfor %}

### Complex Combinations

| Symbol | Address | Description |
|--------|---------|-------------|
{% for pair in complex -%}
| [`{{ pair[0] }}`](https://etherscan.io/token/{{ pair[1].address }}){:target="_blank"} | `{{ pair[1].address }}` | {{ pair[1].description }} |
{% endfor %}

### Powers/Exponents

{: .note }
> **Exponent Division**: Uses `:` character for division in exponents.
> Example: `foo^2:3` means foo^(2/3)

| Symbol | Address | Description |
|--------|---------|-------------|
{% for pair in powers -%}
| [`{{ pair[0] }}`](https://etherscan.io/token/{{ pair[1].address }}){:target="_blank"} | `{{ pair[1].address }}` | {{ pair[1].description }} |
{% endfor %}

## How to Deploy

These units are not automatically deployed. To deploy any unit:

### Using Etherscan

1. Go to [current Uniteum contract on Etherscan](https://etherscan.io/address/{{ site.data.contracts.uniteum.address }}#writeContract)
2. Connect your wallet
3. Call `multiply(string expression)` with the symbol (e.g., `"foo"`)
4. The unit will be deployed to its deterministic address
5. View the newly deployed unit at the predicted address

### Using cast (command line)

```bash
# Predict address (read-only, no gas cost)
cast call {{ site.data.contracts.uniteum.address }} \
  "product(string)(address,string)" "foo" \
  --rpc-url https://eth.llamarpc.com

# Deploy (requires wallet and gas)
cast send {{ site.data.contracts.uniteum.address }} \
  "multiply(string)(address)" "foo" \
  --rpc-url https://eth.llamarpc.com \
  --private-key $PRIVATE_KEY
```

### Using ethers.js

```javascript
const uniteum = new ethers.Contract(
  "{{ site.data.contracts.uniteum.address }}",
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

- [Anchored Units](/uniteum/reference/anchored-units/) - Real ERC-20 backed units
- [Creating Units Guide](/uniteum/guides/creating-units/) - How to create your own units
- [Contracts Reference](/uniteum/reference/contracts/) - Contract addresses and interfaces
