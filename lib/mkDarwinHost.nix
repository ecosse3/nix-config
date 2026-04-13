{ inputs }:

{
  hostname,
  username,
  system,
  homeModules ? [ ],
  extraModules ? [ ],
}:

inputs.nix-darwin.lib.darwinSystem {
  inherit system;

  specialArgs = {
    inherit inputs username hostname;
  };

  modules = [
    ../packages
    ../darwin

    inputs.nix-homebrew.darwinModules.nix-homebrew

    inputs.home-manager.darwinModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.backupFileExtension = "backup";
      home-manager.extraSpecialArgs = {
        inherit inputs username;
      };
      home-manager.users.${username} =
        { ... }:
        {
          imports = [ ../home ] ++ homeModules;
        };
    }
  ] ++ extraModules;
}
