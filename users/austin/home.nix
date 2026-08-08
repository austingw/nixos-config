{ config, pkgs, ... }:

{
  home.username = "austin";
  home.homeDirectory = "/home/austin";

  home.packages = with pkgs; [
    fastfetch
    zip
    unzip
    p7zip
    ripgrep
    eza
    alacritty
    neovim
    starship
    fish
  ];

  programs.git = {
    enable = true;
    settings.user = {
      name = "austin";
      email = "austin@austingw.com";
    };
  };

  home.stateVersion = "26.05";
  programs.home-manager.enable = true;
}
