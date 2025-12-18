#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/.env"
echo "ONE=$ONE"
SYMBOL='foo^2\\3'
echo "Calling cast with symbol: $SYMBOL"
result=$(cast call "$ONE" "product(string)(address,string)" "$SYMBOL" --rpc-url https://eth.llamarpc.com 2>&1)
echo "Raw result:"
echo "$result"
canonical=$(echo "$result" | sed -n '2p' | tr -d '"')
echo "Input:     [$SYMBOL]"
echo "Canonical: [$canonical]"
if [ "$SYMBOL" = "$canonical" ]; then
    echo "✅ MATCH"
    exit 0
else
    echo "❌ NO MATCH"
    exit 1
fi
