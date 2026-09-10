{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ./disko.nix
    ./impermanence.nix
    ../common.nix
    ../../users/austin/nixos.nix

    inputs.dms-plugin-registry.nixosModules.default
  ];

  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot = {
        enable = true;
        configurationLimit = 10;
      };
    };
    kernelParams = lib.mkAfter [
      "amdgpu.dcdebugmask=0x410"
      "amdgpu.sg_display=0"
    ];
  };

  hardware.bluetooth.enable = true;
  hardware.graphics = {
    enable32Bit = true;
  };

  security.rtkit.enable = true;

  services = {
    power-profiles-daemon.enable = true;
    upower.enable = true;
    printing.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    keyd = {
      enable = true;
      keyboards.framework = {
        ids = [ "0001:0001" ];
        settings.main = {
          capslock = "esc";
          esc = "capslock";
        };
      };
    };
    displayManager.dms-greeter = {
      enable = true;
      compositor.name = "niri";
      configHome = "/home/austin";
    };
  };

  environment = {
    sessionVariables.NIXOS_OZONE_WL = "1";
    systemPackages = with pkgs; [
      wl-clipboard
    ];
  };

  programs = {
    niri.enable = true;
    dms-shell = {
      enable = true;
      systemd.enable = true;
      plugins = {
        dankterminaltheme.enable = true;
      };
    };
    dsearch = {
      enable = true;
      package = pkgs.dsearch;
      systemd = {
        enable = true;
        target = "default.target";
      };
    };
  };

  users.users.austin.hashedPasswordFile = "/persist/secrets/austin-password-hash";

  system.stateVersion = "26.05";
}
