{
  description = "Ecosse Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-darwin.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };

    determinate.url = "github:DeterminateSystems/determinate";

    nix-homebrew = {
      url = "github:zhaofengli/nix-homebrew";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };

    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";

    dank-material-shell = {
      url = "github:AvengeMedia/DankMaterialShell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dms-plugin-registry = {
      url = "github:AvengeMedia/dms-plugin-registry";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    danksearch = {
      url = "github:AvengeMedia/danksearch";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      home-manager,
      nix-darwin,
      ...
    }:
    let
      mkHost = import ./lib/mkHost.nix { inherit inputs; };
      mkDarwinHost = import ./lib/mkDarwinHost.nix { inherit inputs; };
    in
    {
      nixosConfigurations = {
        hp = mkHost {
          hostname = "hp";
          username = "ecosse";
          system = "x86_64-linux";
          systemModules = [ ./hosts/hp ];
          homeModules = [
            ./home/shared/zen-browser.nix
            ./home/linux/dank-material-shell.nix
            ./home/linux/danksearch.nix
            ./home/linux/niri.nix
          ];
        };
      };

      darwinConfigurations = {
        macbook = mkDarwinHost {
          hostname = "macbook";
          username = "lukasz.kurpiewski";
          system = "aarch64-darwin";
          systemModules = [ ./hosts/macbook ];
          homeModules = [
            ./home/darwin
            ./home/shared/zen-browser.nix
          ];
          extraModules = [
            inputs.determinate.darwinModules.default
          ];
        };
      };
    };
}
