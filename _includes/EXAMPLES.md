# Contract Include Examples

This file shows various ways to reference contracts in documentation.

## Basic Contract Link

```liquid
Deploy to {% include contract_link.html contract=site.data.contracts.uniteum.v0_3 %}
```
Renders: Deploy to [`0x210C655F8a51244bA7607726DeAdEB5866723D87`](https://etherscan.io/address/0x210C655F8a51244bA7607726DeAdEB5866723D87#code)

## Different Networks

```liquid
{%- comment -%} Mainnet (default) {%- endcomment -%}
{% include contract_link.html contract=site.data.contracts.uniteum.v0_3 %}

{%- comment -%} Sepolia {%- endcomment -%}
{% include contract_link.html contract=site.data.contracts.uniteum.v0_3 network="sepolia" %}
```

## Different Etherscan Sections

```liquid
{%- comment -%} View source code (default) {%- endcomment -%}
{% include contract_link.html contract=site.data.contracts.uniteum.v0_3 section="code" %}

{%- comment -%} Write to contract {%- endcomment -%}
{% include contract_link.html contract=site.data.contracts.uniteum.v0_3 section="writeContract" %}

{%- comment -%} Read from contract {%- endcomment -%}
{% include contract_link.html contract=site.data.contracts.uniteum.v0_3 section="readContract" %}

{%- comment -%} View events {%- endcomment -%}
{% include contract_link.html contract=site.data.contracts.uniteum.v0_3 section="events" %}
```

## Custom Link Text

```liquid
{%- comment -%} Using descriptive text instead of address {%- endcomment -%}
Call the {% include contract_link.html contract=site.data.contracts.uniteum.v0_3 text="Uniteum contract" section="writeContract" %} to forge units.
```
Renders: Call the [`Uniteum contract`](https://etherscan.io/address/0x210C655F8a51244bA7607726DeAdEB5866723D87#writeContract) to forge units.

## Contract Tables

```liquid
### Uniteum 0.3 '1'

The current version with full functionality.

{% include contract_table.html contract=site.data.contracts.uniteum.v0_3 %}
```

Renders:
| Network | Address |
|---------|---------|
| Mainnet | [`0x210C655F8a51244bA7607726DeAdEB5866723D87`](https://etherscan.io/address/0x210C655F8a51244bA7607726DeAdEB5866723D87#code) |
| Sepolia | [`0x210C655F8a51244bA7607726DeAdEB5866723D87`](https://sepolia.etherscan.io/address/0x210C655F8a51244bA7607726DeAdEB5866723D87#code) |

## Shorthand Contract Reference

```liquid
{%- comment -%} Shorthand syntax using contract.html {%- endcomment -%}
Deploy to {% include contract.html name="uniteum.v0_3" %}

{%- comment -%} With custom options {%- endcomment -%}
Call {% include contract.html name="uniteum.v0_3" section="writeContract" text="the Uniteum contract" %}
```

## Using Contract Data Directly

```liquid
{%- comment -%} Access properties {%- endcomment -%}
Contract name: {{ site.data.contracts.uniteum.v0_3.name }}
Version: {{ site.data.contracts.uniteum.v0_3.version }}
ENS: {{ site.data.contracts.uniteum.v0_3.ens }}

{%- comment -%} Conditional logic {%- endcomment -%}
{% if site.data.contracts.uniteum.v0_3.ens %}
  ENS available: {{ site.data.contracts.uniteum.v0_3.ens }}
{% endif %}
```

## Looping Through Versions

```liquid
## All Uniteum Versions

{% for version in site.data.contracts.uniteum %}
### {{ version[1].name }}

{{ version[1].description }}

{% include contract_table.html contract=version[1] %}
{% endfor %}
```

## Complete Example Page

```liquid
---
title: Getting Started
---

# Getting Started with Uniteum

## Prerequisites

You'll need to interact with {{ site.data.contracts.uniteum.v0_3.name }} at:

{% include contract_table.html contract=site.data.contracts.uniteum.v0_3 %}

## Step 1: Buy Genesis Tokens

Purchase tokens from {% include contract.html name="kiosk.v0_0" section="writeContract" text="the v0.0 kiosk" %}.

## Step 2: Migrate to v0.3

Migrate your tokens using the {% include contract_link.html contract=site.data.contracts.uniteum.v0_3 section="writeContract" text="migrate function" %}.

## Step 3: Create Your First Unit

Call `multiply("foo")` on {% include contract.html name="uniteum.v0_3" section="writeContract" %}.

For testing on Sepolia, use {% include contract.html name="uniteum.v0_3" network="sepolia" %}.
```

## Accessing Token Data

```liquid
{%- comment -%} Reference common tokens {%- endcomment -%}
WETH address: {{ site.data.contracts.tokens.weth.mainnet }}

Create anchored unit for {% include contract_link.html contract=site.data.contracts.tokens.usdc text="USDC" %}:
\`\`\`solidity
one().anchored(IERC20({{ site.data.contracts.tokens.usdc.mainnet }}))
\`\`\`
```

## Tips

1. **Always use includes for contract addresses** - Never hardcode addresses in documentation
2. **Use descriptive link text in prose** - `text="the Uniteum contract"` instead of showing addresses
3. **Show full addresses in reference docs** - Don't use custom text in API documentation
4. **Link to appropriate sections** - Use `section="writeContract"` for tutorials
5. **Test on Sepolia** - Always provide Sepolia links for testing instructions
