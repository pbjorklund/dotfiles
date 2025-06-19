#!/bin/bash
# Simple wallpaper cycling script for Hyprland
# Usage: cycle-wallpaper.sh <monitor_number>

WALLPAPER_DIR="$HOME/.config/hypr/wallpapers"

case "$1" in
1)
    # DVI-I-2 portrait - portrait wallpapers
    MONITOR="DVI-I-2"
    WALLPAPERS=($(find "$WALLPAPER_DIR" -name 'portrait*' | grep -E '\.(jpg|webp|png)$' | sort))
    ;;
2)
    # DVI-I-1 - desktop wallpapers
    MONITOR="DVI-I-1"
    WALLPAPERS=($(find "$WALLPAPER_DIR" -name 'main*' -o -name 'work*' | grep -E '\.(jpg|webp|png)$' | sort))
    ;;
*)
    echo "Usage: $0 <1|2|3>"
    echo "  1 - DVI-I-2"
    echo "  2 - DVI-I-1 portrait"
    exit 1
    ;;
esac

if [[ ${#WALLPAPERS[@]} -eq 0 ]]; then
    echo "No wallpapers found for monitor $1"
    exit 1
fi

# Kill existing swaybg for this monitor
pkill -f "swaybg.*$MONITOR" 2>/dev/null || true

# Select random wallpaper
WALLPAPER="${WALLPAPERS[$RANDOM % ${#WALLPAPERS[@]}]}"

# Apply wallpaper
swaybg -o "$MONITOR" -i "$WALLPAPER" -m fill &

echo "Applied wallpaper: $(basename "$WALLPAPER") to $MONITOR"
