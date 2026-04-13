{ lib, ... }:

let
  sketchybar-config = lib.cleanSource ./sketchybar;
in
{
  home.file = {
    ".config/sketchybar" = {
      source = sketchybar-config;
      recursive = true;
    };
  };
}
