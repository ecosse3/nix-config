{ pkgs, lib, ... }:

{
  imports = [
    ./languages
    ./neovim.nix
  ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Fonts (NixOS only -- on Darwin, fonts are managed differently)
  fonts.packages = lib.mkIf pkgs.stdenv.isLinux (
    with pkgs;
    [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      liberation_ttf
      nerd-fonts.fira-code
      mplus-outline-fonts.githubRelease
      dina-font
      proggyfonts
    ]
  );

  # System-wide packages needed by all users or system services
  environment.systemPackages =
    with pkgs;
    [
      nixfmt
      smartmontools
    ]
    ++ lib.optionals pkgs.stdenv.isLinux [
      # curl is installed from Homebrew on Darwin because nixpkgs curl has
      # TLS certificate issues on macOS (missing CA bundle fallback).
      curl
      libgcc
      libgccjit
      xdg-utils
      libnotify
      mpd
      wayland
      cups-pk-helper
      i2c-tools
      pciutils
      usbutils
      lm_sensors
      ethtool
      linuxPackages.nvidia_x11.settings
    ];
}
