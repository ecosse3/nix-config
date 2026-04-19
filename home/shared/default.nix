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
    ./lazygit.nix
    ./neovide.nix
    ./neovim.nix
    ./shell/zsh.nix
    ./wezterm.nix
    ./yazi.nix
    ./zen-browser.nix
  ];

  fonts.fontconfig.enable = pkgs.stdenv.isLinux;

  home.username = username;
  home.homeDirectory = if pkgs.stdenv.isLinux then "/home/${username}" else "/Users/${username}";

  # ╭──────────────────────────────────────────────────────────╮
  # │ Packages                                                 │
  # ╰──────────────────────────────────────────────────────────╯
  home.packages =
    with pkgs;
    [
      # System utils
      age
      awscli2
      cmake
      gnumake
      glow # markdown viewer
      htop
      imagemagick # image manipulation
      mmv # mass move/rename
      ncdu # disk usage analyzer
      slack
      spotify
      unzip
      vim
      wget
      yt-dlp # video downloader

      # Dev tools
      fastfetch
      just # task runner (see Justfile)
      ripgrep
      sqlite

      # Dev containers
      devenv
      devpod

      # Database tools
      tableplus

      # TUI
      gopass
      lazydocker
      ngrok
      zellij
    ]
    ++ lib.optionals pkgs.stdenv.isLinux [
      pinentry-gnome3
      cava
      firefox
      matugen
      wasistlos
      wdisplays
      wl-clipboard
    ]
    ++ lib.optionals pkgs.stdenv.isDarwin [
      pkgs.google-cloud-sdk # Google Cloud CLI
    ];

  # ╭──────────────────────────────────────────────────────────╮
  # │ Programs                                                 │
  # ╰──────────────────────────────────────────────────────────╯
  programs.bat = {
    enable = true;
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

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true; # caches devShells, much faster than plain direnv
  };

  programs.discord = {
    enable = true;
  };

  programs.eza = {
    enable = true;
    enableZshIntegration = true; # replaces ls with eza
    icons = "auto";
    git = true;
  };

  programs.fd = {
    enable = true;
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.gh = {
    enable = true;
    settings.git_protocol = "ssh";
    settings.aliases.co = "pr checkout";
  };

  programs.gpg.enable = true;

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

  programs.jq.enable = true;

  programs.obsidian = {
    enable = true;
  };

  programs.opencode = {
    enable = true;
  };

  programs.password-store = {
    enable = true;
    settings = {
      PASSWORD_STORE_DIR = "${config.home.homeDirectory}/.password-store";
    };
  };

  # Ruby version manager
  program.rbenv = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true; # provides rbenv init - zsh plugin is not needed
  };

  # Python project manager (replaces pip/venv/pyenv)
  programs.uv = {
    enable = true;
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true; # provides z command (replaces oh-my-zsh z plugin)
  };

  # ╭──────────────────────────────────────────────────────────╮
  # │ Services                                                 │
  # ╰──────────────────────────────────────────────────────────╯
  services.gpg-agent.enable = pkgs.stdenv.isLinux;
  services.gpg-agent.pinentry.package = lib.mkIf pkgs.stdenv.isLinux pkgs.pinentry-gnome3;

  home.stateVersion = "25.11";
}
