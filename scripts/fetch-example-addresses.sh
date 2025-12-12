#!/bin/bash
# Fetch deterministic addresses for all example units used in documentation
# Queries the deployed Uniteum 0.1 contract to predict CREATE2 addresses

set -e

# Uniteum 0.1 "1" contract
ONE="0x9df9b0501e8f6c05623b5b519f9f18b598d9b253"
RPC_URL="${RPC_URL:-https://eth.llamarpc.com}"

echo "Fetching CREATE2 addresses for example units..."
echo "Contract: $ONE"
echo "RPC: $RPC_URL"
echo ""
echo "NOTE: These addresses are network-agnostic (same on mainnet and all testnets)"
echo ""

# Function to predict unit address and canonical symbol
predict() {
    local symbol="$1"
    local result=$(cast call "$ONE" "product(string)(address,string)" "$symbol" --rpc-url "$RPC_URL" 2>/dev/null)

    if [ $? -eq 0 ]; then
        # Parse the output (address on first line, string on second)
        local address=$(echo "$result" | sed -n '1p')
        local canonical=$(echo "$result" | sed -n '2p' | tr -d '"')
        echo "$address|$canonical"
    else
        echo "ERROR|ERROR"
    fi
}

# Array of units to calculate
declare -a UNITS=(
    # Base units - generic/abstract
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
    # Base units - symbolic (cautionary examples)
    "USD"
    "ETH"
    "BTC"
    "MSFT"
    # Reciprocals
    "1/foo"
    "1/bar"
    "1/meter"
    "1/second"
    "1/kilogram"
    "1/kg"
    # Simple compounds
    "foo*bar"
    "meter*second"
    "kg*m"
    "kilogram*meter"
    "sword*shield"
    # Ratios
    "meter/second"
    "foo/bar"
    "second/meter"
    # Complex
    "kg*m/s^2"
    # Powers
    "foo^2"
    "foo^2\3"
    "bar^1\2"
)

# Output format: markdown table
echo "| Input Symbol | Canonical Symbol | Address |"
echo "|--------------|------------------|---------|"

for unit in "${UNITS[@]}"; do
    result=$(predict "$unit")
    IFS='|' read -r address canonical <<< "$result"

    if [ "$address" != "ERROR" ]; then
        # Check if canonical differs from input
        if [ "$canonical" != "$unit" ]; then
            echo "| \`$unit\` | \`$canonical\` | [\`$address\`](https://etherscan.io/address/$address#code) |"
        else
            echo "| \`$unit\` |  | [\`$address\`](https://etherscan.io/address/$address#code) |"
        fi
    else
        echo "| \`$unit\` | ERROR | ERROR |"
    fi

    # Rate limit to avoid overwhelming RPC
    sleep 0.1
done

echo ""
echo "✅ Address prediction complete!"
echo ""
echo "These addresses can be used in documentation with Etherscan links."
echo "Units can be deployed by calling: one().multiply(\"symbol\")"
