#!/bin/bash
# Validate that a single unit symbol is in canonical form
# Usage: ./validate-unit.sh <symbol> [rpc-url]
# Exit codes: 0 = valid, 1 = invalid/error

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
RPC_URL="${2:-https://ethereum.publicnode.com}"

if [ -z "$SYMBOL" ]; then
    echo "Error: No symbol provided" >&2
    echo "Usage: $0 <symbol> [rpc-url]" >&2
    exit 1
fi

# Call contract to get canonical form
result=$(cast call "$ONE" "product(string)(address,string)" "$SYMBOL" --rpc-url "$RPC_URL" 2>&1)

if [ $? -ne 0 ]; then
    echo "Error: Failed to query contract for symbol '$SYMBOL'" >&2
    echo "$result" >&2
    exit 1
fi

# Parse canonical form (second line of output)
# Use sed to convert \\ to \
canonical=$(echo "$result" | sed -n '2p' | tr -d '"' | sed 's/\\\\/\\/g')

if [ -z "$canonical" ]; then
    echo "Error: Could not parse canonical form for '$SYMBOL'" >&2
    exit 1
fi

# Check if input matches canonical
if [ "$SYMBOL" = "$canonical" ]; then
    exit 0
else
    echo "Error: Symbol '$SYMBOL' is not canonical. Canonical form is: '$canonical'" >&2
    exit 1
fi
