# Ecosse Nix Config

> **Multi-host Nix flake for NixOS (x86_64-linux) and macOS (aarch64-darwin)**  
> By [Lucas Kurpiewski](https://github.com/ecosse3) — [@ecosse3](https://github.com/ecosse3)

[![NixOS](https://img.shields.io/badge/NixOS-unstable-blue?logo=nixos)](https://nixos.org)
[![nix-darwin](https://img.shields.io/badge/nix--darwin-unstable-blue?logo=apple)](https://github.com/nix-darwin/nix-darwin)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)

A fully declarative, reproducible system configuration managed as a single Nix flake. One repository drives both a NixOS laptop (Niri with GNOME fallback) and a macOS workstation (SketchyBar + Karabiner + Raycast), sharing Home Manager modules where possible while keeping platform-specific concerns isolated.

---

## Table of Contents

- [Quick Start](#quick-start)
- [Architecture](#architecture)
- [Hosts](#hosts)
  - [HP — NixOS Laptop](#hp--nixos-laptop)
  - [MacBook — macOS Workstation](#macbook--macos-workstation)
- [Key Concepts](#key-concepts)
- [Directory Structure](#directory-structure)
- [Neovim Setup](#neovim-setup)
- [Daily Workflow](#daily-workflow)
- [Notable Features](#notable-features)
- [Inspiration & Thanks](#inspiration--thanks)

---

## Quick Start

```bash
# Clone
git clone git@github.com:ecosse3/nix-config.git ~/nix-config
cd ~/nix-config

# NixOS — build and activate
just switch        # or: sudo nixos-rebuild switch --flake .#hp

# macOS — build and activate
just switch        # or: sudo darwin-rebuild switch --flake .#macbook
```

The [`Justfile`](Justfile) auto-detects the host OS and runs the correct rebuild command.

---

## Architecture

### Design Philosophy

1. **Single flake entry point** — `flake.nix` contains one call per host. No per-host `flake.nix` copies.
2. **Minimal host definitions** — `hosts/<name>/` only imports per-host modules (hardware, display, boot). Shared logic lives elsewhere.
3. **Shared Home Manager core** — `home/shared/` is imported on both NixOS and Darwin. Platform-specific modules (`home/linux/`, `home/darwin/`) are appended per-host.
4. **All packages in one place** — System-wide packages, language toolchains, Neovim LSPs, and fonts are declared in `packages/`, not scattered across host files.
5. **Tooling over tiling** — A carefully curated shell environment (zsh + p10k + fzf + zoxide + eza + lazygit + yazi) that works identically on both platforms.

### Flake Inputs

| Input | Purpose |
|-------|---------|
| `nixpkgs` | NixOS unstable channel |
| `nixpkgs-darwin` | macOS unstable channel (follows `nixpkgs-unstable`) |
| `home-manager` | User-level dotfile and package management |
| `nix-darwin` | macOS system configuration |
| `determinate` | Determinate Nix installer module (macOS) |
| `nix-homebrew` | Declarative Homebrew management via nix |
| `neovim-nightly-overlay` | Neovim nightly binary |
| `zen-browser` | Zen Browser flake |
| `niri` | Scrollable-tiling Wayland compositor |
| `dank-material-shell` | Custom GNOME/greetd lock screen |
| `danksearch` | Custom launcher |

### Host Builders

Two helper functions eliminate boilerplate:

- **`lib/mkHost.nix`** — For NixOS hosts. Sets up `nixosSystem` with `specialArgs` (inputs, username, hostname), imports `packages/`, enables Home Manager with `useGlobalPkgs = true`, and wires `home/shared` + per-host `homeModules`.
- **`lib/mkDarwinHost.nix`** — For nix-darwin hosts. Same pattern but for `darwinSystem`, adds `nix-homebrew` module, and supports `extraModules` (e.g. Determinate Nix).

Both builders pass `username` and `inputs` through `specialArgs`/`extraSpecialArgs` so every module has access to flake inputs without explicit imports.

---

## Hosts

### HP — NixOS Laptop

| Property | Value |
|----------|-------|
| System | `x86_64-linux` |
| Desktop | Niri (scrollable-tiling Wayland compositor) with GNOME as fallback |
| Display Manager | greetd + GDM |
| GPU | NVIDIA (modesetting) |
| Boot | systemd-boot, EFI, NTFS support |
| Audio | PipeWire (+ ALSA, PulseAudio compat) |
| Locale | en_US.UTF-8 with Polish regional settings |
| Keyboard | Polish (`pl`) layout |
| Extras | Fingerprint reader (fprintd), power-profiles-daemon, MPD, Docker |

**Key modules:**
- `hosts/hp/hardware-configuration.nix` — Auto-generated hardware config
- `hosts/hp/boot.nix` — systemd-boot, EFI, NTFS
- `hosts/hp/system.nix` — Networking, locale, sound, printing, user, Docker, NVIDIA
- `hosts/hp/display.nix` — Niri, greetd, GDM, GNOME fallback, keyboard, touchpad
- `hosts/hp/keyd.nix` — keyd key remapping

### MacBook — macOS Workstation

| Property | Value |
|----------|-------|
| System | `aarch64-darwin` (Apple Silicon) |
| Window Management | SketchyBar + Karabiner + custom keybindings |
| Launcher | Raycast |
| Shell | zsh (managed by nix-darwin at system level) |
| Package Manager | Nix + Homebrew (via `nix-homebrew`) |
| Auth | Touch ID for sudo |

**Key modules:**
- `hosts/macbook/default.nix` — macOS system defaults, Homebrew taps/brews/casks, fonts, Determinate Nix
- `home/darwin/sketchybar.nix` — SketchyBar configuration
- `home/darwin/karabiner.nix` — Karabiner-Elements key remapping
- `home/darwin/raycast.nix` — Raycast settings

---

## Key Concepts

### `useGlobalPkgs = true`

Overlays and package sets are defined at the NixOS/nix-darwin level, not inside `home.nix`. This means:
- All packages resolve through the same `pkgs` instance.
- No per-user package set drift.
- Home Manager modules just declare *what* to install; the system decides *which* version.

### Platform-Specific Imports

Linux-only Home Manager modules (Zen Browser, DankMaterialShell, DankSearch, Niri) are imported via `homeModules` in `flake.nix`, **not** inside `home/default.nix`. This keeps the shared core truly platform-agnostic.

### Language Toolchains

All language runtimes and build tools are defined in `packages/languages/`:

| File | Contents |
|------|----------|
| `packages/languages/golang.nix` | `go` |
| `packages/languages/lua.nix` | `lua`, `luarocks`, `luajit` |
| `packages/languages/nodejs.nix` | `nodejs_24`, `pnpm`, `corepack_24` |
| `packages/languages/python.nix` | `python3`, `pip` (venvs via `uv`) |
| `packages/languages/rust.nix` | `rustc`, `cargo` |

### Dotfiles Strategy

| Managed by | What |
|------------|------|
| **Home Manager** | zsh/oh-my-zsh/p10k, git (+delta, LFS), gpg, fzf, direnv, bat, eza, gh, zoxide, wezterm, lazygit, yazi, neovide |
| **Separate repo** | Neovim config (`~/.config/nvim` — [EcoVim](https://github.com/ecosse3/ecovim)) |

---

## Directory Structure

```
nix-config/
├── flake.nix                    # Entry point — one call per host
├── flake.lock                   # Pinned inputs
├── lib/
│   ├── mkHost.nix               # NixOS host builder
│   └── mkDarwinHost.nix         # nix-darwin host builder
├── hosts/
│   ├── hp/                      # HP NixOS laptop
│   │   ├── hardware-configuration.nix
│   │   ├── boot.nix
│   │   ├── system.nix
│   │   ├── display.nix
│   │   └── keyd.nix
│   └── macbook/                 # MacBook Pro (nix-darwin)
│       └── default.nix
├── packages/
│   ├── default.nix              # Fonts, system packages, imports
│   ├── neovim.nix               # ALL LSPs, formatters, DAPs, tree-sitter
│   └── languages/               # Language toolchains
│       ├── default.nix
│       ├── golang.nix
│       ├── lua.nix
│       ├── nodejs.nix
│       ├── python.nix
│       └── rust.nix
├── home/
│   ├── shared/                  # Platform-agnostic Home Manager modules
│   │   ├── default.nix          # User packages, git, direnv, bat, eza, etc.
│   │   ├── shell/zsh.nix        # zsh, oh-my-zsh, p10k, aliases
│   │   ├── neovim.nix           # Neovim nightly binary
│   │   ├── wezterm.nix          # Wezterm terminal
│   │   ├── lazygit.nix          # Lazygit TUI
│   │   ├── yazi.nix             # Yazi file manager
│   │   ├── neovide.nix          # Neovide GUI
│   │   └── zen-browser.nix      # Zen Browser
│   ├── linux/                   # Linux-only Home Manager modules
│   │   ├── dank-material-shell.nix
│   │   ├── danksearch.nix
│   │   └── niri/
│   └── darwin/                  # macOS-only Home Manager modules
│       ├── sketchybar.nix
│       ├── karabiner.nix
│       └── raycast.nix
├── p10k-config/
│   └── p10k.zsh                 # Powerlevel10k configuration
├── Justfile                     # Task runner (switch, build, update, gc, etc.)
└── .github/workflows/
    └── check.yml                # CI: nix flake check + nixfmt
```

---

## Neovim Setup

This configuration installs **Neovim nightly** via the `neovim-nightly-overlay` and provides **all language servers, formatters, and debuggers** through Nix (see [`packages/neovim.nix`](packages/neovim.nix)).

**Why?** Mason detects these binaries on `$PATH` and uses them directly — no downloading, no network calls, fully reproducible.

| Category | Tools |
|----------|-------|
| **LSPs** | bash, biome, clangd, deno, dockerfile, emmet, graphql, lua, markdown, nil/nixd, typescript, oxlint, prisma, pyright, sqls, tailwindcss, terraform, eslint, vue, yaml |
| **Formatters** | prettierd, stylua |
| **DAP** | vscode-js-debug |
| **Tree-sitter** | tree-sitter + gcc for parser compilation |

The actual Neovim config ([EcoVim](https://github.com/ecosse3/ecovim)) lives in a separate repo at `~/.config/nvim`.

---

## Daily Workflow

All common operations are wrapped in the [`Justfile`](Justfile):

```bash
just switch      # Build and activate config for current host
just test        # Test config (reverts on reboot for NixOS)
just build       # Build only (no activation)
just trace       # Build with --show-trace for debugging
just dry         # Dry-run
just rollback    # Rollback to previous generation
just update      # Update all flake inputs
just check       # nix flake check --no-build
just fmt         # Format all nix files with nixfmt
just gc          # Garbage collect old generations
just generations # List system generations
just store-size  # Disk usage of /nix/store
just optimise    # Deduplicate nix store
```

### macOS Specific

```bash
sudo darwin-rebuild switch --flake .#macbook
sudo darwin-rebuild check --flake .#macbook
```

---

## Notable Features

- **Niri as primary compositor** — scrollable-tiling Wayland with GNOME available as a traditional desktop fallback.
- **Custom greetd greeter** — [DankMaterialShell](https://github.com/AvengeMedia/DankMaterialShell) provides a stylized login/lock screen.
- **Declarative Homebrew** — macOS casks and brews are managed through nix, with safe migration (`autoMigrate = true`).
- **Touch ID for sudo** — Enabled via `security.pam.services.sudo_local.touchIdAuth`.
- **Powerlevel10k** — Instant prompt with a custom config shared across both platforms.
- **Rich zsh environment** — Oh My Zsh with git, docker, terraform, aws, npm, yarn, bun plugins + fzf-tab + zsh-you-should-use + zsh-fzf-history-search.
- **Full Neovim IDE** — 20+ LSPs, formatters, DAP — all from Nix, no Mason downloads.
- **CI verification** — GitHub Actions runs `nix flake check --no-build` and `nixfmt` on every push/PR.

---

## Inspiration & Thanks

- [NixOS](https://nixos.org) and [nix-darwin](https://github.com/nix-darwin/nix-darwin) for making declarative systems possible
- [Home Manager](https://github.com/nix-community/home-manager) for user-level reproducibility
- [Misterio77](https://github.com/Misterio77/nix-config) and [Mathias](https://github.com/Misterio77) for Nix flake patterns
- [Determinate Systems](https://determinate.systems) for the Nix installer and excellent Nix content

---

## License

MIT — feel free to fork, copy, or adapt.

> **Note:** `flake.lock` is root-owned (written by `sudo nixos-rebuild`). If git complains about permissions after a rebuild: `sudo chown $(id -u):$(id -g) flake.lock`
