#!/bin/bash
# Smart wallpaper cycling script for Hyprland - dynamically finds monitors by description
# Usage: cycle-wallpaper.sh <portrait|main|laptop>

WALLPAPER_DIR="$HOME/.config/hypr/wallpapers"

# Function to find current connector name by monitor description
find_monitor_connector() {
    local target_desc="$1"
    hyprctl monitors -j | jq -r ".[] | select(.description == \"$target_desc\") | .name"
}

case "$1" in
laptop)
    # Laptop monitor - find current connector for BOE display
    TARGET_DESC="BOE 0x094C"
    MONITOR=$(find_monitor_connector "$TARGET_DESC")
    WALLPAPERS=($(find "$WALLPAPER_DIR" -name 'laptop*' -o -name 'main*' | grep -E '\.(jpg|webp|png)$' | sort))
    ;;
portrait)
    # Portrait monitor - find current connector for XV240Y P
    TARGET_DESC="Acer Technologies XV240Y P 0x944166C5"
    MONITOR=$(find_monitor_connector "$TARGET_DESC")
    WALLPAPERS=($(find "$WALLPAPER_DIR" -name 'portrait*' | grep -E '\.(jpg|webp|png)$' | sort))
    ;;
main)
    # Main monitor - find current connector for XZ321QU
    TARGET_DESC="Acer Technologies Acer XZ321QU 0x9372982E"
    MONITOR=$(find_monitor_connector "$TARGET_DESC")
    WALLPAPERS=($(find "$WALLPAPER_DIR" -name 'main*' -o -name 'work*' | grep -E '\.(jpg|webp|png)$' | sort))
    ;;
ultra)
    # Ultra-wide monitor - find current connector for Samsung SE790C
    TARGET_DESC="Samsung Electric Company SE790C HTRH401237"
    MONITOR=$(find_monitor_connector "$TARGET_DESC")
    WALLPAPERS=($(find "$WALLPAPER_DIR" -name 'main*' | grep -E '\.(jpg|webp|png)$' | sort))
    ;;
*)
    echo "Usage: $0 <laptop|portrait|main>"
    echo "  laptop   - BOE laptop display (any connector)"
    echo "  portrait - XV240Y P portrait monitor (any connector)"
    echo "  main     - XZ321QU main monitor (any connector)"
    echo "  ultra    - Samsung SE790C ultra-wide monitor (any connector)"
    exit 1
    ;;
esac

if [[ -z "$MONITOR" ]]; then
    echo "Monitor not found for type: $1"
    exit 1
fi

if [[ ${#WALLPAPERS[@]} -eq 0 ]]; then
    echo "No wallpapers found for monitor type: $1"
    exit 1
fi

# Kill existing swaybg for this monitor
pkill -f "swaybg.*$MONITOR" 2>/dev/null || true

# Select random wallpaper
WALLPAPER="${WALLPAPERS[$RANDOM % ${#WALLPAPERS[@]}]}"

# Apply wallpaper using the dynamically found connector name
swaybg -o "$MONITOR" -i "$WALLPAPER" -m fill &

echo "Applied wallpaper: $(basename "$WALLPAPER") to $MONITOR ($1 monitor)"
