{ ... }:

{
  programs.neovide = {
    enable = true;

    settings = {
      fork = false;
      frame = "full";
      title-hidden = true;
      tabs = true;
      idle = true;
      maximized = false;
      vsync = true;
      srgb = false;
      no-multigrid = false;
      # neovim-bin is intentionally omitted — neovide finds nvim on $PATH,
      # which is required on NixOS (no /usr/local/bin)

      font = {
        normal = [ "FiraCode Nerd Font" ];
        size = 14.0;
        hinting = "full";
        edging = "antialias";
        features."FiraCode Nerd Font" = [
          "+liga"
          "+calt"
        ];
      };

      box-drawing.mode = "native";
    };
  };
}
