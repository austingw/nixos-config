{ lib, ... }:

let
  picker = key: source: desc: {
    mode = "n";
    inherit key;
    action = lib.nixvim.mkRaw ''
      function()
        Snacks.picker.${source}()
      end
    '';
    options.desc = desc;
  };
in
{
  plugins.snacks = {
    enable = true;

    settings = {
      bigfile.enabled = true;
      notifier.enabled = true;
      picker.enabled = true;
      quickfile.enabled = true;
      scroll.enabled = true;
      words.enabled = true;
    };
  };

  keymaps = [
    # Top-level pickers
    (picker "<leader>," "smart" "Smart Find Files")
    (picker "<leader><space>" "buffers" "Buffers")
    (picker "<leader>/" "grep" "Grep")
    (picker "<leader>:" "command_history" "Command History")
    (picker "<leader>n" "notifications" "Notification History")

    # Files
    (picker "<leader>fb" "buffers" "Buffers")
    {
      mode = "n";
      key = "<leader>fc";
      action = lib.nixvim.mkRaw ''
        function()
          Snacks.picker.files({
            cwd = vim.fn.expand("~/nixos-config"),
          })
        end
      '';
      options.desc = "Find Nix Config File";
    }
    (picker "<leader>ff" "files" "Find Files")
    (picker "<leader>fg" "git_files" "Find Git Files")
    (picker "<leader>fp" "projects" "Projects")
    (picker "<leader>fr" "recent" "Recent")

    # Git
    (picker "<leader>gb" "git_branches" "Git Branches")
    (picker "<leader>gl" "git_log" "Git Log")
    (picker "<leader>gL" "git_log_line" "Git Log Line")
    (picker "<leader>gs" "git_status" "Git Status")
    (picker "<leader>gS" "git_stash" "Git Stash")
    (picker "<leader>gd" "git_diff" "Git Diff")
    (picker "<leader>gf" "git_log_file" "Git Log File")

    # Search
    (picker "<leader>sb" "lines" "Buffer Lines")
    (picker "<leader>sB" "grep_buffers" "Grep Open Buffers")
    (picker "<leader>sg" "grep" "Grep")
    {
      mode = [
        "n"
        "x"
      ];
      key = "<leader>sw";
      action = lib.nixvim.mkRaw ''
        function()
          Snacks.picker.grep_word()
        end
      '';
      options.desc = "Visual selection or word";
    }
    (picker "<leader>s\"" "registers" "Registers")
    (picker "<leader>s/" "search_history" "Search History")
    (picker "<leader>sa" "autocmds" "Autocmds")
    (picker "<leader>sc" "command_history" "Command History")
    (picker "<leader>sC" "commands" "Commands")
    (picker "<leader>sd" "diagnostics" "Diagnostics")
    (picker "<leader>sD" "diagnostics_buffer" "Buffer Diagnostics")
    (picker "<leader>sh" "help" "Help Pages")
    (picker "<leader>sH" "highlights" "Highlights")
    (picker "<leader>si" "icons" "Icons")
    (picker "<leader>sj" "jumps" "Jumps")
    (picker "<leader>sk" "keymaps" "Keymaps")
    (picker "<leader>sl" "loclist" "Location List")
    (picker "<leader>sm" "marks" "Marks")
    (picker "<leader>sM" "man" "Man Pages")
    (picker "<leader>sq" "qflist" "Quickfix List")
    (picker "<leader>sR" "resume" "Resume")
    (picker "<leader>su" "undo" "Undo History")
    (picker "<leader>uC" "colorschemes" "Colorschemes")

    # LSP
    (picker "gd" "lsp_definitions" "Goto Definition")
    (picker "gD" "lsp_declarations" "Goto Declaration")
    (picker "grr" "lsp_references" "References")
    (picker "gri" "lsp_implementations" "Goto Implementation")
    (picker "grt" "lsp_type_definitions" "Goto Type Definition")
    (picker "<leader>ss" "lsp_symbols" "LSP Symbols")
    (picker "<leader>sS" "lsp_workspace_symbols" "LSP Workspace Symbols")
  ];
}
