#!/usr/bin/env bash

set -e

REPO_URL="https://github.com/yourname/shardprune.git"
ADDON_NAME="ShardPrune"

# Change this if needed
WOW_ADDONS_DIR="$HOME/Games/battlenet/drive_c/Program Files (x86)/World of Warcraft/_anniversary_/Interface/AddOns"

INSTALL_DIR="$WOW_ADDONS_DIR/$ADDON_NAME"

# Ensure AddOns dir exists
if [ ! -d "$WOW_ADDONS_DIR" ]; then
    echo "ERROR: AddOns directory not found at:"
    echo "  $WOW_ADDONS_DIR"
    exit 1
fi

echo "Copying addon..."
cp -r "$ADDON_NAME" "$INSTALL_DIR"

echo "Done! Addon installed."
