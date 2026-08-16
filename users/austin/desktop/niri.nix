{
  # Replace niri's automatically created default config with the managed one.
  xdg.configFile."niri/config.kdl".force = true;

  wayland.windowManager.niri = {
    enable = true;
    extraConfig = ''
      // Keep niri's compositor colors in sync with the active DMS theme.
      include optional=true "dms/colors.kdl"
    '';

    settings = {
      input = {
        keyboard.xkb = { };
        touchpad = {
          tap = { };
          dwt = { };
          natural-scroll = { };
        };
      };

      layout = {
        gaps = 8;
        center-focused-column = "never";
        preset-column-widths._children = [
          { proportion = 0.33333; }
          { proportion = 0.5; }
          { proportion = 0.66667; }
        ];
        default-column-width.proportion = 0.5;

        focus-ring = {
          width = 2;
          active-color = "#7fc8ff";
          inactive-color = "#505050";
        };
        border.off = { };
      };

      prefer-no-csd = { };
      screenshot-path = "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png";

      debug = {
        honor-xdg-activation-with-invalid-serial = { };
        wait-for-frame-completion-before-queueing = { };
      };

      binds = {
        # Applications and DMS surfaces.
        "Mod+T" = {
          _props.hotkey-overlay-title = "Open a Terminal";
          spawn = [ "alacritty" ];
        };
        "Mod+Space" = {
          _props.hotkey-overlay-title = "Application Launcher";
          spawn = [
            "dms"
            "ipc"
            "call"
            "spotlight"
            "toggle"
          ];
        };
        "Mod+N" = {
          _props.hotkey-overlay-title = "Notification Center";
          spawn = [
            "dms"
            "ipc"
            "call"
            "notifications"
            "toggle"
          ];
        };
        "Mod+Comma" = {
          _props.hotkey-overlay-title = "DMS Settings";
          spawn = [
            "dms"
            "ipc"
            "call"
            "settings"
            "toggle"
          ];
        };
        "Mod+V" = {
          _props.hotkey-overlay-title = "Clipboard Manager";
          spawn = [
            "dms"
            "ipc"
            "call"
            "clipboard"
            "toggle"
          ];
        };
        "Mod+M" = {
          _props.hotkey-overlay-title = "Process List";
          spawn = [
            "dms"
            "ipc"
            "call"
            "processlist"
            "toggle"
          ];
        };
        "Mod+X" = {
          _props.hotkey-overlay-title = "Power Menu";
          spawn = [
            "dms"
            "ipc"
            "call"
            "powermenu"
            "toggle"
          ];
        };
        "Super+Alt+L" = {
          _props.hotkey-overlay-title = "Lock the Session";
          spawn = [
            "dms"
            "ipc"
            "call"
            "lock"
            "lock"
          ];
        };
        # Audio, microphone, brightness, and night mode.
        "XF86AudioRaiseVolume" = {
          _props.allow-when-locked = true;
          spawn = [
            "dms"
            "ipc"
            "call"
            "audio"
            "increment"
            "3"
          ];
        };
        "XF86AudioLowerVolume" = {
          _props.allow-when-locked = true;
          spawn = [
            "dms"
            "ipc"
            "call"
            "audio"
            "decrement"
            "3"
          ];
        };
        "XF86AudioMute" = {
          _props.allow-when-locked = true;
          spawn = [
            "dms"
            "ipc"
            "call"
            "audio"
            "mute"
          ];
        };
        "XF86AudioMicMute" = {
          _props.allow-when-locked = true;
          spawn = [
            "dms"
            "ipc"
            "call"
            "audio"
            "micmute"
          ];
        };
        "XF86MonBrightnessUp" = {
          _props.allow-when-locked = true;
          spawn = [
            "dms"
            "ipc"
            "call"
            "brightness"
            "increment"
            "5"
            ""
          ];
        };
        "XF86MonBrightnessDown" = {
          _props.allow-when-locked = true;
          spawn = [
            "dms"
            "ipc"
            "call"
            "brightness"
            "decrement"
            "5"
            ""
          ];
        };
        "Mod+Alt+N" = {
          _props = {
            allow-when-locked = true;
            hotkey-overlay-title = "Toggle Night Mode";
          };
          spawn = [
            "dms"
            "ipc"
            "call"
            "night"
            "toggle"
          ];
        };

        # Window focus and movement.
        "Mod+Q" = {
          _props.repeat = false;
          close-window = { };
        };
        "Mod+H".focus-column-left = { };
        "Mod+J".focus-window-down = { };
        "Mod+K".focus-window-up = { };
        "Mod+L".focus-column-right = { };

        "Mod+Shift+H".consume-or-expel-window-left = { };
        "Mod+Shift+J".move-window-down = { };
        "Mod+Shift+K".move-window-up = { };
        "Mod+Shift+L".consume-or-expel-window-right = { };

        "Mod+Home".focus-column-first = { };
        "Mod+End".focus-column-last = { };
        "Mod+Ctrl+Home".move-column-to-first = { };
        "Mod+Ctrl+End".move-column-to-last = { };

        # Monitor focus and movement.
        "Mod+Ctrl+Left".focus-monitor-left = { };
        "Mod+Ctrl+Down".focus-monitor-down = { };
        "Mod+Ctrl+Up".focus-monitor-up = { };
        "Mod+Ctrl+Right".focus-monitor-right = { };
        "Mod+Ctrl+H".focus-monitor-left = { };
        "Mod+Ctrl+J".focus-monitor-down = { };
        "Mod+Ctrl+K".focus-monitor-up = { };
        "Mod+Ctrl+L".focus-monitor-right = { };

        "Mod+Ctrl+Shift+Left".move-column-to-monitor-left = { };
        "Mod+Ctrl+Shift+Down".move-column-to-monitor-down = { };
        "Mod+Ctrl+Shift+Up".move-column-to-monitor-up = { };
        "Mod+Ctrl+Shift+Right".move-column-to-monitor-right = { };
        "Mod+Ctrl+Shift+H".move-column-to-monitor-left = { };
        "Mod+Ctrl+Shift+J".move-column-to-monitor-down = { };
        "Mod+Ctrl+Shift+K".move-column-to-monitor-up = { };
        "Mod+Ctrl+Shift+L".move-column-to-monitor-right = { };

        # Workspaces.
        "Mod+Down".focus-workspace-down = { };
        "Mod+Up".focus-workspace-up = { };
        "Mod+Shift+Down".move-column-to-workspace-down = { };
        "Mod+Shift+Up".move-column-to-workspace-up = { };

        "Mod+WheelScrollDown" = {
          _props.cooldown-ms = 150;
          focus-workspace-down = { };
        };
        "Mod+WheelScrollUp" = {
          _props.cooldown-ms = 150;
          focus-workspace-up = { };
        };
        "Mod+Ctrl+WheelScrollDown" = {
          _props.cooldown-ms = 150;
          move-column-to-workspace-down = { };
        };
        "Mod+Ctrl+WheelScrollUp" = {
          _props.cooldown-ms = 150;
          move-column-to-workspace-up = { };
        };

        "Mod+1".focus-workspace = 1;
        "Mod+2".focus-workspace = 2;
        "Mod+3".focus-workspace = 3;
        "Mod+4".focus-workspace = 4;
        "Mod+5".focus-workspace = 5;
        "Mod+6".focus-workspace = 6;
        "Mod+7".focus-workspace = 7;
        "Mod+8".focus-workspace = 8;
        "Mod+9".focus-workspace = 9;
        "Mod+Shift+1".move-column-to-workspace = 1;
        "Mod+Shift+2".move-column-to-workspace = 2;
        "Mod+Shift+3".move-column-to-workspace = 3;
        "Mod+Shift+4".move-column-to-workspace = 4;
        "Mod+Shift+5".move-column-to-workspace = 5;
        "Mod+Shift+6".move-column-to-workspace = 6;
        "Mod+Shift+7".move-column-to-workspace = 7;
        "Mod+Shift+8".move-column-to-workspace = 8;
        "Mod+Shift+9".move-column-to-workspace = 9;

        # Column and window sizing.
        "Mod+BracketLeft".consume-or-expel-window-left = { };
        "Mod+BracketRight".consume-or-expel-window-right = { };
        "Mod+Period".expel-window-from-column = { };
        "Mod+R".switch-preset-column-width = { };
        "Mod+Shift+R".switch-preset-column-width-back = { };
        "Mod+Ctrl+Shift+R".switch-preset-window-height = { };
        "Mod+Ctrl+R".reset-window-height = { };
        "Mod+F".maximize-column = { };
        "Mod+Shift+F".fullscreen-window = { };
        "Mod+Shift+M".maximize-window-to-edges = { };
        "Mod+Ctrl+F".expand-column-to-available-width = { };
        "Mod+C".center-column = { };
        "Mod+Ctrl+C".center-visible-columns = { };
        "Mod+Minus".set-column-width = "-10%";
        "Mod+Equal".set-column-width = "+10%";
        "Mod+Shift+Minus".set-window-height = "-10%";
        "Mod+Shift+Equal".set-window-height = "+10%";
        "Mod+Ctrl+V".toggle-window-floating = { };
        "Mod+Shift+V".switch-focus-between-floating-and-tiling = { };
        "Mod+W".toggle-column-tabbed-display = { };

        # Overview, screenshots, and session controls.
        "Mod+O" = {
          _props.repeat = false;
          toggle-overview = { };
        };
        Print.screenshot = { };
        "Ctrl+Print".screenshot-screen = { };
        "Alt+Print".screenshot-window = { };
        "Mod+Escape" = {
          _props.allow-inhibiting = false;
          toggle-keyboard-shortcuts-inhibit = { };
        };
        "Mod+Shift+E".quit = { };
        "Ctrl+Alt+Delete".quit = { };
        "Mod+Shift+P".power-off-monitors = { };
        "Mod+Shift+Slash".show-hotkey-overlay = { };
      };

      _children = [
        {
          window-rule._children = [
            {
              draw-border-with-background = false;
            }
            { opacity = 0.9; }
            {
              background-effect = {
                blur = true;
              };
            }
          ];
        }
        {
          window-rule._children = [
            { match._props.is-active = false; }
            { opacity = .6; }
            {
              background-effect = {
                saturation = 0.0;
              };
            }
          ];
        }
        {
          window-rule._children = [
            { match._props.app-id = "brave-browser"; }

            { open-maximized = true; }
            { opacity = 1.0; }
          ];
        }
        {
          window-rule._children = [
            { geometry-corner-radius = 0; }
            { clip-to-geometry = true; }
          ];
        }
        {
          window-rule._children = [
            { match._props.app-id = "firefox$"; }
            { open-maximized = true; }
          ];
        }
        {
          window-rule._children = [
            { match._props.app-id = "^org\\.quickshell$"; }
            { open-floating = true; }
          ];
        }
      ];
    };
  };
}
