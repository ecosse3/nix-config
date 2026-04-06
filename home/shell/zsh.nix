{ pkgs, lib, ... }:

{
  programs.zsh.enable = true;
  programs.zsh = {
    enableCompletion = true;
    autosuggestion = {
      enable = true;
    };
    shellAliases = {
      update = "sudo nixos-rebuild switch --flake .#hp";
      v = "nvim";
      ":q" = "exit";
      lg = "lazygit";
      sozsh = "source ~/.zshrc";
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
