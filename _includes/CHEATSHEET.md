# Contract Reference Cheatsheet

Quick copy-paste snippets for common scenarios.

## Most Common Uses

### Current Uniteum Contract Link
```liquid
{% include uniteum.html %}
```

### Current Uniteum Contract Table
```liquid
{%- assign uniteum = site.data.contracts.uniteum[site.data.contracts.current.uniteum] %}
{% include contract_table.html contract=uniteum %}
```

### Current Uniteum Address (in code blocks)
```liquid
IUnit one = IUnit({% include uniteum_address.html %});
```

### Current Kiosk
```liquid
{% include kiosk.html %}
```

### Custom Link Text
```liquid
{% include uniteum.html text="the Uniteum contract" %}
```

### Write Functions (for tutorials)
```liquid
{% include uniteum.html section="writeContract" text="the forge function" %}
```

## Version-Agnostic Patterns (Recommended)

These automatically use the current version defined in `_data/contracts.yml`:

### Get Current Contracts
```liquid
{%- assign uniteum = site.data.contracts.uniteum[site.data.contracts.current.uniteum] %}
{%- assign kiosk = site.data.contracts.kiosk[site.data.contracts.current.kiosk] %}

{{ uniteum.name }}        # "Uniteum 0.3 '1'"
{{ uniteum.mainnet }}     # "0x210C..."
{{ kiosk.name }}          # "Buy Uniteum 0.3 '1'"
```

### In Code Blocks
```liquid
\`\`\`solidity
IUnit one = IUnit({% include uniteum_address.html %});
\`\`\`
```

### In Documentation
```liquid
Deploy to {% include uniteum.html %}.
Purchase from {% include kiosk.html section="writeContract" %}.
```

## Specific Version Access (When Needed)

Sometimes you need to reference a specific version (e.g., migration docs):

```liquid
{%- assign current_version = site.data.contracts.current.uniteum -%}
{%- assign uniteum = site.data.contracts.uniteum[current_version] -%}
{%- assign genesis = site.data.contracts.uniteum.v0_0 -%}

Migrate from {% include contract_link.html contract=genesis %}
to {% include contract_link.html contract=uniteum %}.
```

## Network Options

```liquid
network="mainnet"    # Default
network="sepolia"    # Testnet
```

Examples:
```liquid
{% include uniteum.html network="sepolia" %}
{% include uniteum_address.html network="sepolia" %}
```

## Section Anchors

```liquid
section="code"           # View source (default)
section="writeContract"  # Write functions (tutorials)
section="readContract"   # Read state
section="events"         # Event logs
```

## Token References

Tokens don't have versions, just direct reference:

```liquid
{{ site.data.contracts.tokens.weth.mainnet }}
{{ site.data.contracts.tokens.usdc.mainnet }}
{{ site.data.contracts.tokens.usdt.mainnet }}
{{ site.data.contracts.tokens.wbtc.mainnet }}
{{ site.data.contracts.tokens.dai.mainnet }}
```

## Updating Current Version

When you release a new version, edit `_data/contracts.yml`:

```yaml
current:
  uniteum: "v0_4"  # Changed from v0_3
  kiosk: "v0_4"    # Changed from v0_3
```

All documentation automatically updates!

## Complete Examples

### Tutorial Pattern
```liquid
## Step 1: Call the Contract

Navigate to {% include uniteum.html section="writeContract" text="the Uniteum write interface" %}.

Connect your wallet and call `multiply("foo")`.

For testing on Sepolia, use {% include uniteum.html network="sepolia" section="writeContract" text="the Sepolia deployment" %}.
```

### Code Example Pattern
```liquid
\`\`\`solidity
// Get current Uniteum contract
IUnit one = IUnit({% include uniteum_address.html %});

// Create anchored USDC unit
IERC20 usdc = IERC20({{ site.data.contracts.tokens.usdc.mainnet }});
IUnit usdcUnit = one.anchored(usdc);
\`\`\`
```

### Migration Documentation
```liquid
{%- assign current = site.data.contracts.uniteum[site.data.contracts.current.uniteum] %}
{%- assign genesis = site.data.contracts.uniteum.v0_0 %}

## Migration

Migrate your tokens from {% include contract_link.html contract=genesis text="Uniteum 0.0" %}
to {% include contract_link.html contract=current %}.

\`\`\`solidity
// Approve genesis tokens
IERC20({{ genesis.mainnet }}).approve({{ current.mainnet }}, amount);

// Call migrate on current version
IUnit({% include uniteum_address.html %}).migrate(amount);
\`\`\`
```

## Pro Tips

1. **Use version-agnostic helpers** (`{% include uniteum.html %}`) not hardcoded versions
2. **Only reference specific versions when documenting migration/history**
3. **Update `current` pointer in `_data/contracts.yml` when releasing**
4. **All docs update automatically - no manual find/replace needed**
5. **Link to writeContract for tutorials**
6. **Link to readContract for state queries**
7. **Use custom text in prose, show addresses in reference tables**
