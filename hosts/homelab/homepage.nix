{
  services.homepage-dashboard = {
    enable = true;
    listenPort = 3333;
    allowedHosts = "homepage.stoat-wyvern.ts.net,localhost:3333,127.0.0.1:3333";

    settings = {
      title = "Austin's Homelab";
      description = "My homelab";

      statusStyle = "dot";
      useEqualHeights = true;
    };
  };
}
