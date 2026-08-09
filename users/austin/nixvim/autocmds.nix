{ lib, ... }:

{
  autoGroups = {
    highlight_yank = { };
    last_location = { };
    resize_splits = { };
  };

  autoCmd = [
    {
      event = "TextYankPost";
      group = "highlight_yank";
      desc = "Highlight when yanking text";
      callback = lib.nixvim.mkRaw ''
        function()
          vim.hl.on_yank()
        end
      '';
    }
    {
      event = "VimResized";
      group = "resize_splits";
      desc = "Resize splits when resizing the window";
      callback = lib.nixvim.mkRaw ''
        function()
          local current_tab = vim.fn.tabpagenr()
          vim.cmd("tabdo wincmd =")
          vim.cmd("tabnext " .. current_tab)
        end
      '';
    }
    {
      event = "BufReadPost";
      group = "last_location";
      desc = "Jump to the last location when opening a file";
      callback = lib.nixvim.mkRaw ''
        function(event)
          local buf = event.buf
          if vim.bo[buf].filetype == "gitcommit" or vim.b[buf].nixvim_last_loc then
            return
          end

          vim.b[buf].nixvim_last_loc = true
          local mark = vim.api.nvim_buf_get_mark(buf, '"')
          local line_count = vim.api.nvim_buf_line_count(buf)
          if mark[1] > 0 and mark[1] <= line_count then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
          end
        end
      '';
    }
  ];
}
