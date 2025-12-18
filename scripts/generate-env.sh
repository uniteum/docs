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

# Extract addresses from contracts.yml using grep/awk
UNITEUM_0_3=$(grep -A5 "^  v0_3:" "$CONTRACTS_FILE" | grep "mainnet:" | head -1 | awk '{print $2}' | tr -d '"')
UNITEUM_0_0=$(grep -A5 "^  v0_0:" "$CONTRACTS_FILE" | grep "mainnet:" | head -1 | awk '{print $2}' | tr -d '"')
KIOSK_0_3=$(grep -A5 "kiosk:" "$CONTRACTS_FILE" | grep -A5 "v0_3:" | grep "mainnet:" | awk '{print $2}' | tr -d '"')
KIOSK_0_0=$(grep -A5 "kiosk:" "$CONTRACTS_FILE" | grep -A5 "v0_0:" | grep "mainnet:" | awk '{print $2}' | tr -d '"')

# Get current version
CURRENT_VERSION=$(grep -A1 "^current:" "$CONTRACTS_FILE" | grep "uniteum:" | awk '{print $2}' | tr -d '"')

# Generate .env file
cat > "$ENV_FILE" << EOF
# Auto-generated from _data/contracts.yml
# DO NOT EDIT MANUALLY - Run ./generate-env.sh to regenerate
# Current version: $CURRENT_VERSION

# Uniteum 0.3 '1'
UNITEUM_0_3=$UNITEUM_0_3

# Uniteum 0.0 '1' (Genesis)
UNITEUM_0_0=$UNITEUM_0_0

# Kiosks
KIOSK_0_3=$KIOSK_0_3
KIOSK_0_0=$KIOSK_0_0

# Convenience aliases (point to current version)
ONE=\$UNITEUM_0_3
KIOSK=\$KIOSK_0_3
GENESIS=\$UNITEUM_0_0
EOF

echo "✅ Generated $ENV_FILE"
echo ""
echo "Environment variables available:"
echo "  UNITEUM_0_3=$UNITEUM_0_3"
echo "  UNITEUM_0_0=$UNITEUM_0_0"
echo "  KIOSK_0_3=$KIOSK_0_3"
echo "  KIOSK_0_0=$KIOSK_0_0"
echo "  ONE=\$UNITEUM_0_3 (current version)"
echo "  GENESIS=\$UNITEUM_0_0"
