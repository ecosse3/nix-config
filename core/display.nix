{ config, pkgs, ... }:

{
  # X11
  services.xserver.enable = true;

  # GNOME Desktop Environment
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # Keyboard layout
  services.xserver = {
    xkb = {
      layout = "pl";
      variant = "";
    };
  };

  services.xserver.dpi = 120;

  # Touchpad natural scrolling
  services.libinput = {
    enable = true;
    touchpad.naturalScrolling = true;
  };

  # Console keymap
  console.keyMap = "pl2";

  # Niri compositor
  programs.niri.enable = true;

  # Greetd
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${config.programs.niri.package}/bin/niri-session";
        user = "ecosse";
      };
    };
  };
}
