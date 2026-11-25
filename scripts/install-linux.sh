#!/usr/bin/env bash
# Installs the packaged Linux app for the current user and adds it to the app launcher.
# Run `npm run package:linux` first, or use `npm run install:linux` to do both.
set -euo pipefail

root="$(cd "$(dirname "$0")/.." && pwd)"
build="$root/release/Vault-linux-x64"
dest="${XDG_DATA_HOME:-$HOME/.local/share}"
app_dir="$HOME/.local/opt/Vault"

if [[ ! -x "$build/Vault" ]]; then
  echo "No build found at $build. Run: npm run package:linux" >&2
  exit 1
fi

rm -rf "$app_dir"
mkdir -p "$(dirname "$app_dir")" "$dest/applications" "$dest/icons/hicolor/scalable/apps"
cp -r "$build" "$app_dir"
cp "$root/public/favicon.svg" "$dest/icons/hicolor/scalable/apps/vault-app.svg"

cat > "$dest/applications/vault-app.desktop" <<EOF
[Desktop Entry]
Type=Application
Name=Vault
GenericName=Password Manager
Comment=Encrypted password manager
Keywords=password;passwords;login;2fa;totp;vault;
Exec=$app_dir/Vault %U
Icon=vault-app
Terminal=false
Categories=Utility;Security;
StartupWMClass=Vault
EOF

update-desktop-database "$dest/applications" 2>/dev/null || true
gtk-update-icon-cache -q -t "$dest/icons/hicolor" 2>/dev/null || true

echo "Installed Vault to $app_dir"
echo "Search for \"Vault\" in your app launcher."
