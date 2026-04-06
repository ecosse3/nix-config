{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    inputs.zen-browser.homeModules.twilight
    inputs.dank-material-shell.homeModules.dank-material-shell
    inputs.dms-plugin-registry.modules.default
    inputs.danksearch.homeModules.default
  ];

  fonts.fontconfig.enable = true;

  home.username = "ecosse";
  home.homeDirectory = "/home/ecosse";

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
    nodejs_22
    polkit
    prettier
    sshfs
  ];

  programs.git = {
    enable = true;
    settings.user.name = "ecosse3";
    settings.user.email = "luk.kurpiewski@gmail.com";
  };

  programs.gpg = {
    enable = true;
  };

  programs.password-store = {
    enable = true;
    settings = {
      PASSWORD_STORE_DIR = "~/.password-store";
    };
  };

  programs.neovim = {
    enable = true;
    package = inputs.neovim-nightly-overlay.packages.${pkgs.stdenv.hostPlatform.system}.default;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  programs.zen-browser = {
    enable = true;
    policies = {
      DisableAppUpdate = true;
      DisableTelemetry = true;
      DisablePocket = true;
      DisableFirefoxStudies = true;
      DontCheckDefaultBrowser = true;
      NoDefaultBookmarks = true;
    };
  };

  programs.dank-material-shell = {
    enable = true;
    systemd.enable = true;
    dgop.package = inputs.nixpkgs-unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system}.dgop;
    plugins = {
      dankKDEConnect.enable = true;
    };
    clipboardSettings = {
      maxHistory = 500;
      autoClearDays = 30;
    };
    managePluginSettings = true;
  };

  programs.dsearch = {
    enable = true;
    config = {
      index_paths = [
        {
          path = "~/Projects";
          max_depth = 8;
          exclude_hidden = true;
          exclude_dirs = [ "node_modules" ".git" ".next" "dist" "build" ".turbo" ".cache" ];
        }
        {
          path = "~/Documents";
          max_depth = 6;
          exclude_hidden = true;
          exclude_dirs = [ ];
        }
      ];
    };
  };

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
        src = lib.cleanSource ./p10k-config;
        file = "p10k.zsh";
      }
    ];
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "z" "sudo" ];
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
