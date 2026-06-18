{
  inputs,
  pkgs,
  lib,
  ...
}:

let
  # Get dgop from nixpkgs (which is already nixos-unstable)
  unstable = import inputs.nixpkgs { system = pkgs.stdenv.hostPlatform.system; };
in
{
  imports = [
    inputs.dank-material-shell.homeModules.dank-material-shell
    inputs.dms-plugin-registry.homeModules.default
  ];

  programs.dank-material-shell = {
    enable = true;
    systemd.enable = true;
    dgop.package = unstable.dgop;
    plugins = {
      dankKDEConnect.enable = true;
    };
    clipboardSettings = {
      maxHistory = 500;
      autoClearDays = 30;
    };
    managePluginSettings = true;
  };

  home.packages = with pkgs; [
    polkit
    prettier
    sshfs
  ];
}
