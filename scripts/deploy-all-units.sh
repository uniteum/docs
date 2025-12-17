#!/bin/bash
# Deploy all units from example-units-input.yml
# Usage: ./deploy-all-units.sh [network] [--dry-run]
# Networks: mainnet, sepolia

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INPUT_FILE="$SCRIPT_DIR/../_data/example-units-input.yml"
NETWORK="mainnet"
DRY_RUN=false

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        mainnet|sepolia)
            NETWORK="$1"
            shift
            ;;
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        *)
            echo "Usage: $0 [mainnet|sepolia] [--dry-run]"
            exit 1
            ;;
    esac
done

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

# Check for private key (unless dry run)
if [ "$DRY_RUN" = false ] && [ -z "$PRIVATE_KEY" ]; then
    echo "Error: PRIVATE_KEY environment variable not set" >&2
    echo "Set it with: export PRIVATE_KEY=0x..." >&2
    echo "Or run in dry-run mode: $0 --dry-run" >&2
    exit 1
fi

echo "=================================================="
echo "Deploying Example Units to $NETWORK"
echo "=================================================="
echo "Input: $INPUT_FILE"
echo ""

if [ "$DRY_RUN" = true ]; then
    echo "🔍 DRY RUN MODE - No transactions will be sent"
    echo ""
fi

# Extract symbols
symbols=$(yq eval '.units[].symbol' "$INPUT_FILE")

if [ -z "$symbols" ]; then
    echo "Error: No units found in $INPUT_FILE" >&2
    exit 1
fi

total=0
success=0
already_deployed=0
failed=0

while IFS= read -r symbol; do
    if [ -z "$symbol" ]; then
        continue
    fi

    total=$((total + 1))

    if [ "$DRY_RUN" = true ]; then
        # In dry run, just show what would happen
        echo "🔍 Would deploy: $symbol"
        success=$((success + 1))
    else
        # Actually deploy
        if "$SCRIPT_DIR/deploy-unit.sh" "$symbol" "$NETWORK" "$PRIVATE_KEY"; then
            # Check output to see if it was already deployed
            output=$("$SCRIPT_DIR/deploy-unit.sh" "$symbol" "$NETWORK" "$PRIVATE_KEY" 2>&1 || true)
            if echo "$output" | grep -q "already deployed"; then
                already_deployed=$((already_deployed + 1))
            else
                success=$((success + 1))
            fi
        else
            failed=$((failed + 1))
        fi
    fi

    echo ""

    # Rate limit to avoid nonce issues
    if [ "$DRY_RUN" = false ]; then
        sleep 2
    fi
done <<< "$symbols"

echo "=================================================="
echo "Deployment Summary"
echo "=================================================="
echo "Total units: $total"
echo "Newly deployed: $success"
echo "Already deployed: $already_deployed"
echo "Failed: $failed"
echo ""

if [ "$DRY_RUN" = true ]; then
    echo "This was a dry run. Run without --dry-run to deploy."
    echo "Make sure to set PRIVATE_KEY environment variable first."
elif [ $failed -gt 0 ]; then
    echo "❌ Some deployments failed"
    exit 1
else
    echo "✅ Deployment complete!"
fi
