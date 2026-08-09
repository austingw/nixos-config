{
  plugins.which-key = {
    enable = true;

    settings = {
      delay = 0;

      spec = [
        {
          __unkeyed-1 = "<leader>c";
          group = "[C]ode";
          mode = [
            "n"
            "x"
          ];
        }
        {
          __unkeyed-1 = "<leader>d";
          group = "[D]ocument";
        }
        {
          __unkeyed-1 = "<leader>r";
          group = "[R]ename";
        }
        {
          __unkeyed-1 = "<leader>s";
          group = "[S]earch";
        }
        {
          __unkeyed-1 = "<leader>w";
          group = "[W]orkspace";
        }
      ];
    };
  };
}
