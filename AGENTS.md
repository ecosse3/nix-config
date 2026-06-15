# AGENTS.md

## Project

NixOS flake configuration for **ecosse** (Lucas Kurpiewski, GitHub: ecosse3).
Multi-host: HP laptop (x86_64-linux) running NixOS unstable with GNOME + Niri,
and macOS via nix-darwin.

**Repo**: `git@github.com:ecosse3/nix-config.git`

---

## Directory Structure

```
nix-config/
  flake.nix                         # Entry point. One call per host.
  flake.lock                        # Pinned inputs (root-owned)
  lib/mkHost.nix                    # NixOS host helper

  core/                             # NixOS-only system configuration
    default.nix                     # Networking, locale, sound, users, DMS services
    boot.nix                        # Bootloader (systemd-boot, NTFS)
    display.nix                     # X11, GNOME, GDM, Niri, greetd, keyboard, touchpad

  packages/                         # System-level packages
    default.nix                     # Fonts, system packages, imports languages/ + neovim.nix
    neovim.nix                      # ALL LSPs, formatters, DAPs, tree-sitter
    languages/                      # One file per language toolchain
      default.nix                   # Aggregator
      golang.nix                    # go
      lua.nix                       # lua, luarocks, luajit
      nodejs.nix                    # nodejs_24, pnpm, corepack_24
      python.nix                    # python3, pip (venvs via uv)
      rust.nix                      # rustc, cargo

  home/                             # Home Manager modules
    shared/                         # Platform-agnostic core
      default.nix                   # User packages, git, bat, eza, gh, zoxide, gpg, fzf, etc.
      shell/zsh.nix                 # zsh, oh-my-zsh, p10k, aliases
      neovim.nix                    # Neovim nightly binary only
      neovide.nix                   # Neovide GUI
      wezterm.nix                   # Wezterm terminal (platform-aware keybindings)
      lazygit.nix                   # Lazygit TUI
      yazi.nix                      # Yazi file manager
      zen-browser.nix               # Zen Browser (broken on darwin)
    darwin/                         # macOS-specific
      default.nix                   # Imports raycast, karabiner, sketchybar
      karabiner.nix                 # Karabiner-Elements config
      sketchybar.nix                # SketchyBar config
      raycast.nix                   # Raycast config
    linux/                          # Linux-specific

  hosts/
    hp/                             # NixOS HP laptop
      default.nix, boot.nix, display.nix, system.nix, keyd.nix
      hardware-configuration.nix    # Auto-generated
    macbook/                        # nix-darwin macOS
      default.nix                   # nix-homebrew, macOS defaults, fonts

  p10k-config/p10k.zsh             # Powerlevel10k configuration

  .github/workflows/check.yml      # CI: nix flake check + nixfmt

  Justfile                          # Task runner
  .editorconfig                     # 2-space indent, LF, UTF-8
  .gitignore                        # Ignores .agents/, skills-lock.json
```

---

## Architecture

- **Single nixpkgs channel**: `nixos-unstable` for both NixOS and nix-darwin.
  `nixpkgs-darwin` follows `nixpkgs-unstable`.
- **`lib/mkHost.nix`**: Reduces each host to a single function call.
- **`specialArgs`/`extraSpecialArgs`**: `inputs`, `username`, and `hostname` are
  threaded through to all modules.
- **`useGlobalPkgs = true`**: Overlays live at the NixOS level, not in home.nix.
- **Linux-only home modules** are imported via `homeModules` per-host in
  `flake.nix`, NOT inside `home/default.nix`.

### Neovim & Mason

- Neovim binary is **nightly** via `neovim-nightly-overlay`.
- Neovim config is **EcoVim** — separate repo cloned to `~/.config/nvim`.
- **All LSPs, formatters, and DAPs** are installed via nix in `packages/neovim.nix`.
  Mason detects them on `$PATH` and uses them directly.

### Package management strategy

