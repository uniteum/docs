# Uniteum Documentation Scripts

This directory contains scripts for managing example units used throughout the Uniteum documentation.

## Overview

The scripts follow a clean separation of concerns:

- **Config files** (`_data/*.yml`) define what units exist
- **Atomic scripts** operate on one unit at a time
- **Wrapper scripts** process all units from YAML config
- **Computed data** is generated and stored separately from input data

## Architecture

```
_data/example-units-input.yml  (manual, input only)
           ↓
    validate-all-units.sh  (enforces canonical forms)
           ↓
    compute-all-addresses.sh  (generates addresses)
           ↓
_data/example-units.yml  (generated, for Jekyll)
           ↓
    deploy-all-units.sh  (optional deployment)
```

## Prerequisites

Install required tools:

```bash
# Foundry (for cast)
curl -L https://foundry.paradigm.xyz | bash
foundryup

# yq (YAML processor) - only needed for wrapper scripts
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
contracts:
  - name: "Uniteum 0.1 '1'"
    address: "0x9df9b0501e8f6c05623b5b519f9f18b598d9b253"
    version: "0.1"
    ens: "0-1.uniteum.eth"
```

### `_data/example-units-input.yml`

Input file listing example units. Manually maintained.

**IMPORTANT:** All symbols must be in canonical form (validated by scripts).

```yaml
units:
  - symbol: "foo"
    description: "Generic placeholder unit"

  - symbol: "meter/second"
    description: "Velocity unit"
```

### `_data/example-units.yml`

Generated output with computed addresses. **DO NOT EDIT MANUALLY.**

```yaml
units:
  - symbol: "foo"
    canonical: "foo"
    address: "0x966108210F3B2eC0f01B646a61Ce7D8F1aDE7430"
    description: "Generic placeholder unit"
```

## Atomic Scripts

These operate on a single unit at a time.

### `validate-unit.sh`

Validates that a symbol is in canonical form.

```bash
./validate-unit.sh "foo"
# Exit 0 if canonical, exit 1 if not

./validate-unit.sh "foo*bar"
# Error: Symbol 'foo*bar' is not canonical. Canonical form is: 'bar*foo'
```

**Usage:**
```bash
./validate-unit.sh <symbol> [rpc-url]
```

**Exit codes:**
- `0` - Symbol is canonical
- `1` - Symbol is not canonical or error

### `compute-unit-address.sh`

Computes the deterministic address for a unit symbol.

```bash
./compute-unit-address.sh "foo"
# Output: {"symbol":"foo","canonical":"foo","address":"0x966108210F3B2eC0f01B646a61Ce7D8F1aDE7430"}
```

**Usage:**
```bash
./compute-unit-address.sh <symbol> [rpc-url]
```

**Output:** JSON with symbol, canonical form, and address

### `deploy-unit.sh`

Deploys a single unit if it doesn't already exist.

```bash
export PRIVATE_KEY=0x...
./deploy-unit.sh "foo" mainnet

# Or specify private key as argument
./deploy-unit.sh "foo" mainnet 0x...
```

**Usage:**
```bash
./deploy-unit.sh <symbol> [network] [private-key]
```

**Networks:** `mainnet`, `sepolia`

**Environment variables:**
- `PRIVATE_KEY` - Private key for deployment (if not passed as argument)

## Wrapper Scripts

These process all units from `_data/example-units-input.yml`.

### `validate-all-units.sh`

Validates that all units in the input file are in canonical form.

```bash
./validate-all-units.sh

# Output:
# ✅ foo
# ✅ bar
# Error: Symbol 'foo*bar' is not canonical. Canonical form is: 'bar*foo'
# ❌ Validation failed
```

**Usage:**
```bash
./validate-all-units.sh [rpc-url]
```

**Exit codes:**
- `0` - All units are canonical
- `1` - One or more units are not canonical

### `compute-all-addresses.sh`

Generates `_data/example-units.yml` with computed addresses for all units.

