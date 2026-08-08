{ config, pkgs, ... }:

{
  home = {
    username = "austin";
    homeDirectory = "/home/austin";

    packages = with pkgs; [
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

    stateVersion = "26.05";
  };

  programs.git = {
    enable = true;
    settings.user = {
      name = "austin";
      email = "austin@austingw.com";
    };
  };

  programs.home-manager.enable = true;
}
