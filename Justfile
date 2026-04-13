# Nix Config Task Runner
# Usage: just <recipe>
# Run `just` with no args to see all available commands.

# Default: list available recipes
default:
    @just --list

# Auto-detect host based on OS
host := if os() == "macos" { "macbook" } else { "hp" }
rebuild_cmd := if os() == "macos" { "darwin-rebuild" } else { "nixos-rebuild" }
sudo_cmd := if os() == "macos" { "" } else { "sudo " }

# ─── System Rebuild (works on both NixOS and macOS) ───────────────────

# Build and switch configuration for current host
switch:
    {{sudo_cmd}}{{rebuild_cmd}} switch --flake .#{{host}}

# Test configuration (reverts on reboot for NixOS, check on Darwin)
test:
    {{sudo_cmd}}{{rebuild_cmd}} test --flake .#{{host}}

# Build without activating (check it compiles)
build:
    {{rebuild_cmd}} build --flake .#{{host}}

# Build with trace (for debugging errors)
trace:
    {{sudo_cmd}}{{rebuild_cmd}} switch --flake .#{{host}} --show-trace

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
    darwin-rebuild switch --flake .#macbook

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
