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

#
# fnm interop:
#   nixpkgs' corepack shims (pnpm, yarn, ...) have a shebang hardcoded to
#   the Nix Node store path, so they ignore `fnm use` and report the wrong
#   Node to engines checks (e.g. "current: v24.x" while fnm is on 26).
#   `corepackShims` re-launches corepack's JS entrypoints with whatever
#   `node` is first on PATH: fnm's in interactive shells, Nix's elsewhere.
#   Node >= 25 no longer bundles corepack, so `corepack enable` per fnm
#   version isn't an option.

{ lib, pkgs, ... }:

let
  # Each entry is a node script; Node resolves the symlink to the real
  # corepack dist, so relative requires keep working.
  corepackEntrypoints = {
    corepack = "${pkgs.nodejs_24}/bin/corepack";
    pnpm = "${pkgs.corepack_24}/bin/pnpm";
    pnpx = "${pkgs.corepack_24}/bin/pnpx";
    yarn = "${pkgs.corepack_24}/bin/yarn";
    yarnpkg = "${pkgs.corepack_24}/bin/yarnpkg";
  };
  corepackShims = pkgs.symlinkJoin {
    name = "corepack-path-node";
    paths = lib.mapAttrsToList (
      bin: script:
      pkgs.writeShellScriptBin bin ''
        exec node ${script} "$@"
      ''
    ) corepackEntrypoints;
  };
in
{
  environment.systemPackages = with pkgs; [
    bun
    (lib.hiPrio corepackShims) # yarn/pnpm via packageManager, on PATH node
    deno
    fnm # Node version manager
    nodejs_24 # fallback `node` when fnm isn't initialised (GUI apps, scripts)
    pnpm # popular in Next.js ecosystem
  ];
}
