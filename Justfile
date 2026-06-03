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

# Copy-paste steps for a bare macOS machine (just is not available yet)
#   xcode-select --install
#   curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
#   # restart terminal
#   git clone https://github.com/ecosse3/nix-config.git
#   darwin-rebuild switch --flake ~/nix-config#macbook
#   just bootstrap-config

# Print bootstrap instructions
bootstrap:
    @echo "Run these on the bare MacBook (copy-paste one by one):"
    @echo ""
    @echo "  xcode-select --install"
    @echo '  curl --proto "=https" --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install'
    @echo "  # restart terminal"
    @echo "  git clone https://github.com/ecosse3/nix-config.git ~/nix-config"
    @echo "  darwin-rebuild switch --flake ~/nix-config#macbook"
    @echo "  just bootstrap-config"
    @echo ""
    @echo "After that, manually restore: ~/.ssh/, ~/.gnupg/, ~/.password-store"

# Complete setup after nix + config are in place
bootstrap-config:
    @echo "Restore from old machine:"
    @echo "  ~/.ssh/          — copy manually"
    @echo "  ~/.gnupg/        — copy manually"
    @echo "  cd ~/.password-store && git pull"

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
