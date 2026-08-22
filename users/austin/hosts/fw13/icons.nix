{ pkgs, ... }:

{
  home.pointerCursor = {
    enable = true;
    package = pkgs.simp1e-cursors;
    name = "Simp1e-Mix-Dark";
    size = 24;
    gtk.enable = true;
  };

  gtk = {
    enable = true;
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
  };
}
