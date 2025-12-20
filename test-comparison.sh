#!/bin/bash
source scripts/.env

symbol="$1"
result=$(cast call "$ONE" "product(string)(address,string)" "$symbol" --rpc-url https://eth.llamarpc.com)
canonical=$(echo "$result" | sed -n '2p' | tr -d '"')

echo "Input symbol: [$symbol]"
echo "Canonical:    [$canonical]"
echo "Input length: ${#symbol}"
echo "Canon length: ${#canonical}"

if [ "$symbol" = "$canonical" ]; then
    echo "MATCH ✅"
else
    echo "NO MATCH ❌"
fi
