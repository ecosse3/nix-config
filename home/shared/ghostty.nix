{
  lib,
  pkgs,
  ...
}: {
  programs.ghostty = {
    enable = true;
    package = if pkgs.stdenv.isDarwin then pkgs.ghostty-bin else pkgs.ghostty;
    enableZshIntegration = true;
    installBatSyntax = true;
    installVimSyntax = true;

    settings = {
      theme = "TokyoNight";
      font-family = "FiraCode Nerd Font Mono";
      font-size = 18;
      background-opacity = 0.95;
      background-blur = 20;
      window-padding-x = 4;
      window-padding-y = 4;
      macos-titlebar-style = "tabs";
      macos-option-as-alt = true;
      mouse-hide-while-typing = true;
      window-save-state = "always";
      copy-on-select = "clipboard";
      confirm-close-surface = false;
      unfocused-split-opacity = 0.5;

      keybind = [
        # Splits (mirrors WezTerm macOS bindings)
        "super+shift+h=new_split:right"
        "super+shift+v=new_split:down"
        # Navigation
        "super+a=goto_split:left"
        "super+d=goto_split:right"
        "super+shift+k=goto_split:up"
        "super+shift+j=goto_split:down"
        # Close / zoom
        "super+e=close_surface"
        "super+f=toggle_split_zoom"
        # Rename tab
        "super+shift+t=prompt_tab_title"
      ];
    };
  };
}
