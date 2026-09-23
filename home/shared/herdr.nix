{ ... }:
{
  # herdr has no native Home Manager module yet, so config.toml is managed directly.
  # Keybindings mirror the Ghostty/WezTerm scheme (h/v splits, a/d/k/j pane focus,
  # e=close, f=zoom) under herdr's own prefix key, so nothing collides with
  # Ghostty's cmd-based shortcuts (herdr never sees a bare key outside prefix mode).
  xdg.configFile."herdr/config.toml".text = ''
    [keys]
    prefix = "ctrl+b"

    # Splits
    split_vertical = "prefix+h"    # side-by-side split (mirrors Ghostty super+shift+h)
    split_horizontal = "prefix+v"  # stacked split (mirrors Ghostty super+shift+v)

    # Pane focus
    focus_pane_left = "prefix+a"
    focus_pane_right = "prefix+d"
    focus_pane_up = "prefix+k"
    focus_pane_down = "prefix+j"

    # Pane operations
    close_pane = "prefix+e"
    zoom = "prefix+f"

    # Tabs
    new_tab = "prefix+t"
    close_tab = "prefix+w"
  '';
}
