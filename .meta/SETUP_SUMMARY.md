# Data-Driven Contract Reference Setup

## What Was Done

Set up a **truly version-agnostic** data-driven contract reference system for Jekyll that eliminates hardcoded addresses AND version numbers from documentation.

## Key Innovation

**Version pointer system** - Update one line to release a new version:

```yaml
current:
  uniteum: "v0_4"  # Change this → all docs update automatically
  kiosk: "v0_4"
```

No more `v0_3` sprinkled throughout documentation!

## Files Created

### Data Files
- **[_data/contracts.yml](_data/contracts.yml)** - Single source of truth
  - **`current:` section** - Version pointers (update when releasing)
  - Uniteum contracts (v0.3, v0.0)
  - Kiosk contracts (v0.3, v0.0)
  - Deployer addresses
  - Common tokens (WETH, USDC, USDT, WBTC, DAI)

### Version-Agnostic Includes
- **[_includes/uniteum.html](_includes/uniteum.html)** - Current Uniteum contract link
- **[_includes/kiosk.html](_includes/kiosk.html)** - Current Kiosk contract link
- **[_includes/uniteum_address.html](_includes/uniteum_address.html)** - Current Uniteum address (for code blocks)

### General Includes
- **[_includes/contract_link.html](_includes/contract_link.html)** - Single contract link (any contract)
- **[_includes/contract_table.html](_includes/contract_table.html)** - Two-column table
- **[_includes/contract.html](_includes/contract.html)** - Shorthand inline reference

### Documentation
- **[CONTRACT_REFERENCES.md](CONTRACT_REFERENCES.md)** - Overview and guide
- **[_includes/README.md](_includes/README.md)** - Complete API documentation
- **[_includes/EXAMPLES.md](_includes/EXAMPLES.md)** - Comprehensive usage examples
- **[_includes/CHEATSHEET.md](_includes/CHEATSHEET.md)** - Quick copy-paste snippets

### Updated Files
- **[reference/contracts.md](reference/contracts.md)** - Version-agnostic
- **[tokens/weth.md](tokens/weth.md)** - Example token page

## How to Use

### Version-Agnostic (Recommended)

**In prose:**
```liquid
Deploy to {% include uniteum.html %}.
```

**In code blocks:**
```liquid
IUnit one = IUnit({% include uniteum_address.html %});
```

**With options:**
```liquid
{% include uniteum.html section="writeContract" text="the Uniteum contract" %}
```

### Specific Versions (When Needed)

Only for migration docs or historical reference:

```liquid
{%- assign current = site.data.contracts.uniteum[site.data.contracts.current.uniteum] %}
{%- assign genesis = site.data.contracts.uniteum.v0_0 %}

Migrate from {% include contract_link.html contract=genesis %}
to {% include contract_link.html contract=current %}.
```

## Benefits

### Before (Hardcoded Everything)
```liquid
IUnit one = IUnit({{ site.data.contracts.uniteum.v0_3.mainnet }});
```

Problems:
- ❌ Hardcoded `v0_3` everywhere
- ❌ When releasing v0.4, find/replace in all files
- ❌ Easy to miss references
- ❌ Huge git diffs
- ❌ Maintenance nightmare

### After (Version-Agnostic)
```liquid
IUnit one = IUnit({% include uniteum_address.html %});
```

Benefits:
- ✅ Zero version numbers in docs (except `_data/contracts.yml`)
- ✅ Release new version by changing **two lines** in one file
- ✅ All documentation updates automatically
- ✅ Impossible to miss references
- ✅ Minimal git diffs
- ✅ Future-proof

## Releasing a New Version

