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
    };
    initExtra = ''
      # Source cargo env if it exists (Rust toolchain on macOS without nix)
      if [ -f "$HOME/.cargo/env" ]; then
        source "$HOME/.cargo/env"
      fi
    '';
    shellAliases = {
      l = "eza -lA --icons=auto --git";
      ls = "eza --tree --level=2 --long --icons --git";
      lg = "lazygit";
      pn = "pnpm";
      serena = "uvx --from git+https://github.com/oraios/serena serena";
      sozsh = "source ~/.zshrc";
      v = "nvim";
      ":q" = "exit";
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
