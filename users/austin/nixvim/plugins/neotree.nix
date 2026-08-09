{
  plugins.neo-tree = {
    enable = true;

    lazyLoad.settings.cmd = "Neotree";

    settings.filesystem.filtered_items = {
      hide_dotfiles = false;
      hide_gitignored = false;
    };
  };
}
