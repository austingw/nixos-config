{
  services.wastebin = {
    enable = true;
    stateDir = "/var/lib/wastebin";

    secretFile = "/var/lib/nixos/secrets/wastebin.env";

    settings = {
      WASTEBIN_ADDRESS_PORT = "127.0.0.1:3007";
      WASTEBIN_BASE_URL = "https://bin.stoat-wyvern.ts.net";

      WASTEBIN_DATABASE_PATH = "/var/lib/wastebin/sqlite3.db";
      WASTEBIN_TITLE = "Austin's Pastebin";

      # Maximum paste request size: 1 MiB.
      WASTEBIN_MAX_BODY_SIZE = 1048576;
    };
  };
}
