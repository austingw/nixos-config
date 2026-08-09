{
  # complex plugin configs get their own files
  imports = [
    ./snacks.nix
  ];

  # plugins using mostly default settings get configured here
  plugins = {
    # lazy loading
    lz-n.enable = true;

    # git plugins
    diffview.enable = true;
    gitsigns.enable = true;
    gitblame = {
      enable = true;
      lazyLoad.settings.event = "DeferredUIEnter";
    };
    neogit = {
      enable = true;
      lazyLoad.settings.cmd = "Neogit";
      settings.integrations = {
        diffview = true;
        snacks = true;
      };
    };

    # editor utilities
    grug-far = {
      enable = true;
      lazyLoad.settings.cmd = "GrugFar";
    };

    # ui plugins
    sleuth.enable = true;
    todo-comments.enable = true;
  };
}
