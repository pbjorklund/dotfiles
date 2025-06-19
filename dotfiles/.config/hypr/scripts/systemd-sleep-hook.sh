#!/bin/bash
# Simple systemd sleep hook that triggers user-space resume handling
# This works around the complexity of calling Hyprland from root context

set -euo pipefail

readonly RESUME_TRIGGER="/tmp/hypr-resume-trigger"

case "$1/$2" in
pre/*)
    # Before suspend - nothing special needed
    ;;
post/*)
    # After resume - create trigger file for user service to pick up
    touch "$RESUME_TRIGGER"
    chmod 666 "$RESUME_TRIGGER"
    ;;
esac
