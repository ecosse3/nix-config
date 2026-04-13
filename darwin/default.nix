{ pkgs, lib, ... }:

{
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable nix-command and flakes
  nix.settings.experimental-features = "nix-command flakes";

  # Safe Homebrew integration -- does NOT uninstall existing brews
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = false;
      upgrade = false;
      cleanup = "none"; # SAFE: preserves all existing Homebrew packages
    };
  };

  # Required for Apple Silicon
  nixpkgs.hostPlatform = lib.mkDefault "aarch64-darwin";

  # Backwards compatibility
  system.stateVersion = 6;
}
