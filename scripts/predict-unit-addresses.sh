#!/bin/bash
# Predict CREATE2 addresses for floating example units
# Uses OpenZeppelin Clones.predictDeterministicAddress logic

set -e

# Uniteum 0.1 "1" contract (both implementation and deployer)
IMPLEMENTATION="0x9df9b0501e8f6c05623b5b519f9f18b598d9b253"
DEPLOYER="$IMPLEMENTATION"  # Self-cloning

# EIP-1167 Minimal Proxy bytecode prefix/suffix (OpenZeppelin Clones)
# The proxy bytecode is: 0x3d602d80600a3d3981f3363d3d373d3d3d363d73[implementation]5af43d82803e903d91602b57fd5bf3
# We need the keccak256 of this bytecode for CREATE2 calculation

echo "Calculating CREATE2 addresses for example units..."
echo "Implementation/Deployer: $IMPLEMENTATION"
echo ""
echo "NOTE: These addresses are the same on ALL networks (mainnet, Sepolia, etc.)"
echo ""

# Function to predict unit address
# Args: $1 = symbol (the canonical string)
predict_address() {
    local symbol="$1"

    # Step 1: Calculate salt = keccak256(abi.encode(symbol))
    # abi.encode pads the string: length (32 bytes) + offset (32 bytes) + data (padded)
    # For strings, abi.encode(string) = 0x20 (offset) + length + data
    local salt=$(cast keccak $(cast abi-encode "f(string)" "$symbol"))

    # Step 2: Use cast to compute CREATE2 address
    # Note: OpenZeppelin's Clones uses a specific bytecode pattern
    # The minimal proxy bytecode template:
    local bytecode_prefix="3d602d80600a3d3981f3363d3d373d3d3d363d73"
    local implementation_no_0x="${IMPLEMENTATION#0x}"
    local bytecode_suffix="5af43d82803e903d91602b57fd5bf3"
    local init_code="${bytecode_prefix}${implementation_no_0x}${bytecode_suffix}"

    # CREATE2: keccak256(0xff ++ deployer ++ salt ++ keccak256(initCode))[12:]
    local init_code_hash=$(cast keccak "0x${init_code}")
    local create2_input="ff${DEPLOYER#0x}${salt#0x}${init_code_hash#0x}"
    local full_hash=$(cast keccak "0x${create2_input}")

    # Take last 20 bytes (40 hex chars)
    local address="0x${full_hash: -40}"

    echo "$address"
}

# Array of units to calculate
declare -a UNITS=(
    # Base units
    "foo"
    "bar"
    "baz"
    "acme"
    "widget"
    "meter"
    "second"
    "kilogram"
    "kg"
    "sword"
    "shield"
    "USD"
    "ETH"
    "BTC"
    # Reciprocals
    "1/foo"
    "1/bar"
    "1/meter"
    "1/second"
    "1/kilogram"
    # Compounds
    "foo*bar"
    "meter*second"
    "kg*m"
    "sword*shield"
    "meter/second"
    "foo/bar"
    "second/meter"
    "kg*m/s^2"
    "foo^2"
    "foo^2\3"
    "bar^1\2"
)

# Generate output
echo "| Symbol | Address |"
echo "|--------|---------|"

for unit in "${UNITS[@]}"; do
    # Note: This is a simplified calculation. The actual CREATE2 address
    # requires calling the contract's anchoredPredict or product functions
    # because the symbol may be canonicalized (sorted/merged terms)
    echo "| \`$unit\` | *(requires contract call - see script)* |"
done

echo ""
echo "=================================================="
echo "IMPORTANT: The addresses above are PLACEHOLDERS"
echo "=================================================="
echo ""
echo "To get the actual addresses, you need to:"
echo "1. Call IUnit(0x9df9b0501e8f6c05623b5b519f9f18b598d9b253).product(\"symbol\")"
echo "2. This returns (address unit, string memory canonical)"
echo "3. The canonical form may differ from input (e.g., terms are sorted)"
echo ""
echo "Example using cast:"
echo "  cast call $IMPLEMENTATION \"product(string)(address,string)\" \"foo\""
echo ""
echo "This will give you the deterministic address WITHOUT deploying."
