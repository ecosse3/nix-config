{
  inputs,
  pkgs,
  username,
  ...
}:

{
  imports = [
    ./neovim.nix
    ./shell/zsh.nix
    ./wezterm.nix
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
    fd
    stow
    opencode
    pinentry-gnome3
    fastfetch
    just # task runner (see Justfile)
    uv # Python project manager (replaces pip/venv/pyenv)
  ];

  programs.git = {
    enable = true;
    lfs.enable = true;
    settings = {
      user.name = "ecosse3";
      user.email = "luk.kurpiewski@gmail.com";
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
      pull.rebase = true;
      rebase.autoStash = true;
      merge.conflictStyle = "zdiff3";
      diff.algorithm = "histogram";
      diff.colorMoved = "default";
      commit.verbose = true;
      rerere.enabled = true;
      branch.sort = "-committerdate";
      log.date = "iso";
      alias = {
        graph = "log --decorate --oneline --graph";
        p = "pull --ff-only";
        co = "checkout";
        s = "status --short --branch";
      };
    };
    ignores = [
      ".direnv"
      "result"
      ".DS_Store"
    ];
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      line-numbers = true;
      side-by-side = true;
      navigate = true;
    };
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

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true; # caches devShells, much faster than plain direnv
  };

  programs.bat = {
    enable = true;
  };

  programs.eza = {
    enable = true;
    enableZshIntegration = true; # replaces ls with eza
    icons = "auto";
    git = true;
  };

  programs.gh = {
    enable = true;
    settings.git_protocol = "ssh";
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true; # provides z command (replaces oh-my-zsh z plugin)
  };

  services.gpg-agent.enable = true;
  services.gpg-agent.pinentry.package = pkgs.pinentry-gnome3;

  home.stateVersion = "25.11";
}
