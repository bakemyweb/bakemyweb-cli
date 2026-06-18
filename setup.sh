#!/bin/bash
set -e

OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)

case "$ARCH" in
  aarch64|arm64) ARCH="arm64" ;;
  x86_64) ARCH="amd64" ;;
  *) echo "Unsupported architecture: $ARCH"; exit 1 ;;
esac

case "$OS" in
  darwin) OS="darwin" ;;
  linux) OS="linux" ;;
  *) echo "Unsupported OS: $OS"; exit 1 ;;
esac

VERSION=$(curl -s https://api.github.com/repos/bakemyweb/bakemyweb-cli/releases/latest | grep tag_name | cut -d'"' -f4)
[ -z "$VERSION" ] && echo "Failed to fetch version" && exit 1

BINARY_NAME="bakemyweb-${VERSION}-${OS}-${ARCH}"
DOWNLOAD_URL="https://github.com/bakemyweb/bakemyweb-cli/releases/download/${VERSION}/${BINARY_NAME}"
echo $DOWNLOAD_URL
INSTALL_DIR="$HOME/.local/bin"

echo "Installing bakemyweb ${VERSION}..."
mkdir -p "$INSTALL_DIR"
curl -L -o "$INSTALL_DIR/bakemyweb" "$DOWNLOAD_URL"
chmod +x "$INSTALL_DIR/bakemyweb"

echo "✓ Installed to $INSTALL_DIR/bakemyweb"

# Add to PATH if not already there
for PROFILE in ~/.zshrc ~/.bashrc; do
  if [ -f "$PROFILE" ]; then
    if ! grep -q "\.local/bin" "$PROFILE"; then
      echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$PROFILE"
      echo "✓ Added to $PROFILE"
    fi
  fi
done

echo ""
echo "✓ Installation complete!"
echo "Reload your shell: source ~/.zshrc"
echo "Then run: bakemyweb --help"
