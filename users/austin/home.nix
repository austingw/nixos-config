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
    ];

    sessionVariables = {
      TERMINAL = "alacritty";
    };

    stateVersion = "26.05";
  };

  programs = {
    alacritty.enable = true;
    fish.enable = true;

    git = {
      enable = true;
      settings.user = {
        name = "austin";
        email = "austin@austingw.com";
      };
    };

    home-manager.enable = true;

    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
    };

    starship.enable = true;
  };
}
