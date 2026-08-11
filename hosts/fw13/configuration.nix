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
    noctalia = {
      enable = true;
      systemd.enable = true;
    };
    noctalia-greeter = {
      enable = true;

      settings = {
        cursor = {
          theme = "Bibata-Modern-Ice";
          size = 24;
          path = "${pkgs.bibata-cursors}/share/icons";
        };
        session.default = "niri";

        keyboard.layout = "us";
      };
    };
  };

  system.stateVersion = "26.05";
}
