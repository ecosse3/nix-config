{
  config,
  inputs,
  lib,
  pkgs,
  username,
  ...
}:

{
  imports = [
    ./neovim.nix
    ./shell/zsh.nix
    ./wezterm.nix
    ./lazygit.nix
    ./yazi.nix
    ./neovide.nix
    ./opencode.nix
    ./obsidian.nix
    ./discord.nix
  ];

  fonts.fontconfig.enable = pkgs.stdenv.isLinux;

  home.username = username;
  home.homeDirectory = if pkgs.stdenv.isLinux then "/home/${username}" else "/Users/${username}";

  home.packages =
    with pkgs;
    [
      # System utils
      htop
      jq
      age
      glow # markdown viewer
      imagemagick # image manipulation
      ncdu # disk usage analyzer
      mmv # mass move/rename
      yt-dlp # video downloader
      awscli2

      # Dev tools
      bun
      deno
      ripgrep
      fd
      fastfetch
      just # task runner (see Justfile)
      uv # Python project manager (replaces pip/venv/pyenv)
      fnm # Node version manager
      rbenv # Ruby version manager
      sqlite
      television

      # Dev containers
      devenv
      devpod

      # Database tools
      tableplus

      # Terminal tools
      zellij
      lazydocker
      ngrok
      gopass
    ]
    ++ lib.optionals pkgs.stdenv.isLinux [
      pinentry-gnome3
    ]
    ++ lib.optionals pkgs.stdenv.isDarwin [
      pkgs.google-cloud-sdk # Google Cloud CLI
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
      ".claude"
    ];
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      line-numbers = true;
      side-by-side = false;
      navigate = true;
    };
  };

  programs.gpg.enable = true;

  programs.password-store = {
    enable = true;
    settings = {
      PASSWORD_STORE_DIR = "${config.home.homeDirectory}/.password-store";
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
    settings.aliases.co = "pr checkout";
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true; # provides z command (replaces oh-my-zsh z plugin)
  };

  services.gpg-agent.enable = pkgs.stdenv.isLinux;
  services.gpg-agent.pinentry.package = lib.mkIf pkgs.stdenv.isLinux pkgs.pinentry-gnome3;

  home.stateVersion = "25.11";
}
