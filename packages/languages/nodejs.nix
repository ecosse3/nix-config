# Node.js environment for Next.js development
#
# Version management in Nix (instead of nvm):
# - nixpkgs pins Node versions per channel. On nixos-25.11:
#     nodejs_20  -> 20.x (LTS maintenance)
#     nodejs_22  -> 22.x (LTS active)
#     nodejs_24  -> 24.x (current)
#     nodejs     -> alias for nodejs_22
#
# - nvm does NOT work on NixOS (downloads glibc-linked binaries that
#   fail on NixOS's non-FHS layout). Use these alternatives instead:
#
#   1. System-wide default: change nodejs_XX here
#   2. Per-project override: add a flake.nix to the project:
#        devShells.default = pkgs.mkShell {
#          packages = [ pkgs.nodejs_22 ];
#        };
#      then run `nix develop` in that project directory.
#   3. Quick one-off: nix shell nixpkgs#nodejs_22
#
# Corepack (for pnpm/yarn version pinning via package.json):
#   corepack ships with nodejs. Enable it if your projects use the
#   packageManager field in package.json.

{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    nodejs_24 # current (24.x) -- default `node` on PATH
    nodePackages.pnpm # popular in Next.js ecosystem
    corepack_24 # enables yarn/pnpm auto-install from package.json
  ];
}
