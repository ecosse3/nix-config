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

  # Cross-platform system packages
  environment.systemPackages =
    with pkgs;
    [
      cmake
      curl
      gnumake
      slack
      spotify
      unzip
      vim
      wget
      yazi
    ]
    # Linux-only packages
    ++ lib.optionals pkgs.stdenv.isLinux [
      libgcc
      libgccjit
      xdg-utils
      firefox
      libnotify
      mpd
      wayland
      wdisplays
      wl-clipboard
      wasistlos

      # DankMaterialShell optional features
      matugen
      cava
      cups-pk-helper
      i2c-tools
    ];
}
