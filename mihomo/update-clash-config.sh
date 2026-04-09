#!/bin/bash
set -e

SUB_URL="${SUB_URL:-$1}"

# Fallback: read from /etc/mihomo/sub.conf
if [ -z "$SUB_URL" ] && [ -f /etc/mihomo/sub.conf ]; then
    SUB_URL=$(cat /etc/mihomo/sub.conf)
fi

if [ -z "$SUB_URL" ]; then
    echo "Error: SUB_URL not set"
    echo "Usage: $0 <subscription_url>"
    echo "Or create /etc/mihomo/sub.conf with subscription URL"
    exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SUBCONVERTER_DIR="/etc/mihomo/subconverter"
OUTPUT_FILE="/etc/mihomo/config.yaml"

# Install subconverter if needed
if [ ! -x "$SUBCONVERTER_DIR/subconverter" ]; then
    echo "Installing subconverter..."
    curl -sL https://github.com/tindy2013/subconverter/releases/download/v0.9.0/subconverter_linux64.tar.gz | tar -xzf - -C /tmp
    chmod +x "$SUBCONVERTER_DIR/subconverter"
fi

# Set block style in pref.toml
if ! grep -q 'clash_proxies_style = "block"' "$SUBCONVERTER_DIR/pref.toml" 2>/dev/null; then
    echo "Configuring subconverter for block style YAML..."
    sed -i 's/clash_proxies_style = "flow"/clash_proxies_style = "block"/' "$SUBCONVERTER_DIR/pref.toml" 2>/dev/null || true
fi

TMP_FILE=$(mktemp)

cleanup() {
    rm -f "$TMP_FILE" "$SUBCONVERTER_DIR/generate.ini"
}
trap cleanup EXIT

# Create generate.ini
cat > "$SUBCONVERTER_DIR/generate.ini" << EOF
[custom]
path=$TMP_FILE
target=clash
url=$SUB_URL
EOF

echo "Converting subscription..."
cd "$SUBCONVERTER_DIR"
./subconverter -g generate.ini > /dev/null 2>&1

if [ ! -s "$TMP_FILE" ]; then
    echo "Error: Failed to convert subscription"
    exit 1
fi

# Add external-ui at the beginning
echo "external-ui: ui" > "$OUTPUT_FILE"
echo "external-ui-url: \"https://github.com/MetaCubeX/metacubexd/archive/refs/heads/gh-pages.zip\"" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"
cat "$TMP_FILE" >> "$OUTPUT_FILE"

echo "Done! Config written to $OUTPUT_FILE"
