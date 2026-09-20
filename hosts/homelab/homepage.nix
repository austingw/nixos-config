{
  services.homepage-dashboard = {
    enable = true;
    listenPort = 3333;
    allowedHosts = "homepage.stoat-wyvern.ts.net,localhost:3333,127.0.0.1:3333";

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
      useEqualHeights = true;
    };

    widgets = [
      {
        resources = {
          cpu = true;
          disk = "/";
          memory = true;
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
  };
}
