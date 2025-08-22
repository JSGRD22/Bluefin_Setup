#!/usr/bin/env bash
set -euo pipefail

LIST1="https://raw.githubusercontent.com/ublue-os/bluefin/main/flatpaks/system-flatpaks.list"
LIST2="https://raw.githubusercontent.com/ublue-os/bluefin/main/flatpaks/system-flatpaks-dx.list"

normalize_bluefin_ids() {
  curl -fsSL "$LIST1" "$LIST2" \
    | sed -E 's@^(app/|runtime/)@@' \
    | sort -u
}

flatpak list --columns=application --app \
  | sort -u \
  | grep -xvFf <(normalize_bluefin_ids) \
  > flatpaks.txt
