{
  lib,
  pkgs,
  ...
}:

let
  regenerateDmsTheme = pkgs.writeShellScript "regenerate-dms-theme" ''
    for ((attempt = 0; attempt < 50; attempt++)); do
      mode="$(${lib.getExe pkgs.dms-shell} ipc call theme getMode 2>/dev/null)"
      if [[ "$mode" == "dark" || "$mode" == "light" ]]; then
        # DMS 1.5.3 skips custom-theme generation during its matugen startup race.
        sleep 1
        exec ${lib.getExe pkgs.dms-shell} ipc call theme "$mode"
      fi
      sleep 0.1
    done
    exit 1
  '';
in
{
  xdg.configFile = {
    "systemd/user/dms.service.d/theme.conf".text = ''
      [Service]
      ExecStartPost=${regenerateDmsTheme}
    '';

    "DankMaterialShell/settings.json".text = builtins.toJSON {
      currentThemeName = "custom";
      currentThemeCategory = "registry";
      customThemeFile = "/home/austin/.config/DankMaterialShell/themes/duskfox/theme.json";

      cornerRadius = 0;
      barElevationEnabled = false;
      blurEnabled = true;
      blurLayerOutlineOpacity = 0.13;
      blurBorderOpacity = 0.47;
      showWorkspaceIndex = true;
      mediaUseAlbumArtAccent = true;

      greeterRememberLastUser = false;
      greeterFontFamily = "DepartureMono Nerd Font";

      rememberLastMode = false;
      dankLauncherV2Size = "micro";
      dankLauncherV2IncludeFilesInAll = true;
      dankLauncherV2IncludeFoldersInAll = true;
      launcherUseOverlayLayer = true;
      launcherLogoColorOverride = "primary";

      iconThemeDark = "Papirus-Dark";
      lastAppliedIconTheme = "Papirus-Dark";
      fontFamily = "DepartureMono Nerd Font";
      monoFontFamily = "DepartureMono Nerd Font";

      acSuspendBehavior = 2;
      batterySuspendBehavior = 2;
      batteryAutoPowerSaver = true;
      fadeToLockEnabled = false;
      fadeToLockGracePeriod = 30;
      fadeToDpmsGracePeriod = 30;

      muxType = "zellij";

      showDock = true;
      dockSmartAutoHide = true;
      dockPosition = 3;

      lockScreenFontFamily = "DepartureMono Nerd Font";
      updaterIntervalSeconds = 86400;

      barConfigs = [
        {
          id = "default";
          name = "Main Bar";
          enabled = true;
          position = 0;
          screenPreferences = [ "all" ];
          showOnLastDisplay = true;
          leftWidgets = [
            "launcherButton"
            "workspaceSwitcher"
            {
              id = "focusedWindow";
              enabled = true;
              focusedWindowCompactMode = true;
              focusedWindowSize = 0;
            }
          ];
          centerWidgets = [ "clock" ];
          rightWidgets = [
            "systemTray"
            {
              id = "music";
              enabled = true;
              mediaSize = 1;
            }
            "clipboard"
            "notificationButton"
            {
              id = "cpuUsage";
              enabled = true;
              minimumWidth = false;
            }
            "battery"
            "controlCenterButton"
          ];
          spacing = 4;
          innerPadding = 0;
          barInsetPadding = 4;
          bottomGap = 0;
          transparency = 0.54;
          widgetTransparency = 1.0;
          squareCorners = true;
          noBackground = true;
          maximizeWidgetIcons = true;
          maximizeWidgetText = false;
          removeWidgetPadding = false;
          widgetPadding = 8;
          widgetOutlineEnabled = true;
          fontScale = 1.12;
          iconScale = 0.81;
          hoverPopoutDelay = 259;
        }
      ];

      builtInPluginSettings = {
        dms_settings_search.trigger = "?";
        dms_clipboard_search.trigger = "cb";
      };

      configVersion = 13;
    };

    "DankMaterialShell/themes/duskfox/theme.json" = {
      source = ./duskfox-theme.json;
      force = true;
    };
  };
}
