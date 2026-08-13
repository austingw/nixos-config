{
  # complex plugin configs get their own files
  imports = [
    ./cmp.nix
    ./conform.nix
    ./copilot-lua.nix
    ./lint.nix
    ./lsp.nix
    ./mini.nix
    ./neotree.nix
    ./snacks.nix
    ./treesitter.nix
    ./which-key.nix
  ];

  colorschemes.gruvbox-material-nvim.enable = true;

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
    highlight-colors = {
      enable = true;
      settings.render = "foreground";
    };
    sleuth.enable = true;
    todo-comments.enable = true;
    web-devicons.enable = true;
  };
}
