# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable NTFS support
  boot.supportedFilesystems = [ "ntfs" ];

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    liberation_ttf
    nerd-fonts.fira-code
    mplus-outline-fonts.githubRelease
    dina-font
    proggyfonts
  ];

  # Enable Flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Warsaw";

  # Select internationalisation properties.
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

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver = {
    xkb = {
      layout = "pl";
      variant = "";
    };
  };

  services.xserver.dpi = 120;

  # Reverse scroll direction on touchpad (natural scrolling)
  services.libinput = {
    enable = true;
    touchpad.naturalScrolling = true;
  };

  # Configure console keymap
  console.keyMap = "pl2";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  services.mpd = {
    enable = true;
    network.listenAddress = "any";
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # DankMaterialShell optional features
  services.fprintd.enable = true;                  # fingerprint auth on lock screen
  services.power-profiles-daemon.enable = true;    # power profile management
  services.accounts-daemon.enable = true;          # persist user profile changes
  hardware.i2c.enable = true;                      # I2C/DDC for external monitor brightness


  programs.zsh.enable = true;

  xdg.portal.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.ecosse = {
    isNormalUser = true;
    description = "Lucas Kurpiewski";
    extraGroups = [ "networkmanager" "wheel" "i2c" ];
    shell = pkgs.zsh;
    packages = with pkgs; [];
  };

  environment.shells = with pkgs; [ zsh ];

  hardware = {
    graphics.enable = true;
    nvidia.modesetting.enable = true;
  };

  programs.niri = {
    enable = true;
  };

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${config.programs.niri.package}/bin/niri-session";
        user = "ecosse";
      };
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    blueman
    bun
    cargo
    cmake
    curl
    fastfetch
    firefox
    gnumake
    go
    libgcc
    libgccjit
    libnotify
    mpd
    rustc
    unzip
    vim
    wayland
    wdisplays
    wget
    wl-clipboard
    xdg-utils
    yazi
    # DankMaterialShell optional features
    matugen          # dynamic theming
    cava             # audio visualization
    cups-pk-helper   # printer management via polkit
    i2c-tools        # I2C/DDC external monitor brightness
  ];

  environment.sessionVariables = {
    # If cursor becomes invisible
    WLR_NO_HARDWARE_CURSORS = "1";
    # Hint electron apps to use wayland
    NIXOS_OZONE_WL = "1";
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?
}