- **Nix first**: All CLI tools go in `home/shared/default.nix` (home.packages) or via `programs.<name>` where a HM module exists.
- **nix-homebrew**: macOS-only GUI apps and tools not in nixpkgs are declared in `hosts/macbook/default.nix` under `homebrew.brews`/`homebrew.casks`. This ensures they auto-install on a fresh machine while keeping brew as the package runtime.
- **brew migration**: Most packages have been migrated from Homebrew to Nix. Remaining brew items are either macOS GUI apps, kernel extensions, or services better suited to brew.

### Dotfiles strategy

- **Home Manager owns**: zsh/oh-my-zsh/p10k, git (+delta, lfs), gpg, fzf,
  direnv, bat, eza, gh, zoxide, wezterm, lazygit, yazi, neovide, neovim.
- **Separate repo**: Neovim config (`~/.config/nvim`).

---

## Common Tasks

```bash
just switch      # Build and activate (auto-detects host)
just test        # Build and activate (reverts on reboot)
just build       # Build only
just trace       # Build with --show-trace for debugging
just dry         # Dry-run
just rollback    # Rollback to previous generation
just update      # Update all flake inputs
just check       # nix flake check --no-build
just fmt         # Format all nix files with nixfmt
just gc          # Garbage collect old generations
just store-size  # Disk usage of /nix/store
just optimise    # Deduplicate nix store
just bootstrap   # Print new MacBook bootstrap instructions
just bootstrap-config  # Post-clone setup reminders
```

### macOS (nix-darwin)

```bash
just switch                    # auto-detects macbook host
sudo darwin-rebuild switch --flake .#macbook  # explicit
```

---

## CI

GitHub Actions (`.github/workflows/check.yml`) runs on push/PR to `main`:
1. `nix flake check --no-build`
2. `nix run nixpkgs#nixfmt -- --check .`

---

## Commit Style

