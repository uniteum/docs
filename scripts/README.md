# Uniteum Documentation Scripts

This directory contains scripts for managing example units used throughout the Uniteum documentation.

## Overview

The scripts follow a clean separation of concerns:

- **Config files** (`_data/*.yml`) define what units exist
- **Wrapper scripts** process all units from YAML config
- **Computed data** is generated and stored separately from input data

## Architecture

```
_data/unit-inputs.yml  (manual, input only)
           ↓
    compute-all-addresses.sh  (generates addresses)
           ↓
_data/units.yml  (generated, for Jekyll)
           ↓
    deploy-all-units.sh  (optional deployment)
```

## Prerequisites

Install required tools:

```bash
# Foundry (for cast)
curl -L https://foundry.paradigm.xyz | bash
foundryup

# yq (YAML processor)
brew install yq          # macOS
# or
snap install yq          # Linux

# jq (JSON processor)
brew install jq          # macOS
# or
apt install jq           # Linux
```

## Setup

Before running any scripts, generate the `.env` file from contract configuration:

```bash
./scripts/generate-env.sh
```

This creates `scripts/.env` with contract addresses sourced from `_data/contracts.yml`. The `.env` file is gitignored and should be regenerated when contract addresses change (though they're deterministic and unlikely to change).

**Important:** Run this once after cloning the repository, or after updating `_data/contracts.yml`.

## Config Files

### `_data/contracts.yml`

Contract addresses for Uniteum protocol contracts. Manually maintained.

```yaml
uniteum:
  name: "Uniteum 0.5 '1'"
  version: "0.5"
  address: "0x419d44A1d28e5B8e320Ee31Cc04dC1C75B8b89da"
  ens: "uniteum.eth"
```

### `_data/unit-inputs.yml`

Input file listing example units. Manually maintained.

```yaml
foo:
  description: "Generic placeholder unit"

meter/second:
  description: "Velocity unit"
```

### `_data/units.yml`

Generated output with computed addresses. **DO NOT EDIT MANUALLY.**

```yaml
foo:
  canonical: "foo"
  address: "0x966108210F3B2eC0f01B646a61Ce7D8F1aDE7430"
  description: "Generic placeholder unit"
```

## Scripts

### `generate-env.sh`

Generates `scripts/.env` from `_data/contracts.yml`. Run once after cloning or when contracts change.

```bash
./scripts/generate-env.sh
```

**Output:** `scripts/.env` with `ONE`, `GENESIS`, `KIOSK`, `HELPER` variables.

### `compute-all-addresses.sh`

Generates `_data/units.yml` with computed addresses for all units in `_data/unit-inputs.yml`.

```bash
./scripts/compute-all-addresses.sh

# Output:
# Computing addresses for units from: _data/unit-inputs.yml
# Uniteum: 0x419d...
# UnitHelper: 0x456d...
# Found 42 units to process
# ✓ foo → foo (0x966108...)
# ✓ meter/second → meter/second (0x...)
# ✅ Address computation complete!
```

**Usage:**
```bash
./scripts/compute-all-addresses.sh [rpc-url]
```

**Output file:** `_data/units.yml`

### `deploy-all-units.sh`

Deploys all units from the input file to mainnet or Sepolia using `UnitHelper.multiply()` (idempotent).

```bash
# Dry run (no actual deployment)
./scripts/deploy-all-units.sh mainnet

# Deploy to Sepolia testnet
export PRIVATE_KEY=0x...
./scripts/deploy-all-units.sh sepolia --broadcast

# Deploy to mainnet
./scripts/deploy-all-units.sh mainnet --broadcast
```

**Usage:**
```bash
./scripts/deploy-all-units.sh [network] [--broadcast]
```

**Networks:** `mainnet`, `sepolia` (default: mainnet)

**Flags:**
- `--broadcast` - Actually send transactions (default is dry-run)

**Environment variables:**
- `PRIVATE_KEY` - Required when using `--broadcast`

## Typical Workflows

### Adding a New Example Unit

1. **Add to input file:**
   ```bash
   # Edit _data/unit-inputs.yml
   # Add new entry with symbol as key and description as value
   ```

2. **Regenerate addresses:**
   ```bash
   ./scripts/compute-all-addresses.sh
   ```

3. **Commit changes:**
   ```bash
   git add _data/unit-inputs.yml _data/units.yml
   git commit -m "Add new example unit: your-symbol"
   ```

4. **Deploy (optional):**
   ```bash
   export PRIVATE_KEY=0x...
   ./scripts/deploy-all-units.sh mainnet --broadcast
   ```

### Regenerating All Addresses

If the contract changes or you want to refresh all computed data:

```bash
./scripts/compute-all-addresses.sh
git diff _data/units.yml  # Review changes
git add _data/units.yml
git commit -m "Regenerate example unit addresses"
```

### Deploying All Units to Testnet

```bash
# First, dry run to verify
./scripts/deploy-all-units.sh sepolia

# If looks good, deploy
export PRIVATE_KEY=0x...
./scripts/deploy-all-units.sh sepolia --broadcast
```

## RPC Configuration

All scripts accept an optional RPC URL parameter. Default is `https://ethereum.publicnode.com` for mainnet queries.

```bash
# Use custom RPC
./scripts/compute-all-addresses.sh https://your-rpc-url.com

# Use environment variable
export RPC_URL=https://your-rpc-url.com
```

## Rate Limiting

Scripts include rate limiting (0.1s - 2s delays) to avoid overwhelming RPC endpoints. Adjust `sleep` values in scripts if needed.

## Error Handling

All scripts:
- Exit with non-zero status on errors
- Print errors to stderr
- Provide clear error messages
- Validate inputs before processing

## Integration with Jekyll

Jekyll automatically reads `_data/units.yml` and makes it available as `site.data.units` in Liquid templates.

Example usage in markdown:
```liquid
{% for pair in site.data.units %}
- [{{ pair[0] }}](https://etherscan.io/token/{{ pair[1].address }})
{% endfor %}
```

## CI/CD Integration

Example GitHub Actions workflow:

```yaml
name: Validate Units
on: [pull_request]
jobs:
  validate:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Install dependencies
        run: |
          curl -L https://foundry.paradigm.xyz | bash
          source ~/.bashrc
          foundryup
          sudo snap install yq
      - name: Compute addresses
        run: ./scripts/compute-all-addresses.sh
```

## Troubleshooting

### "yq is required but not installed"

Install yq:
```bash
# macOS
brew install yq

# Linux
snap install yq
```

### "cast: command not found"

Install Foundry:
```bash
curl -L https://foundry.paradigm.xyz | bash
foundryup
```

### "Failed to query contract"

Check:
- RPC endpoint is working
- Network connectivity
- Contract address is correct (`0x419d44A1d28e5B8e320Ee31Cc04dC1C75B8b89da`)

### Addresses look wrong after contracts.yml update

Regenerate the `.env` file and recompute addresses:

```bash
./scripts/generate-env.sh
./scripts/compute-all-addresses.sh
```

## See Also

- [Example Units Reference](/reference/example-units/) - Documentation page
- [Creating Units Guide](/guides/creating-units/) - How to create custom units
- [Contracts Reference](/reference/contracts/) - Contract addresses
