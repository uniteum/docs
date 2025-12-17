#!/bin/bash
# Deploy a single unit if it doesn't already exist
# Usage: ./deploy-unit.sh <symbol> [network] [private-key]
# Exit codes: 0 = success (deployed or already exists), 1 = error

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source contract addresses
if [ -f "$SCRIPT_DIR/.env" ]; then
    source "$SCRIPT_DIR/.env"
else
    echo "Error: .env file not found. Run ./generate-env.sh first" >&2
    exit 1
fi

SYMBOL="$1"
NETWORK="${2:-mainnet}"
PRIVATE_KEY="${3:-$PRIVATE_KEY}"

if [ -z "$SYMBOL" ]; then
    echo "Error: No symbol provided" >&2
    echo "Usage: $0 <symbol> [network] [private-key]" >&2
    exit 1
fi

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

# Get predicted address
result=$(cast call "$ONE" "product(string)(address,string)" "$SYMBOL" --rpc-url "$RPC_URL" 2>&1)

if [ $? -ne 0 ]; then
    echo "Error: Failed to predict address for symbol '$SYMBOL'" >&2
    echo "$result" >&2
    exit 1
fi

address=$(echo "$result" | sed -n '1p')
canonical=$(echo "$result" | sed -n '2p' | tr -d '"')

# Check if already deployed
code=$(cast code "$address" --rpc-url "$RPC_URL" 2>/dev/null)

if [ "$code" != "0x" ] && [ -n "$code" ]; then
    echo "✅ $SYMBOL (canonical: $canonical) already deployed"
    echo "   Address: $EXPLORER/token/$address"
    exit 0
fi

# Deploy the unit
if [ -z "$PRIVATE_KEY" ]; then
    echo "Error: PRIVATE_KEY not provided" >&2
    echo "Set via environment variable or pass as third argument" >&2
    exit 1
fi

echo "🚀 Deploying: $SYMBOL (canonical: $canonical)"

tx=$(cast send "$ONE" "multiply(string)(address)" "$SYMBOL" \
    --rpc-url "$RPC_URL" \
    --private-key "$PRIVATE_KEY" \
    --json 2>&1)

if [ $? -eq 0 ]; then
    tx_hash=$(echo "$tx" | jq -r '.transactionHash')
    echo "   ✅ Deployed: $EXPLORER/tx/$tx_hash"
    echo "   Address: $EXPLORER/token/$address"
    exit 0
else
    echo "   ❌ Deployment failed: $tx" >&2
    exit 1
fi
