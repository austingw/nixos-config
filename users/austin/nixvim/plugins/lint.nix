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
      python = [ "ruff" ];
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
          local lint = require("lint")
          local js_filetypes = {
            javascript = true,
            javascriptreact = true,
            typescript = true,
            typescriptreact = true,
          }

          local names_override
          local cwd

          if js_filetypes[vim.bo[args.buf].filetype] then
            cwd = vim.fs.root(args.buf, {
              { "biome.json", "biome.jsonc" },
            })

            if cwd then
              names_override = { "biomejs" }
            else
              cwd = vim.fs.root(args.buf, {
                { ".oxlintrc.json", "oxlint.config.ts" },
              })

              if cwd then
                names_override = { "oxlint" }
              end
            end
          end

          lint.try_lint(names_override, { cwd = cwd })
        end
      '';
    };
  };
}
