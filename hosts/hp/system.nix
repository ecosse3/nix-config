{
  config,
  pkgs,
  lib,
  inputs,
  hostname,
  username,
  ...
}:

{
  # Nix daemon settings
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    trusted-users = [
      "root"
      "@wheel"
    ];
    warn-dirty = false; # suppress "Git tree is dirty" warnings

    # nix-community binary cache (neovim-nightly, etc.)
    substituters = [ "https://nix-community.cachix.org" ];
    trusted-public-keys = [ "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=" ];
  };

  # Auto garbage-collect old generations weekly
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  # Deduplicate store via systemd timer (not after every nix command)
  nix.optimise = {
    automatic = true;
    dates = "weekly";
  };

  # Disable legacy channels (flakes replace them)
  nix.channel.enable = false;

  # Networking
  networking.hostName = hostname;
  networking.networkmanager.enable = true;

  # WireGuard kernel module
  boot.extraModulePackages = [ config.boot.kernelPackages.wireguard ];
  environment.systemPackages = with pkgs; [ wireguard-tools ];

  # Timezone & Locale
  time.timeZone = "Europe/Warsaw";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pl_PL.UTF-8";
    LC_IDENTIFICATION = "pl_PL.UTF-8";
    LC_MEASUREMENT = "pl_PL.UTF-8";
    LC_MONETARY = "pl_PL.UTF-8";
    LC_NAME = "pl_PL.UTF-8";
    LC_NUMERIC = "pl_PL.UTF-8";
    LC_PAPER = "pl_PL.UTF-8";
    LC_TELEPHONE = "pl_PL.UTF-8";
    LC_TIME = "pl_PL.UTF-8";
  };

  # Sound (pipewire)
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Printing
  services.printing.enable = true;

  # MPD
  services.mpd = {
    enable = true;
    settings.bind_to_address = "any";
    openFirewall = false;
  };

  # Shell
  programs.zsh.enable = true;
  environment.shells = with pkgs; [ zsh ];

  # XDG portal
  xdg.portal.enable = true;

  # Docker
  virtualisation.docker.enable = true;

  # User
  users.users.${username} = {
    isNormalUser = true;
    description = "Lucas Kurpiewski";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
      "i2c"
    ];
    shell = pkgs.zsh;
    packages = with pkgs; [ ];
  };

  # Hardware
  hardware = {
    graphics.enable = true;
    nvidia.modesetting.enable = true;
  };

  # DankMaterialShell optional NixOS services
  services.fprintd.enable = true;
  services.power-profiles-daemon.enable = true;
  services.accounts-daemon.enable = true;
  hardware.i2c.enable = true;

  # Session variables
  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
  };

  system.stateVersion = "25.11";
}
