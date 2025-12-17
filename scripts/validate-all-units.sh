#!/bin/bash
# Validate all units from example-units-input.yml
# Usage: ./validate-all-units.sh [rpc-url]

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INPUT_FILE="$SCRIPT_DIR/../_data/example-units-input.yml"
RPC_URL="${1:-https://eth.llamarpc.com}"

if [ ! -f "$INPUT_FILE" ]; then
    echo "Error: Input file not found: $INPUT_FILE" >&2
    exit 1
fi

# Check for yq
if ! command -v yq &> /dev/null; then
    echo "Error: yq is required but not installed" >&2
    echo "Install with: brew install yq (macOS) or snap install yq (Linux)" >&2
    exit 1
fi

echo "Validating units from: $INPUT_FILE"
echo "RPC: $RPC_URL"
echo ""

# Extract symbols from YAML
symbols=$(yq eval '.units[].symbol' "$INPUT_FILE")

if [ -z "$symbols" ]; then
    echo "Error: No units found in $INPUT_FILE" >&2
    exit 1
fi

total=0
valid=0
invalid=0

while IFS= read -r symbol; do
    if [ -z "$symbol" ]; then
        continue
    fi

    total=$((total + 1))

    if "$SCRIPT_DIR/validate-unit.sh" "$symbol" "$RPC_URL" 2>/dev/null; then
        echo "✅ $symbol"
        valid=$((valid + 1))
    else
        # Get the error message
        error=$("$SCRIPT_DIR/validate-unit.sh" "$symbol" "$RPC_URL" 2>&1 || true)
        echo "$error"
        invalid=$((invalid + 1))
    fi

    # Rate limit
    sleep 0.1
done <<< "$symbols"

echo ""
echo "=================================================="
echo "Validation Summary"
echo "=================================================="
echo "Total units: $total"
echo "Valid (canonical): $valid"
echo "Invalid (non-canonical): $invalid"
echo ""

if [ $invalid -gt 0 ]; then
    echo "❌ Validation failed. Fix non-canonical symbols in $INPUT_FILE"
    exit 1
else
    echo "✅ All units are in canonical form"
    exit 0
fi
