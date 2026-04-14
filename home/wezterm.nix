{
  lib,
  pkgs,
  ...
}:

{
  programs.wezterm = {
    enable = true;
    enableZshIntegration = true;

    # The HM module auto-generates: local wezterm = require 'wezterm'
    # Everything below is appended after that line.
    extraConfig =
      let
        # CMD keybindings only work on macOS
        darwinKeys = lib.optionalString pkgs.stdenv.isDarwin ''
          -- Tab management (macOS CMD keys)
          { mods = "CMD",       key = "j", action = act.ActivateTabRelative(-1) },
          { mods = "CMD",       key = "k", action = act.ActivateTabRelative(1) },
          { mods = "CMD",       key = 't', action = act.SpawnCommandInNewTab { cwd = wezterm.home_dir } },
          { mods = "CMD",       key = 'y', action = act.SpawnTab 'CurrentPaneDomain' },

          -- Window management
          { mods = "CMD",       key = ".", action = act.MoveTabRelative(1) },
          { mods = "CMD",       key = ",", action = act.MoveTabRelative(-1) },
          { mods = "CMD|SHIFT", key = "1", action = act.ActivateTab(0) },
          { mods = "CMD|SHIFT", key = "2", action = act.ActivateTab(1) },
          { mods = "CMD|SHIFT", key = "3", action = act.ActivateTab(2) },
          { mods = "CMD|SHIFT", key = "4", action = act.ActivateTab(3) },
          { mods = "CMD|SHIFT", key = "5", action = act.ActivateTab(4) },
          { mods = "CMD|SHIFT", key = "6", action = act.ActivateTab(5) },
          { mods = "CMD|SHIFT", key = "7", action = act.ActivateTab(6) },
          { mods = "CMD|SHIFT", key = "8", action = act.ActivateTab(7) },
          { mods = "CMD|SHIFT", key = "9", action = act.ActivateTab(8) },
          { mods = "CMD|SHIFT", key = "9", action = act.ActivateTab(9) },

          -- Panes
          { mods = "CMD|SHIFT", key = "h", action = act.SplitHorizontal({ args = {} }) },
          { mods = "CMD|SHIFT", key = "v", action = act.SplitVertical({ args = {} }) },
          { mods = "CMD",       key = "a", action = act.ActivatePaneDirection("Left") },
          { mods = "CMD",       key = "d", action = act.ActivatePaneDirection("Right") },
          { mods = "CMD|SHIFT", key = "k", action = act.ActivatePaneDirection("Up") },
          { mods = "CMD|SHIFT", key = "j", action = act.ActivatePaneDirection("Down") },
          { mods = "CMD",       key = "e", action = act.CloseCurrentPane({ confirm = true }) },
          { mods = "CMD",       key = "r", action = act.RotatePanes("Clockwise") },

          -- Copy Mode
          { mods = "CMD",       key = "x", action = act.ActivateCopyMode },

          -- Toggle Zoom Mode (Full Screen)
          { mods = "CMD",       key = "f", action = act.TogglePaneZoomState },

          -- Launcher
          {
            mods = "CMD",
            key = "Backspace",
            action = act.ShowLauncherArgs({
              flags = "FUZZY|WORKSPACES|LAUNCH_MENU_ITEMS",
            }),
          },

          -- Rename tab
          {
            mods = "CMD|SHIFT",
            key = "T",
            action = act.PromptInputLine({
              description = "Enter new name for tab",
              action = wezterm.action_callback(function(window, _pane, line)
                if line then
                  window:active_tab():set_title(line)
                end
              end),
            }),
          },

          -- Rename workspace
          {
            mods = "CMD|SHIFT",
            key = "W",
            action = act.PromptInputLine({
              description = "Enter new name for workspace",
              action = wezterm.action_callback(function(window, pane, line)
                if line then
                  wezterm.mux.rename_workspace(wezterm.mux.get_active_workspace(), line)
                end
              end),
            }),
          },

          -- Spawn cas-marketplace workspace
          {
            mods = "CMD|SHIFT",
            key = "C",
            action = wezterm.action_callback(function(window, pane)
              local project_path = wezterm.home_dir .. "/Projects/cas-marketplace"
              local workspace_name = "cas-marketplace"

              -- Create workspace and first window
              local tab1, pane1, window = mux.spawn_window({
                workspace = workspace_name,
                cwd = project_path .. "/apps/backend",
              })

              -- Pane 1: yarn dev in /apps/backend (already there)
              pane1:send_text("yarn dev\n")

              -- Pane 2: yarn dev in /apps/admin-panel
              local pane2 = pane1:split({
                direction = "Right",
                cwd = project_path .. "/apps/admin-panel",
              })
              pane2:send_text("yarn dev\n")

              -- Pane 3: yarn dev in /apps/storefront
              local pane3 = pane2:split({
                direction = "Right",
                cwd = project_path .. "/apps/storefront",
              })
              pane3:send_text("yarn dev\n")

              -- Second tab
              local tab2 = window:spawn_tab({
                cwd = project_path,
              })

              -- Pane 1: ngrok http 9000
              local tab2_pane1 = tab2:active_pane()
              tab2_pane1:send_text("ngrok http 9000\n")

              -- Pane 2: v (neovide)
              local tab2_pane2 = tab2_pane1:split({
                direction = "Right",
                cwd = project_path,
              })
              tab2_pane2:send_text("v\n")

              -- Focus the first tab
              window:activate()
            end),
          },
        '';

        darwinConfig = lib.optionalString pkgs.stdenv.isDarwin ''
          config.macos_window_background_blur = 20
        '';

        fontSize = if pkgs.stdenv.isLinux then "14.0" else "17.0";
      in
      # language=lua
      ''
        local mux = wezterm.mux
        local act = wezterm.action

        local config = {}

        if wezterm.config_builder then
          config = wezterm.config_builder()
        end

        --  ╭──────────────────────────────────────────────────────────╮
        --  │ Keymappings                                              │
        --  ╰──────────────────────────────────────────────────────────╯
        config.keys = {
          -- Window management
          { mods = "CTRL",       key = ".", action = act.MoveTabRelative(1) },
          { mods = "CTRL",       key = ",", action = act.MoveTabRelative(-1) },
          { mods = "CTRL|SHIFT", key = "1", action = act.ActivateTab(0) },
          { mods = "CTRL|SHIFT", key = "2", action = act.ActivateTab(1) },
          { mods = "CTRL|SHIFT", key = "3", action = act.ActivateTab(2) },
          { mods = "CTRL|SHIFT", key = "4", action = act.ActivateTab(3) },
          { mods = "CTRL|SHIFT", key = "5", action = act.ActivateTab(4) },
          { mods = "CTRL|SHIFT", key = "6", action = act.ActivateTab(5) },
          { mods = "CTRL|SHIFT", key = "7", action = act.ActivateTab(6) },
          { mods = "CTRL|SHIFT", key = "8", action = act.ActivateTab(7) },
          { mods = "CTRL|SHIFT", key = "9", action = act.ActivateTab(8) },
          { mods = "CTRL|SHIFT", key = "0", action = act.ActivateTab(9) },

          ${darwinKeys}

          -- Panes
          { mods = "CTRL|SHIFT", key = "h", action = act.SplitHorizontal({ args = {} }) },
          { mods = "CTRL|SHIFT", key = "s", action = act.SplitVertical({ args = {} }) },
          { mods = "CTRL|SHIFT", key = "v", action = act.PasteFrom("Clipboard") },
          { mods = "CTRL",       key = "a", action = act.ActivatePaneDirection("Left") },
          { mods = "CTRL",       key = "d", action = act.ActivatePaneDirection("Right") },
          { mods = "CTRL|SHIFT", key = "k", action = act.ActivatePaneDirection("Up") },
          { mods = "CTRL|SHIFT", key = "j", action = act.ActivatePaneDirection("Down") },
          { mods = "CTRL|ALT",       key = "e", action = act.CloseCurrentPane({ confirm = true }) },
          { mods = "CTRL|ALT",       key = "r", action = act.RotatePanes("Clockwise") },

          -- Copy Mode
          { mods = "CTRL|ALT",       key = "x", action = act.ActivateCopyMode },

          -- Toggle Zoom Mode (Full Screen)
          { mods = "CTRL|ALT",       key = "f", action = act.TogglePaneZoomState },

          -- Launcher
          {
            mods = "CTRL",
            key = "Backspace",
            action = act.ShowLauncherArgs({
              flags = "FUZZY|WORKSPACES|LAUNCH_MENU_ITEMS",
            }),
          },

          -- Rename tab
          {
            mods = "CTRL|SHIFT",
            key = "T",
            action = act.PromptInputLine({
              description = "Enter new name for tab",
              action = wezterm.action_callback(function(window, _pane, line)
                if line then
                  window:active_tab():set_title(line)
                end
              end),
            }),
          },

          -- Rename workspace
          {
            mods = "CTRL|SHIFT",
            key = "W",
            action = act.PromptInputLine({
              description = "Enter new name for workspace",
              action = wezterm.action_callback(function(window, pane, line)
                if line then
                  wezterm.mux.rename_workspace(wezterm.mux.get_active_workspace(), line)
                end
              end),
            }),
          },
        }

        --  ╭──────────────────────────────────────────────────────────╮
        --  │ Config options                                           │
        --  ╰──────────────────────────────────────────────────────────╯

        config.enable_kitty_keyboard = true
        config.front_end = "WebGpu"
        config.max_fps = 144
        config.window_padding = {
          left = 0,
          right = 0,
          top = 0,
          bottom = 2,
        }
        config.color_scheme = "Tokyo Night (Gogh)"
        config.font = wezterm.font("FiraCode Nerd Font")
        config.harfbuzz_features = { "zero", "cv05", "cv02", "ss05", "ss04" }
        config.font_size = ${fontSize}
        config.enable_scroll_bar = true
        config.scrollback_lines = 3500

        config.window_background_opacity = 0.95
        ${darwinConfig}

        config.launch_menu = {}

        config.enable_tab_bar = true
        config.use_fancy_tab_bar = false
        config.tab_bar_at_bottom = true
        config.hide_tab_bar_if_only_one_tab = true
        config.tab_max_width = 32

        config.colors = {
          tab_bar = {
            background = "#1a1b26",
            active_tab = {
              bg_color = "#755E87",
              fg_color = "#c0caf5",
              intensity = "Normal",
              underline = "None",
              italic = false,
              strikethrough = false,
            },
            inactive_tab = {
              bg_color = "#1a1b26",
              fg_color = "#6b7089",
              intensity = "Normal",
              underline = "None",
              italic = false,
              strikethrough = false,
            },
            inactive_tab_hover = {
              bg_color = "#1f2335",
              fg_color = "#6b7089",
              intensity = "Normal",
              underline = "None",
              italic = false,
              strikethrough = false,
            },
            new_tab = {
              bg_color = "#1a1b26",
              fg_color = "#6b7089",
              intensity = "Normal",
              underline = "None",
              italic = false,
              strikethrough = false,
            },
            new_tab_hover = {
              bg_color = "#1f2335",
              fg_color = "#6b7089",
              intensity = "Normal",
              underline = "None",
              italic = false,
              strikethrough = false,
            },
          },
        }

        --  ╭──────────────────────────────────────────────────────────╮
        --  │ Multiplexer                                              │
        --  ╰──────────────────────────────────────────────────────────╯
        wezterm.on("gui-startup", function(cmd)
          local args = {}
          if cmd then
            args = cmd.args
          end

          local default_tab, default_pane, default_window = mux.spawn_window({
            workspace = "default",
          })
        end)

        --  ╭──────────────────────────────────────────────────────────╮
        --  │ Neovim Zen Mode Integration                              │
        --  ╰──────────────────────────────────────────────────────────╯

        wezterm.on('user-var-changed', function(window, pane, name, value)
          local overrides = window:get_config_overrides() or {}
          if name == "ZEN_MODE" then
            local incremental = value:find("+")
            local number_value = tonumber(value)
            if incremental ~= nil then
              while (number_value > 0) do
                window:perform_action(wezterm.action.IncreaseFontSize, pane)
                number_value = number_value - 1
              end
              overrides.enable_tab_bar = false
            elseif number_value < 0 then
              window:perform_action(wezterm.action.ResetFontSize, pane)
              overrides.font_size = nil
              overrides.enable_tab_bar = true
            else
              overrides.font_size = number_value
              overrides.enable_tab_bar = false
            end
          end
          window:set_config_overrides(overrides)
        end)

        return config
      '';
  };
}
