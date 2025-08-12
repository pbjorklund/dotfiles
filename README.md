# Le Dotfiles

Personal dotfiles for Linux development environments. Focused on terminal workflows with Kitty + tmux + Neovim and AI coding tools integration. **This is a personal configuration** - fork and adapt to your needs.

> [!IMPORTANT]
> **After running install**: Search and replace hardcoded paths for your username:
> 1. Open in nvim: `nvim` (or any file)
> 2. Search and replace: `,fg` then search `/home/pbjorklund` and replace with your path
>
> Many tools don't properly expand `~` so we use absolute paths. Update these to match your system. I could fix, but to lazy.

> [!NOTE]
> **System automation moved**: Ansible playbooks for system setup have been moved to a [separate repository](https://github.com/pbjorklund/ansible-fedora). This repo now focuses purely on dotfiles and personal configurations.

## My Development Workflow

**Primary Setup**: Kitty terminal + tmux + CLI-agentic-coding-tools
- Start with Claude Code (until usage ceiling)
- Switch to OpenCode (GitHub Copilot subscription limits)
- Neovim monitors file changes from CLI LLMs and auto-reloads
- Custom tmux styling with activity indicators and workspace management

**Secondary Setup**: VS Code with extensions
- Roo/Cline/GitHub Copilot integration
- Dark theme configuration matching terminal aesthetic
- Used for GUI-heavy tasks and extension-dependent workflows

**Why Ansible**: Documents complex setup procedures (DisplayLink drivers, fingerprint auth, hardware quirks) that would otherwise require hours of research and trial-and-error.

## Quick Start

```bash
git clone https://github.com/pbjorklund/dotfiles.git ~/dotfiles
cd ~/dotfiles

# Install dotfiles (configuration files only)
cd dotfiles && ./install.sh
```

> **For system automation**: See the separate [ansible-fedora](https://github.com/pbjorklund/ansible-fedora) repository for automated Fedora workstation setup.

## What This Provides

**Development Toolbelt**
- **CLI Workflow**: Kitty + tmux + Neovim (file-watching, auto-reload)
- **GUI Workflow**: VS Code with dark theme + extensions (roo/cline/copilot)
- **AI Coding**: Claude Code → OpenCode workflow with notification integration
- Containers, CLI utilities, development notifications via mako

## File Structure (What Goes Where)

```
dotfiles/                   # Personal config files
├── install.sh             # Symlinks everything to ~/.config, ~/.*
├── nvim/                  # Neovim config with file watching
├── tmux/                  # Styled tmux with activity indicators
├── hypr/                  # Hyprland window manager config
└── shell/                 # bash/zsh aliases, functions

bin/                       # Custom scripts that go in PATH
├── pbproject              # AI-optimized project initialization and templates
├── llm-link               # Unified LLM instruction management across projects
└── dev-notify.sh          # Notification bridge (moved to ansible-fedora)

project-templates/         # Starter configs for new projects with AI support
├── LLM_CORE_SYSTEM_PROMPT.md  # Unified system prompt for all AI tools
├── AGENTS.md|CLAUDE.md|GEMINI.md  # Symlinks to core prompt for each tool
├── github/instructions/   # GitHub Copilot context and workflow templates
└── roo/rules/            # Roo AI assistant rules and configuration
```

## Key Features

**Notifications**
- `dev-notify.sh` (now in ansible-fedora) sends desktop notifications from Claude Code, OpenCode
- Shows in mako (Wayland) with proper icons and persistence
- No more missing that the AI finished your request

**Smart File Watching**
- Neovim auto-reloads when external tools modify files
- Works great with CLI AI tools that edit multiple files
- No more "file changed on disk" prompts

**Hyprland Workspace Management**
- Workspaces follow monitors (workspace 1 always on main display)
- Scripts for moving workspaces between monitors
- Keybinds for common window management tasks

**Project Setup Tools**
- `pbproject` creates new gh private repo projects with shared LLM instructions
- `llm-link` manages AI tool configurations across projects
- Templates include proper context for Claude, OpenCode, Copilot, Roo, Gemini

### pbproject - Project Bootstrapper

Creates new projects with consistent structure and shared AI tool configurations.

```bash
# Create new project with LLM setup
pbproject init my-new-project

# Create project at specific location
pbproject init my-app ~/projects/my-app

# Check current project status
pbproject status

# Detach symlinks to create independent copies
pbproject detach

# Migrate folder from existing project to new standalone project
pbproject migrate batch_writer ~/Projects/cli-tool

# Create private GitHub repository for current project
pbproject newghrepo
```

**What it provides:**
- **LLM instructions**: All AI tools share the same system prompt
- **Symlinked**: Symlinked configs get improvements automatically
- **Easy customization**: Detach to independent copies when needed
- **GitHub integration**: Automatic private repo creation and push

### llm-link - Baseline AI Configuration Setup

Symlinks in generic LLM instruction files across all supported AI coding tools. All based on the same core prompt. Can detach to create independent copies for customization.

```bash
# Set up LLM files in current directory
llm-link

# Check status of LLM files
llm-link --status

# Convert symlinks to independent copies for customization
llm-link --detach
```

**Supported AI Tools:**
- **OpenCode** (`AGENTS.md`) - CLI coding assistant
- **Claude Desktop** (`CLAUDE.md`) - Desktop AI chat
- **Gemini CLI** (`GEMINI.md`) - Google's AI assistant
- **GitHub Copilot** (`.github/copilot-instructions.md`) - IDE integration. Also comes with custom instructions for a bunch of filetypes and langs.
- **Roo** (`.roo/rules/00-general.md`) - AI pair programming Cline fork. Quite good.

**Workflow:**
1. **Start new project**: `pbproject init` creates project with symlinked LLM configs
2. **Develop**: All AI tools share unified instructions and coding standards
3. **Customize when needed**: `llm-link --detach` creates independent copies
4. **Update shared configs**: Changes to templates automatically propagate to linked projects

## Why These Choices

**Hyprland over i3/sway**: Better multi-monitor, active development
**tmux over screen/zellij**: Better scripting, mouse support, more features. But most of all I'm a grumpy old man set in his ways
**Neovim over vim**: Lua config, built-in LSP, better plugin ecosystem. Kinda forced into it
**Kitty over alacritty**: Better font rendering, graphics support they say. I don't really care, it works
**mako over dunst**: It's just the first I went with

## Requirements

- Linux environment (tested on Fedora)
- Git for cloning and managing dotfiles
- Basic shell utilities (bash/zsh)

