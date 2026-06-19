{
  config,
  pkgs,
  lib,
  ...
}:

{
  programs.starship = {
    enable = false;
    enableZshIntegration = false;

    presets = [
      "tokyo-night"
      "nerd-font-symbols"
    ];

    settings = {
      add_newline = true;
      scan_timeout = 10;

      format =
        "[░▒▓](#a3aed2)"
        + "$shlvl"
        + "$os"
        + "$username"
        + "[](bg:#769ff0 fg:#a3aed2)"
        + "$directory"
        + "$hostname"
        + "[](fg:#769ff0 bg:#394260)"
        + "$git_branch"
        + "$git_status"
        + "[](fg:#394260 bg:#212736)"
        + "$bun"
        + "$nodejs"
        + "$python"
        + "$rust"
        + "$golang"
        + "$package"
        + "$java"
        + "$terraform"
        + "$docker_context"
        + "$nix_shell"
        + "$direnv"
        + "$jobs"
        + "$cmd_duration"
        + "[](fg:#212736 bg:#1d2230)"
        + "$localip"
        + "$time"
        + "$status"
        + "[ ](fg:#1d2230)"
        + "\n"
        + "$character";

      # ── User / System ──────────────────────────────────────

      os = {
        disabled = false;
        format = "[ $symbol]($style)";
        style = "bg:#a3aed2 fg:#090c0c";
      };

      username = {
        show_always = true;
        style_user = "bg:#090c0c fg:#a3aed2";
        format = "[ $user ]($style)";
      };

      shlvl = {
        disabled = false;
        format = "[ $symbol$shlvl ]($style)";
        style = "bg:#a3aed2 fg:#090c0c";
      };

      hostname = {
        ssh_only = true;
        style = "bg:#769ff0 fg:#090c0c";
        format = "@[$hostname]($style)";
        disabled = false;
      };

      # ── Git ─────────────────────────────────────────────────

      git_status = {
        staged = "+\${count}";
        modified = "!\${count}";
        deleted = "✘\${count}";
        untracked = "?\${count}";
        conflicted = "=\${count}";
        stashed = "\\$\${count}";
        ahead = "⇡\${count}";
        behind = "⇣\${count}";
        diverged = "⇕⇡\${ahead_count}⇣\${behind_count}";
      };

      # ── Languages / Tools ───────────────────────────────────

      bun = {
        format = "[ $symbol$version ]($style)";
        style = "bg:#212736 fg:#a0a9cb";
      };

      nodejs = {
        format = "[ $symbol$version ]($style)";
        style = "bg:#212736 fg:#a0a9cb";
      };

      python = {
        format = "[ $symbol$version ]($style)";
        style = "bg:#212736 fg:#a0a9cb";
      };

      rust = {
        format = "[ $symbol$version ]($style)";
        style = "bg:#212736 fg:#a0a9cb";
      };

      golang = {
        format = "[ $symbol$version ]($style)";
        style = "bg:#212736 fg:#a0a9cb";
      };

      java = {
        format = "[ $symbol$version ]($style)";
        style = "bg:#212736 fg:#a0a9cb";
      };

      package = {
        format = "[ $symbol$version ]($style)";
        style = "bg:#212736 fg:#a0a9cb";
      };

      terraform = {
        format = "[ Terraform: $workspace ]($style)";
        style = "bg:#212736 fg:#a0a9cb";
      };

      docker_context = {
        format = "[ $context ]($style)";
        style = "bg:#212736 fg:#a0a9cb";
      };

      nix_shell = {
        format = "[ $symbol$name ]($style)";
        style = "bg:#212736 fg:#a0a9cb";
        impure_msg = "impure";
        pure_msg = "pure";
      };

      direnv = {
        disabled = false;
        format = "[ $symbol$loaded/$allowed ]($style)";
        style = "bg:#212736 fg:#a0a9cb";
      };

      # ── Process / System ────────────────────────────────────

      jobs = {
        disabled = false;
        format = "[ $number ]($style)";
        style = "bg:#212736 fg:#a0a9cb";
        threshold = 1;
        number_threshold = 2;
      };

      cmd_duration = {
        min_time = 2000;
        format = "[ $duration ]($style)";
        style = "bg:#212736 fg:#a0a9cb";
      };

      localip = {
        disabled = false;
        format = "[ $localipv4 ]($style)";
        style = "bg:#1d2230 fg:#a0a9cb";
        ssh_only = true;
      };

      status = {
        disabled = false;
        format = "[ $symbol$status ]($style)";
        style = "bg:#1d2230 fg:#a0a9cb";
        pipestatus = true;
        pipestatus_separator = "|";
      };

      time = {
        disabled = false;
        time_format = "%R";
        style = "bg:#1d2230 fg:#a0a9cb";
        format = "[ $time ]($style)";
      };
    };
  };
}
