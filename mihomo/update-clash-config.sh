#!/bin/bash
set -euo pipefail

SUB_URL="${SUB_URL:-${1:-}}"
USER_CONFIG_FILE="${USER_CONFIG_FILE:-${2:-}}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

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

if [ -z "$USER_CONFIG_FILE" ] && [ -f "$SCRIPT_DIR/user-config.yaml" ]; then
    USER_CONFIG_FILE="$SCRIPT_DIR/user-config.yaml"
fi

SUBCONVERTER_DIR="/etc/mihomo/subconverter"
OUTPUT_FILE="${OUTPUT_FILE:-/etc/mihomo/config.yaml}"

mkdir -p "$SUBCONVERTER_DIR"
mkdir -p "$(dirname "$OUTPUT_FILE")"

# Install subconverter if needed
if [ ! -x "$SUBCONVERTER_DIR/subconverter" ]; then
    echo "Installing subconverter..."
    INSTALL_TMP_DIR=$(mktemp -d)
    curl -fsSL https://github.com/tindy2013/subconverter/releases/download/v0.9.0/subconverter_linux64.tar.gz | tar -xzf - -C "$INSTALL_TMP_DIR"
    install -m 755 "$INSTALL_TMP_DIR/subconverter/subconverter" "$SUBCONVERTER_DIR/subconverter"
    if [ -f "$INSTALL_TMP_DIR/subconverter/pref.toml" ] && [ ! -f "$SUBCONVERTER_DIR/pref.toml" ]; then
        install -m 644 "$INSTALL_TMP_DIR/subconverter/pref.toml" "$SUBCONVERTER_DIR/pref.toml"
    fi
fi

# Set block style in pref.toml
if [ ! -f "$SUBCONVERTER_DIR/pref.toml" ]; then
    cat > "$SUBCONVERTER_DIR/pref.toml" << EOF
clash_proxies_style = "block"
EOF
elif ! grep -q 'clash_proxies_style = "block"' "$SUBCONVERTER_DIR/pref.toml" 2>/dev/null; then
    echo "Configuring subconverter for block style YAML..."
    if grep -q 'clash_proxies_style = ' "$SUBCONVERTER_DIR/pref.toml" 2>/dev/null; then
        sed -i 's/clash_proxies_style = .*/clash_proxies_style = "block"/' "$SUBCONVERTER_DIR/pref.toml"
    else
        printf '\nclash_proxies_style = "block"\n' >> "$SUBCONVERTER_DIR/pref.toml"
    fi
fi

TMP_FILE=$(mktemp)
OUTPUT_TMP_FILE=$(mktemp)

cleanup() {
    rm -f "$TMP_FILE" "$OUTPUT_TMP_FILE" "$SUBCONVERTER_DIR/generate.ini"
    if [ -n "${INSTALL_TMP_DIR:-}" ]; then
        rm -rf "$INSTALL_TMP_DIR"
    fi
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
echo "external-ui: ui" > "$OUTPUT_TMP_FILE"
echo "external-ui-url: \"https://github.com/MetaCubeX/metacubexd/archive/refs/heads/gh-pages.zip\"" >> "$OUTPUT_TMP_FILE"
echo "" >> "$OUTPUT_TMP_FILE"
cat "$TMP_FILE" >> "$OUTPUT_TMP_FILE"

if [ -n "$USER_CONFIG_FILE" ]; then
    if [ ! -f "$USER_CONFIG_FILE" ]; then
        echo "Error: USER_CONFIG_FILE not found: $USER_CONFIG_FILE"
        exit 1
    fi

    echo "Merging user config from $USER_CONFIG_FILE..."
    ruby -ryaml -e '
def deep_merge(base, override)
  return override unless base.is_a?(Hash) && override.is_a?(Hash)

  base.merge(override) do |_key, left, right|
    if left.is_a?(Hash) && right.is_a?(Hash)
      deep_merge(left, right)
    else
      right
    end
  end
end

def merge_clash_config(base, override)
  merged = deep_merge(base, override)

  if base["rules"].is_a?(Array) && override["rules"].is_a?(Array)
    merged["rules"] = override["rules"] + base["rules"]
  end

  merged
end

generated_path, user_path, output_path = ARGV
generated = YAML.unsafe_load_file(generated_path) || {}
user = YAML.unsafe_load_file(user_path) || {}

unless generated.is_a?(Hash) && user.is_a?(Hash)
  warn "Error: both generated config and user config must be YAML mappings"
  exit 1
end

File.write(output_path, YAML.dump(merge_clash_config(generated, user)))
' "$OUTPUT_TMP_FILE" "$USER_CONFIG_FILE" "$OUTPUT_FILE"
else
    mv "$OUTPUT_TMP_FILE" "$OUTPUT_FILE"
fi

echo "Done! Config written to $OUTPUT_FILE"
