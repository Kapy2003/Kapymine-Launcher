#!/bin/bash
set -e

# ── Script Location ─────────────────────────────────────────
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"

# ── Config ─────────────────────────────────────────────────
pkgver="9.4"
download_url="https://github.com/Diegiwg/PrismLauncher-Cracked/releases/download/${pkgver}/PrismLauncher-Linux-x86_64.AppImage"

ICON_NAME="kapymine.png"
ICON_DST="/usr/share/icons/hicolor/256x256/apps"

APPIMAGE_DST="/usr/share/kapymine-launcher"
APPIMAGE_FILE="$APPIMAGE_DST/kapymine-launcher.AppImage"

WRAPPER_SCRIPT="kapymine-launcher.sh"
WRAPPER_DST="/usr/bin/kapymine-launcher"

DESKTOP_TEMPLATE="kapymine-launcher.desktop"

# Determine real user's home, even under sudo
USER_HOME=$(eval echo ~$(logname))
DESKTOP_FINAL="$USER_HOME/.local/share/applications/kapymine-launcher.desktop"

# ── Elevate to sudo if not already ─────────────────────────
if [[ $EUID -ne 0 ]]; then
  echo "🔐 Root privileges required. Asking for sudo..."
  exec sudo "$0" "$@"
fi

# ── Download AppImage ──────────────────────────────────────
echo "🌐 Downloading PrismLauncher AppImage version ${pkgver}..."
mkdir -p "$APPIMAGE_DST"
if ! wget -q --show-progress -O "$APPIMAGE_FILE" "$download_url"; then
  echo "❌ Failed to download AppImage from:"
  echo "$download_url"
  exit 1
fi
chmod +x "$APPIMAGE_FILE"

# ── Install Icon ───────────────────────────────────────────
echo "🖼️ Installing icon..."
install -Dm644 "$SCRIPT_DIR/$ICON_NAME" "$ICON_DST/kapymine.png"

# ── Install Launcher Wrapper ───────────────────────────────
echo "📜 Installing launcher wrapper..."
install -Dm755 "$SCRIPT_DIR/$WRAPPER_SCRIPT" "$WRAPPER_DST"

# ── Install Desktop Shortcut ───────────────────────────────
echo "🔗 Installing desktop entry..."
mkdir -p "$USER_HOME/.local/share/applications"
sed "s|%EXEC%|$WRAPPER_DST|g; s|%ICON%|kapymine|g" "$SCRIPT_DIR/$DESKTOP_TEMPLATE" > "$DESKTOP_FINAL"
chmod +x "$DESKTOP_FINAL"

# ── Refresh Icon Cache ─────────────────────────────────────
echo "🔄 Refreshing icon cache..."
gtk-update-icon-cache -f /usr/share/icons/hicolor || true

# ── Done ───────────────────────────────────────────────────
echo "✅ Kapymine Launcher (v$pkgver) installed successfully!"
echo "🎮 Launch it from your app menu or run: kapymine-launcher"

