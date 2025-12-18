#!/bin/bash
# Deploy all example units used in documentation
# Usage: scripts/deploy-examples.sh --network mainnet --dry-run
# Usage: scripts/deploy-examples.sh --network sepolia --dry-run

set -e

# Get contract address from .env (generated from _data/contracts.yml)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_FILE="$SCRIPT_DIR/.env"

# Generate .env if it doesn't exist
if [ ! -f "$ENV_FILE" ]; then
    echo "Generating .env file..."
    "$SCRIPT_DIR/generate-env.sh"
fi

# Source the .env file
source "$ENV_FILE"

# Configuration
NETWORK="mainnet"
DRY_RUN=false

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --network)
            NETWORK="$2"
            shift 2
            ;;
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        *)
            echo "Unknown option: $1"
            echo "Usage: $0 [--network sepolia|mainnet] [--dry-run]"
            exit 1
            ;;
    esac
done

# Set RPC URL based on network
case $NETWORK in
    mainnet)
        RPC_URL="https://eth.llamarpc.com"
        EXPLORER="https://etherscan.io"
        ;;
    sepolia)
        RPC_URL="https://sepolia.gateway.tenderly.co"
        EXPLORER="https://sepolia.etherscan.io"
        ;;
    *)
        echo "Unknown network: $NETWORK"
        exit 1
        ;;
esac

echo "=================================================="
echo "Deploying Example Units to $NETWORK"
echo "=================================================="
echo "Contract: $ONE"
echo "RPC: $RPC_URL"
echo "Explorer: $EXPLORER"
echo ""

if [ "$DRY_RUN" = true ]; then
    echo "🔍 DRY RUN MODE - No transactions will be sent"
    echo ""
fi

# Check for private key
if [ "$DRY_RUN" = false ] && [ -z "$PRIVATE_KEY" ]; then
    echo "Error: PRIVATE_KEY environment variable not set"
    echo "Set it with: export PRIVATE_KEY=0x..."
    echo "Or run in dry-run mode: $0 --dry-run"
    exit 1
fi

# Function to deploy a unit
deploy_unit() {
    local symbol="$1"

    # Check if already deployed
    local result=$(cast call "$ONE" "product(string)(address,string)" "$symbol" --rpc-url "$RPC_URL" 2>&1)
    if [ $? -ne 0 ]; then
        echo "❌ Error predicting address for: $symbol"
        echo "   $result"
        return 1
    fi

    local address=$(echo "$result" | sed -n '1p')
    local canonical=$(echo "$result" | sed -n '2p' | tr -d '"')

    # Check if code exists at address
    local code=$(cast code "$address" --rpc-url "$RPC_URL" 2>/dev/null)

    if [ "$code" != "0x" ] && [ -n "$code" ]; then
        echo "✅ $symbol (canonical: $canonical)"
        echo "   Already deployed: $EXPLORER/token/$address"
    else
        if [ "$DRY_RUN" = true ]; then
            echo "🔍 $symbol (canonical: $canonical)"
            echo "   Would deploy to: $EXPLORER/token/$address"
        else
            echo "🚀 Deploying: $symbol (canonical: $canonical)"
            local tx=$(cast send "$ONE" "multiply(string)(address)" "$symbol" \
                --rpc-url "$RPC_URL" \
                --private-key "$PRIVATE_KEY" \
                --json 2>&1)

            if [ $? -eq 0 ]; then
                local tx_hash=$(echo "$tx" | jq -r '.transactionHash')
                echo "   ✅ Deployed: $EXPLORER/tx/$tx_hash"
                echo "   Address: $EXPLORER/token/$address"
            else
                echo "   ❌ Deployment failed: $tx"
                return 1
            fi
        fi
    fi

    echo ""
}

# Read units from example-units-input.yml
INPUT_FILE="$SCRIPT_DIR/../_data/example-units-input.yml"

if [ ! -f "$INPUT_FILE" ]; then
    echo "Error: $INPUT_FILE not found"
    exit 1
fi

# Check if yq is available
if ! command -v yq &> /dev/null; then
    echo "Error: yq is required but not installed"
    echo "Install with: brew install yq (macOS) or apt-get install yq (Linux)"
    exit 1
fi

# Extract all unit symbols from the YAML file
echo "Reading units from $INPUT_FILE..."
mapfile -t UNITS < <(yq eval '.units[].symbol' "$INPUT_FILE")

# Filter out reciprocal units (they auto-deploy with base units)
UNITS_TO_DEPLOY=()
for unit in "${UNITS[@]}"; do
    if [[ ! "$unit" =~ ^1/ ]]; then
        UNITS_TO_DEPLOY+=("$unit")
    fi
done

UNITS=("${UNITS_TO_DEPLOY[@]}")

echo "Deploying ${#UNITS[@]} units..."
echo ""

success_count=0
fail_count=0

for unit in "${UNITS[@]}"; do
    if deploy_unit "$unit"; then
        success_count=$((success_count + 1))
    else
        fail_count=$((fail_count + 1))
    fi

    # Rate limit to avoid overwhelming RPC or nonce issues
    if [ "$DRY_RUN" = false ]; then
        sleep 2
    else
        sleep 0.1
    fi
done

echo "=================================================="
echo "Deployment Summary"
echo "=================================================="
echo "Total units: ${#UNITS[@]}"
echo "Successful: $success_count"
echo "Failed: $fail_count"
echo ""

if [ "$DRY_RUN" = true ]; then
    echo "This was a dry run. Run without --dry-run to deploy."
    echo "Make sure to set PRIVATE_KEY environment variable first."
else
    echo "✅ Deployment complete!"
    echo ""
    echo "View all deployed units in the documentation:"
    echo "https://uniteum.one/reference/example-units/"
fi
