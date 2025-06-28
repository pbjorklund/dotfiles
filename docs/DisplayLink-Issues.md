# DisplayLink USB-C Dock Issues

**TL;DR**: USB-C dock works in GNOME, broken in wlroots compositors. Electron apps crash with DisplayLink active. Force X11 to fix.

## Hardware

- ThinkPad + USB-C dock with DisplayLink DL-6950
- 3 monitors: laptop (eDP-1) + Samsung (DVI-I-1) + Dell (DVI-I-2)
- Fedora 42, EVDI 1.14.10

## Issues

### 1. Monitor Detection

- **GNOME**: All 3 monitors work
- **Hyprland**: All monitors work (post-v0.42 with aquamarine backend), Electron apps crash
- **niri**: Dell monitor not detected (Smithay backend limitations)

**Root cause**: Compositor backend architecture differences:

- **GNOME/Mutter**: Advanced DisplayLink integration built-in
- **Hyprland v0.42+**: Custom aquamarine backend with better DisplayLink support
- **niri**: Smithay backend lacks DisplayLink abstraction layer
- **Other wlroots compositors**: wlroots has poor DisplayLink integration

### 2. Electron Crashes (SOLVED)

- **Problem**: SIGILL crashes when DisplayLink active + XWayland
- **Cause**: Electron auto-detects Wayland → DisplayLink virtual display incompatibility
- **Fix**: Force X11 backend

## Solutions

### System Electron Apps

```bash
# In Hyprland environment.conf
env = ELECTRON_OZONE_PLATFORM_HINT,x11
```

### Flatpak Electron Apps

```bash
flatpak override --user --env=ELECTRON_OZONE_PLATFORM_HINT=x11 --nosocket=wayland md.obsidian.Obsidian
```

### Monitor Detection Debug

```bash
# Check DRM status
for f in /sys/class/drm/card*/card*-*/status; do echo "$f: $(cat $f)"; done

# Check EDID
ls -la /sys/class/drm/card*/card*-*/edid

# Force rescan
echo 1 | sudo tee /sys/class/drm/card*/device/rescan
```

## Status

- ✅ **Electron crashes**: Fixed via X11 force
- ❌ **niri monitor detection**: No workaround, use GNOME
- ✅ **Hyprland**: Works with X11 fix
- ✅ **GNOME**: Works natively

## Files

- `dotfiles/.config/hypr/conf/environment.conf` - X11 force setting
- `ansible/desktop-applications.ansible.yml` - Automated Flatpak overrides
- `docs/fix-monitors.sh` - Monitor fix helper
- `docs/monitor-detection-helper.sh` - Monitor detection debug tool

## Don't Waste Time On

- EDID injection (hardware EDID is fine)
- GPU acceleration flags (doesn't help SIGILL)
- DisplayLink driver updates (not the issue)
- Wayland protocol fixes (use X11 instead)

## Upstream Issues

- DisplayLink/EVDI: Poor integration with non-GNOME backends
- XWayland: DisplayLink virtual display incompatibility
- ~~wlroots: No DisplayLink abstraction layer~~ (Hyprland v0.42+ uses custom aquamarine)
- Smithay: Needs DisplayLink abstraction layer like GNOME (affects niri)

**Recommendation**: Use GNOME for full DisplayLink support, or Hyprland v0.42+ with X11 Electron backend. Avoid niri/Smithay-based compositors for DisplayLink setups.
