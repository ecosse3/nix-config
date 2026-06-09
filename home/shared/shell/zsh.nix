{
  config,
  inputs,
  pkgs,
  lib,
  ...
}:

{
  home.packages = with pkgs; [
    zsh-completions
  ];

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion = {
      enable = true;
      strategy = [
        "history"
        "completion"
      ];
    };
    syntaxHighlighting = {
      enable = true;
    };
    historySubstringSearch = {
      enable = true;
    };
    history = {
      size = 100000;
      save = 100000;
      share = true;
      ignoreDups = true;
      ignoreAllDups = true;
      ignoreSpace = true;
      expireDuplicatesFirst = true;
    };
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "sudo"
        "docker"
        "terraform"
        "aws"
        "gcloud"
        "npm"
        "yarn"
        "bun"
        "command-not-found"
        "extract"
      ];
    };
    sessionVariables = {
      # Oh My Zsh path
      ZSH = "${pkgs.oh-my-zsh}/share/oh-my-zsh";
      # Source cargo env for Rust toolchain
      NIX_CARGO_LD_LIBRARY_PATH = "${config.home.homeDirectory}/.rustup/toolchains/*/lib";
      # Android SDK
      ANDROID_HOME = "${config.home.homeDirectory}/Library/Android/sdk";
      ANDROID_SDK_ROOT = "${config.home.homeDirectory}/Library/Android/sdk";
      # Editors
      VISUAL = "nvim";
      EDITOR = "nvim";
      # Locale
      LC_ALL = "en_US.UTF-8";
      LANG = "en_US.UTF-8";
      LANGUAGE = "en_US.UTF-8";
    };
    initContent =
      let
        # CMD keybindings only work on macOS
        darwin = lib.optionalString pkgs.stdenv.isDarwin ''
          # Kiro CLI post init
          if [ -f "${config.home.homeDirectory}/Library/Application Support/kiro-cli/shell/zshrc.post.zsh" ]; then
            source "${config.home.homeDirectory}/Library/Application Support/kiro-cli/shell/zshrc.post.zsh"
          fi

          # SSH agent with keychain (macOS)
          if [ -f "${config.home.homeDirectory}/.ssh/id_rsa" ]; then
            ssh-add --apple-use-keychain "${config.home.homeDirectory}/.ssh/id_rsa" 2>/dev/null
          fi
        '';

      in
      ''
        # Source cargo env if it exists (Rust toolchain on macOS without nix)
        if [ -f "${config.home.homeDirectory}/.cargo/env" ]; then
          source "${config.home.homeDirectory}/.cargo/env"
        fi

        eval "$(fnm env)"
        eval "$(rbenv init - zsh)"
        eval "$(devenv hook zsh)"

        # Google Cloud SDK (installed via nixpkgs)
        # Completions are handled automatically by home-manager

        # Cargo completions
        fpath+=("${config.home.homeDirectory}/.cargo/completions/zsh")

        # pnpm
        export PNPM_HOME="${config.home.homeDirectory}/Library/pnpm"
        export PATH="$PNPM_HOME:$PATH"

        # bun completions
        if [ -s "${config.home.homeDirectory}/.bun/_bun" ]; then
          source "${config.home.homeDirectory}/.bun/_bun"
        fi

        # bun path
        export PATH="${config.home.homeDirectory}/.bun/bin:$PATH"

        # GPG TTY
        export GPG_TTY=$(tty)

        ${darwin}

        # Open file(s) in running Neovide instance, or launch a new one
        function v() {
          local socket="/tmp/neovide.pipe"
          if nvr --servername "$socket" --nostart --remote-expr 'v:true' &>/dev/null; then
            # Existing Neovide is running — send files to it
            if [ $# -eq 0 ]; then
              nvr --servername "$socket" --nostart
            else
              nvr --servername "$socket" --nostart "$@"
            fi
          else
            # No running Neovide — clean stale socket and launch new one
            rm -f "$socket"
            neovide --frame ${if pkgs.stdenv.isDarwin then "buttonless" else "none"} "$@" &
            disown
          fi
        }

        function enativ-watermark () {
          local image_path="''${1:-bfp-propozycja-enativ-lukasz-kurpiewski_org_sekcja_jak_uzyskac_odszkodowanie.jpeg}"
          local watermark_text="''${2:-ENATIV Łukasz Kurpiewski}"
          local text_scale="''${3:-0.01}"
          local color="''${4:-128, 128, 128, 30}"

          watermark-cli "$image_path" "$watermark_text" -t "$text_scale" -c "$color" 100
        }
      '';
    shellAliases = {
      # Navigation
      l = "eza -lA --icons=auto --git";
      ls = "eza --tree --level=2 --long --icons --git";
      lt = "eza --tree --level=2 --long --icons --git";
      lg = "lazygit";
      y = "yazi";
      vi = "nvim";
      vim = "nvim";

      # Dev
      pn = "pnpm";
      yd = "yarn dev --concurrency 20";
      ydt = "yarn dev:turbo --concurrency 20";
      emulator = "emulator -avd Pixel_6_Pro_API_31";
      iosdevices = "xcrun xctrace list devices";

      # Utils
      sozsh = "source ~/.zshrc";
      bu = "brew update && brew upgrade";
      icat = "kitty +kitten icat";
      gpge = "gpg --encrypt --sign --armor -r";
      ghcs = "gh copilot suggest";
      serena = "uvx --from git+https://github.com/oraios/serena serena";
      loaddb = "gupdatedb --localpaths=${config.home.homeDirectory} --prunepaths=/Volumes --output=${config.home.homeDirectory}/locatedb";

      # Exit
      ":q" = "exit";
      ":wq" = "exit";
    };
    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "powerlevel10k-config";
        src = pkgs.writeTextDir "p10k.zsh" (builtins.readFile ./p10k.zsh);
        file = "p10k.zsh";
      }
      {
        name = "you-should-use";
        src = pkgs.zsh-you-should-use;
        file = "share/zsh/plugins/you-should-use/you-should-use.plugin.zsh";
      }
      {
        name = "zsh-fzf-history-search";
        src = pkgs.zsh-fzf-history-search;
        file = "share/zsh-fzf-history-search/zsh-fzf-history-search.plugin.zsh";
      }
      {
        name = "fzf-tab";
        src = pkgs.zsh-fzf-tab;
        file = "share/fzf-tab/fzf-tab.plugin.zsh";
      }
      {
        name = "kimi-cli";
        src = pkgs.fetchFromGitHub {
          owner = "MoonshotAI";
          repo = "zsh-kimi-cli";
          rev = "50d72a9182f3b8db6667a8c68ee1904482b59020";
          sha256 = "02fsbm410s1zyxsizpi9zx7caj3xfd3p3zh17hy1k4d5300ns4hl";
        };
        file = "kimi-cli.plugin.zsh";
      }
    ];
  };
}
