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

  # Enable Determinate Nix module
  determinateNix.enable = true;

  # Enable nix-command and flakes
  nix.settings.experimental-features = "nix-command flakes";

  # Manage zsh at system level (nix-darwin writes /etc/zshrc)
  programs.zsh.enable = true;

  # Touch ID for sudo (renamed option)
  security.pam.services.sudo_local.touchIdAuth = true;

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
      autoUpdate = true;
      upgrade = true;
      cleanup = "none"; # SAFE: preserves all existing Homebrew packages during migration
    };
    global.autoUpdate = false;

    taps = [
      "BarutSRB/tap"
      "felixkratz/formulae"
    ];

    brews = [
      # System customization
      "sketchybar"

      # CLI tools
      # curl from Homebrew ships its own CA bundle and works reliably on macOS.
      # nixpkgs curl relies on NIX_SSL_CERT_FILE or falls back to /etc/ssl/cert.pem,
      # which often causes TLS verification failures on Darwin.
      "curl"
      "sheets"
      "elio-fm/elio/elio"

      # Services (managed via brew for now)
      "mongodb-community"

      # Not in nixpkgs (stay in brew)
      "borders"
      "ical-buddy"
      "pinentry-mac"
      "tsm"
    ];

    casks = [
      # Browsers
      "arc"

      # Communication
      "whatsapp"

      # Productivity / Launcher
      "raycast"

      # Developer tools
      "docker-desktop" # Docker Desktop app (cask)
      "leader-key"
      "android-platform-tools"
      "devhub"
      "pgadmin4"
      "meld"
      "vlc"

      # System customization
      "aerospace"
      "betterdisplay"
      "blackhole-64ch"
      "droppy"
      "hammerspoon"
      "jordanbaird-ice"
      "karabiner-elements"
      "keycastr"
      "macfuse"
      "omniwm"
      "qmk-toolbox"
      "qnapi"
      "rar"
      "sf-symbols"
      "shottr"
      "vial"
    ];

    masApps = { };
  };

  # macOS system defaults
  system.defaults = {
    dock.autohide = true;
    dock.mru-spaces = false;
    dock.launchanim = true;
    finder.AppleShowAllExtensions = true;
    finder.FXPreferredViewStyle = "Nlsv"; # list view
    NSGlobalDomain.AppleKeyboardUIMode = 3;
    NSGlobalDomain.InitialKeyRepeat = 15;
    NSGlobalDomain.KeyRepeat = 2;
    NSGlobalDomain.NSAutomaticSpellingCorrectionEnabled = false;
    NSGlobalDomain.NSAutomaticWindowAnimationsEnabled = false;
    NSGlobalDomain."com.apple.sound.beep.volume" = 0.0;
    NSGlobalDomain."com.apple.sound.beep.feedback" = 0;
  };

  # Required for Apple Silicon
  nixpkgs.hostPlatform = lib.mkDefault "aarch64-darwin";

  # Define user (required for home-manager to set homeDirectory correctly)
  users.users.${username} = {
    home = "/Users/${username}";
  };

  # Set primary user (required for nix-darwin system defaults to work)
  system.primaryUser = username;

  # Backwards compatibility
  system.stateVersion = 6;
}
