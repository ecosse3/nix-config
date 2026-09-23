{ ... }:

{
  # OmniWM's home-manager module was upstreamed from nix-dotfiles into
  # home-manager itself (nix-community/home-manager#... "chore(omniwm): use
  # upstreamed module"), so programs.omniwm is now provided directly by the
  # home-manager input; no extra import needed.

  programs.omniwm = {
    enable = true;

    # Full copy of the live settings.toml (hotkeys, app rules, monitor
    # layout, etc.) captured on 2026-08-15. Home Manager owns this file from
    # now on, so any future GUI edits must be copied back here to persist
    # across `darwin-rebuild switch`.
    settings = ./omniwm-settings.toml;

    launchd = {
      enable = true;
      keepAlive = true;
    };
  };
}
