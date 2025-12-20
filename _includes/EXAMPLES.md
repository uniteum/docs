# Contract Include Examples

This file shows various ways to reference contracts in documentation.

**IMPORTANT**: Never hardcode version keys like `v0_3`. Use helper includes or the `current` pointer.

## Basic Contract Link

```liquid
{%- comment -%} Get current version dynamically {%- endcomment -%}
{%- assign current_version = site.data.contracts.current.uniteum -%}
{%- assign uniteum = site.data.contracts.uniteum[current_version] -%}
Deploy to {% include contract_link.html contract=uniteum %}
```
Renders: Deploy to [`0x210C655F8a51244bA7607726DeAdEB5866723D87`](https://etherscan.io/address/0x210C655F8a51244bA7607726DeAdEB5866723D87#code)

## Different Networks

```liquid
{%- assign current_version = site.data.contracts.current.uniteum -%}
{%- assign uniteum = site.data.contracts.uniteum[current_version] -%}

{%- comment -%} Mainnet (default) {%- endcomment -%}
{% include contract_link.html contract=uniteum %}

{%- comment -%} Sepolia {%- endcomment -%}
{% include contract_link.html contract=uniteum network="sepolia" %}
```

## Different Etherscan Sections

```liquid
{%- assign current_version = site.data.contracts.current.uniteum -%}
{%- assign uniteum = site.data.contracts.uniteum[current_version] -%}

{%- comment -%} View source code (default) {%- endcomment -%}
{% include contract_link.html contract=uniteum section="code" %}

{%- comment -%} Write to contract {%- endcomment -%}
{% include contract_link.html contract=uniteum section="writeContract" %}

{%- comment -%} Read from contract {%- endcomment -%}
{% include contract_link.html contract=uniteum section="readContract" %}

{%- comment -%} View events {%- endcomment -%}
{% include contract_link.html contract=uniteum section="events" %}
```

## Custom Link Text

```liquid
{%- assign current_version = site.data.contracts.current.uniteum -%}
{%- assign uniteum = site.data.contracts.uniteum[current_version] -%}

{%- comment -%} Using descriptive text instead of address {%- endcomment -%}
Call the {% include contract_link.html contract=uniteum text="Uniteum contract" section="writeContract" %} to forge units.
```
Renders: Call the [`Uniteum contract`](https://etherscan.io/address/0x210C655F8a51244bA7607726DeAdEB5866723D87#writeContract) to forge units.

## Contract Tables

```liquid
{%- assign current_version = site.data.contracts.current.uniteum -%}
{%- assign uniteum = site.data.contracts.uniteum[current_version] -%}

### {{ uniteum.name }}

The current version with full functionality.

{% include contract_table.html contract=uniteum %}
```

Renders:
| Network | Address |
|---------|---------|
| Mainnet | [`0x210C655F8a51244bA7607726DeAdEB5866723D87`](https://etherscan.io/address/0x210C655F8a51244bA7607726DeAdEB5866723D87#code) |
| Sepolia | [`0x210C655F8a51244bA7607726DeAdEB5866723D87`](https://sepolia.etherscan.io/address/0x210C655F8a51244bA7607726DeAdEB5866723D87#code) |

## Shorthand Contract Reference

```liquid
{%- comment -%} Shorthand syntax using contract.html with current pointer {%- endcomment -%}
{%- assign current_version = site.data.contracts.current.uniteum -%}
Deploy to {% include contract.html name=current_version %}

{%- comment -%} ALTERNATIVE: For specific versions (only when needed, e.g., migration docs) {%- endcomment -%}
Migrate from {% include contract.html name="uniteum.v0_0" %}
```

## Using Contract Data Directly

```liquid
{%- assign current_version = site.data.contracts.current.uniteum -%}
{%- assign uniteum = site.data.contracts.uniteum[current_version] -%}

{%- comment -%} Access properties {%- endcomment -%}
Contract name: {{ uniteum.name }}
Version: {{ uniteum.version }}
ENS: {{ uniteum.ens }}

{%- comment -%} Conditional logic {%- endcomment -%}
{% if uniteum.ens %}
  ENS available: {{ uniteum.ens }}
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

{%- comment -%} Set up contract references at page level {%- endcomment -%}
{%- assign current_uniteum_version = site.data.contracts.current.uniteum -%}
{%- assign uniteum = site.data.contracts.uniteum[current_uniteum_version] -%}
{%- assign genesis = site.data.contracts.uniteum.v0_0 -%}
{%- assign genesis_kiosk = site.data.contracts.kiosk.v0_0 -%}

# Getting Started with Uniteum

## Prerequisites

You'll need to interact with {{ uniteum.name }} at:

{% include contract_table.html contract=uniteum %}

## Step 1: Buy Genesis Tokens

Purchase tokens from {% include contract_link.html contract=genesis_kiosk section="writeContract" text="the v0.0 kiosk" %}.

## Step 2: Migrate to Current Version

Migrate your tokens using the {% include contract_link.html contract=uniteum section="writeContract" text="migrate function" %}.

## Step 3: Create Your First Unit

Call `multiply("foo")` on {% include contract_link.html contract=uniteum section="writeContract" text="the Uniteum contract" %}.

For testing on Sepolia, use {% include contract_link.html contract=uniteum network="sepolia" text="Sepolia Uniteum" %}.
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