### Old Way (Without This System)
1. Deploy new contracts
2. Search for `v0_3` in all markdown files
3. Replace with `v0_4` (hope you didn't miss any)
4. Update addresses in 50+ locations
5. Cross your fingers
6. Find the ones you missed
7. Repeat

### New Way (With This System)
1. Deploy new contracts
2. Edit `_data/contracts.yml`:
   ```yaml
   # Add new version
   uniteum:
     v0_4:
       name: "Uniteum 0.4 '1'"
       mainnet: "0xNEWADDRESS"
       # ...

   # Update pointer
   current:
     uniteum: "v0_4"  # Changed from v0_3
   ```
3. Commit and push
4. Done! ✨

All documentation now references v0.4. No manual updates needed.

## Structure

```
docs/
├── _data/
│   └── contracts.yml                  # Version pointers + contract data
├── _includes/
│   ├── uniteum.html                  # {% include uniteum.html %}
│   ├── kiosk.html                    # {% include kiosk.html %}
│   ├── uniteum_address.html          # {% include uniteum_address.html %}
│   ├── contract_link.html            # Generic link
│   ├── contract_table.html           # Generic table
│   ├── contract.html                 # Shorthand reference
│   ├── README.md                     # API docs
│   ├── EXAMPLES.md                   # Usage examples
│   └── CHEATSHEET.md                 # Quick reference
├── reference/
│   └── contracts.md                  # Version-agnostic
├── tokens/
│   └── weth.md                       # Example updated
├── CONTRACT_REFERENCES.md            # Overview
└── SETUP_SUMMARY.md                  # This file
```

## Next Steps

### 1. Migrate Existing Documentation

Search for hardcoded contract references:

```bash
# Find hardcoded addresses
grep -r "0x210C655F8a51244bA7607726DeAdEB5866723D87" --include="*.md"

# Find hardcoded version references
grep -r "v0_3" --include="*.md"
grep -r "site.data.contracts.uniteum.v0_3" --include="*.md"
```

Replace with version-agnostic includes:
```liquid
{% include uniteum.html %}
{% include uniteum_address.html %}
```

### 2. Update Other Token Pages

Apply same pattern to:
- [tokens/usdc.md](tokens/usdc.md)
- [tokens/usdt.md](tokens/usdt.md)
- [tokens/wbtc.md](tokens/wbtc.md)
- [tokens/dai.md](tokens/dai.md)

### 3. Update CLAUDE.md

The [CLAUDE.md](CLAUDE.md) project instructions should document this system so future AI assistants know to use it.

### 4. Test the System

Build Jekyll site:
```bash
bundle exec jekyll serve
```

Verify:
- ✅ Contract links work
- ✅ Addresses render correctly in code blocks
- ✅ Tables display properly
- ✅ Network switching works

## Quick Reference

See [_includes/CHEATSHEET.md](_includes/CHEATSHEET.md) for copy-paste snippets.

### Most Common Patterns

**Link to current Uniteum:**
```liquid
{% include uniteum.html %}
```

**Link to current Kiosk:**
```liquid
{% include kiosk.html %}
```

**Address in code:**
```liquid
IUnit one = IUnit({% include uniteum_address.html %});
```

**Custom text:**
```liquid
{% include uniteum.html text="the Uniteum contract" section="writeContract" %}
```

**Different network:**
```liquid
{% include uniteum.html network="sepolia" %}
```

## Maintenance

### Adding a New Version
1. Add to `_data/contracts.yml`
2. Update `current:` pointer
3. Done - all docs update automatically

### Updating an Address
1. Edit `_data/contracts.yml`
2. Change the address
3. Rebuild site

### Deprecating a Version
1. Update `current:` pointer to new version
2. Old version data stays in YAML for historical reference
3. All "current" references automatically point to new version

## Design Principles

1. **Version-agnostic by default** - Use includes that resolve current version
2. **Single source of truth** - One file (`_data/contracts.yml`) controls everything
3. **Explicit version references only when needed** - Migration docs, history
4. **Minimal churn** - Releasing new version = 2 line change
5. **Future-proof** - System scales to v1.0, v2.0, etc.

---

**Result:** Truly data-driven, version-agnostic contract references! 🎉

No more hardcoded version numbers. Release new versions by updating two lines. All documentation stays current automatically.
