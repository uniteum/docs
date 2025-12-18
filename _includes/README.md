# Jekyll Includes

This directory contains reusable Liquid templates for the Uniteum documentation.

## Contract Link Helpers

### `contract_link.html`

Creates a markdown link to a contract on Etherscan.

**Usage:**
```liquid
{% include contract_link.html contract=site.data.contracts.uniteum.v0_3 network="mainnet" section="code" %}
```

**Parameters:**
- `contract` (required): Contract object from `_data/contracts.yml`
- `network` (optional): `"mainnet"` or `"sepolia"`, defaults to `"mainnet"`
- `section` (optional): Etherscan section anchor (`"code"`, `"writeContract"`, `"readContract"`, `"events"`), defaults to `"code"`
- `text` (optional): Link text, defaults to contract address

**Examples:**
```liquid
{%- comment -%} Basic usage - mainnet code view {%- endcomment -%}
{% include contract_link.html contract=site.data.contracts.uniteum.v0_3 %}

{%- comment -%} Sepolia testnet {%- endcomment -%}
{% include contract_link.html contract=site.data.contracts.uniteum.v0_3 network="sepolia" %}

{%- comment -%} Write functions {%- endcomment -%}
{% include contract_link.html contract=site.data.contracts.uniteum.v0_3 section="writeContract" %}

{%- comment -%} Custom link text {%- endcomment -%}
{% include contract_link.html contract=site.data.contracts.uniteum.v0_3 text="Uniteum contract" %}

{%- comment -%} Token reference (uses /token/ instead of /address/) {%- endcomment -%}
For unit tokens, just use regular markdown: [foo](https://etherscan.io/token/0x...)
```

### `contract_table.html`

Creates a two-column table showing both Mainnet and Sepolia addresses.

**Usage:**
```liquid
{% include contract_table.html contract=site.data.contracts.uniteum.v0_3 %}
```

**Parameters:**
- `contract` (required): Contract object from `_data/contracts.yml`
- `section` (optional): Etherscan section anchor, defaults to `"code"`

**Example:**
```liquid
### Uniteum 0.3

The current version with full Uniteum functionality.

{% include contract_table.html contract=site.data.contracts.uniteum.v0_3 %}
```

## Contract Data Structure

Contract data is defined in `_data/contracts.yml`:

```yaml
uniteum:
  v0_3:
    name: "Uniteum 0.3 '1'"
    version: "0.3"
    description: "Current version with full Uniteum functionality"
    mainnet: "0x210C655F8a51244bA7607726DeAdEB5866723D87"
    sepolia: "0x210C655F8a51244bA7607726DeAdEB5866723D87"
    ens: "0-3.uniteum.eth"
```

### Accessing Contract Data

```liquid
{%- comment -%} Direct property access {%- endcomment -%}
{{ site.data.contracts.uniteum.v0_3.name }}
{{ site.data.contracts.uniteum.v0_3.mainnet }}

{%- comment -%} Loop through all Uniteum versions {%- endcomment -%}
{% for version in site.data.contracts.uniteum %}
  {{ version[1].name }}: {{ version[1].mainnet }}
{% endfor %}
```

## Benefits

1. **Single source of truth:** Update addresses once in `_data/contracts.yml`
2. **Consistent formatting:** All links follow the same pattern
3. **Easy network switching:** Change `network` parameter
4. **Maintainable:** Add new contracts without touching documentation
5. **Type safety:** YAML structure is validated

## Adding New Contracts

1. Add to `_data/contracts.yml`:
```yaml
uniteum:
  v0_4:
    name: "Uniteum 0.4 '1'"
    version: "0.4"
    description: "Next version description"
    mainnet: "0x..."
    sepolia: "0x..."
    ens: "0-4.uniteum.eth"
```

2. Use in documentation:
```liquid
### {{ site.data.contracts.uniteum.v0_4.name }}

{{ site.data.contracts.uniteum.v0_4.description }}

{% include contract_table.html contract=site.data.contracts.uniteum.v0_4 %}
```

That's it! No need to update multiple files.
