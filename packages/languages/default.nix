# Language environments aggregator
#
# Add a new language by creating a file here and importing it below.
# Each file is platform-agnostic (works on NixOS and Darwin).

{ ... }:

{
  imports = [
    ./golang.nix
    ./lua.nix
    ./nodejs.nix
    ./python.nix
    ./rust.nix
  ];
}
