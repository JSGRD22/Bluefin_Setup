#!/usr/bin/env bash
set -euo pipefail

EXTENSION_IDS=(779 5982 1720)
FULL_VERSION=$(gnome-shell --version | awk '{print $3}')
MAJOR_VERSION=$(echo "$FULL_VERSION" | cut -d. -f1)
UUIDS=()

echo "Detected GNOME Shell major version: $MAJOR_VERSION"

for EXT_ID in "${EXTENSION_IDS[@]}"; do
    INFO=""
    INFO=$(wget -qO- "https://extensions.gnome.org/extension-info?pk=$EXT_ID&shell_version=$MAJOR_VERSION" || echo "")
    if [[ -z "$INFO" || "$INFO" == "null" ]]; then
        echo "No compatible extension found for ID $EXT_ID and GNOME Shell major version $MAJOR_VERSION"
        continue
    fi

    DOWNLOAD_URL=$(echo "$INFO" | jq -r '.download_url')
    UUID=$(echo "$INFO" | jq -r '.uuid')
    UUIDS+=("$UUID")

    ZIP_FILE="${UUID}.zip"
    echo "Downloading extension $UUID..."
    wget -qO "$ZIP_FILE" "https://extensions.gnome.org${DOWNLOAD_URL}"

    echo "Installing extension $UUID..."
    gnome-extensions install "$ZIP_FILE" --force

    rm "$ZIP_FILE"
done

if [[ ${#UUIDS[@]} -eq 0 ]]; then
    echo "No extensions installed. Exiting."
    exit 1
fi

echo
echo "Installed extensions:"
printf '%s\n' "${UUIDS[@]}"
echo
echo "Reload the Gnome Shell and run setup_extensions.sh for changes to take effect"
