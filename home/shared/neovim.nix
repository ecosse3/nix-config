{ inputs, pkgs, lib, ... }:

{
  programs.neovim = {
    enable = true;
    package = inputs.neovim-nightly-overlay.packages.${pkgs.stdenv.hostPlatform.system}.default;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    withRuby = false;
    withPython3 = false;
    extraConfig = "";
  };

  xdg.configFile."nvim/init.lua".enable = lib.mkForce false;
}
