{
  services.linkwarden = {
    enable = true;
    host = "127.0.0.1";
    port = 3006;
    openFirewall = false;

    database.createLocally = true;

    storageLocation = "/var/lib/linkwarden";
    cacheLocation = "/var/cache/linkwarden";

    # FIRST-RUN ONLY, should delete:
    enableRegistration = true;

    environment = {
      NEXTAUTH_URL = "https://lw.stoat-wyvern.ts.net/api/v1/auth";

      # Preserve upstream's protection against fetching internal services.
      ALLOW_PRIVATE_NETWORK_ACCESS = "false";
    };

    environmentFile = "/var/lib/nixos/secrets/linkwarden.env";
  };
}
