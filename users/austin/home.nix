{ inputs, pkgs, ... }:

{
  imports = [
    inputs.nixvim.homeModules.nixvim
    ./desktop
  ];
  home = {
    username = "austin";
    homeDirectory = "/home/austin";

    packages = with pkgs; [
      brave
      eza
      fastfetch
      nerd-fonts.departure-mono
      nodejs
      opencode
      papirus-icon-theme
      p7zip
      pnpm
      ripgrep
      unzip
      uv
      zip
    ];

    sessionVariables = {
      TERMINAL = "alacritty";
    };

    stateVersion = "26.05";
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

    fish = {
      enable = true;
      interactiveShellInit = ''
        set fish_greeting # Disable greeting
      '';
      shellAbbrs = {
        nrs = "sudo nixos-rebuild switch --flake $HOME/nixos-config#fw13";
      };
      shellAliases = {
        ls = "eza";
        pn = "pnpm";
        ":q" = "exit";
      };
    };

    git = {
      enable = true;
      settings.user = {
        name = "austin";
        email = "austin@austingw.com";
      };
    };

    home-manager.enable = true;

    nixvim = {
      enable = true;
      viAlias = true;
      vimAlias = true;

      imports = [
        ./nixvim
      ];
    };

    starship = {
      enable = true;
      enableFishIntegration = true;
    };

    zellij = {
      enable = true;
      enableFishIntegration = true;
      themes = {
        duskfox.themes.duskfox = {
          bg = "#433c59";
          fg = "#e0def4";
          red = "#eb6f92";
          green = "#a3be8c";
          blue = "#569fba";
          yellow = "#f6c177";
          magenta = "#c4a7e7";
          orange = "#ea9a97";
          cyan = "#9ccfd8";
          black = "#373354";
          white = "#cdcbe0";
        };
      };
      layouts = {
        default = {
          layout = {
            _children = [
              {
                default_tab_template = {
                  _children = [
                    {
                      pane = {
                        size = 1;
                        borderless = true;
                        plugin.location = "zellij:tab-bar";
                      };
                    }
                    { children = { }; }
                    {
                      pane = {
                        size = 2;
                        borderless = true;
                        plugin.location = "zellij:status-bar";
                      };
                    }
                  ];
                };
              }
              {
                tab = {
                  _props.name = "fastfetch";
                  _children = [
                    {
                      pane = {
                        command = "fish";
                        args = [
                          "-c"
                          "fastfetch; exec fish"
                        ];
                      };
                    }
                  ];
                };
              }
            ];
          };
        };
      };
      settings = {
        default_mode = "locked";
        default_shell = "fish";
        show_startup_tips = false;
        theme = "duskfox";

        keybinds = {
          locked._children = [
            {
              bind = {
                _args = [
                  "Alt Left"
                  "Alt h"
                ];
                MoveFocusOrTab = [ "Left" ];
              };
            }
            {
              bind = {
                _args = [
                  "Alt Down"
                  "Alt j"
                ];
                MoveFocus = [ "Down" ];
              };
            }
            {
              bind = {
                _args = [
                  "Alt Up"
                  "Alt k"
                ];
                MoveFocus = [ "Up" ];
              };
            }
            {
              bind = {
                _args = [
                  "Alt Right"
                  "Alt l"
                ];
                MoveFocusOrTab = [ "Right" ];
              };
            }
            {
              bind = {
                _args = [ "Alt n" ];
                NewPane = { };
              };
            }
            {
              bind = {
                _args = [ "Alt f" ];
                ToggleFloatingPanes = { };
              };
            }
          ];
          shared._children = [
            {
              bind = {
                _args = [ "Alt N" ];
                NewTab = { };
              };
            }
          ];
        };
      };
    };

    zoxide = {
      enable = true;
      enableFishIntegration = true;
    };
  };
}
