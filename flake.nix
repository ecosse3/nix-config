{
  description = "Ecosse Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
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
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    dms-plugin-registry = {
      url = "github:AvengeMedia/dms-plugin-registry";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    danksearch = {
      url = "github:AvengeMedia/danksearch";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    home-manager,
    ...
  }: let
    mkHost = import ./lib/mkHost.nix { inherit inputs; };
  in {
    nixosConfigurations = {
      hp = mkHost {
        hostname = "hp";
        username = "ecosse";
        system = "x86_64-linux";
        homeModules = [
          ./home/zen-browser.nix
          ./home/dank-material-shell.nix
          ./home/danksearch.nix
        ];
      };

      # Future hosts:
      # macbook = mkDarwinHost { ... };
    };
  };
}
