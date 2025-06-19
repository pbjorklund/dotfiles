#!/bin/bash
# Wallpaper Manager for Hyprland using swaybg
# Multi-monitor wallpaper management with per-monitor assignments
# Usage: wallpaper-manager.sh [start|reload|set <wallpaper>]

WALLPAPER_DIR="$HOME/.config/hypr/wallpapers"

# Default wallpapers per monitor
declare -A MONITOR_WALLPAPERS=(
    ["default"]="main.jpg"
    ["Samsung Electric Company SE790C"]="work.jpg"  # 43" ultrawide 3440x1440
    ["DVI-I-2"]="main.jpg"                         # 32" 2560x1440 Acer monitor  
    ["DVI-I-1"]="portrait.jpg"                     # 27" acer 1920x1080@144 in portrait mode
)

# Function to kill all existing swaybg processes
kill_swaybg() {
    pkill swaybg 2>/dev/null || true
}

# Function to get connected monitors
get_monitors() {
    hyprctl monitors -j | jq -r '.[].name'
}

# Function to get monitor description
get_monitor_desc() {
    local monitor_name="$1"
    hyprctl monitors -j | jq -r ".[] | select(.name == \"$monitor_name\") | .description"
}

# Function to start wallpapers for all monitors
start_wallpapers() {
    if ! check_wallpaper_dir; then
        return 1
    fi
    
    echo "Starting wallpapers for all monitors..."
    kill_swaybg
    sleep 0.5
    
    # Get list of connected monitors
    while IFS= read -r monitor; do
        local wallpaper_file="${MONITOR_WALLPAPERS[default]}"
        local monitor_desc
        
        # Try to get monitor description for matching
        monitor_desc=$(get_monitor_desc "$monitor" 2>/dev/null || echo "")
        
        # Check if we have a specific wallpaper for this monitor by name
        if [[ -n "${MONITOR_WALLPAPERS[$monitor]}" ]]; then
            wallpaper_file="${MONITOR_WALLPAPERS[$monitor]}"
        # Check if we have a specific wallpaper for this monitor by description
        elif [[ -n "$monitor_desc" && -n "${MONITOR_WALLPAPERS[$monitor_desc]}" ]]; then
            wallpaper_file="${MONITOR_WALLPAPERS[$monitor_desc]}"
        fi
        
        local wallpaper_path="$WALLPAPER_DIR/$wallpaper_file"
        
        if [[ -f "$wallpaper_path" ]]; then
            echo "Setting wallpaper for monitor $monitor: $wallpaper_file"
            swaybg -o "$monitor" -i "$wallpaper_path" -m fill &
        else
            echo "Warning: Wallpaper not found: $wallpaper_path"
            # Fallback to main.jpg
            if [[ -f "$WALLPAPER_DIR/main.jpg" ]]; then
                swaybg -o "$monitor" -i "$WALLPAPER_DIR/main.jpg" -m fill &
            fi
        fi
    done < <(get_monitors)
    
    echo "Wallpapers started for all monitors"
}

# Function to set wallpaper for all monitors
set_wallpaper_all() {
    local wallpaper_name="$1"
    local wallpaper_path="$WALLPAPER_DIR/$wallpaper_name"
    
    if [[ ! -f "$wallpaper_path" ]]; then
        echo "Error: Wallpaper not found: $wallpaper_path"
        return 1
    fi
    
    echo "Setting wallpaper for all monitors: $wallpaper_name"
    kill_swaybg
    sleep 0.5
    
    while IFS= read -r monitor; do
        swaybg -o "$monitor" -i "$wallpaper_path" -m fill &
    done < <(get_monitors)
    
    echo "Wallpaper set for all monitors: $wallpaper_name"
}

# Function to cycle through wallpapers
cycle_wallpaper() {
    local wallpapers=($(find "$WALLPAPER_DIR" -maxdepth 1 -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" -o -name "*.webp" \) | sort))
    
    if [[ ${#wallpapers[@]} -eq 0 ]]; then
        echo "No wallpapers found in $WALLPAPER_DIR"
        return 1
    fi
    
    # Get current wallpaper (simplified - just use first one found)
    local current_wallpaper
    current_wallpaper=$(pgrep -af swaybg | head -1 | grep -o '[^/]*\.\(jpg\|jpeg\|png\|webp\)' | head -1)
    
    # Find next wallpaper
    local next_wallpaper="${wallpapers[0]}"
    for i in "${!wallpapers[@]}"; do
        if [[ "${wallpapers[i]}" == *"$current_wallpaper" && $((i + 1)) -lt ${#wallpapers[@]} ]]; then
            next_wallpaper="${wallpapers[$((i + 1))]}"
            break
        fi
    done
    
    set_wallpaper_all "$(basename "$next_wallpaper")"
}

# Function to check if wallpaper directory exists and has images
check_wallpaper_dir() {
    if [[ ! -d "$WALLPAPER_DIR" ]]; then
        echo "Error: Wallpaper directory does not exist: $WALLPAPER_DIR"
        return 1
    fi
    
    local count=$(find "$WALLPAPER_DIR" -maxdepth 1 -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" -o -name "*.webp" \) | wc -l)
    if [[ $count -eq 0 ]]; then
        echo "Error: No image files found in wallpaper directory: $WALLPAPER_DIR"
        return 1
    fi
    return 0
}

# Main logic
case "${1:-start}" in
    "start")
        start_wallpapers
        ;;
    "reload")
        start_wallpapers
        ;;
    "set")
        if [[ -z "$2" ]]; then
            echo "Usage: $0 set <wallpaper_filename>"
            exit 1
        fi
        set_wallpaper_all "$2"
        ;;
    "cycle")
        cycle_wallpaper
        ;;
    *)
        echo "Usage: $0 {start|reload|set <wallpaper>|cycle}"
        echo "  start  - Set monitor-specific wallpapers on startup"
        echo "  reload - Restart wallpapers (same as start)"
        echo "  set    - Set specific wallpaper for all monitors"
        echo "  cycle  - Cycle through available wallpapers"
        exit 1
        ;;
esac
