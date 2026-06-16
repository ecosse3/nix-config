{ pkgs, ... }:

let
  yazi-plugins = pkgs.fetchFromGitHub {
    owner = "yazi-rs";
    repo = "plugins";
    rev = "e84f4fe5122b659544b4984e6b7daf14383dbe8f";
    hash = "sha256-FVVUU9c3VQBvfjwBBilbBS8ygU4U97L2DwdT4s55OW0=";
  };

  yazi-flavors-src = pkgs.fetchFromGitHub {
    owner = "kalidyasin";
    repo = "yazi-flavors";
    rev = "70fe6b4a245a59b546166aae6c45ee2b471869c2";
    hash = "sha256-9I6NWIlNi4y0mNuqX8AbjfIK9vrC3+fzP0dJdh6QAic=";
  };

  yazi-flavors = pkgs.runCommand "yazi-flavors-patched" { } ''
    cp -a ${yazi-flavors-src} $out
    chmod -R +w $out
    substituteInPlace $out/tokyonight-night.yazi/flavor.toml \
      --replace-fail 'name = "*/"' 'url = "*/"' \
      --replace-fail 'name = "*"' 'url = "*"'
  '';
in
{
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    shellWrapperName = "y";

    settings = {
      plugin.prepend_fetchers = [
        {
          id = "git";
          url = "*";
          run = "git";
          group = "git";
        }
        {
          id = "git";
          url = "*/";
          run = "git";
          group = "git";
        }
      ];
    };

    theme = {
      flavor = {
        dark = "tokyonight-night";
        light = "tokyonight-night";
      };
    };

    plugins = {
      git = "${yazi-plugins}/git.yazi";
    };

    flavors = {
      tokyonight-night = "${yazi-flavors}/tokyonight-night.yazi";
    };

    initLua = ''
      require("git"):setup {
        order = 1500,
      }
    '';
  };
}
