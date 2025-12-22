# Scripts Implementation Summary

## Overview

Streamlined script architecture using UnitHelper contract for efficient batch operations.

## File Structure

```
_data/
├── contracts.yml              (contract addresses config)
├── example-units-input.yml    (input: symbols + descriptions)
└── example-units.yml          (GENERATED - output: addresses computed)

scripts/
├── generate-env.sh            (generate .env from contracts.yml)
├── compute-all-addresses.sh   (batch predict addresses using UnitHelper)
└── deploy-all-units.sh        (batch deploy using UnitHelper)
```

## Key Architecture Changes

### Batch Operations via UnitHelper

All scripts now use the UnitHelper contract for efficient batch operations:

- **UnitHelper.product(IUnit, string[])** - Predict addresses for multiple units in one call
- **UnitHelper.multiply(IUnit, string[])** - Deploy multiple units in one transaction

### Benefits

1. **Single RPC Call** - All addresses computed at once (vs. N calls)
2. **Single Transaction** - All units deployed together (vs. N transactions)
3. **Atomic Operations** - All-or-nothing deployments
4. **Gas Efficiency** - Batch operations save gas
5. **Simplicity** - Removed 8 helper scripts, down to 3 core scripts

## Removed Scripts (Obsolete)

The following scripts have been removed as they're no longer needed:

- ❌ `deploy-unit.sh` - Single unit deployment (use batch instead)
- ❌ `compute-unit-address.sh` - Single unit prediction (use batch instead)
- ❌ `validate-unit.sh` - Single unit validation (no longer needed)
- ❌ `validate-all-units.sh` - Batch validation (contract validates)
- ❌ `fetch-example-addresses.sh` - Duplicate of compute-all
- ❌ `predict-unit-addresses.sh` - Duplicate with CREATE2 math
- ❌ `deploy-examples.sh` - Replaced by deploy-all-units.sh
- ❌ `test-backslash.sh` - Testing old `\` operator (now `:`)

## Core Scripts

### 1. `generate-env.sh`

Generates `.env` file from `contracts.yml` with current contract addresses.

**Output:**
```bash
UNITEUM_CURRENT=0x419d44A1d28e5B8e320Ee31Cc04dC1C75B8b89da
KIOSK_CURRENT=0xBFdf4Cf25EC0DB0Be49a04213D230495291C6fFA
HELPER_CURRENT=0x456dcb7a3f7d9A6DB77DDf6a4eA8B10453acF7F9
ONE=$UNITEUM_CURRENT
HELPER=$HELPER_CURRENT
```

**Usage:**
```bash
./scripts/generate-env.sh
```

### 2. `compute-all-addresses.sh`

Computes addresses for all units in `example-units-input.yml` using UnitHelper batch prediction.

**Features:**
- Single RPC call via `UnitHelper.product()`
- Reads from `_data/example-units-input.yml`
- Generates `_data/example-units.yml` with addresses
- Includes canonical forms from contract

**Usage:**
```bash
./scripts/compute-all-addresses.sh [rpc-url]
```

**Example:**
```bash
# Use default RPC
./scripts/compute-all-addresses.sh

# Use custom RPC
./scripts/compute-all-addresses.sh https://eth.llamarpc.com
```

### 3. `deploy-all-units.sh`

Deploys all units in a single batch transaction using UnitHelper.

**Features:**
- Single transaction via `UnitHelper.multiply()`
- Checks deployment status first
- **Dry-run by default** for safety
- Requires `--broadcast` flag to actually deploy
- Works on mainnet and sepolia

**Usage:**
```bash
./scripts/deploy-all-units.sh [network] [--broadcast]
```

**Examples:**
```bash
# Dry run on sepolia (default behavior)
./scripts/deploy-all-units.sh sepolia

# Deploy to sepolia (requires --broadcast)
export PRIVATE_KEY=0x...
./scripts/deploy-all-units.sh sepolia --broadcast

# Deploy to mainnet (requires --broadcast)
./scripts/deploy-all-units.sh mainnet --broadcast
```

## Workflows

### Adding a New Unit

1. Add to `_data/example-units-input.yml`:
   ```yaml
   - symbol: "newunit"
     description: "Description of new unit"
   ```

2. Regenerate addresses:
   ```bash
   ./scripts/compute-all-addresses.sh
   ```

3. (Optional) Deploy:
   ```bash
   ./scripts/deploy-all-units.sh sepolia
   ```

### Regenerating All Data

After editing `example-units-input.yml`:

```bash
./scripts/compute-all-addresses.sh
```

This updates `example-units.yml` with correct addresses and canonical forms.

### Deploying All Units

```bash
# Dry run first (default behavior)
./scripts/deploy-all-units.sh sepolia

# Deploy (requires --broadcast flag)
export PRIVATE_KEY=0x...
./scripts/deploy-all-units.sh sepolia --broadcast
```

## Config Files

### `_data/contracts.yml`

Contract addresses for all versions and networks.

```yaml
current:
  uniteum: "v0_5"
  kiosk: "v0_5"
  helper: "v0_5"

uniteum:
  v0_5:
    mainnet: "0x419d44A1d28e5B8e320Ee31Cc04dC1C75B8b89da"
    sepolia: "0x419d44A1d28e5B8e320Ee31Cc04dC1C75B8b89da"

helper:
  v0_5:
    mainnet: "0x456dcb7a3f7d9A6DB77DDf6a4eA8B10453acF7F9"
    sepolia: "0x456dcb7a3f7d9A6DB77DDf6a4eA8B10453acF7F9"
```

### `_data/example-units-input.yml`

Input file with symbols and descriptions only:

```yaml
units:
  - symbol: "foo"
    description: "Generic placeholder unit"
  - symbol: "foo^2:3"
    description: "Foo to the power 2/3"
```

**Note:** Uses `:` for exponent division (not `\`)

### `_data/example-units.yml` (Generated)

Output file with computed addresses:

```yaml
units:
  - symbol: "foo"
    canonical: "foo"
    address: "0xa2Eb33714a4a9551c6aF5492c85128376c882Ad0"
    one: "0x419d44A1d28e5B8e320Ee31Cc04dC1C75B8b89da"
    description: "Generic placeholder unit"
```

**DO NOT EDIT MANUALLY** - Generated by `compute-all-addresses.sh`

## UnitHelper Contract

Deployed at same address on all networks (deterministic).

```solidity
contract UnitHelper {
    // Batch deployment
    function multiply(IUnit unit, string[] memory expressions)
        external returns (IUnit[] memory);

    // Batch prediction (view-only)
    function product(IUnit unit, string[] memory expressions)
        external view returns (IUnit[] memory, string[] memory);
}
```

See `_data/contracts.yml` for addresses.

## Dependencies

- `cast` (Foundry) - For contract calls
- `yq` (YAML processor) - For reading YAML files
- `jq` (JSON processor) - For parsing JSON

Install:
```bash
# macOS
brew install foundry yq jq

# Linux
curl -L https://foundry.paradigm.xyz | bash
snap install yq
apt install jq
```

## Migration Notes

If you have old scripts or workflows using the removed scripts:

**Old:**
```bash
./scripts/deploy-unit.sh "foo" sepolia
./scripts/compute-unit-address.sh "foo"
./scripts/validate-unit.sh "foo"
```

**New:**
```bash
# Add to example-units-input.yml, then:
./scripts/compute-all-addresses.sh
./scripts/deploy-all-units.sh sepolia --broadcast  # Note: --broadcast required
```

The contract validates symbols automatically during batch operations.
