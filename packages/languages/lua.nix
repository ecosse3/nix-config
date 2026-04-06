# Lua environment
#
# Provides lua interpreter + luarocks for neovim plugin development
# and general scripting.

{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    lua
    luarocks
    luajit
  ];
}
