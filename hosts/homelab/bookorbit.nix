{
  services.bookorbit = {
    enable = true;
    openFirewall = false;
    createDatabaseLocally = true;

    environment = {
      HOST = "127.0.0.1";
      PORT = 3005;
      APP_URL = "https://lib.stoat-wyvern.ts.net";

      APP_DATA_PATH = "/var/lib/bookorbit";
      LIBRARY_BROWSE_ROOT = "/var/lib/bookorbit/books";

      # Trust forwarded headers from the local Tailscale proxy.
      TRUST_PROXY = "loopback";
    };

    environmentFile = "/var/lib/nixos/secrets/bookorbit.env";
  };

  systemd.tmpfiles.rules = [
    "d /var/lib/bookorbit/books 0750 bookorbit bookorbit -"
  ];

  systemd.services.bookorbit.serviceConfig = {
    Restart = "on-failure";
    RestartSec = "5s";
  };
}
