#!/bin/bash

# Universal notification script for Claude Code and OpenCode
# Supports both JSON input (Claude Code) and command line arguments (OpenCode)

# Check if arguments were passed (OpenCode format)
if [ $# -gt 0 ]; then
    # OpenCode format: script.sh "title" "message" "urgency"
    title="${1:-Code Notification}"
    message="${2:-Notification received}"
    urgency="${3:-normal}"
    hook_event="opencode"
    session_id="opencode"
else
    # Claude Code format: JSON input from stdin
    input=$(cat)
    
    # Parse the notification message and session info
    message=$(echo "$input" | jq -r '.message // "Claude Code notification"')
    session_id=$(echo "$input" | jq -r '.session_id // "unknown"')
    hook_event=$(echo "$input" | jq -r '.hook_event_name // "notification"')
    title="Claude Code"
    urgency="normal"
fi

# Determine notification icon and timeout based on message content
icon="dialog-information"
timeout=5000

# Customize notification based on message content and urgency
if echo "$message" | grep -qi "permission"; then
    urgency="critical"
    icon="dialog-warning"
    timeout=0  # Don't auto-dismiss permission requests
elif echo "$message" | grep -qi "waiting.*input"; then
    urgency="normal"
    icon="dialog-question"
    timeout=10000
elif echo "$message" | grep -qi "error\|fail"; then
    urgency="critical"
    icon="dialog-error"
    timeout=8000
elif echo "$message" | grep -qi "complete\|done\|success"; then
    urgency="low"
    icon="dialog-information"
    timeout=3000
elif [ "$urgency" = "critical" ]; then
    icon="dialog-error"
    timeout=8000
elif [ "$urgency" = "low" ]; then
    icon="dialog-information"
    timeout=3000
fi

# Format the title for Claude Code sessions
if [ "$hook_event" != "opencode" ] && [ "$session_id" != "unknown" ]; then
    # Show last 8 characters of session ID
    short_session=$(echo "$session_id" | tail -c 9)
    title="Claude Code ($short_session)"
fi

# Send notification to mako
notify-send "$title" "$message" \
    -u "$urgency" \
    -i "$icon" \
    -t "$timeout" \
    -a "claude-opencode" \
    -c "development"

# Trigger tmux bell if we're in a tmux session and this is a session completion
if [ -n "$TMUX" ] && echo "$message" | grep -qi "complete\|done\|success\|finished"; then
    # Send bell character to terminal
    echo -ne '\a'
    
    # Also try sending it via tmux
    tmux send-keys -t $(tmux display -p '#S:#I.#P') 'C-g' 2>/dev/null || true
fi

# Log the notification for debugging (optional)
if [ "${CLAUDE_NOTIFY_DEBUG:-}" = "1" ]; then
    echo "$(date '+%Y-%m-%d %H:%M:%S') [$hook_event] $title: $message" >> ~/.claude/notifications.log
fi