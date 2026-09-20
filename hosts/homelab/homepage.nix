{
  services.homepage-dashboard = {
    enable = true;
    listenPort = 3333;
    allowedHosts = "homepage.stoat-wyvern.ts.net,localhost:3333,127.0.0.1:3333";

    environmentFiles = [
      "/var/lib/nixos/secrets/homepage.env"
    ];

    settings = {
      title = "Austin's Homelab";
      description = "My homelab";

      color = "emerald";
      theme = "dark";
      background = {
        image = "https://wallpapercave.com/wp/wp12329545.png";
        blur = "xl";
        saturate = 0;
        brightness = 50;
        opacity = 50;
      };
      statusStyle = "dot";
      disableIndexing = true;
      useEqualHeights = true;
    };

    widgets = [
      {
        resources = {
          cpu = true;
          disk = "/";
          memory = true;
          uptime = true;
          network = "enp2s0";
        };
      }
      {
        search = {
          provider = "google";
          focus = true;
          showSearchSuggestions = true;
          target = "_blank";
        };
      }
    ];

    services = [
      {
        Applications = [
          {
            AIOStreams = {
              href = "https://aio.stoat-wyvern.ts.net";
              description = "Media stream aggregation";
              siteMonitor = "http://127.0.0.1:3000";
            };
          }
        ];
      }

      {
        Monitoring = [
          {
            Beszel = {
              href = "https://beszel.stoat-wyvern.ts.net";
              description = "Host and container metrics";

              widget = {
                type = "beszel";
                url = "http://127.0.0.1:3001";
                username = "{{HOMEPAGE_VAR_BESZEL_USERNAME}}";
                password = "{{HOMEPAGE_VAR_BESZEL_PASSWORD}}";
                systemId = "homelab";
                version = 2;
                fields = [
                  "status"
                  "cpu"
                  "memory"
                  "disk"
                ];
              };
            };
          }
          {
            Dozzle = {
              href = "https://dozzle.stoat-wyvern.ts.net";
              description = "Container logs";
            };
          }
          {
            "Uptime Kuma" = {
              href = "https://kuma.stoat-wyvern.ts.net";
              description = "Service availability";

              widget = {
                type = "uptimekuma";
                url = "http://127.0.0.1:3002";
                slug = "hl";
                fields = [
                  "up"
                  "down"
                  "uptime"
                  "incident"
                ];
              };
            };
          }
        ];
      }

      {
        Infrastructure = [
          {
            "Pi-hole" = {
              description = "DNS filtering";
              siteMonitor = "http://127.0.0.1:8080";

              widget = {
                type = "pihole";
                url = "http://127.0.0.1:8080";
                version = 6;
                fields = [
                  "queries"
                  "blocked"
                  "gravity"
                ];
              };
            };
          }

          {
            Tailscale = {
              href = "https://login.tailscale.com/admin/machines";
              description = "Tailnet administration";

              widget = {
                type = "tailscale";
                deviceid = "{{HOMEPAGE_VAR_TAILSCALE_DEVICE_ID}}";
                key = "{{HOMEPAGE_VAR_TAILSCALE_KEY}}";
                fields = [
                  "address"
                  "last_seen"
                  "client_version"
                  "update_available"
                ];
              };
            };
          }
        ];
      }
    ];
  };
}
