{
  plugins.mini = {
    enable = true;

    modules = {
      ai.n_lines = 500;
      pairs = { };
      surround = { };
      statusline = { };
    };

    luaConfig.post = ''
      MiniStatusline.section_location = function()
        return "%2l:%-2v"
      end
    '';
  };
}
