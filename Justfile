# Nix Config Task Runner
# Usage: just <recipe>
# Run `just` with no args to see all available commands.

# Default: list available recipes
default:
    @just --list

# Auto-detect host based on OS
host := if os() == "macos" { "macbook" } else { "hp" }
rebuild_cmd := if os() == "macos" { "darwin-rebuild" } else { "nixos-rebuild" }
sudo_cmd := "sudo "

# Read GitHub token from user nix.conf (for macOS to override Determinate's stale cached token)
# Returns empty on Linux or if no token is configured.
darwin_token_opt := `grep "^access-tokens" ~/.config/nix/nix.conf 2>/dev/null | sed 's/^access-tokens = /--option access-tokens /' || echo ""`

# ─── Fresh MacBook Bootstrap ──────────────────────────────────────────

# Print full bootstrap instructions (just is not available until after step 6)
bootstrap:
    @echo "╔══════════════════════════════════════════════════════════╗"
    @echo "║           MacBook Fresh Install Instructions             ║"
    @echo "╚══════════════════════════════════════════════════════════╝"
    @echo ""
    @echo "─── Phase 0: Initial macOS Setup ───"
    @echo "  1. Set up iCloud & Apple ID (System Settings > Sign In)"
    @echo "  2. Enable FileVault (System Settings > Privacy & Security)"
    @echo "  3. (Optional) Install Xcode.app from App Store — some"
    @echo "     Homebrew casks need it"
    @echo ""
    @echo "─── Phase 1: Install Prerequisites ───"
    @echo '  xcode-select --install'
    @echo '  curl --proto "=https" --tlsv1.2 -sSf -L \\'
    @echo '    https://install.determinate.systems/nix | sh -s -- install'
    @echo ""
    @echo "─── Phase 2: Restart Terminal, Clone & Build ───"
    @echo "  git clone https://github.com/ecosse3/nix-config.git \\"
    @echo "    ~/nix-config"
    @echo "  cd ~/nix-config"
    @echo "  # If build fails with GitHub rate limiting:"
    @echo "  # 1. Create a GitHub PAT at https://github.com/settings/tokens"
    @echo "  # 2. Add it to /etc/nix/nix.conf:"
    @echo "  #    access-tokens = github.com=<PAT>"
    @echo '  darwin-rebuild switch --flake .#macbook --impure'
    @echo ""
    @echo "─── Phase 3: Post-Rebuild State Restore ───"
    @echo "  just bootstrap-config"
    @echo ""
    @echo "─── Phase 4: Manual Steps ───"
    @echo "  - Log into Raycast (cloud syncs config)"
    @echo "  - Grant Karabiner-Elements input monitoring"
    @echo "  - Authorize SketchyBar (accessibility permissions)"
    @echo "  - Grant Aerospace accessibility permissions"
    @echo "  - Some system.defaults changes require logout/restart"

