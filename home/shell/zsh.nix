{ pkgs, lib, ... }:

{
  programs.zsh.enable = true;
  programs.zsh = {
    enableCompletion = true;
    autosuggestion = {
      enable = true;
    };
    sessionVariables = {
      # Source cargo env for Rust toolchain
      NIX_CARGO_LD_LIBRARY_PATH = "$HOME/.rustup/toolchains/*/lib";
      # Android SDK
      ANDROID_HOME = "$HOME/Library/Android/sdk";
      ANDROID_SDK_ROOT = "$HOME/Library/Android/sdk";
      # Editors
      VISUAL = "nvim";
      EDITOR = "nvim";
      # Locale
      LC_ALL = "en_US.UTF-8";
      LANG = "en_US.UTF-8";
      LANGUAGE = "en_US.UTF-8";
    };
    initExtra = ''
      # Skip broken completions and use cached compinit
      autoload -Uz compinit
      compinit -u -C

      # Source cargo env if it exists (Rust toolchain on macOS without nix)
      if [ -f "$HOME/.cargo/env" ]; then
        source "$HOME/.cargo/env"
      fi

      # fnm - Node version manager
      eval "$(fnm env)"

      # rbenv - Ruby version manager
      eval "$(rbenv init - zsh)"

      # Google Cloud SDK (installed via nixpkgs)
      # Completions are handled automatically by home-manager

      # Kiro CLI
      if [ -f "$HOME/Library/Application Support/kiro-cli/shell/zshrc.pre.zsh" ]; then
        source "$HOME/Library/Application Support/kiro-cli/shell/zshrc.pre.zsh"
      fi

      # SSH agent with keychain (macOS)
      if [ -f "$HOME/.ssh/id_rsa" ]; then
        ssh-add --apple-use-keychain "$HOME/.ssh/id_rsa" 2>/dev/null
      fi

      # Cargo completions
      fpath+=("$HOME/.cargo/completions/zsh")

      # pnpm
      export PNPM_HOME="$HOME/Library/pnpm"
      export PATH="$PNPM_HOME:$PATH"

      # bun completions
      if [ -s "$HOME/.bun/_bun" ]; then
        source "$HOME/.bun/_bun"
      fi

      # GPG TTY
      export GPG_TTY=$(tty)

      # Kiro CLI post init
      if [ -f "$HOME/Library/Application Support/kiro-cli/shell/zshrc.post.zsh" ]; then
        source "$HOME/Library/Application Support/kiro-cli/shell/zshrc.post.zsh"
      fi
    '';
    shellAliases = {
      # Navigation
      l = "eza -lA --icons=auto --git";
      ls = "eza --tree --level=2 --long --icons --git";
      lt = "eza --tree --level=2 --long --icons --git";
      lg = "lazygit";
      y = "yazi";
      v = "nvim";
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
      loaddb = "gupdatedb --localpaths=$HOME --prunepaths=/Volumes --output=$HOME/locatedb";

      # SSH
      gl-bastion = "ssh l.kurpiewski@35.210.101.108 -NL 51821:localhost:51821";

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
        src = lib.cleanSource ../../p10k-config;
        file = "p10k.zsh";
      }
      {
        name = "zsh-syntax-highlighting";
        src = pkgs.zsh-syntax-highlighting;
        file = "share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh";
      }
    ];
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "sudo"
      ];
    };
  };
}
