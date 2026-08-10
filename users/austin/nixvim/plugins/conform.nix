let
  jsFormatters = {
    __unkeyed-1 = "biome"; # unkeyed is a nixvim convention for mixed tables
    __unkeyed-2 = "oxfmt";
    __unkeyed-3 = "prettierd";
    stop_after_first = true;
  };
in
{
  plugins.conform-nvim = {
    enable = true;
    autoInstall.enable = true;

    settings = {
      default_format_opts = {
        timeout_ms = 3000;
        lsp_format = "fallback";
      };

      format_on_save = {
        timeout_ms = 500;
        lsp_format = "fallback";
      };

      formatters_by_ft = {
        css = [ "prettierd" ];
        fish = [ "fish_indent" ];
        go = [ "gofumpt" ];
        html = [ "prettierd" ];
        java = [ "google-java-format" ];
        javascript = jsFormatters;
        javascriptreact = jsFormatters;
        json = jsFormatters;
        lua = [ "stylua" ];
        nix = [ "nixfmt" ];
        python = [
          "ruff_fix"
          "ruff_organize_imports"
          "ruff_format"
        ];
        svelte = [ "prettierd" ];
        typescript = jsFormatters;
        typescriptreact = jsFormatters;
      };

      formatters = {
        biome.require_cwd = true;
        oxfmt.require_cwd = true;
        prettierd.require_cwd = true;
      };
    };
  };
}
