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
    ../../users/austin/nixos.nix

    inputs.noctalia-greeter.nixosModules.default
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  networking.networkmanager.enable = true;
  networking.hostName = "fw13";
  hardware.bluetooth.enable = true;
  hardware.enableRedistributableFirmware = true;
  services.power-profiles-daemon.enable = true;
  services.upower.enable = true;
  time.timeZone = "America/New_York";

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ALL = "en_US.UTF-8";
    };
  };

  security.rtkit.enable = true;

  services = {
    printing.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };

  nixpkgs.config = {
    allowUnfree = true;
  };

  environment.systemPackages = with pkgs; [
    git
    curl
    niri
    wget
  ];

  programs.fish.enable = true;
  programs.niri.enable = true;
  programs.noctalia = {
    enable = true;
    systemd.enable = true;
  };
  programs.noctalia-greeter = {
    enable = true;

    settings = {
      cursor = {
        theme = "Bibata-Modern-Ice";
        size = 24;
        path = "${pkgs.bibata-cursors}/share/icons";
      };

      keyboard.layout = "us";
    };
  };

  system.stateVersion = "26.05";
}
