# Rust toolchain
#
# rustup from nixpkgs manages toolchains imperatively in ~/.rustup.
# nixpkgs' rustup patches downloaded binaries so they run on NixOS too.
# Do NOT also install rustc/cargo from nixpkgs — they collide with the
# rustup proxies (same bin names) and shadow each other on $PATH.
#
# First-time setup (per machine):
#   rustup default stable
#   rustup component add rust-analyzer   # optional
#
# Binaries from `cargo install` land in ~/.cargo/bin (added to PATH in
# home/shared/shell/zsh.nix).

{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    rustup
  ];
}
