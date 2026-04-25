{ pkgs, inputs, ... }:

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
  programs.niri = {
    enable = true;
    package = inputs.niri.packages.${pkgs.stdenv.hostPlatform.system}.default;
  };

  # Greetd
  services.greetd = {
    enable = true;
    settings.default_session.user = "ecosse";
  };

  # DMS Greeter (DankMaterialShell login/lock screen via greetd)
  programs.dank-material-shell.greeter = {
    enable = true;
    compositor.name = "niri";
    configHome = "/home/ecosse";
  };
}
