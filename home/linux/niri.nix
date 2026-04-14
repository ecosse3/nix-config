{ lib, ... }:

let
  niri-config = lib.cleanSource ./niri;
in
{
  home.file = {
    ".config/niri" = {
      source = niri-config;
      recursive = true;
    };
  };
}
