#!/bin/bash
# Compute the address and canonical form for a single unit symbol
# Usage: ./compute-unit-address.sh <symbol> [rpc-url]
# Output: JSON with address and canonical form

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
RPC_URL="${2:-https://eth.llamarpc.com}"

if [ -z "$SYMBOL" ]; then
    echo "Error: No symbol provided" >&2
    echo "Usage: $0 <symbol> [rpc-url]" >&2
    exit 1
fi

# Call contract to get address and canonical form
result=$(cast call "$ONE" "product(string)(address,string)" "$SYMBOL" --rpc-url "$RPC_URL" 2>&1)

if [ $? -ne 0 ]; then
    echo "Error: Failed to query contract for symbol '$SYMBOL'" >&2
    echo "$result" >&2
    exit 1
fi

# Parse address (first line) and canonical (second line)
address=$(echo "$result" | sed -n '1p')
canonical=$(echo "$result" | sed -n '2p' | tr -d '"')

if [ -z "$address" ] || [ -z "$canonical" ]; then
    echo "Error: Could not parse result for '$SYMBOL'" >&2
    exit 1
fi

# Output as JSON
echo "{\"symbol\":\"$SYMBOL\",\"canonical\":\"$canonical\",\"address\":\"$address\"}"
