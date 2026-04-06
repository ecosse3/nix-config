{ inputs, pkgs, username, ... }:

{
  imports = [
    ./neovim.nix
    ./shell/zsh.nix
  ];

  fonts.fontconfig.enable = true;

  home.username = username;
  home.homeDirectory = "/home/${username}";

  home.packages = with pkgs; [
    htop
    bun
    kitty
    lazygit
    ripgrep
    stow
    wezterm
    opencode
    pinentry-gnome3
    fastfetch
    just         # task runner (see Justfile)
    uv           # Python project manager (replaces pip/venv/pyenv)
  ];

  programs.git = {
    enable = true;
    settings.user.name = "ecosse3";
    settings.user.email = "luk.kurpiewski@gmail.com";
  };

  programs.gpg.enable = true;

  programs.password-store = {
    enable = true;
    settings = {
      PASSWORD_STORE_DIR = "~/.password-store";
    };
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  services.gpg-agent.enable = true;
  services.gpg-agent.pinentry.package = pkgs.pinentry-gnome3;

  home.stateVersion = "25.11";
}
