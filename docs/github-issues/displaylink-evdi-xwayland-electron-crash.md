# XWayland + Electron Apps Crash with SIGILL when DisplayLink Monitors Connected

## Summary

Electron applications crash on startup with `SIGILL` (illegal instruction) when DisplayLink monitors are connected to the system and running under XWayland. This affects all Electron apps including VS Code, Obsidian, Discord, etc.

## Environment

- **OS**: Fedora 42
- **Kernel**: 6.14.11-300.fc42.x86_64
- **EVDI Version**: displaylink-1.14.10-1.github_evdi.x86_64
- **Window Manager**: Hyprland 0.49.0
- **XWayland Version**: 24.1.8-1.fc42
- **Hardware**: ThinkPad with Intel Raptor Lake-P Iris Xe Graphics
- **DisplayLink Device**: USB-C dock with DisplayLink DL-6950

## Problem Description

When DisplayLink monitors are connected and active, all Electron applications crash immediately on startup with `SIGILL` (illegal instruction). This happens in Wayland compositors like Hyprland where Electron apps run via XWayland.

**Key observations**:

- Works perfectly in GNOME/Wayland (native Wayland integration)
- Crashes in Hyprland/XWayland environment
- All GPU acceleration disable flags tested without success
- Forcing native Wayland (`ELECTRON_OZONE_PLATFORM_HINT=wayland`) still crashes
- Forcing native Wayland (`ELECTRON_OZONE_PLATFORM_HINT=x11`) works
- Native non-Electron apps work fine on DisplayLink monitors

## Reproduction Steps

1. Connect DisplayLink USB-C dock with external monitors
2. Boot into Hyprland (wlroots-based Wayland compositor)
3. Verify XWayland is running: `ps aux | grep Xwayland`
4. Attempt to launch any Electron app: `flatpak run md.obsidian.Obsidian`
5. App crashes immediately with SIGILL

## Expected Behavior

Electron apps should launch normally when DisplayLink monitors are connected, as they do in GNOME/Wayland.

## Actual Behavior

```bash
# Multiple crashes with SIGILL (illegal instruction)
sudo coredumpctl list obsidian --since today
TIME                           PID  UID  GID SIG    COREFILE EXE           SIZE
Sat 2025-06-28 16:23:51 CEST  3417 1000 1000 SIGILL present  /app/obsidian 9.1M
Sat 2025-06-28 16:27:11 CEST 16805 1000 1000 SIGILL present  /app/obsidian 9.3M
Sat 2025-06-28 16:28:14 CEST 18283 1000 1000 SIGILL present  /app/obsidian 9.2M

# Stack trace shows crash in graphics/rendering code
Stack trace of thread 14:
#0  0x0000565213818431 n/a (/app/obsidian + 0x3023431)
#1  0x000056521383000c n/a (/app/obsidian + 0x303b00c)
#2  0x0000565212b9a795 n/a (/app/obsidian + 0x23a5795)
```

## DisplayLink Monitor Status

```bash
# DisplayLink monitors detected at kernel level
for status_file in /sys/class/drm/card*/card*-*/status; do
    connector=$(basename $(dirname "$status_file"))
    status=$(cat "$status_file" 2>/dev/null)
    echo "$connector: $status"
done

card0-DVI-I-1: connected      # DisplayLink monitor 1
card1-eDP-1: connected        # Laptop screen
card2-DVI-I-2: connected      # DisplayLink monitor 2
```

## Tested Workarounds (All Failed)

1. **GPU acceleration flags**: `--disable-gpu`, `--disable-hardware-acceleration`, `--disable-gpu-compositing`
2. **Native Wayland**: `ELECTRON_OZONE_PLATFORM_HINT=wayland`
3. **Software rendering**: `LIBGL_ALWAYS_SOFTWARE=1`
4. **Different Electron versions**: Tested with multiple Flatpak Electron apps

## Analysis

This appears to be an **XWayland + DisplayLink virtual display compatibility issue**:

1. **Electron apps default to XWayland** on most Wayland compositors
2. **XWayland lacks proper DisplayLink integration** compared to native Wayland
3. **Virtual display GPU context conflicts** cause illegal instruction crashes
4. **DisplayLink's EVDI driver interferes** with XWayland's graphics acceleration

## Impact

This makes Electron applications completely unusable on systems with DisplayLink docking stations when using wlroots-based Wayland compositors (Hyprland, Sway, etc.).

## Related Issues

- [DisplayLink/evdi#484](https://github.com/DisplayLink/evdi/issues/484): "Monitors blank on Wayland"
- [hyprwm/Hyprland#7292](https://github.com/hyprwm/Hyprland/issues/7292): "DisplayLink dock no signal"

## Suggested Investigation

1. XWayland's interaction with DisplayLink virtual displays
2. Graphics context initialization when virtual displays are present
3. CPU instruction compatibility in XWayland's rendering pipeline with DisplayLink
4. Potential XWayland patches for DisplayLink compatibility

This is a significant compatibility issue affecting a large number of users who rely on DisplayLink docking stations and Electron applications.
