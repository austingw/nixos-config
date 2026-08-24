{ config, ... }:

let
  pihole = config.services.pihole-ftl;
in
{
  services.pihole-ftl = {
    enable = true;

    queryLogDeleter = {
      enable = true;
      age = 90;
    };

    settings = {
      dns = {
        domainNeeded = true;
        listeningMode = "LOCAL";
        upstreams = [
          "9.9.9.9"
          "149.112.112.112"
        ];
      };

      ntp = {
        ipv4.active = false;
        ipv6.active = false;
        sync.active = false;
      };
    };

    lists = [
      {
        url = "https://raw.githubusercontent.com/hagezi/dns-blocklists/main/adblock/pro.txt";
        type = "block";
        enabled = true;
        description = "HaGeZi Multi Pro";
      }
      {
        url = "https://raw.githubusercontent.com/hagezi/dns-blocklists/main/adblock/tif.txt";
        type = "block";
        enabled = true;
        description = "HaGeZi Threat Intelligence Feeds";
      }
    ];
  };

  services.pihole-web = {
    enable = true;
    ports = [ "127.0.0.1:8080" ];
  };

  networking.firewall.interfaces.enp2s0 = {
    allowedTCPPorts = [ 53 ];
    allowedUDPPorts = [ 53 ];
  };

  systemd.services.pihole-gravity-update = {
    description = "Update Pi-hole gravity database";
    after = [
      "network-online.target"
      "pihole-ftl.service"
      "pihole-ftl-setup.service"
    ];
    wants = [ "network-online.target" ];
    requires = [ "pihole-ftl.service" ];

    serviceConfig = {
      Type = "oneshot";
      User = pihole.user;
      Group = pihole.group;
      ExecStart = "${pihole.pihole}/bin/pihole -g";
    };
  };

  systemd.timers.pihole-gravity-update = {
    description = "Daily Pi-hole gravity database update";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "daily";
      RandomizedDelaySec = "1h";
      Persistent = true;
    };
  };
}
