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

# Get current versions (data-driven)
CURRENT_UNITEUM_VERSION=$(yq eval '.current.uniteum' "$CONTRACTS_FILE")
CURRENT_KIOSK_VERSION=$(yq eval '.current.kiosk' "$CONTRACTS_FILE")

# Extract addresses dynamically using yq
UNITEUM_CURRENT=$(yq eval ".uniteum.${CURRENT_UNITEUM_VERSION}.mainnet" "$CONTRACTS_FILE")
UNITEUM_0_0=$(yq eval '.uniteum.v0_0.mainnet' "$CONTRACTS_FILE")
KIOSK_CURRENT=$(yq eval ".kiosk.${CURRENT_KIOSK_VERSION}.mainnet" "$CONTRACTS_FILE")
KIOSK_0_0=$(yq eval '.kiosk.v0_0.mainnet' "$CONTRACTS_FILE")

# Generate .env file
cat > "$ENV_FILE" << EOF
# Auto-generated from _data/contracts.yml
# DO NOT EDIT MANUALLY - Run ./generate-env.sh to regenerate
# Current Uniteum version: $CURRENT_UNITEUM_VERSION
# Current Kiosk version: $CURRENT_KIOSK_VERSION

# Current versions (data-driven)
UNITEUM_CURRENT=$UNITEUM_CURRENT
KIOSK_CURRENT=$KIOSK_CURRENT

# Genesis (stable)
UNITEUM_0_0=$UNITEUM_0_0
KIOSK_0_0=$KIOSK_0_0

# Convenience aliases
ONE=\$UNITEUM_CURRENT
KIOSK=\$KIOSK_CURRENT
GENESIS=\$UNITEUM_0_0
EOF

echo "✅ Generated $ENV_FILE"
echo ""
echo "Environment variables available:"
echo "  UNITEUM_CURRENT=$UNITEUM_CURRENT (version: $CURRENT_UNITEUM_VERSION)"
echo "  KIOSK_CURRENT=$KIOSK_CURRENT (version: $CURRENT_KIOSK_VERSION)"
echo "  UNITEUM_0_0=$UNITEUM_0_0 (genesis)"
echo "  KIOSK_0_0=$KIOSK_0_0 (genesis)"
echo "  ONE=\$UNITEUM_CURRENT"
echo "  GENESIS=\$UNITEUM_0_0"