**This script:**
1. Validates all units first (fails if any non-canonical)
2. Computes addresses for each unit
3. Writes output to `_data/example-units.yml`

```bash
./compute-all-addresses.sh

# Output:
# Validating units...
# ✅ foo
# ✅ bar
# Computing addresses...
# Computing: foo
# Computing: bar
# ✅ Address computation complete!
```

**Usage:**
```bash
./compute-all-addresses.sh [rpc-url]
```

**Output file:** `_data/example-units.yml`

### `deploy-all-units.sh`

Deploys all units from the input file to mainnet or Sepolia.

```bash
# Dry run (no actual deployment)
./deploy-all-units.sh mainnet --dry-run

# Deploy to Sepolia testnet
export PRIVATE_KEY=0x...
./deploy-all-units.sh sepolia

# Deploy to mainnet
./deploy-all-units.sh mainnet
```

**Usage:**
```bash
./deploy-all-units.sh [network] [--dry-run]
```

**Networks:** `mainnet`, `sepolia` (default: mainnet)

**Flags:**
- `--dry-run` - Show what would be deployed without sending transactions

**Environment variables:**
- `PRIVATE_KEY` - Required for actual deployment (not needed for dry run)

## Typical Workflows

### Adding a New Example Unit

1. **Add to input file:**
   ```bash
   # Edit _data/example-units-input.yml
   # Add new unit with symbol and description
   ```

2. **Validate the symbol is canonical:**
   ```bash
   ./scripts/validate-unit.sh "your-symbol"
   ```

3. **Regenerate addresses:**
   ```bash
   ./scripts/compute-all-addresses.sh
   ```

4. **Commit changes:**
   ```bash
   git add _data/example-units-input.yml _data/example-units.yml
   git commit -m "Add new example unit: your-symbol"
   ```

5. **Deploy (optional):**
   ```bash
   export PRIVATE_KEY=0x...
   ./scripts/deploy-unit.sh "your-symbol" sepolia
   ```

### Regenerating All Addresses

If the contract changes or you want to refresh all computed data:

```bash
./scripts/compute-all-addresses.sh
git diff _data/example-units.yml  # Review changes
git add _data/example-units.yml
git commit -m "Regenerate example unit addresses"
```

### Deploying All Units to Testnet

```bash
# First, dry run to verify
./scripts/deploy-all-units.sh sepolia --dry-run

# If looks good, deploy
export PRIVATE_KEY=0x...
./scripts/deploy-all-units.sh sepolia
```

### Fixing Non-Canonical Symbols

If validation fails:

```bash
./scripts/validate-all-units.sh

# Output shows:
# Error: Symbol 'foo*bar' is not canonical. Canonical form is: 'bar*foo'

# Fix in _data/example-units-input.yml:
# Change symbol: "foo*bar" to symbol: "bar*foo"

# Re-validate
./scripts/validate-all-units.sh
```

## RPC Configuration

All scripts accept an optional RPC URL parameter. Default is `https://eth.llamarpc.com` for mainnet queries.

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

Jekyll automatically reads `_data/example-units.yml` and makes it available as `site.data.example-units.units` in Liquid templates.

Example usage in markdown:
```liquid
{% for unit in site.data.example-units.units %}
- [{{ unit.symbol }}](https://etherscan.io/token/{{ unit.address }})
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
      - name: Validate units
        run: ./scripts/validate-all-units.sh
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
- Contract address is correct (0x9df9b0501e8f6c05623b5b519f9f18b598d9b253)

### Validation fails with non-canonical symbols

The contract returns canonical forms with:
- Alphabetically sorted terms in products (e.g., `bar*foo` not `foo*bar`)
- Normalized exponent notation
- Merged duplicate terms

Always use `validate-unit.sh` to check symbols before adding to input file.

## See Also

- [Example Units Reference](/reference/example-units/) - Documentation page
- [Creating Units Guide](/guides/creating-units/) - How to create custom units
- [Contracts Reference](/reference/contracts/) - Contract addresses
