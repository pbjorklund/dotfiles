#!/bin/bash
set -euo pipefail

############################
# Simplified dotfiles installer
# Links dotfiles and .config directories
############################

# Configuration
readonly DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/dotfiles" && pwd)"
readonly BACKUP_DIR="/tmp/dotfiles-backup-$(date +%Y%m%d-%H%M%S)"

# Files and directories to link
readonly HOME_FILES=(shell/bashrc shell/bash_profile shell/zshrc git/gitconfig tmux/tmux.conf shell/inputrc)
readonly CONFIG_DIRS=(hypr waybar zellij mako wofi terminal/kitty gh nvim opencode niri)

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
        backup_and_link "$DOTFILES_DIR/$file" "$HOME/.$(basename "$file")"
    done
    
    # Link .config directories
    mkdir -p ~/.config
    for dir in "${CONFIG_DIRS[@]}"; do
        [[ -d "$DOTFILES_DIR/$dir" ]] && backup_and_link "$DOTFILES_DIR/$dir" "$HOME/.config/$dir"
    done
    
    # Link special files
    backup_and_link "$DOTFILES_DIR/Code/User/settings.json" "$HOME/.config/Code/User/settings.json"
    backup_and_link "$DOTFILES_DIR/claude/settings.json" "$HOME/.claude/settings.json"
    
    # Link global LLM instruction files
    mkdir -p ~/.config/opencode ~/.claude
    backup_and_link "$DOTFILES_DIR/claude/CLAUDE.md" "$HOME/.config/opencode/AGENTS.md"
    backup_and_link "$DOTFILES_DIR/claude/CLAUDE.md" "$HOME/.claude/CLAUDE.md"
    
    # Setup tmux plugins
    log "Setting up tmux plugins"
    if [[ ! -d ~/.tmux/plugins/tpm ]]; then
        log "Installing Tmux Plugin Manager (TPM)"
        git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
        log "TPM installed. Run 'prefix + I' in tmux to install plugins"
    else
        log "TPM already installed"
    fi
    
    log "Installation complete! Backup: $BACKUP_DIR"
}

main "$@"
