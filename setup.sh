#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

ujust devmode
ujust bluefin-cli
ujust toggle-tailscale
ujust install-system-flatpaks

xargs flatpak install -y < "$SCRIPT_DIR/flatpaks.txt"
"$SCRIPT_DIR/install_extensions.sh"

curl -fsSl https://pkg.cloudflareclient.com/cloudflare-warp-ascii.repo \
    | sudo tee /etc/yum.repos.d/cloudflare-warp.repo
rpm-ostree install cloudflare-warp

mkdir -p "$HOME/.config/autostart"
DESKTOP_FILE="$HOME/.config/autostart/post_setup_once.desktop"

# Create .desktop file to run post_setup.sh in SCRIPT_DIR in a terminal after next login
cat > "$DESKTOP_FILE" <<EOF
[Desktop Entry]
Type=Application
Exec=bash -c 'ptyxis -- bash -c "cd $SCRIPT_DIR && ./post_setup.sh; rm -f $DESKTOP_FILE"'
Hidden=false
X-GNOME-Autostart-enabled=true
Name=Post Setup
EOF

echo "Post-setup will run automatically after your next login."
echo "Please reboot the system now to complete setup."

