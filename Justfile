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
    @echo "║           Post-Rebuild Restore                           ║"
    @echo "╚══════════════════════════════════════════════════════════╝"
    @echo ""
    @echo "  1. SSH keys"
    @echo "     Copy from backup:"
    @echo "       rsync -a user@old-mac:~/.ssh/ ~/.ssh/"
    @echo "     Set permissions:"
    @echo "       chmod 700 ~/.ssh && chmod 600 ~/.ssh/id_*"
    @echo ""
    @echo "  2. GPG keys"
    @echo "     Copy from backup:"
    @echo "       rsync -a user@old-mac:~/.gnupg/ ~/.gnupg/"
    @echo "     Set permissions:"
    @echo "       chmod 700 ~/.gnupg && chmod 600 ~/.gnupg/*"
    @echo ""
    @echo "  3. Password store"
    @echo "       git clone git@github.com:ecosse3/password-store.git \\"
    @echo "         ~/.password-store"
    @echo "       # or pull existing:"
    @echo "       cd ~/.password-store && git pull"
    @echo ""
    @echo "  4. EcoVim (Neovim config)"
    @echo "       git clone https://github.com/ecosse3/ecovim.git \\"
    @echo "         ~/.config/nvim"
    @echo ""
    @echo "  5. Rust toolchain (not managed by nix)"
    @echo "       curl --proto '=https' --tlsv1.2 -sSf \\"
    @echo "         https://sh.rustup.rs | sh"
    @echo ""
    @echo "  6. fnm (Node version manager, not in nixpkgs)"
    @echo "       curl -fsSL https://fnm.vercel.app/install | bash"
    @echo "       fnm install --lts"
    @echo ""
    @echo "  7. bun"
    @echo "       curl -fsSL https://bun.sh/install | bash"
    @echo ""
    @echo "  8. pnpm (via corepack, after fnm/node is installed)"
    @echo "       corepack enable pnpm"
    @echo ""
    @echo "  9. Restart terminal or: source ~/.zshrc"

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
