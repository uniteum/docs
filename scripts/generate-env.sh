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

# Generate .env file
cat > "$ENV_FILE" << 'EOF'
# Auto-generated from _data/contracts.yml
# DO NOT EDIT MANUALLY - Run ./generate-env.sh to regenerate

# Uniteum 0.1 '1'
UNITEUM_0_1_1=0x9df9b0501e8f6c05623b5b519f9f18b598d9b253
UNITEUM_0_1=0x9df9b0501e8f6c05623b5b519f9f18b598d9b253

# Uniteum 0.0 '1'
UNITEUM_0_0_1=0xC833f0B7cd7FC479DbbF6581EB4eEFc396Cf39E4
UNITEUM_0_0=0xC833f0B7cd7FC479DbbF6581EB4eEFc396Cf39E4

# Discount Kiosk
DISCOUNT_KIOSK=0x55816c3e5d999e2f45ce0146ffd89b2e78a56dc9

# Migrating Kiosk
MIGRATING_KIOSK=0xb1e179cbf76cec54658fe3932ce854afaf530809

# Convenience aliases
ONE=$UNITEUM_0_1
GENESIS=$UNITEUM_0_0
EOF

echo "✅ Generated $ENV_FILE"
echo ""
echo "Environment variables available:"
echo "  UNITEUM_0_1         # Current version '1' token"
echo "  UNITEUM_0_0         # Genesis '1' token"
echo "  DISCOUNT_KIOSK      # v0.0 kiosk"
echo "  MIGRATING_KIOSK     # v0.1 kiosk"
echo "  ONE                 # Alias for UNITEUM_0_1"
echo "  GENESIS             # Alias for UNITEUM_0_0"
