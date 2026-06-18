{ pkgs, lib, ... }:

let
  sketchybar-config = lib.cleanSource ./sketchybar;

  sbarLua = pkgs.stdenv.mkDerivation {
    name = "sbar-lua";
    src = pkgs.fetchFromGitHub {
      owner = "FelixKratz";
      repo = "SbarLua";
      rev = "dba9cc4";
      sha256 = "1wkfygk3qk8navj42n48wnqzksilc2virfb44w5p00wzvfnx64ln";
    };
    buildPhase = ''
      runHook preBuild
      make -C lua-5.5.0/src liblua.a SYSCFLAGS="-DLUA_USE_MACOSX" CC="cc -std=gnu99"
      mkdir -p bin
      cp lua-5.5.0/src/liblua.a bin/
      cc -std=c99 -O3 -g -shared -fPIC \
        -arch arm64 \
        -I lua-5.5.0/src \
        -L bin -llua \
        -framework CoreFoundation \
        src/sketchybar.c src/cJSON.c src/parsing.c \
        -o bin/sketchybar.so
      runHook postBuild
    '';
    installPhase = ''
      runHook preInstall
      mkdir -p $out/lib
      cp bin/sketchybar.so $out/lib/
      runHook postInstall
    '';
  };
in
{
  home.file = {
    ".config/sketchybar" = {
      source = sketchybar-config;
      recursive = true;
    };
    ".local/share/sketchybar_lua/sketchybar.so" = {
      source = "${sbarLua}/lib/sketchybar.so";
    };
  };
}
