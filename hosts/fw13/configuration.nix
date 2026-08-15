{
  config,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ./disko.nix
    ./impermanence.nix
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
    kernelParams = [ "amdgpu.sg_display=0" ];
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  networking.networkmanager.enable = true;
  networking.hostName = "fw13";
  hardware.bluetooth.enable = true;
  hardware.enableRedistributableFirmware = true;
  time.timeZone = "America/New_York";

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ALL = "en_US.UTF-8";
    };
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

  nixpkgs.config = {
    allowUnfree = true;
  };

  environment.systemPackages = with pkgs; [
    git
    curl
    just
    wget
    wl-clipboard
  ];

  programs = {
    fish.enable = true;
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

  system.stateVersion = "26.05";
}
