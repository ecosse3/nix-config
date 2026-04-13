{
  pkgs,
  lib,
  inputs,
  username,
  ...
}:

{
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable nix-command and flakes
  nix.settings.experimental-features = "nix-command flakes";

  # Manage zsh at system level (nix-darwin writes /etc/zshrc)
  programs.zsh.enable = true;

  # Touch ID for sudo
  security.pam.enableSudoTouchIdAuth = true;

  # Fonts
  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
  ];

  # nix-homebrew: manage Homebrew installation via nix
  nix-homebrew = {
    enable = true;
    enableRosetta = true; # for x86_64 brews on Apple Silicon
    user = username;
    autoMigrate = true; # safely migrate existing Homebrew install
  };

  # Homebrew package management
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = false;
      upgrade = false;
      cleanup = "none"; # SAFE: preserves all existing Homebrew packages during migration
    };
    global.autoUpdate = false;

    taps = [
      "BarutSRB/tap"
    ];

    brews = [
      # Window manager
      "omniwm"
    ];

    casks = [
      # Browsers
      "arc"

      # Communication
      "slack"
      "whatsapp"

      # Media / Productivity
      "spotify"

      # Productivity / Launcher
      "raycast"

      # System customization
      "karabiner-elements"
      "sketchybar"
    ];
  };

  # macOS system defaults
  system.defaults = {
    dock.autohide = true;
    dock.mru-spaces = false;
    finder.AppleShowAllExtensions = true;
    finder.FXPreferredViewStyle = "Nlsv"; # list view
    NSGlobalDomain.AppleKeyboardUIMode = 3;
    NSGlobalDomain.InitialKeyRepeat = 15;
    NSGlobalDomain.KeyRepeat = 2;
    NSGlobalDomain.NSAutomaticSpellingCorrectionEnabled = false;
    NSGlobalDomain.NSAutomaticWindowAnimationsEnabled = false;
  };

  # Required for Apple Silicon
  nixpkgs.hostPlatform = lib.mkDefault "aarch64-darwin";

  # Backwards compatibility
  system.stateVersion = 6;
}
