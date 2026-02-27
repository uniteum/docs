#!/bin/bash
# Generate .env file from contracts.yml
# Usage: ./generate-env.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONTRACTS_FILE="$SCRIPT_DIR/../_data/contracts.yml"
ENV_FILE="$SCRIPT_DIR/.env"

if [ ! -f "$CONTRACTS_FILE" ]; then
    echo "Error: Contracts file not found: $CONTRACTS_FILE" >&2
    exit 1
fi

echo "Generating .env from $CONTRACTS_FILE..."

# Extract addresses directly from flat structure
ONE=$(yq eval '.uniteum.address' "$CONTRACTS_FILE")
GENESIS=$(yq eval '.genesis.address' "$CONTRACTS_FILE")
KIOSK=$(yq eval '.kiosk.address' "$CONTRACTS_FILE")
HELPER=$(yq eval '.helper.address' "$CONTRACTS_FILE")

# Generate .env file
cat > "$ENV_FILE" << EOF
# Auto-generated from _data/contracts.yml
# DO NOT EDIT MANUALLY - Run ./generate-env.sh to regenerate

ONE=$ONE
GENESIS=$GENESIS
KIOSK=$KIOSK
HELPER=$HELPER
EOF

echo "✅ Generated $ENV_FILE"
echo ""
echo "Environment variables available:"
echo "  ONE=$ONE"
echo "  GENESIS=$GENESIS"
echo "  KIOSK=$KIOSK"
echo "  HELPER=$HELPER"
