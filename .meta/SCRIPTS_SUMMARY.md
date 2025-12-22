# Scripts Implementation Summary

## What Was Created

A clean separation of concerns for managing example units in the documentation.

## File Structure

```
_data/
├── contracts.yml              (NEW - contract addresses config)
├── example-units-input.yml    (NEW - input: symbols + descriptions)
└── example-units.yml          (GENERATED - output: addresses computed)

scripts/
├── README.md                  (NEW - complete documentation)
├── validate-unit.sh           (NEW - atomic: validate one symbol)
├── compute-unit-address.sh    (NEW - atomic: compute one address)
├── deploy-unit.sh             (NEW - atomic: deploy one unit)
├── validate-all-units.sh      (NEW - wrapper: validate all)
├── compute-all-addresses.sh   (NEW - wrapper: compute all)
└── deploy-all-units.sh        (NEW - wrapper: deploy all)
```

## Design Principles Applied

1. **Input vs Computed Data Separation**
   - Input: `example-units-input.yml` (symbol + description only)
   - Output: `example-units.yml` (includes addresses, generated)

2. **Canonical Form Enforcement**
   - All symbols must be canonical
   - Validation happens before computation
   - Contract is source of truth

3. **Atomic + Wrapper Pattern**
   - Small scripts do one thing (one unit)
   - Wrapper scripts call atomic scripts for each unit
   - Easy to test, debug, and reuse

4. **Independent from Protocol Repo**
   - Uses `cast` (no forge scripts needed)
   - No dependency on uniteum submodule
   - Only needs contract address + RPC

5. **Minimal Config Files**
   - Only non-derivable data stored
   - YAML format for all configs
   - Human-readable and machine-parseable

## Config Files

### `_data/contracts.yml`
```yaml
contracts:
  - name: "Uniteum 0.1 '1'"
    address: "0x9df9b0501e8f6c05623b5b519f9f18b598d9b253"
    version: "0.1"
    ens: "0-1.uniteum.eth"
```

### `_data/example-units-input.yml`
```yaml
units:
  - symbol: "foo"
    description: "Generic placeholder unit"
```

## Script Architecture

```
Atomic Scripts (single unit):
├── validate-unit.sh <symbol>           → exit 0/1
├── compute-unit-address.sh <symbol>    → JSON output
└── deploy-unit.sh <symbol> [network]   → deploy if needed

Wrapper Scripts (all units):
├── validate-all-units.sh               → validate input file
├── compute-all-addresses.sh            → generate output file
└── deploy-all-units.sh [network]       → deploy all units
```

## Workflows

### Adding a New Unit
1. Add to `_data/example-units-input.yml`
2. Validate: `./scripts/validate-unit.sh "symbol"`
3. Compute: `./scripts/compute-all-addresses.sh`
4. Deploy (optional): `./scripts/deploy-unit.sh "symbol" sepolia`

### Regenerating All Data
```bash
./scripts/compute-all-addresses.sh
```

### Deploying All Units
```bash
# Dry run first
./scripts/deploy-all-units.sh sepolia --dry-run

# Then deploy
export PRIVATE_KEY=0x...
./scripts/deploy-all-units.sh sepolia
```

## Testing Results

✅ `validate-unit.sh "foo"` - Passes (canonical)
✅ `validate-unit.sh "foo*bar"` - Fails correctly (non-canonical, should be "bar*foo")
✅ `compute-unit-address.sh "foo"` - Returns correct JSON with address

## Next Steps

1. **Update existing scripts** - Old scripts can be deprecated:
   - `fetch-example-addresses.sh` → replaced by `compute-all-addresses.sh`
   - `deploy-examples.sh` → replaced by `deploy-all-units.sh`
   - `predict-unit-addresses.sh` → can be removed (incomplete)

2. **Run compute script** - Generate the new `example-units.yml`:
   ```bash
   ./scripts/compute-all-addresses.sh
   ```

3. **Update documentation pages** - Modify markdown to use new YAML structure

4. **Add CI validation** - GitHub Actions to validate units on PR

5. **Protocol repo** - Create similar structure there with shared format

## Dependencies

- `cast` (Foundry)
- `yq` (YAML processor)
- `jq` (JSON processor)

All standard tools, easy to install.

## Documentation

Complete usage guide in [scripts/README.md](scripts/README.md)
