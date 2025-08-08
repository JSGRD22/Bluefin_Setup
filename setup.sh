#!/usr/bin/env bash

ujust devmode
ujust bluefin-cli
ujust dx-group
ujust toggle-tailscale
ujust install-system-flatpaks

xargs flatpak install -y < flatpaks.txt
./install_extensions.sh
