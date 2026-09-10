{ ... }:

{
  imports = [
    ./aiostreams.nix
    ./disko.nix
    ./hardware-configuration.nix
    ./monitoring.nix
    ./pihole.nix

    ../common.nix
    ../../users/austin/nixos.nix
  ];

  boot.loader = {
    efi.canTouchEfiVariables = true;
    systemd-boot = {
      enable = true;
      configurationLimit = 10;
    };
  };

  networking.firewall = {
    enable = true;
    interfaces.tailscale0.allowedTCPPorts = [ 22 ];
  };

  services = {
    fstrim.enable = true;

    logind.settings.Login = {
      HandleLidSwitch = "ignore";
      HandleLidSwitchDocked = "ignore";
      HandleLidSwitchExternalPower = "ignore";
    };

    openssh = {
      enable = true;
      openFirewall = false;
      settings = {
        KbdInteractiveAuthentication = false;
        PasswordAuthentication = false;
        PermitRootLogin = "no";
      };
    };

  };

  systemd.tmpfiles.rules = [
    "d /var/lib/nixos/secrets 0700 root root -"
  ];

  users.users.austin.hashedPasswordFile = "/var/lib/nixos/secrets/austin-password-hash";
  users.users.austin.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJTbqJrkyDFOcRi1QsHU5xO311TNBL8vIhHFz1ej84a9 austin@austingw.com"
  ];

  zramSwap = {
    enable = true;
    memoryPercent = 25;
  };

  system.stateVersion = "26.05";
}
