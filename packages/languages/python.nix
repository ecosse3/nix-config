# Python environment
#
# Nix approach to Python versions:
# - `python3` resolves to current stable (3.13.x on nixos-25.11)
# - Pin a specific version with `python312`, `python313`, etc.
# - For project-level venvs, use `uv` (installed in home/)
# - For nix-managed Python with packages, use `python3.withPackages`

{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    python3
    python3.pkgs.pip
  ];
}
