# Tmux Bell Investigation - OpenCode Notifications

## Goal
Trigger tmux bell indicators on the OpenCode window when a session completes, so the window shows a bell icon (🔔) and yellow background when viewed from other windows.

## Problem Statement
When OpenCode session completes, we want:
1. Immediate mako notification (✅ working)
2. Visual bell indicator on the OpenCode tmux window tab when viewing other windows
3. Bell stays until user returns to the OpenCode window

## Key Discovery: Hook Context Issue
🚨 **Critical Issue**: OpenCode hooks run in background process context, NOT within the tmux window itself. This means:
- Manual `printf '\a'` in tmux window = works ✅
- `printf '\a'` in OpenCode hook script = doesn't work ❌

## Tests Performed (Human Verified)

### ✅ Test 1: Manual Bell in Tmux Window
**Command**: `printf '\a'` followed by 15-second delay
**Result**: SUCCESS - Bell indicator appeared on window 1 when viewing from window 2
**Context**: Executed directly in tmux window 1 (OpenCode session)

### ❌ Tests NOT Yet Verified with Sleep Methodology
- OpenCode hook script execution
- `tmux send-keys` approaches
- External script targeting specific windows
- Background process bell triggers

## Technical Understanding

### How Tmux Bells Work
- Bells only show on **inactive windows** (not current window)
- Bell character must originate from within the tmux session/window
- Bell flags persist until user switches back to that window

### OpenCode Hook Context
- Hooks execute as separate background processes
- Not connected to the original tmux window context
- Need to explicitly target tmux window from external process

## Potential Solutions to Test

### Solution 1: Target Tmux Window from Hook
Use `tmux send-keys` to send bell command TO the specific window:
```bash
tmux send-keys -t "session:window" 'printf "\\a"' Enter
```

### Solution 2: Tmux Run-Shell Command
Execute bell within tmux context:
```bash
tmux run-shell -t "session:window" 'printf "\\a"'
```

### Solution 3: Direct Window Targeting
Send bell directly to pane:
```bash
tmux send-keys -t "session:window.pane" 'printf "\\a"' Enter
```

## Current Configuration Status

### ✅ Working Components
- Mako notifications via `notify-send`
- Tmux bell monitoring: `monitor-bell on`
- Bell styling: yellow background configured
- Bell action: `bell-action other`
- Filtered notifications: "opencode-bell" windows ignored

### ❌ Not Working
- OpenCode hook bell triggering (context issue)

## Final Decision

After extensive testing, **OpenCode tmux bell integration is not feasible** due to hook context limitations:

### ✅ What Works
- Manual `printf '\a'` in tmux window
- Temporary window approach (creates unwanted extra windows)
- Claude Code bell hooks (proper terminal context)
- Mako desktop notifications

### ❌ What Doesn't Work for OpenCode
- Hook-triggered bells (wrong process context)
- `tmux send-keys` from hooks
- `tmux run-shell` from hooks
- `tmux display-message` with bell

### **Final Solution**
1. **OpenCode**: Enhanced mako notifications only (no tmux bells)
2. **Claude Code**: Keep existing tmux bell hooks (they work properly)
3. **Result**: Clear, prominent desktop notifications for OpenCode completions

### Implementation
- Removed tmux bell code from `dev-notify.sh`
- Enhanced mako notifications: longer timeout, normal urgency
- Kept Claude Code tmux integration intact