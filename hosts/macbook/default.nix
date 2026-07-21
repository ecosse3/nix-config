{
  pkgs,
  lib,
  inputs,
  username,
  ...
}:

{
  # Enable Determinate Nix module
  determinateNix.enable = true;

  # Enable nix-command and flakes
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

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

    # Optional: Declarative Homebrew tap trust entries.
    #
    # Note: The trust entries are _not_ removed if you remove them from those lists!
    # Use the `brew untrust` command to remove a trust entry.
    trust = {
      formulae = [
        "felixkratz/formulae/sketchybar"
      ];
      casks = [ ];
      commands = [ ];
      taps = [
        "adibhanna/tsm"
        "barutsrb/tap"
        "mongodb/brew"
      ];
    };
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
      "elio"
      "sheets"

      # Services (managed via brew for now)
      "mongodb-community@7.0"

      # Not in nixpkgs (stay in brew)
      "borders"
      "ical-buddy"
      "pinentry-mac"
      "adibhanna/tsm/tsm"
    ];

    casks = [
      # Photo Editing
      "affinity"

      # Browsers
      "arc"

      # Communication
      "whatsapp"

      # Productivity / Launcher
      "raycast"

      # Database
      "dbngin"

      # Developer tools
      "android-platform-tools"
      "ghostty"
      "docker-desktop" # Docker Desktop app (cask)
      "kiro-cli"
      "leader-key"
      "meld"
      "pgadmin4"
      "vlc"

      # System customization
      "nikitabobko/tap/aerospace"
      "betterdisplay"
      "blackhole-64ch"
      "hammerspoon"
      "jordanbaird-ice"
      "karabiner-elements"
      "keycastr"
      "macfuse"
      "omniwm"
      "qmk-toolbox"
      "rar"
      "sf-symbols"
      "shottr"
    ];

    masApps = { };
  };

  # macOS system defaults
  system.defaults = {
    dock.autohide = false;
    dock.mru-spaces = false;
    dock.launchanim = true;
    dock.tilesize = 64;
    dock.minimize-to-application = true;
    dock.show-recents = false;
    # Auto-hide the native macOS menu bar (sketchybar replaces it)
    NSGlobalDomain._HIHideMenuBar = true;
    finder.AppleShowAllExtensions = true;
    finder.FXPreferredViewStyle = "Nlsv";
    finder.ShowPathbar = true;
    finder.ShowStatusBar = true;
    finder._FXShowPosixPathInTitle = true;
    trackpad.TrackpadRightClick = true;
    trackpad.TrackpadThreeFingerDrag = true;
    screencapture.location = "~/Desktop/screenshots";
    screencapture.disable-shadow = true;
    loginwindow.GuestEnabled = false;
    NSGlobalDomain.AppleKeyboardUIMode = 3;
    NSGlobalDomain.InitialKeyRepeat = 15;
    NSGlobalDomain.KeyRepeat = 1;
    NSGlobalDomain.NSAutomaticSpellingCorrectionEnabled = false;
    NSGlobalDomain.NSAutomaticWindowAnimationsEnabled = false;
    NSGlobalDomain.ApplePressAndHoldEnabled = false;
    NSGlobalDomain."com.apple.sound.beep.volume" = 0.0;
    NSGlobalDomain."com.apple.sound.beep.feedback" = 0;
  };

  # Pre-activation: unload old LaunchAgents before nix-darwin bootstraps new ones.
  # Prevents "Failed to start agent with I/O error (code 5)" when agent plists change.
  system.activationScripts.preActivation.text = ''
    for agent in org.nix-community.home.gpg-agent org.nix-community.home.dconf-service; do
      launchctl bootout "gui/501/$agent" 2>/dev/null || true
    done
  '';

  # Overlay: fetch neovide nightly binary until next release fixes API compat
  nixpkgs.overlays = [
    (final: prev: {
      neovide = prev.stdenvNoCC.mkDerivation {
        pname = "neovide";
        version = "nightly-2026-07-20";
        src = final.fetchurl {
          url = "https://github.com/neovide/neovide/releases/download/nightly/neovide-macos-aarch64.tar.gz";
          hash = "sha256-XRyAHY3ryc5j7QDU7CZuLR5MW3tCCvXNzzn87F+5FTc=";
        };
        sourceRoot = ".";
        installPhase = ''
          mkdir -p $out/bin
          cp neovide $out/bin/
        '';
        meta.mainProgram = "neovide";
      };
    })
  ];

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
