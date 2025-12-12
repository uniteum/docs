#!/bin/bash
# Deploy all example units used in documentation
# Usage: ./deploy-examples.sh [--network sepolia|mainnet] [--dry-run]

set -e

# Configuration
ONE="0x9df9b0501e8f6c05623b5b519f9f18b598d9b253"
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
        echo "   Already deployed: $EXPLORER/address/$address#code"
    else
        if [ "$DRY_RUN" = true ]; then
            echo "🔍 $symbol (canonical: $canonical)"
            echo "   Would deploy to: $EXPLORER/address/$address#code"
        else
            echo "🚀 Deploying: $symbol (canonical: $canonical)"
            local tx=$(cast send "$ONE" "multiply(string)(address)" "$symbol" \
                --rpc-url "$RPC_URL" \
                --private-key "$PRIVATE_KEY" \
                --json 2>&1)

            if [ $? -eq 0 ]; then
                local tx_hash=$(echo "$tx" | jq -r '.transactionHash')
                echo "   ✅ Deployed: $EXPLORER/tx/$tx_hash"
                echo "   Address: $EXPLORER/address/$address#code"
            else
                echo "   ❌ Deployment failed: $tx"
                return 1
            fi
        fi
    fi

    echo ""
}

# List of units to deploy
UNITS=(
    # Base units - generic
    "foo"
    "bar"
    "baz"
    "acme"
    "widget"
    # Base units - physics
    "meter"
    "second"
    "kilogram"
    "kg"
    # Base units - gaming
    "sword"
    "shield"
    # Base units - symbolic (for warnings/examples)
    "USD"
    "ETH"
    "BTC"
    "MSFT"
    # Reciprocals (will auto-deploy when base is deployed)
    # Compounds
    "foo*bar"
    "meter*second"
    "kg*m"
    "kilogram*meter"
    "sword*shield"
    "meter/second"
    "foo/bar"
    "second/meter"
    "kg*m/s^2"
    "foo^2"
    "foo^2\\3"
    "bar^1\\2"
)

echo "Deploying ${#UNITS[@]} units..."
echo ""

success_count=0
fail_count=0

for unit in "${UNITS[@]}"; do
    if deploy_unit "$unit"; then
        ((success_count++))
    else
        ((fail_count++))
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
