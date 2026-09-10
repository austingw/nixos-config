{ config, lib, ... }:

let
  tailscale = lib.getExe config.services.tailscale.package;

  endpoints = [
    {
      name = "aio";
      target = "http://127.0.0.1:3000";
      unit = "docker-aiostreams.service";
    }
    {
      name = "beszel";
      target = "http://127.0.0.1:3001";
      unit = "beszel-hub.service";
    }
    {
      name = "kuma";
      target = "http://127.0.0.1:3002";
      unit = "uptime-kuma.service";
    }
    {
      name = "dozzle";
      target = "http://127.0.0.1:3003";
      unit = "docker-dozzle.service";
    }

  ];

  dependencies = [
    "network-online.target"
    "tailscaled.service"
  ]
  ++ map (endpoint: endpoint.unit) endpoints;
in
{
  systemd.services.tailscale-services = {
    description = "Advertise homelab Tailscale Services";
    wantedBy = [ "multi-user.target" ];

    wants = dependencies;
    after = dependencies ++ [
      "tailscale-serve-aiostreams.service"
    ];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;

      ExecStart = map (
        endpoint: "${tailscale} serve --yes --service=svc:${endpoint.name} --https=443 ${endpoint.target}"
      ) endpoints;

      ExecStop = map (
        endpoint: "-${tailscale} serve --yes --service=svc:${endpoint.name} --https=443 off"
      ) (lib.reverseList endpoints);

      Restart = "on-failure";
      RestartSec = "5s";
    };
  };
}
