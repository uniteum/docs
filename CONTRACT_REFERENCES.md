# Contract Reference System

This documentation uses a data-driven approach to manage contract addresses, reducing maintenance burden and ensuring consistency.

## Quick Start

### 1. Update Contract Addresses (One Place Only!)

Edit [_data/contracts.yml](_data/contracts.yml):

```yaml
# Update the current version pointer
current:
  uniteum: "v0_4"  # Change this when releasing new version
  kiosk: "v0_4"

# Add new version data
uniteum:
  v0_4:
    name: "Uniteum 0.4 '1'"
    version: "0.4"
    description: "Latest version with new features"
    mainnet: "0xNEWADDRESS"
    sepolia: "0xNEWADDRESS"
    ens: "0-4.uniteum.eth"
```

**That's it!** All documentation updates automatically. No hardcoded version numbers anywhere.

### 2. Reference in Documentation

**Version-agnostic (recommended):**
```liquid
{% include uniteum.html %}
{% include kiosk.html %}
```

**In code blocks:**
```liquid
IUnit one = IUnit({% include uniteum_address.html %});
```

**Specific version (for migration docs only):**
```liquid
{%- assign genesis = site.data.contracts.uniteum.v0_0 %}
{% include contract_link.html contract=genesis %}
```

## Available Includes

### Version-Agnostic (Recommended)

- `uniteum.html` - Current Uniteum contract link
- `kiosk.html` - Current Kiosk contract link
- `uniteum_address.html` - Current Uniteum address (for code blocks)

These automatically use the version defined in `current:` section of `_data/contracts.yml`.

### General Purpose

- `contract_link.html` - Single contract link (requires explicit contract)
- `contract_table.html` - Two-column table (Mainnet + Sepolia)

See [_includes/README.md](_includes/README.md) for full API documentation.

## Contract Data Structure

All contracts defined in [_data/contracts.yml](_data/contracts.yml):

```yaml
# Version pointers (update these when releasing)
current:
  uniteum: "v0_3"
  kiosk: "v0_3"

# Contract data
uniteum:
  v0_3: { ... }
  v0_0: { ... }

kiosk:
  v0_3: { ... }
  v0_0: { ... }

deployer:
  eoa: { ... }

tokens:
  weth: { ... }
  usdc: { ... }
  # etc.
```

## Benefits

### Before (Hardcoded Versions)
```liquid
{% include contract_link.html contract=site.data.contracts.uniteum.v0_3 %}
```

Problems:
- `v0_3` sprinkled throughout all docs
- When releasing v0.4, need to find/replace everywhere
- Easy to miss references
- Large git diffs

### After (Version-Agnostic)
```liquid
{% include uniteum.html %}
```

Benefits:
- ✅ No version numbers in documentation
- ✅ Update one line in `_data/contracts.yml` → all docs update
- ✅ Minimal git churn when releasing
- ✅ Impossible to miss references
- ✅ Current version always correct

## Usage Examples

### Most Common Pattern
```liquid
## Getting Started

Deploy to {% include uniteum.html %}.

Purchase tokens from {% include kiosk.html section="writeContract" %}.

\`\`\`solidity
IUnit one = IUnit({% include uniteum_address.html %});
one.multiply("foo");
\`\`\`
```

### Migration Documentation
```liquid
{%- assign current = site.data.contracts.uniteum[site.data.contracts.current.uniteum] %}
{%- assign genesis = site.data.contracts.uniteum.v0_0 %}

Migrate from {% include contract_link.html contract=genesis text="v0.0" %}
to {% include contract_link.html contract=current %}.
```

### Reference Page
```liquid
{%- assign uniteum = site.data.contracts.uniteum[site.data.contracts.current.uniteum] %}

## {{ uniteum.name }}

{{ uniteum.description }}

{% include contract_table.html contract=uniteum %}
```

See [_includes/CHEATSHEET.md](_includes/CHEATSHEET.md) for comprehensive examples.

## Releasing a New Version

When you deploy v0.4:

1. **Add new contract data** to `_data/contracts.yml`:
   ```yaml
   uniteum:
     v0_4:
       name: "Uniteum 0.4 '1'"
       mainnet: "0xNEWADDRESS"
       sepolia: "0xNEWADDRESS"
       # ... etc
   ```

2. **Update current pointer**:
   ```yaml
   current:
     uniteum: "v0_4"  # Changed from v0_3
     kiosk: "v0_4"
   ```

3. **Commit and push**. Done!

All documentation now references v0.4. No manual find/replace needed.

## File Structure

```
docs/
├── _data/
│   └── contracts.yml              # Single source of truth with version pointers
├── _includes/
│   ├── uniteum.html              # Current Uniteum link (version-agnostic)
│   ├── kiosk.html                # Current Kiosk link (version-agnostic)
│   ├── uniteum_address.html      # Current Uniteum address (for code)
│   ├── contract_link.html        # Generic single link
│   ├── contract_table.html       # Generic table
│   ├── README.md                 # Full API docs
│   ├── EXAMPLES.md               # Usage examples
│   └── CHEATSHEET.md             # Quick reference
├── reference/
│   └── contracts.md              # Uses version-agnostic approach
├── tokens/
│   └── weth.md                   # Example updated page
└── CONTRACT_REFERENCES.md        # This file
```

## Notes

- **Default to version-agnostic** - Use `{% include uniteum.html %}`
- **Only reference specific versions** when documenting migrations or history
- **Tokens don't have versions** - Reference directly via `site.data.contracts.tokens.weth.mainnet`
- **Update `current:` pointers** when releasing new versions
- **Zero hardcoded version numbers** in documentation (except contracts.yml itself)

---

**Result:** Truly data-driven references with minimal maintenance! Release new versions by updating two lines. 🎉
