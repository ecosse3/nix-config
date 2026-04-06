# Rust toolchain
#
# Provides rustc + cargo from nixpkgs (stable channel).
# For per-project toolchain management (nightly, specific versions),
# consider adding `rust-overlay` flake input in the future:
#   https://github.com/oxalica/rust-overlay

{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    rustc
    cargo
  ];
}
