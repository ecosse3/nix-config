{ inputs, ... }:

{
  imports = [ inputs.nix-dotfiles.homeModules.omniwm ];

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
