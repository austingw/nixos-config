{ pkgs, ... }:

{
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  networking.networkmanager.enable = true;

  hardware.enableRedistributableFirmware = true;

  time.timeZone = "America/New_York";

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings.LC_ALL = "en_US.UTF-8";
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    curl
    git
    just
    wget
  ];

  programs.fish.enable = true;

  services.tailscale = {
    enable = true;
    openFirewall = true;
  };
}
