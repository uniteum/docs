# Version Reference Refactoring Summary

## Overview

Successfully refactored the entire documentation repository to eliminate hardcoded version references (like `v0_3`), making the system fully data-driven through `_data/contracts.yml`.

## Changes Made

### 1. New Helper Includes

Created two new helper includes for accessing current contract objects:

- **[_includes/uniteum_contract.html](_includes/uniteum_contract.html)** - Returns current Uniteum contract object
- **[_includes/kiosk_contract.html](_includes/kiosk_contract.html)** - Returns current Kiosk contract object

These are not actively used yet but available for future use.

### 2. Updated Documentation Files

#### [CLAUDE.md](CLAUDE.md)
- Updated "Deployed Contracts" section to explain the data-driven approach
- Removed hardcoded `v0_3` references
- Added clear instructions to use `site.data.contracts.current.*` pointers
- Updated ENS structure diagram to use `[version]` placeholder instead of `0-3`

#### [_includes/EXAMPLES.md](_includes/EXAMPLES.md)
- Updated all examples to use dynamic version lookup pattern:
  ```liquid
  {%- assign current_version = site.data.contracts.current.uniteum -%}
  {%- assign uniteum = site.data.contracts.uniteum[current_version] -%}
  ```
- Added warning at top: "Never hardcode version keys like `v0_3`"

#### [_includes/README.md](_includes/README.md)
- Updated all usage examples to show data-driven pattern
- Added `current:` section to contract data structure examples
- Updated comments to emphasize "ALWAYS use current pointer - never hardcode version"

#### [_includes/CHEATSHEET.md](_includes/CHEATSHEET.md)
- Updated specific version access pattern to use current pointer with genesis
- Changed from hardcoded `v0_3` to dynamic `current_version` lookup

#### [CONTRACT_REFERENCES.md](CONTRACT_REFERENCES.md)
- Updated migration documentation example
- Updated reference page example
- Both now use `current_version` pattern instead of hardcoded versions

### 3. Updated Scripts

#### [scripts/generate-env.sh](scripts/generate-env.sh)
Complete rewrite to be fully data-driven:

**Before:**
```bash
# Hardcoded version extraction
UNITEUM_0_3=$(grep -A5 "^  v0_3:" ...)
KIOSK_0_3=$(grep -A5 "kiosk:" "$CONTRACTS_FILE" | grep -A5 "v0_3:" ...)
```

**After:**
```bash
# Data-driven version extraction
CURRENT_UNITEUM_VERSION=$(yq eval '.current.uniteum' "$CONTRACTS_FILE")
CURRENT_KIOSK_VERSION=$(yq eval '.current.kiosk' "$CONTRACTS_FILE")
UNITEUM_CURRENT=$(yq eval ".uniteum.${CURRENT_UNITEUM_VERSION}.mainnet" "$CONTRACTS_FILE")
KIOSK_CURRENT=$(yq eval ".kiosk.${CURRENT_KIOSK_VERSION}.mainnet" "$CONTRACTS_FILE")
```

**Generated .env changes:**
- Old: `UNITEUM_0_3=...`, `KIOSK_0_3=...`
- New: `UNITEUM_CURRENT=...`, `KIOSK_CURRENT=...`
- Aliases now point to `$UNITEUM_CURRENT` instead of `$UNITEUM_0_3`

### 4. Documentation Pattern

The standard pattern for all documentation is now:

```liquid
{%- comment -%} Set up at page/section level {%- endcomment -%}
{%- assign current_version = site.data.contracts.current.uniteum -%}
{%- assign uniteum = site.data.contracts.uniteum[current_version] -%}

{%- comment -%} Use throughout the page {%- endcomment -%}
{% include contract_link.html contract=uniteum %}
{{ uniteum.name }}
{{ uniteum.mainnet }}
```

## Impact

### Before (Hardcoded)
- Version numbers (`v0_3`) scattered across ~15 files
- Releasing v0.4 would require find/replace across entire repo
- High risk of missing references
- Large git diffs for version changes

### After (Data-Driven)
- **Single point of change**: Update `current.uniteum` in `_data/contracts.yml`
- All documentation automatically reflects new version
- Zero hardcoded version keys in actual documentation
- Minimal git diff for version changes (1-2 lines)

## Verification

✅ Jekyll site builds successfully with all changes
✅ `generate-env.sh` script works and produces correct output
✅ No hardcoded `v0_3` references in actual documentation pages
✅ All example/documentation files updated to show best practices

## How to Release New Version

When deploying v0.4, the workflow is now:

1. **Add new version data** to `_data/contracts.yml`:
   ```yaml
   uniteum:
     v0_4:
       name: "Uniteum 0.4 '1'"
       version: "0.4"
       mainnet: "0xNEWADDRESS"
       sepolia: "0xNEWADDRESS"
       ens: "0-4.uniteum.eth"
   ```

2. **Update current pointer**:
   ```yaml
   current:
     uniteum: "v0_4"  # Changed from v0_3
     kiosk: "v0_4"
   ```

3. **Regenerate .env** (if needed):
   ```bash
   cd scripts && ./generate-env.sh
   ```

4. **Commit and push** - Done!

All documentation, includes, and scripts automatically use the new version.

## Files Modified

- [CLAUDE.md](CLAUDE.md)
- [CONTRACT_REFERENCES.md](CONTRACT_REFERENCES.md)
- [_includes/CHEATSHEET.md](_includes/CHEATSHEET.md)
- [_includes/EXAMPLES.md](_includes/EXAMPLES.md)
- [_includes/README.md](_includes/README.md)
- [scripts/generate-env.sh](scripts/generate-env.sh)
- [scripts/.env](scripts/.env)

## Files Created

- [_includes/uniteum_contract.html](_includes/uniteum_contract.html)
- [_includes/kiosk_contract.html](_includes/kiosk_contract.html)

## Next Steps

The repository is now fully data-driven. Future work could include:

1. Searching actual documentation pages (in `/guides`, `/reference`, `/concepts`, etc.) for any remaining hardcoded addresses and converting them to use the include system
2. Creating similar helper includes for other contract types (tokens, deployer, etc.)
3. Extending the pattern to handle testnet-specific documentation

---

**Date:** 2024-12-19
**Status:** Complete ✅
