{ lib, ... }:

{
  home.file.".config/niri" = {
    source = lib.fileset.toSource {
      root = ./.;
      fileset = lib.fileset.difference ./. ./default.nix;
    };
    recursive = true;
  };
}
