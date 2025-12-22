#!/bin/bash
# Deploy all units from example-units-input.yml using UnitHelper for batch deployment
# Usage: ./deploy-all-units.sh [network] [--broadcast]
# Networks: mainnet, sepolia
# Note: Dry-run by default; use --broadcast to actually deploy

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INPUT_FILE="$SCRIPT_DIR/../_data/example-units-input.yml"
NETWORK="mainnet"
DRY_RUN=true  # Default to dry-run for safety

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        mainnet|sepolia)
            NETWORK="$1"
            shift
            ;;
        --broadcast)
            DRY_RUN=false
            shift
            ;;
        *)
            echo "Usage: $0 [mainnet|sepolia] [--broadcast]"
            exit 1
            ;;
    esac
done

if [ ! -f "$INPUT_FILE" ]; then
    echo "Error: Input file not found: $INPUT_FILE" >&2
    exit 1
fi

# Check for yq and jq
if ! command -v yq &> /dev/null; then
    echo "Error: yq is required but not installed" >&2
    echo "Install with: brew install yq (macOS) or snap install yq (Linux)" >&2
    exit 1
fi

if ! command -v jq &> /dev/null; then
    echo "Error: jq is required but not installed" >&2
    echo "Install with: brew install jq" >&2
    exit 1
fi

# Generate .env if it doesn't exist
if [ ! -f "$SCRIPT_DIR/.env" ]; then
    echo "Generating .env file..."
    "$SCRIPT_DIR/generate-env.sh"
fi

# Source the .env file
source "$SCRIPT_DIR/.env"

# Set RPC and explorer based on network
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
        echo "Error: Unknown network '$NETWORK'. Use 'mainnet' or 'sepolia'" >&2
        exit 1
        ;;
esac

echo "============================================"
echo "Batch Unit Deployment using UnitHelper"
echo "============================================"
echo "Network: $NETWORK"
echo "Uniteum: $ONE"
echo "UnitHelper: $HELPER"
echo "RPC: $RPC_URL"
echo "Dry run: $DRY_RUN"
echo ""

# Extract all symbols from input file and build JSON array using yq
unit_count=$(yq eval '.units | length' "$INPUT_FILE")
symbols_json=$(yq eval '.units[].symbol' "$INPUT_FILE" | jq -R . | jq -s -c .)

echo "Found $unit_count units to deploy"
echo ""

# First, check which units are already deployed
echo "Checking deployment status..."
echo ""

result=$(cast call "$HELPER" "product(address,string[])(address[],string[])" "$ONE" "$symbols_json" --rpc-url "$RPC_URL" 2>&1)

if [ $? -ne 0 ]; then
    echo "Error: Failed to call UnitHelper.product()" >&2
    echo "$result" >&2
    exit 1
fi

# Parse addresses
addresses_raw=$(echo "$result" | grep -A 999 "^\[" | head -1)
addresses_clean=$(echo "$addresses_raw" | tr -d '[]' | tr ',' '\n' | xargs)
IFS=$'\n' read -r -d '' -a addresses_array <<< "$addresses_clean" || true

# Check which units are deployed
deployed_count=0
undeployed_count=0

for ((i=0; i<unit_count; i++)); do
    address="${addresses_array[$i]}"
    symbol=$(yq eval ".units[$i].symbol" "$INPUT_FILE")

    # Check if contract exists
    code=$(cast code "$address" --rpc-url "$RPC_URL" 2>/dev/null)

    if [ "$code" != "0x" ] && [ -n "$code" ]; then
        echo "  ✓ Already deployed: $symbol"
        ((deployed_count++))
    else
        echo "  ○ Not deployed: $symbol"
        ((undeployed_count++))
    fi
done

echo ""
echo "Status: $deployed_count deployed, $undeployed_count to deploy"
echo ""

if [ $undeployed_count -eq 0 ]; then
    echo "✅ All units already deployed!"
    exit 0
fi

if [ "$DRY_RUN" = true ]; then
    echo "🔍 DRY RUN MODE - would deploy $undeployed_count units"
    echo ""
    echo "To actually deploy, run:"
    echo "  $0 $NETWORK --broadcast"
    exit 0
fi

# Deploy all units in one transaction using UnitHelper.multiply()
if [ -z "$PRIVATE_KEY" ]; then
    echo "Error: PRIVATE_KEY not set" >&2
    echo "Set via environment variable or in .env file" >&2
    exit 1
fi

echo "🚀 Deploying all $unit_count units in a single batch transaction..."
echo ""

tx=$(cast send "$HELPER" "multiply(address,string[])(address[])" "$ONE" "$symbols_json" \
    --rpc-url "$RPC_URL" \
    --private-key "$PRIVATE_KEY" \
    --json 2>&1)

if [ $? -eq 0 ]; then
    tx_hash=$(echo "$tx" | jq -r '.transactionHash')
    echo "✅ Batch deployment successful!"
    echo ""
    echo "Transaction: $EXPLORER/tx/$tx_hash"
    echo ""
    echo "Units deployed:"
    for ((i=0; i<unit_count; i++)); do
        symbol=$(yq eval ".units[$i].symbol" "$INPUT_FILE")
        address="${addresses_array[$i]}"
        echo "  • $symbol → $EXPLORER/token/$address"
    done
    exit 0
else
    echo "❌ Deployment failed" >&2
    echo "$tx" >&2
    exit 1
fi
