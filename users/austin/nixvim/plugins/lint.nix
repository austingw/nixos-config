{ lib, pkgs, ... }:

{
  # Dynamically selected linters are not discovered by autoInstall.
  extraPackages = with pkgs; [
    biome
    oxlint
  ];

  autoGroups.lint = { };

  plugins.lint = {
    enable = true;

    lazyLoad.settings.event = [
      "BufReadPost"
      "BufNewFile"
    ];

    # Installs linters listed statically in lintersByFt.
    autoInstall.enable = true;

    lintersByFt = {
      fish = [ "fish" ];
      go = [ "golangcilint" ];
      javascript = [ "eslint" ];
      javascriptreact = [ "eslint" ];
      lua = [ "luacheck" ];
      markdown = [ "vale" ];
      nix = [ "statix" ];
      typescript = [ "eslint" ];
      typescriptreact = [ "eslint" ];
    };

    autoCmd = {
      event = [
        "BufEnter"
        "BufWritePost"
        "InsertLeave"
      ];
      group = "lint";
      desc = "Lint current buffer";

      callback = lib.nixvim.mkRaw ''
        function(args)
          local buf = args.buf

          if not vim.api.nvim_buf_is_valid(buf) then
            return
          end

          vim.api.nvim_buf_call(buf, function()
            local lint = require("lint")
            local js_filetypes = {
              javascript = true,
              javascriptreact = true,
              typescript = true,
              typescriptreact = true,
            }
            local js_linters = {
              "eslint",
              "biomejs",
              "oxlint",
            }

            local filetype = vim.bo[buf].filetype

            if not js_filetypes[filetype] then
              -- Clear JS diagnostics if the buffer's filetype changed.
              for _, name in ipairs(js_linters) do
                vim.diagnostic.reset(lint.get_namespace(name), buf)
              end

              lint.try_lint()
              return
            end

            local selected = "eslint"
            local cwd = vim.fs.root(buf, {
              { "biome.json", "biome.jsonc" },
            })

            if cwd then
              selected = "biomejs"
            else
              cwd = vim.fs.root(buf, {
                { ".oxlintrc.json", "oxlint.config.ts" },
              })

              if cwd then
                selected = "oxlint"
              end
            end

            -- Each nvim-lint linter has a separate diagnostic namespace.
            for _, name in ipairs(js_linters) do
              if name ~= selected then
                vim.diagnostic.reset(lint.get_namespace(name), buf)
              end
            end

            lint.try_lint({ selected }, { cwd = cwd })
          end)
        end
      '';
    };
  };
}