# Detailed restore steps (run after darwin-rebuild)
bootstrap-config:
    @echo "╔══════════════════════════════════════════════════════════╗"
    @echo "║           Post-Rebuild State Restore                     ║"
    @echo "╚══════════════════════════════════════════════════════════╝"
    @echo ""
    @echo "SSH keys must come first (all git remotes use git@github.com)."
    @echo "Best way: copy tiny files via USB, then git clone + curl the rest."
    @echo ""
    @echo "─── 1. USB stick (small files, always do this) ───"
    @echo "  On old Mac, copy to USB:"
    @echo "    cp -a ~/.ssh /Volumes/USB/"
    @echo "    cp -a ~/.gnupg /Volumes/USB/"
    @echo "  On new Mac, copy from USB:"
    @echo "    cp -a /Volumes/USB/.ssh ~/"
    @echo "    cp -a /Volumes/USB/.gnupg ~/"
    @echo "    chmod 700 ~/.ssh && chmod 600 ~/.ssh/id_*"
    @echo "    chmod 700 ~/.gnupg && chmod 600 ~/.gnupg/*"
    @echo "  Also copy these if space on USB:"
    @echo "    Password store:    cp -a ~/.password-store /Volumes/USB/"
    @echo "    EcoVim:            cp -a ~/.config/nvim /Volumes/USB/"
    @echo "    Kiro CLI (~60MB):  cp -a '~/Library/Application Support/kiro-cli/' /Volumes/USB/"
    @echo ""
    @echo "─── 2. Git clone (or copy from USB instead) ───"
    @echo "    git clone git@github.com:ecosse3/pass.git ~/.password-store"
    @echo "    git clone https://github.com/ecosse3/ecovim.git ~/.config/nvim"
    @echo ""
    @echo "─── 3. Reinstall (nothing needed — all managed by nix) ───"
    @echo "    rustc/cargo, fnm, bun, pnpm are in packages/languages/*.nix"
    @echo "    darwin-rebuild already installed them."
    @echo "    Only reinstall if you need nightly Rust (via rustup)."
    @echo ""
    @echo "─── 4. Bulk Projects via rsync/LAN (skip if cloned individually) ───"
    @echo "    After USB step, SSH keys work, so you can rsync over network:"
    @echo "    rsync -aP --progress user@old-mac:~/Projects/ ~/Projects/"
    @echo '    rsync -aP "user@old-mac:~/Library/Application Support/kiro-cli/" \\'
    @echo '      "~/Library/Application Support/kiro-cli/"'
    @echo ""
    @echo "─── Alternative: one-shot rsync (no USB) ───"
    @echo "  Enable Remote Login on old Mac (Settings > Sharing), then:"
    @echo "    rsync -aP --progress user@192.168.1.X:~/Projects/ ~/Projects/"

# ─── System Rebuild (works on both NixOS and macOS) ───────────────────

# Build and switch configuration for current host
switch:
    {{sudo_cmd}}{{rebuild_cmd}} switch --flake .#{{host}} {{darwin_token_opt}}

# Test configuration (reverts on reboot for NixOS, check on Darwin)
test:
    {{sudo_cmd}}{{rebuild_cmd}} test --flake .#{{host}} {{darwin_token_opt}}

# Build and activate (next boot for NixOS, immediate for Darwin)
boot:
    {{sudo_cmd}}{{rebuild_cmd}} boot --flake .#{{host}} {{darwin_token_opt}}

# Build without activating (check it compiles)
build:
    {{rebuild_cmd}} build --flake .#{{host}}

# Build with trace (for debugging errors)
trace:
    {{sudo_cmd}}{{rebuild_cmd}} switch --flake .#{{host}} --show-trace {{darwin_token_opt}}

# Dry-run build (show what would be built)
dry:
    {{rebuild_cmd}} build --flake .#{{host}} --dry-run

# Rollback to previous generation
rollback:
    {{sudo_cmd}}{{rebuild_cmd}} switch --rollback

# ─── Explicit Host Commands ───────────────────────────────────────────

# Switch NixOS HP configuration explicitly
switch-hp:
    sudo nixos-rebuild switch --flake .#hp

# Switch Darwin macbook configuration explicitly
switch-macbook:
    sudo darwin-rebuild switch --flake .#macbook {{darwin_token_opt}}

# ─── Flake Management ─────────────────────────────────────────────────

# Update all flake inputs
update:
    nix flake update

# Update a single flake input
update-input input:
    nix flake update {{input}}

# Check flake evaluates correctly
check:
    nix flake check --no-build

# Format all nix files with nixfmt
fmt:
    nixfmt .

# Show flake metadata
info:
    nix flake metadata

# Show flake outputs
outputs:
    nix flake show

# ─── Maintenance ──────────────────────────────────────────────────────

# Garbage collect old generations
gc:
    nix-collect-garbage -d

# List system generations (NixOS only)
generations:
    sudo nix-env --list-generations --profile /nix/var/nix/profiles/system

# Show disk usage of nix store
store-size:
    du -sh /nix/store

# Optimise nix store (deduplicate)
optimise:
    nix store optimise
