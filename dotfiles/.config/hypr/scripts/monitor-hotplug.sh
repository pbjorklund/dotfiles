#!/bin/bash
# Monitor hotplug detector for Hyprland
# Watches for monitor configuration changes and maintains lid state

set -euo pipefail

readonly LID_SCRIPT="$HOME/dotfiles/dotfiles/.config/hypr/scripts/lid-switch.sh"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Monitor Hotplug: $*" | systemd-cat -t hypr-monitor-hotplug
}

# Get current monitor list
get_monitor_list() {
    hyprctl monitors -j | jq -r '.[].name' | sort
}

# Monitor for changes
monitor_changes() {
    local last_monitors
    last_monitors=$(get_monitor_list)

    while true; do
        sleep 2
        local current_monitors
        current_monitors=$(get_monitor_list)

        if [[ "$current_monitors" != "$last_monitors" ]]; then
            log "Monitor configuration changed"
            log "Previous: $last_monitors"
            log "Current: $current_monitors"

            # Give the system time to stabilize
            sleep 1

            # Call the hotplug handler
            if [[ -x "$LID_SCRIPT" ]]; then
                "$LID_SCRIPT" hotplug
            fi

            last_monitors="$current_monitors"
        fi
    done
}

log "Starting monitor hotplug detector"
monitor_changes
