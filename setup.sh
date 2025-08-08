#!/usr/bin/env bash

ujust devmode
ujust bluefin-cli
ujust dx-group
ujust toggle-tailscale
ujust install-system-flatpaks

xargs flatpak install -y < flatpaks.txt
./install_extensions.sh
curl -fsSl https://pkg.cloudflareclient.com/cloudflare-warp-ascii.repo | sudo tee /etc/yum.repos.d/cloudflare-warp.repo
rpm-ostree install cloudflare-warp
echo "Reboot the system and run post_setup.sh to complete setup."
