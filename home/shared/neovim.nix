{ inputs, pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    package = inputs.neovim-nightly-overlay.packages.${pkgs.stdenv.hostPlatform.system}.default;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    withRuby = false;
    withPython3 = false;
    # No extraLuaConfig -- config lives in ~/.config/nvim (managed via stow)
    # No plugins -- managed in ~/.config/nvim directly
  };
}
