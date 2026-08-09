{ lib, ... }:

{
  plugins = {
    # Supplies server defaults to vim.lsp.config().
    lspconfig.enable = true;

    fidget = {
      enable = true;
      settings.integration.nvim-tree.enable = false; # I use neo-tree instead of nvim-tree, so disable the integration to avoid errors.
    };
  };

  lsp = {
    servers = {
      "*".config.capabilities = lib.nixvim.mkRaw ''require("cmp_nvim_lsp").default_capabilities()'';

      ruff.enable = true;
      rust_analyzer.enable = true;
      svelte.enable = true;
      ts_ls.enable = true;
      tailwindcss.enable = true;
      nil_ls.enable = true;

      lua_ls = {
        enable = true;

        config.settings.Lua = {
          runtime.version = "LuaJIT";

          workspace = {
            checkThirdParty = false;
            library = lib.nixvim.mkRaw "{ vim.env.VIMRUNTIME }";
          };

          completion.callSnippet = "Replace";
        };
      };
    };

    onAttach = ''
      local method = "textDocument/documentHighlight"

      if client:supports_method(method, bufnr) then
        local group = vim.api.nvim_create_augroup(
          "lsp_document_highlight",
          { clear = false }
        )

        vim.api.nvim_clear_autocmds({
          group = group,
          buffer = bufnr,
        })

        vim.api.nvim_create_autocmd({
          "CursorHold",
          "CursorHoldI",
        }, {
          group = group,
          buffer = bufnr,
          callback = vim.lsp.buf.document_highlight,
        })

        vim.api.nvim_create_autocmd({
          "CursorMoved",
          "CursorMovedI",
        }, {
          group = group,
          buffer = bufnr,
          callback = vim.lsp.buf.clear_references,
        })

        vim.api.nvim_create_autocmd("LspDetach", {
          group = group,
          buffer = bufnr,
          callback = function()
            vim.schedule(function()
              local clients = vim.lsp.get_clients({
                bufnr = bufnr,
                method = method,
              })

              if #clients == 0 then
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds({
                  group = group,
                  buffer = bufnr,
                })
              end
            end)
          end,
        })
      end
    '';
  };
}
