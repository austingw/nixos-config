{
  xdg.configFile."DankMaterialShell/settings.json".text = builtins.toJSON {
    currentThemeName = "purple";
    niriOverviewOverlayEnabled = true;
    showSystemTray = true;
    wallpaperPath = "~/Pictures/Wallpapers/wallhaven-yq5ejd.png";
  };
}
