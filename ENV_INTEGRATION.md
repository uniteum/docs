# .env Integration Summary

## What Changed

Factored out hardcoded contract addresses from scripts to use a generated `.env` file.

## Files Modified

### New Files
- `scripts/generate-env.sh` - Generates `.env` from `_data/contracts.yml`
- `scripts/.env` - Generated environment variables (gitignored)

### Updated Files
- `scripts/validate-unit.sh` - Now sources `.env`
- `scripts/compute-unit-address.sh` - Now sources `.env`
- `scripts/deploy-unit.sh` - Now sources `.env`
- `.gitignore` - Added `scripts/.env`
- `scripts/README.md` - Added setup instructions

## Architecture

```
_data/contracts.yml  (source of truth, manual)
         ↓
  generate-env.sh  (converts YAML to bash variables)
         ↓
  scripts/.env  (generated, gitignored)
         ↓
  [all scripts source this file]
```

## Environment Variables Available

From `scripts/.env`:

```bash
UNITEUM_0_1         # Current version '1' token (0x9df9...)
UNITEUM_0_0         # Genesis '1' token (0xC833...)
DISCOUNT_KIOSK      # v0.0 kiosk (0x5581...)
MIGRATING_KIOSK     # v0.1 kiosk (0xb1e1...)
ONE                 # Alias for UNITEUM_0_1
GENESIS             # Alias for UNITEUM_0_0
```

## Usage

### First Time Setup

```bash
# Generate .env from contracts.yml
./scripts/generate-env.sh

# Now run any script
./scripts/validate-unit.sh "foo"
```

### After Updating Contract Addresses

If `_data/contracts.yml` changes:

```bash
# Regenerate .env
./scripts/generate-env.sh

# Scripts will now use new addresses
```

## Benefits

1. **Single source of truth** - `_data/contracts.yml` defines all contract addresses
2. **No duplication** - Scripts don't hardcode addresses
3. **Easy to update** - Change one file, regenerate `.env`
4. **Fast** - No YAML parsing overhead at runtime (pre-generated)
5. **Clean** - `.env` is gitignored, generated on demand

## Why Generated vs Manual .env?

**Pros of generated:**
- Guaranteed consistency with `contracts.yml`
- Can't get out of sync
- Easy to regenerate if contracts.yml changes

**Cons:**
- Requires running `generate-env.sh` before first use
- One more step in setup

**Decision:** Generated is better because `contracts.yml` is the canonical source for documentation, and we want scripts to stay in sync automatically.

## Testing

✅ All atomic scripts updated and tested
✅ Scripts fail gracefully if `.env` missing
✅ Generated `.env` has correct addresses
✅ Scripts work correctly with sourced variables
