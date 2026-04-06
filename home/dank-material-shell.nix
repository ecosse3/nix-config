{ inputs, pkgs, ... }:

{
  imports = [
    inputs.dank-material-shell.homeModules.dank-material-shell
    inputs.dms-plugin-registry.modules.default
  ];

  programs.dank-material-shell = {
    enable = true;
    systemd.enable = true;
    dgop.package = inputs.nixpkgs-unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system}.dgop;
    plugins = {
      dankKDEConnect.enable = true;
    };
    clipboardSettings = {
      maxHistory = 500;
      autoClearDays = 30;
    };
    managePluginSettings = true;
  };

  home.packages = with pkgs; [ polkit prettier sshfs ];
}
