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
}
