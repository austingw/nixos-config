{
  services.beszel = {
    hub = {
      enable = true;
      host = "127.0.0.1";
      port = 3001;
      environment.APP_URL = "https://beszel.stoat-wyvern.ts.net";
    };

    agent = {
      enable = true;
      openFirewall = false;
      environment = {
        HUB_URL = "http://127.0.0.1:3001";
        DISABLE_SSH = "true";
        DOCKER_HOST = "unix:///var/run/docker.sock";
        SKIP_SYSTEMD = false;
        SYSTEM_NAME = "homelab";
      };
      environmentFile = "/var/lib/nixos/secrets/beszel-agent.env";
      smartmon.enable = true;
    };
  };

  systemd.services.beszel-agent.unitConfig.ConditionPathExists =
    "/var/lib/nixos/secrets/beszel-agent.env";

  services.uptime-kuma = {
    enable = true;
    settings = {
      HOST = "127.0.0.1";
      PORT = "3002";
    };
  };

  virtualisation.oci-containers.containers.dozzle = {
    image = "amir20/dozzle:v10.10.0@sha256:2875e3c1f31f2244ee99d6067b53852b30666b3e2fb293d179bc8be94b1da5eb";

    ports = [
      "127.0.0.1:3003:8080"
    ];

    volumes = [
      "/var/lib/dozzle:/data"
      "/var/run/docker.sock:/var/run/docker.sock:ro"
    ];

    environment = {
      DOZZLE_AUTH_PROVIDER = "forward-proxy";
      DOZZLE_AUTH_HEADER_USER = "Tailscale-User-Login";
      DOZZLE_AUTH_HEADER_EMAIL = "Tailscale-User-Login";
      DOZZLE_AUTH_HEADER_NAME = "Tailscale-User-Name";

      DOZZLE_ENABLE_ACTIONS = "false";
      DOZZLE_ENABLE_SHELL = "false";
      DOZZLE_ENABLE_MCP = "false";
      DOZZLE_NO_ANALYTICS = "true";
    };

    systemd.tmpfiles.rules = [
      "d /var/lib/dozzle 0750 root root -"
    ];
  };
}
