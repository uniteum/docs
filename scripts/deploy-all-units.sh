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
        RPC_URL="https://ethereum.publicnode.com"
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

if [ "$DRY_RUN" = true ]; then
    echo "🔍 DRY RUN MODE - would deploy units using UnitHelper.multiply() (idempotent)"
    echo ""
    echo "Units to process:"
    for ((i=0; i<unit_count; i++)); do
        symbol=$(yq eval ".units[$i].symbol" "$INPUT_FILE")
        echo "  • $symbol"
    done
    echo ""
    echo "Note: UnitHelper.multiply() is idempotent - it only deploys units that don't exist yet."
    echo ""
    echo "To actually deploy, run:"
    echo "  $0 $NETWORK --broadcast"
    exit 0
fi

# Deploy all units in one transaction using UnitHelper.multiply()
# Note: multiply() is idempotent - it only deploys units that don't already exist
if [ -z "$PRIVATE_KEY" ]; then
    echo "Error: PRIVATE_KEY not set" >&2
    echo "Set via environment variable or in .env file" >&2
    exit 1
fi

echo "🚀 Deploying units using UnitHelper.multiply() (idempotent)..."
echo ""

tx=$(cast send "$HELPER" "multiply(address,string[])(address[])" "$ONE" "$symbols_json" \
    --rpc-url "$RPC_URL" \
    --private-key "$PRIVATE_KEY" \
    --json 2>&1)

if [ $? -eq 0 ]; then
    tx_hash=$(echo "$tx" | jq -r '.transactionHash')

    # Get addresses for display
    result=$(cast call "$HELPER" "product(address,string[])(address[],string[])" "$ONE" "$symbols_json" --rpc-url "$RPC_URL" 2>&1)
    addresses_raw=$(echo "$result" | head -1)
    addresses_json=$(echo "$addresses_raw" | tr -d ' ' | sed 's/^\[/["/' | sed 's/,/","/g' | sed 's/\]$/"]/')

    echo "✅ Batch deployment complete!"
    echo ""
    echo "Transaction: $EXPLORER/tx/$tx_hash"
    echo ""
    echo "Units processed:"
    for ((i=0; i<unit_count; i++)); do
        symbol=$(yq eval ".units[$i].symbol" "$INPUT_FILE")
        address=$(echo "$addresses_json" | jq -r ".[$i]")
        echo "  • $symbol → $EXPLORER/token/$address"
    done
    exit 0
else
    echo "❌ Deployment failed" >&2
    echo "$tx" >&2
    exit 1
fi
