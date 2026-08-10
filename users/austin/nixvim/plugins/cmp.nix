{
  plugins.cmp = {
    enable = true;

    settings = {
      snippet.expand = ''
        function(args)
          vim.snippet.expand(args.body)
        end
      '';

      completion.completeopt = "menu,menuone,noinsert";

      mapping = {
        "<Down>" = "cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select })";
        "<Up>" = "cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select })";
        "<C-n>" = "cmp.mapping.select_next_item()";
        "<C-p>" = "cmp.mapping.select_prev_item()";
        "<C-y>" = "cmp.mapping.confirm({ select = true })";
        "<C-e>" = "cmp.mapping.abort()";
        "<C-Space>" = "cmp.mapping.complete()";

        "<C-l>" = ''
          cmp.mapping(function(fallback)
            if vim.snippet.active({ direction = 1 }) then
              vim.snippet.jump(1)
            else
              fallback()
            end
          end, { "i", "s" })
        '';

        "<C-h>" = ''
          cmp.mapping(function(fallback)
            if vim.snippet.active({ direction = -1 }) then
              vim.snippet.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" })
        '';
      };

      sources = [
        { name = "nvim_lsp"; }
        { name = "path"; }
      ];
    };
  };
}
