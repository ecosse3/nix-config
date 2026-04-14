{ ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./boot.nix
    ./system.nix
    ./display.nix
    ./keyd.nix
  ];
}
