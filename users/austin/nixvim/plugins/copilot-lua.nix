{
  plugins.copilot-lua = {
    enable = true;
    lazyLoad.settings = {
      cmd = "Copilot";
      event = "InsertEnter";
    };
    settings.suggestion = {
      enabled = true;
      auto_trigger = true;
      debounce = 75;
      keymap.accept = "<M-Enter>";
    };
  };
}
