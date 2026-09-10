{
  virtualisation.oci-containers = {
    backend = "docker";

    containers.aiostreams = {
      image = "ghcr.io/viren070/aiostreams:latest";

      ports = [
        "127.0.0.1:3000:3000"
      ];

      extraOptions = [
        "--dns=9.9.9.9"
        "--dns=149.112.112.112"
      ];

      volumes = [
        "/var/lib/aiostreams:/app/data"
        "/var/cache/aiostreams:/app/cache"
      ];

      environment = {
        BASE_URL = "https://aio.stoat-wyvern.ts.net";
        DATABASE_URI = "sqlite://./data/db.sqlite";
        DISK_CACHE_DIR = "/app/cache";
        AIOSTREAMS_AUTH_REQUIRED = "true";
      };

      environmentFiles = [
        "/var/lib/nixos/secrets/aiostreams.env"
      ];
    };
  };

  systemd.tmpfiles.rules = [
    "d /var/lib/aiostreams 0750 root root -"
    "d /var/cache/aiostreams 0750 root root -"
  ];
}
