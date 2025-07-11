#!/bin/bash
set -euo pipefail

############################
# Simplified dotfiles installer
# Links dotfiles and .config directories, handles system files on real systems
############################

# Configuration
readonly DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly BACKUP_DIR="/tmp/dotfiles-backup-$(date +%Y%m%d-%H%M%S)"
readonly IS_DEVCONTAINER=$([[ "$USER" == "vscode" ]] || [[ -f "/.dockerenv" ]] || ! command -v systemctl >/dev/null 2>&1 && echo true || echo false)

# Files and directories to link
readonly HOME_FILES=(shell/bashrc shell/zshrc git/gitconfig tmux/tmux.conf shell/inputrc)
readonly CONFIG_DIRS=(hypr waybar zellij mako wofi systemd terminal/kitty gh nvim opencode niri)

# System files (only on real systems)
declare -A SYSTEM_FILES=(
    ["hypr/scripts/disable-usb-wakeup.sh"]="/usr/local/bin/disable-usb-wakeup.sh"
    ["systemd/system/disable-usb-wakeup.service"]="/etc/systemd/system/disable-usb-wakeup.service"
)

# Logging functions
log() { echo "→ $*"; }
warn() { echo "⚠ $*" >&2; }
error() { echo "✗ $*" >&2; exit 1; }

# Backup and link function
backup_and_link() {
    local source="$1"
    local target="$2"
    
    # Handle mount points
    if mountpoint -q "$target" 2>/dev/null; then
        warn "Skipping $target (mount point)"
        return 0
    fi
    
    # Backup existing file/directory
    if [[ -e "$target" ]]; then
        if ! mv "$target" "$BACKUP_DIR/" 2>/dev/null; then
            # If move fails, try copy and remove
            cp -r "$target" "$BACKUP_DIR/" 2>/dev/null || warn "Could not backup $target"
            rm -rf "$target" 2>/dev/null || {
                warn "Cannot remove $target (busy), skipping"
                return 1
            }
        fi
    fi
    
    # Create parent directory if needed
    mkdir -p "$(dirname "$target")"
    
    # Create symlink
    ln -sf "$source" "$target"
    log "Linked $source → $target"
}

# Main installation
main() {
    log "Starting dotfiles installation"
    mkdir -p "$BACKUP_DIR"
    
    # Link home files
    for file in "${HOME_FILES[@]}"; do
        backup_and_link "$DOTFILES_DIR/$file" "$HOME/.$file"
    done
    
    # Link .config directories
    mkdir -p ~/.config
    for dir in "${CONFIG_DIRS[@]}"; do
        [[ -d "$DOTFILES_DIR/$dir" ]] && backup_and_link "$DOTFILES_DIR/$dir" "$HOME/.config/$dir"
    done
    
    # Link special files
    backup_and_link "$DOTFILES_DIR/Code/User/settings.json" "$HOME/.config/Code/User/settings.json"
    backup_and_link "$DOTFILES_DIR/claude/settings.json" "$HOME/.claude/settings.json"
    
    # Link local bin
    mkdir -p ~/.local/bin
    backup_and_link "$DOTFILES_DIR/../bin/pbproject" "$HOME/.local/bin/pbproject"
    
    # Handle system files (only on real systems)
    if [[ "$IS_DEVCONTAINER" == "false" ]]; then
        log "Installing system files"
        for source in "${!SYSTEM_FILES[@]}"; do
            local dest="${SYSTEM_FILES[$source]}"
            if [[ -f "$DOTFILES_DIR/$source" ]]; then
                sudo mkdir -p "$(dirname "$dest")"
                [[ -f "$dest" ]] && sudo cp "$dest" "$BACKUP_DIR/"
                sudo cp "$DOTFILES_DIR/$source" "$dest"
                sudo chmod +x "$dest" 2>/dev/null || true
                log "Installed $source → $dest"
                
                # Handle systemd services
                if [[ "$dest" == *.service ]]; then
                    local service_name="$(basename "$dest")"
                    sudo systemctl daemon-reload
                    sudo systemctl enable "$service_name" && log "Enabled $service_name"
                    sudo systemctl start "$service_name" && log "Started $service_name"
                fi
            fi
        done
        
        # Handle user systemd services
        if systemctl --user daemon-reload 2>/dev/null; then
            for service in waybar.service waybar-watcher.service; do
                if [[ -f ~/.config/systemd/user/$service ]]; then
                    systemctl --user enable "$service" 2>/dev/null && log "Enabled user $service"
                    systemctl --user start "$service" 2>/dev/null && log "Started user $service"
                fi
            done
        fi
    else
        log "Skipping system configuration (devcontainer)"
    fi
    
    log "Installation complete! Backup: $BACKUP_DIR"
}

main "$@"
