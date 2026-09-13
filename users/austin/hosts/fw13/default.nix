{ inputs, pkgs, ... }:

{
  imports = [

    ./dms.nix
    ./icons.nix
    ./niri.nix
  ];

  home = {
    packages = with pkgs; [
      inputs.custom-packages.packages.${pkgs.stdenv.hostPlatform.system}.nuvio

      brave
      nerd-fonts.departure-mono
      opencode
      qbz
      uv
      vlc
    ];

    sessionVariables = {
      TERMINAL = "alacritty";
    };
  };

  programs = {
    alacritty = {
      enable = true;
      settings = {
        general.import = [
          "~/.config/alacritty/dank-theme.toml"
        ];
        window = {
          blur = true;
          decorations = "None";
        };
        font = {
          normal = {
            family = "DepartureMono Nerd Font";
            style = "Regular";
          };
          size = 14;
        };
        mouse.hide_when_typing = true;
      };
    };
  };
}
