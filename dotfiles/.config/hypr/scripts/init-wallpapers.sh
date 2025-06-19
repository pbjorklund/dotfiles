#!/bin/bash
# Dynamic wallpaper initialization script for Hyprland
# Sets default wallpapers on all monitors using stable descriptions
#
# Monitor Hardware Setup:
# - main: Acer XZ321QU ultrawide (3440x1440, landscape, primary display)
# - portrait: Acer XV240Y P (1920x1080, rotated 90° portrait orientation)
# - laptop: BOE 0x094C (built-in laptop display, may not always be connected)
#
# Technical Notes:
# - Uses monitor descriptions for stable identification across sessions
# - Monitor IDs can change but descriptions remain constant
# - Script dynamically finds current connector names from descriptions
# - Gracefully handles disconnected monitors by checking if connector exists

WALLPAPER_DIR="$HOME/.config/hypr/wallpapers"

# Function to find current connector name by monitor description
find_monitor_connector() {
    local target_desc="$1"
    hyprctl monitors -j | jq -r ".[] | select(.description == \"$target_desc\") | .name"
}

# Kill any existing swaybg processes
pkill swaybg 2>/dev/null || true

# Wait a moment for processes to clean up
sleep 0.5

# Set wallpaper for main monitor (XZ321QU)
MAIN_DESC="Acer Technologies Acer XZ321QU 0x9372982E"
MAIN_MONITOR=$(find_monitor_connector "$MAIN_DESC")
if [[ -n "$MAIN_MONITOR" ]]; then
    swaybg -o "$MAIN_MONITOR" -i "$WALLPAPER_DIR/main.jpg" -m fill &
    echo "Set main wallpaper on $MAIN_MONITOR"
fi

# Set wallpaper for portrait monitor (XV240Y P)
PORTRAIT_DESC="Acer Technologies XV240Y P 0x944166C5"
PORTRAIT_MONITOR=$(find_monitor_connector "$PORTRAIT_DESC")
if [[ -n "$PORTRAIT_MONITOR" ]]; then
    swaybg -o "$PORTRAIT_MONITOR" -i "$WALLPAPER_DIR/portrait2.jpg" -m fill &
    echo "Set portrait wallpaper on $PORTRAIT_MONITOR"
fi

# Set wallpaper for laptop monitor (if connected)
LAPTOP_DESC="BOE 0x094C"
LAPTOP_MONITOR=$(find_monitor_connector "$LAPTOP_DESC")
if [[ -n "$LAPTOP_MONITOR" ]]; then
    swaybg -o "$LAPTOP_MONITOR" -i "$WALLPAPER_DIR/main.jpg" -m fill &
    echo "Set laptop wallpaper on $LAPTOP_MONITOR"
fi

echo "Wallpaper initialization complete"
