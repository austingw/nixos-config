{
  plugins.which-key = {
    enable = true;

    settings = {
      delay = 0;

      spec = [
        {
          __unkeyed-1 = "<leader>f";
          group = "[F]iles";
        }
        {
          __unkeyed-1 = "<leader>g";
          group = "[G]it";
        }
        {
          __unkeyed-1 = "<leader>s";
          group = "[S]earch";
        }
        {
          __unkeyed-1 = "<leader>u";
          group = "[U]I";
        }
      ];
    };
  };
}
