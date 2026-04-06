# Nix Config Task Runner
# Usage: just <recipe>
# Run `just` with no args to see all available commands.

# Default: list available recipes
default:
    @just --list

# ─── NixOS (HP laptop) ───────────────────────────────────────────────

# Build and switch NixOS configuration
switch:
    sudo nixos-rebuild switch --flake .#hp

# Test NixOS configuration (reverts on reboot)
test:
    sudo nixos-rebuild test --flake .#hp

# Build without activating (check it compiles)
build:
    nixos-rebuild build --flake .#hp

# Build with trace (for debugging errors)
trace:
    sudo nixos-rebuild switch --flake .#hp --show-trace

# Dry-run build (show what would be built)
dry:
    nixos-rebuild build --flake .#hp --dry-run

# Rollback to previous generation
rollback:
    sudo nixos-rebuild switch --rollback

# ─── nix-darwin (future macOS) ────────────────────────────────────────

# Build and switch Darwin configuration
# darwin-switch:
#     darwin-rebuild switch --flake .#macbook

# Test Darwin configuration
# darwin-test:
#     darwin-rebuild check --flake .#macbook

# ─── Flake Management ────────────────────────────────────────────────

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
    sudo nix-collect-garbage -d

# List system generations
generations:
    sudo nix-env --list-generations --profile /nix/var/nix/profiles/system

# Show disk usage of nix store
store-size:
    du -sh /nix/store

# Optimise nix store (deduplicate)
optimise:
    nix store optimise
