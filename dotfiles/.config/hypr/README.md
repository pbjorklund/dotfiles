# Hyprland Lid Switch Configuration

Smart docking-aware power management for ThinkPad X1 Carbon Gen 11.

## Features

- **Docking Detection**: Automatically detects external monitors
- **Power Management**: Intelligent sleep/wake behavior based on dock status
- **Display Management**: Proper laptop display handling for all scenarios
- **State Persistence**: Remembers lid state across sleep/wake cycles

## Behavior

### Lid Closed Scenarios

- **Undocked + Lid Closed**: Locks screen and suspends system
- **Docked + Lid Closed**: Disables laptop display only, keeps system running

### Lid Opened Scenarios

- **Lid Opened**: Always re-enables laptop display

### Wake from Sleep Scenarios

- **Wake + Lid Closed + Docked**: Keeps laptop display disabled
- **Wake + Lid Closed + Undocked**: Re-enables laptop display (shouldn't happen)
- **Wake + Lid Open**: Ensures laptop display is enabled

## Files

- **`hyprland.conf`**: Main configuration with lid switch bindings and Super+L lock keybinding
- **`scripts/lid-switch.sh`**: Smart lid switch handler script
- **`hyprlock.conf`**: Screen locker configuration with modern styling

## Prerequisites

- `jq` - JSON parsing for monitor detection
- `hyprctl` - Hyprland control utility
- `hyprlock` - Screen locker for Hyprland
- `systemctl` - System control for suspend

## Installation

### Install Required Packages

```bash
$ sudo dnf install -y jq hyprlock
```

The configuration is automatically active when using this dotfiles setup.

## Usage

### Manual Screen Lock

- **Super+L**: Lock screen immediately using hyprlock

### Automatic Behavior

The lid switch behavior is handled automatically based on docking status and lid position.

## Troubleshooting

### Check Lid State

```bash
$ cat /tmp/hypr-lid-state
```

### Check Connected Monitors

```bash
$ hyprctl monitors -j | jq -r '.[].name'
```

### Manual Script Testing

```bash
$ ~/.config/hypr/scripts/lid-switch.sh wake
$ ~/.config/hypr/scripts/lid-switch.sh close
$ ~/.config/hypr/scripts/lid-switch.sh open
```

### View Logs

```bash
$ journalctl -t hypr-lid-switch -f
```

## Supported Hardware

- ThinkPad X1 Carbon Gen 11
- Any laptop with `eDP-1` internal display
- External monitors via USB-C dock or direct connection
