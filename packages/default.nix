{ pkgs, lib, ... }:

{
  imports = [
    ./languages
    ./neovim.nix
  ];

  # Allow unfree packages and known-insecure-but-necessary packages
  nixpkgs.config.allowUnfree = true;

  # Bump bun ahead of nixpkgs (which still ships 1.3.13) to the latest
  # upstream release. Remove this overlay once nixpkgs catches up.
  #
  # Bump omniwm ahead of nix-dotfiles/nixpkgs (which still pin 0.6.4) to the
  # latest upstream release. Remove this overlay once nix-dotfiles catches up.
  nixpkgs.overlays = [
    (final: prev: {
      # To bump: check the latest tag at
      # https://github.com/BarutSRB/OmniWM/releases, then recompute the hash:
      #   curl -sL -o /tmp/omniwm.zip \
      #     "https://github.com/BarutSRB/OmniWM/releases/download/v<VERSION>/OmniWM-v<VERSION>.zip"
      #   nix hash file --sri --type sha256 /tmp/omniwm.zip
      omniwm = prev.omniwm.overrideAttrs (_: {
        version = "0.7.2";
        src = prev.fetchurl {
          url = "https://github.com/BarutSRB/OmniWM/releases/download/v0.7.2/OmniWM-v0.7.2.zip";
          hash = "sha256-wVPdL16U4JC4WG2E1AR5qv2AA44JOSNfMMS4Zyk3+8E=";
        };
      });
    })
  ];

  # pnpm has known CVEs but is required for EcoVim LSP setup (mason.nvim)
  nixpkgs.config.permittedInsecurePackages = [
    "pnpm-10.34.0"
  ];

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
