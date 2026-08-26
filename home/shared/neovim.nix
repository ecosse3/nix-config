{
  inputs,
  pkgs,
  lib,
  ...
}:

let
  # Set to false to use latest stable Neovim from nixpkgs instead of nightly.
  useNightly = false;
in
{
  programs.neovim = {
    enable = true;
    package =
      if useNightly then
        inputs.neovim-nightly-overlay.packages.${pkgs.stdenv.hostPlatform.system}.default
      else
        pkgs.neovim-unwrapped;
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
