# Helper to create a NixOS host configuration.
#
# Usage in flake.nix:
#   let
#     mkHost = import ./lib/mkHost.nix { inherit inputs; };
#   in {
#     nixosConfigurations.hp = mkHost {
#       hostname = "hp";
#       username = "ecosse";
#       system = "x86_64-linux";
#       homeModules = [
#         ./home/zen-browser.nix
#         ./home/dank-material-shell.nix
#         ./home/danksearch.nix
#       ];
#     };
#   };

{ inputs }:

{
  hostname,
  username,
  system,
  homeModules ? [],
}:

let
  pkgs = inputs.nixpkgs.legacyPackages.${system};
in
inputs.nixpkgs.lib.nixosSystem {
  inherit system;

  specialArgs = {
    inherit inputs username hostname;
  };

  modules = [
    ../core
    ../packages

    inputs.home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.extraSpecialArgs = {
        inherit inputs username;
      };
      home-manager.users.${username} = { ... }: {
        imports = [ ../home ] ++ homeModules;
      };
    }
  ];
}
