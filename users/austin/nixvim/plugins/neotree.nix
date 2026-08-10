{
  plugins.neo-tree = {
    enable = true;

    settings = {
      filesystem.filtered_items = {
        hide_dotfiles = false;
        hide_gitignored = false;
      };
      width = "fit-content";
    };
  };

}
