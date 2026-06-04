{
  inputs,
  pkgs,
  lib,
  ...
}:

{
  programs.neovim = {
    enable = true;
    package = inputs.neovim-nightly-overlay.packages.${pkgs.stdenv.hostPlatform.system}.default;
    extraPackages = with pkgs; [
      neovim-remote
    ];
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    withNodeJs = true;
    withPython3 = true;
    withRuby = true;
    extraConfig = "";
  };

  xdg.configFile."nvim/init.lua".enable = lib.mkForce false;
}
