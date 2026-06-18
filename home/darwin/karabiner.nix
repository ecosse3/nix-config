{ lib, pkgs, ... }:

let
  karabinerJson = lib.optionalString pkgs.stdenv.isDarwin (
    builtins.toJSON {
      global = {
        show_in_menu_bar = false;
      };
      profiles = [
        {
          name = "Default profile";
          selected = true;
          complex_modifications = {
            parameters = {
              basic.to_if_alone_timeout_milliseconds = 120;
            };
            rules = [
              {
                description = "Cmd+Tab to F19 (disable macOS app switcher)";
                enabled = false;
                manipulators = [
                  {
                    from = {
                      key_code = "tab";
                      modifiers = {
                        mandatory = [ "command" ];
                      };
                    };
                    to = [ { key_code = "f19"; } ];
                    type = "basic";
                  }
                ];
              }
              {
                description = "Hyper + i/j/k/l == vim directional Keys";
                manipulators = [
                  {
                    from = {
                      key_code = "k";
                      modifiers = {
                        mandatory = [
                          "left_shift"
                          "left_command"
                          "left_control"
                          "left_option"
                        ];
                      };
                    };
                    to = [ { key_code = "up_arrow"; } ];
                    type = "basic";
                  }
                  {
                    from = {
                      key_code = "h";
                      modifiers = {
                        mandatory = [
                          "left_shift"
                          "left_command"
                          "left_control"
                          "left_option"
                        ];
                      };
                    };
                    to = [ { key_code = "left_arrow"; } ];
                    type = "basic";
                  }
                  {
                    from = {
                      key_code = "j";
                      modifiers = {
                        mandatory = [
                          "left_shift"
                          "left_command"
                          "left_control"
                          "left_option"
                        ];
                      };
                    };
                    to = [ { key_code = "down_arrow"; } ];
                    type = "basic";
                  }
                  {
                    from = {
                      key_code = "l";
                      modifiers = {
                        mandatory = [
                          "left_shift"
                          "left_command"
                          "left_control"
                          "left_option"
                        ];
                      };
                    };
                    to = [ { key_code = "right_arrow"; } ];
                    type = "basic";
                  }
                  {
                    from = {
                      key_code = "semicolon";
                      modifiers = {
                        mandatory = [
                          "left_shift"
                          "left_command"
                          "left_control"
                          "left_option"
                        ];
                      };
                    };
                    to = [
                      {
                        key_code = "right_arrow";
                        modifiers = [ "left_command" ];
                      }
                    ];
                    type = "basic";
                  }
                ];
              }
              {
                description = "CAPS_LOCK to Cmd+Alt (Hyper) or ESCAPE (If Alone) - Built-in Keyboard Only";
                manipulators = [
                  {
                    conditions = [
                      {
                        identifiers = [
                          {
                            product_id = 835;
                            vendor_id = 1452;
                          }
                        ];
                        type = "device_if";
                      }
                    ];
                    from = {
                      key_code = "caps_lock";
                      modifiers = { };
                    };
                    to = [
                      {
                        key_code = "left_command";
                        modifiers = [ "left_option" ];
                      }
                    ];
                    to_if_alone = [ { key_code = "escape"; } ];
                    type = "basic";
                  }
                  {
                    conditions = [
                      {
                        identifiers = [
                          {
                            product_id = 832;
                            vendor_id = 1452;
                          }
                        ];
                        type = "device_if";
                      }
                    ];
                    description = "Avoid starting sysdiagnose with cmd+shift+option+ctrl+,";
                    from = {
                      key_code = "comma";
                      modifiers = {
                        mandatory = [
                          "command"
                          "shift"
                          "option"
                          "control"
                        ];
                      };
                    };
                    to = [ ];
                    type = "basic";
                  }
                  {
                    conditions = [
                      {
                        identifiers = [
                          {
                            product_id = 832;
                            vendor_id = 1452;
                          }
                        ];
                        type = "device_if";
                      }
                    ];
                    description = "Avoid starting sysdiagnose with cmd+shift+option+ctrl+.";
                    from = {
                      key_code = "period";
                      modifiers = {
                        mandatory = [
                          "command"
                          "shift"
                          "option"
                          "control"
                        ];
                      };
                    };
                    to = [ ];
                    type = "basic";
                  }
                  {
                    conditions = [
                      {
                        identifiers = [
                          {
                            product_id = 832;
                            vendor_id = 1452;
                          }
                        ];
                        type = "device_if";
                      }
                    ];
                    from = {
                      description = "Avoid starting sysdiagnose with cmd+shift+option+ctrl+/";
                      key_code = "slash";
                      modifiers = {
                        mandatory = [
                          "command"
                          "shift"
                          "option"
                          "control"
                        ];
                      };
                    };
                    to = [ ];
                    type = "basic";
                  }
                ];
              }
              {
                description = "CAPS_LOCK to COMMAND+OPTION or ESCAPE (If Alone)";
                enabled = false;
                manipulators = [
                  {
                    conditions = [
                      {
                        identifiers = [
                          { vendor_id = 1452; }
                          { product_id = 835; }
                        ];
                        type = "device_if";
                      }
                    ];
                    from = {
                      key_code = "caps_lock";
                      modifiers = { };
                    };
                    to = [
                      {
                        key_code = "left_option";
                        modifiers = [ "left_command" ];
                      }
                    ];
                    to_if_alone = [ { key_code = "escape"; } ];
                    type = "basic";
                  }
                  {
                    description = "Avoid starting sysdiagnose with the built-in macOS shortcut cmd+shift+option+ctrl+,";
                    from = {
                      key_code = "comma";
                      modifiers = {
                        mandatory = [
                          "command"
                          "shift"
                          "option"
                          "control"
                        ];
                      };
                    };
                    to = [ ];
                    type = "basic";
                  }
                  {
                    description = "Avoid starting sysdiagnose with the built-in macOS shortcut cmd+shift+option+ctrl+.";
                    from = {
                      key_code = "period";
                      modifiers = {
                        mandatory = [
                          "command"
                          "shift"
                          "option"
                          "control"
                        ];
                      };
                    };
                    to = [ ];
                    type = "basic";
                  }
                  {
                    from = {
                      description = "Avoid starting sysdiagnose with the built-in macOS shortcut cmd+shift+option+ctrl+/";
                      key_code = "slash";
                      modifiers = {
                        mandatory = [
                          "command"
                          "shift"
                          "option"
                          "control"
                        ];
                      };
                    };
                    to = [ ];
                    type = "basic";
                  }
                ];
              }
              {
                description = "Cmd+h -> Cmd+Shift+H globally (bypass macOS Hide)";
                manipulators = [
                  {
                    from = {
                      key_code = "h";
                      modifiers = {
                        mandatory = [ "command" ];
                      };
                    };
                    to = {
                      key_code = "h";
                      modifiers = [
                        "command"
                        "left_shift"
                      ];
                    };
                    type = "basic";
                  }
                ];
              }
            ];
          };
          devices = [
            {
              identifiers = {
                is_keyboard = true;
                product_id = 835;
                vendor_id = 1452;
              };
              simple_modifications = [
                {
                  from = {
                    apple_vendor_top_case_key_code = "keyboard_fn";
                  };
                  to = [ { key_code = "left_control"; } ];
                }
                {
                  from = {
                    key_code = "left_command";
                  };
                  to = [ { key_code = "left_command"; } ];
                }
                {
                  from = {
                    key_code = "left_control";
                  };
                  to = [ { apple_vendor_top_case_key_code = "keyboard_fn"; } ];
                }
                {
                  from = {
                    key_code = "left_option";
                  };
                  to = [ { key_code = "left_option"; } ];
                }
                {
                  from = {
                    key_code = "non_us_backslash";
                  };
                  to = [ { key_code = "grave_accent_and_tilde"; } ];
                }
              ];
            }
            {
              disable_built_in_keyboard_if_exists = true;
              identifiers = {
                is_keyboard = true;
                product_id = 647;
                vendor_id = 64562;
              };
              manipulate_caps_lock_led = false;
            }
            {
              identifiers = {
                is_keyboard = true;
                product_id = 4294972067;
                vendor_id = 57624;
              };
              ignore = true;
              manipulate_caps_lock_led = false;
            }
            {
              disable_built_in_keyboard_if_exists = true;
              identifiers = {
                is_keyboard = true;
                product_id = 1;
                vendor_id = 57624;
              };
            }
          ];
          parameters = {
            delay_milliseconds_before_open_device = 0;
            mouse_motion_to_scroll.speed = 100;
          };
          virtual_hid_keyboard = {
            keyboard_type_v2 = "ansi";
          };
        }
      ];
    }
  );
in
{
  home.file = lib.mkIf pkgs.stdenv.isDarwin {
    ".config/karabiner/karabiner.json".text = karabinerJson;
  };
}