Use [Conventional Commits](https://www.conventionalcommits.org/):

```
type(scope): short description
```

| Type       | When to use                                |
|------------|--------------------------------------------|
| `feat`     | New feature or capability                  |
| `fix`      | Bug fix                                    |
| `refactor` | Code restructuring without behavior change |
| `chore`    | Maintenance (deps, cleanup, config)        |
| `docs`     | Documentation only                         |
| `style`    | Formatting, whitespace (no logic change)   |
| `ci`       | CI/CD workflow changes                     |

Optional scope: `nix`, `home`, `core`, `packages`, `shell`, `ci`.

---

## Fresh MacBook Bootstrap

### Phase 0: Initial macOS Setup
- Sign into iCloud / Apple ID
- Enable FileVault
- (Optional) Install Xcode.app from App Store

### Phase 1: Install Prerequisites
```bash
xcode-select --install
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

### Phase 2: Clone & Build
```bash
git clone https://github.com/ecosse3/nix-config.git ~/nix-config
cd ~/nix-config
darwin-rebuild switch --flake .#macbook --impure
```
**Troubleshooting**: If the build fails with GitHub rate limiting, create a
[GitHub PAT](https://github.com/settings/tokens) and add to
`/etc/nix/nix.conf`: `access-tokens = github.com=<PAT>`

### Phase 3: Post-Rebuild State Restore

Run `just bootstrap-config` for detailed steps.

**Order matters** — SSH keys must come first (all git remotes use `git@github.com`).

Best approach: **USB stick** for tiny files, then curl/git for the rest.

#### USB stick (always do this)

Copy these from old Mac to USB, then USB to new Mac:

| What | Size | Why |
|------|------|-----|
| `~/.ssh/` | ~10 KB | All git remotes use SSH, no installer exists |
| `~/.gnupg/` | ~100 KB | GPG keys for pass, signing, no installer |
| `~/.password-store/` | ~1 MB | Or `git clone` after SSH keys |
| `~/.config/nvim/` (EcoVim) | ~1 MB | Or `git clone` after SSH keys |
| `~/Library/Application Support/kiro-cli/` | ~60 MB | Local AI state, no installer |

```bash
# Old Mac → USB
cp -a ~/.ssh /Volumes/USB/
cp -a ~/.gnupg /Volumes/USB/
cp -a ~/.password-store /Volumes/USB/
cp -a ~/.config/nvim /Volumes/USB/
cp -a ~/Library/Application\ Support/kiro-cli/ /Volumes/USB/

# USB → New Mac
cp -a /Volumes/USB/.ssh ~/ && chmod 700 ~/.ssh && chmod 600 ~/.ssh/id_*
cp -a /Volumes/USB/.gnupg ~/ && chmod 700 ~/.gnupg && chmod 600 ~/.gnupg/*
cp -a /Volumes/USB/.password-store ~/
cp -a /Volumes/USB/nvim ~/.config/
cp -a /Volumes/USB/kiro-cli/ ~/Library/Application\ Support/kiro-cli/
```

#### Curl-installed tools (reinstall, not copy)

| Tool | Size | Reason |
|------|------|--------|
| **Rust** (`rustup`) | ~9 GB | Reinstall faster than USB copy |
| **bun** | ~4 GB | Reinstall faster than USB copy |
| **fnm** | ~50 MB | Reinstall, then `fnm install --lts` |
| **pnpm** | — | `corepack enable pnpm` |

#### Projects (23+ repos, ~67 GB)

Two options:
- **Clone only what you need**: `git clone` individual repos from GitHub
- **Full rsync over LAN**: after USB step, SSH keys work for network transfer:
  ```bash
  rsync -aP --progress user@192.168.1.X:~/Projects/ ~/Projects/
  ```

### Phase 4: Manual App Config
- **Raycast** — logs into cloud sync automatically
- **Karabiner-Elements** — grant Input Monitoring in Privacy & Security
- **SketchyBar** — grant Accessibility permissions
- **Aerospace** — grant Accessibility permissions
- Some `system.defaults` changes need logout/restart to apply

---

## Host: hp

- **Hardware**: HP laptop, x86_64-linux, Nvidia GPU (modesetting), fingerprint reader
- **Display**: GNOME desktop + Niri compositor, GDM + greetd, X11 enabled, DPI 120
- **Boot**: systemd-boot, EFI, NTFS support
- **Audio**: PipeWire (+ ALSA, PulseAudio compat)
- **Locale**: en_US.UTF-8 with Polish regional settings, Polish keyboard layout
- **User groups**: networkmanager, wheel, i2c
- **Services**: fprintd, power-profiles-daemon, accounts-daemon, MPD, printing (CUPS)

---

## Adding Things

### New app or tool
**Always prefer Home Manager (`programs.<name>`) if a module exists.**
- Check `home-manager/options.html` or search nixpkgs for `programs.<name>`.
- If HM supports it, add it to `home/shared/` (or `home/darwin/` for macOS-only).
- Only fall back to `home/shared/default.nix` (`home.packages`) if no HM module exists.

For macOS-only apps not in nixpkgs, use `hosts/macbook/default.nix` `homebrew.casks`/`brews`.

### New language toolchain
Create `packages/languages/<lang>.nix`, import it in `packages/languages/default.nix`.

### New LSP/formatter/DAP
Add to `packages/neovim.nix`. Then add the server name to `ensure_installed` in
EcoVim config.

### New Home Manager program
Add `programs.<name>` block in `home/default.nix`, or create a new file in
`home/` and import it from `home/default.nix` (if platform-agnostic) or from
`homeModules` in `flake.nix` (if platform-specific).

### New host
1. Create `hosts/<name>/hardware-configuration.nix`
2. Add a `mkHost` call in `flake.nix` with appropriate `homeModules`
3. For Darwin: create `lib/mkDarwinHost.nix`, add `darwinConfigurations` block

### New zsh alias
Add to `shellAliases` in `home/shell/zsh.nix`.

---

## Ownership Caveats

- `flake.lock` is root-owned (written by `sudo nixos-rebuild`). If git complains
  about permissions, run: `sudo chown $(id -u):$(id -g) flake.lock`
- Same applies to any file modified during `nixos-rebuild switch`.
