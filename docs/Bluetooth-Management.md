# Bluetooth Management in Hyprland

Bluetooth integration for Hyprland that leverages your existing GNOME Bluetooth setup with additional Hyprland-specific tools and shortcuts.

## Features

- **Leverages Existing GNOME Setup**: Uses your existing BlueZ configuration and paired devices
- **Dual GUI Options**: GNOME Control Center (primary) + Blueman (tiling WM optimized)
- **Waybar Integration**: Real-time Bluetooth status with device info
- **Keyboard Shortcuts**: Quick toggle and device management
- **Command Line Tools**: Comprehensive CLI management script
- **Seamless Switching**: Works with devices already paired in GNOME

## Installation

The Bluetooth integration is part of the system automation setup. See the [ansible-fedora](https://github.com/pbjorklund/ansible-fedora) repository for automated installation:

```bash
# In the ansible-fedora project
ansible-playbook hyprland-desktop.ansible.yml
# Or install Bluetooth integration separately:
ansible-playbook bluetooth-hyprland.ansible.yml
```

## Keyboard Shortcuts

| Shortcut            | Action                    |
| ------------------- | ------------------------- |
| `Super + T`         | Open Bluetooth quick menu |
| `Super + Shift + T` | Toggle Bluetooth power    |

## Waybar Integration

The Waybar shows real-time Bluetooth status with the following icons:

- `󰂲` - Bluetooth disabled/off
- `󰂯` - Bluetooth enabled (no connections)
- `󰂱` - Connected to device(s)

**Waybar Actions:**

- **Left Click**: Open GNOME Bluetooth settings
- **Right Click**: Toggle Bluetooth power

## Command Line Management

Use the included management script for comprehensive control:

```bash
# Quick toggle
~/.config/hypr/scripts/bluetooth-manager.sh toggle

# Scan for devices
~/.config/hypr/scripts/bluetooth-manager.sh scan

# Show connected devices
~/.config/hypr/scripts/bluetooth-manager.sh connected

# Interactive menu (requires wofi)
~/.config/hypr/scripts/bluetooth-manager.sh menu

# Open GUI
~/.config/hypr/scripts/bluetooth-manager.sh gui
```

### Available Commands

| Command            | Description                          |
| ------------------ | ------------------------------------ |
| `toggle`, `t`      | Toggle Bluetooth power               |
| `on`               | Turn Bluetooth on                    |
| `off`              | Turn Bluetooth off                   |
| `scan`, `s`        | Scan for available devices           |
| `list`, `l`        | List all devices                     |
| `connected`, `c`   | Show connected devices               |
| `connect <MAC>`    | Connect to device by MAC address     |
| `disconnect <MAC>` | Disconnect device by MAC address     |
| `pair <MAC>`       | Pair with device by MAC address      |
| `menu`, `m`        | Show interactive menu                |
| `gui`              | Open GUI (GNOME Settings or Blueman) |
| `gnome`            | Open GNOME Bluetooth settings        |
| `blueman`          | Open Blueman manager                 |
| `status`           | Show current status                  |

## Device Management

### Pairing New Devices

1. **GUI Method**:

   - Click Bluetooth icon in Waybar → Opens GNOME Settings
   - Or use `Super + T` → "Open GNOME Settings"
   - Click "+" to add new device
   - Follow pairing wizard

2. **Alternative GUI (Blueman)**:

   - Use `Super + T` → "Open Blueman"
   - More tiling-WM friendly interface
   - System tray integration

3. **Command Line**:

   ```bash
   # Start scanning
   bluetoothctl scan on

   # Pair with device
   bluetoothctl pair 00:11:22:33:44:55

   # Trust device (auto-connect)
   bluetoothctl trust 00:11:22:33:44:55

   # Connect
   bluetoothctl connect 00:11:22:33:44:55
   ```

### Audio Devices

High-quality audio codecs are already supported through your existing GNOME setup:

- **aptX**: Superior quality for compatible headphones (if supported)
- **SBC**: Universal compatibility
- **A2DP**: Advanced Audio Distribution Profile

PipeWire automatically handles codec selection and switching between devices.

## Configuration

### Existing GNOME Setup

This integration leverages your existing GNOME Bluetooth configuration:

- **Uses current BlueZ settings**: No modifications to working setup
- **Preserves paired devices**: All your existing devices continue to work
- **Maintains audio codecs**: PipeWire configuration remains unchanged
- **No system conflicts**: Safe to switch between GNOME and Hyprland

### User Permissions

Your existing user permissions are maintained - no changes needed.

## Troubleshooting

### Bluetooth Not Working

1. **Check service status**:

   ```bash
   systemctl status bluetooth
   ```

2. **Restart Bluetooth service**:

   ```bash
   sudo systemctl restart bluetooth
   ```

3. **Check if device is blocked**:
   ```bash
   rfkill list bluetooth
   # If blocked, unblock:
   rfkill unblock bluetooth
   ```

### Device Won't Connect

1. **Remove and re-pair device**:

   ```bash
   bluetoothctl remove 00:11:22:33:44:55
   bluetoothctl scan on
   bluetoothctl pair 00:11:22:33:44:55
   ```

2. **Check device compatibility**:
   ```bash
   bluetoothctl info 00:11:22:33:44:55
   ```

### Audio Issues

1. **Check PipeWire status**:

   ```bash
   systemctl --user status pipewire
   systemctl --user status wireplumber
   ```

2. **Switch audio output**:

   - Use `pavucontrol` GUI
   - Or: `wpctl set-default <device_id>`

3. **Check available audio devices**:
   ```bash
   wpctl status
   ```

## GUI Applications

### Blueman (Primary)

Modern Bluetooth manager with system tray integration:

- Device pairing wizard
- Connection management
- System tray notifications
- File transfer support
- Network features

### GNOME Bluetooth Tools

System integration tools:

- Settings panel integration
- Desktop notifications
- Core Bluetooth libraries

## Integration with Other Components

### Waybar

- Real-time status updates
- Device connection info
- Battery levels for supported devices
- Click actions for quick management

### Hyprland

- Keyboard shortcuts for quick access
- Integration with wofi application launcher
- Notification support via mako

### PipeWire Audio

- Automatic audio routing
- High-quality codec support
- Seamless switching between devices
- Multiple simultaneous audio streams

## Supported Devices

- **Audio**: Headphones, speakers, earbuds
- **Input**: Mice, keyboards, trackpads
- **Mobile**: Phones, tablets (file transfer)
- **Gaming**: Controllers (with additional drivers)

## Security Notes

- Bluetooth is configured for balanced security and usability
- Devices require explicit pairing before connection
- Trusted devices can auto-connect
- Experimental features are enabled for better compatibility

## Files Modified

- `/etc/bluetooth/main.conf` - BlueZ configuration
- `~/.config/waybar/config.jsonc` - Waybar Bluetooth module
- `~/.config/waybar/style.css` - Bluetooth styling
- `~/.config/hypr/conf/keybindings.conf` - Keyboard shortcuts
- `~/.config/hypr/scripts/bluetooth-manager.sh` - Management script
