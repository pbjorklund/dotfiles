#!/bin/bash
# Hyprland Resume Monitor - watches for system resume events
# and ensures lid state is properly handled

set -euo pipefail

readonly RESUME_TRIGGER="/tmp/hypr-resume-trigger"
readonly LID_SCRIPT="$HOME/dotfiles/dotfiles/.config/hypr/scripts/lid-switch.sh"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Resume Monitor: $*" | systemd-cat -t hypr-resume-monitor
}

# Monitor for resume trigger file
monitor_resume() {
    while true; do
        if [[ -f "$RESUME_TRIGGER" ]]; then
            log "Resume event detected"

            # Remove trigger immediately to prevent multiple processing
            rm -f "$RESUME_TRIGGER" 2>/dev/null || log "Warning: Could not remove resume trigger file"

            # Give the system more time to stabilize
            log "Waiting for system to stabilize after resume..."
            sleep 5

            # Run the wake handler
            if [[ -x "$LID_SCRIPT" ]]; then
                log "Executing wake handler..."
                "$LID_SCRIPT" wake
                log "Wake handler executed successfully"
            else
                log "Warning: Lid script not found or not executable: $LID_SCRIPT"
            fi
        fi

        sleep 1
    done
}

log "Starting resume monitor"
monitor_resume
