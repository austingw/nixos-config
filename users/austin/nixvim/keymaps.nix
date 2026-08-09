{ lib, ... }:

{
  keymaps = [
    {
      mode = "n";
      key = "<Esc>";
      action = "<cmd>nohlsearch<CR>";
      options.desc = "Clear search highlighting";
    }
    {
      mode = "n";
      key = "[d";
      action = lib.nixvim.mkRaw ''
        function()
          vim.diagnostic.jump({ count = -1 })
        end
      '';
      options.desc = "Go to previous [D]iagnostic message";
    }
    {
      mode = "n";
      key = "]d";
      action = lib.nixvim.mkRaw ''
        function()
          vim.diagnostic.jump({ count = 1 })
        end
      '';
      options.desc = "Go to next [D]iagnostic message";
    }
    {
      mode = "n";
      key = "<leader>e";
      action = lib.nixvim.mkRaw "vim.diagnostic.open_float";
      options.desc = "Show diagnostic [E]rror messages";
    }
    {
      mode = "n";
      key = "<leader>q";
      action = lib.nixvim.mkRaw "vim.diagnostic.setloclist";
      options.desc = "Open diagnostic [Q]uickfix list";
    }
    {
      mode = "n";
      key = "<C-h>";
      action = "<C-w><C-h>";
      options.desc = "Move focus to the left window";
    }
    {
      mode = "n";
      key = "<C-l>";
      action = "<C-w><C-l>";
      options.desc = "Move focus to the right window";
    }
    {
      mode = "n";
      key = "<C-j>";
      action = "<C-w><C-j>";
      options.desc = "Move focus to the lower window";
    }
    {
      mode = "n";
      key = "<C-k>";
      action = "<C-w><C-k>";
      options.desc = "Move focus to the upper window";
    }
    {
      mode = "n";
      key = "<leader>h";
      action = "<cmd>split<CR>";
      options.desc = "[H]orizontally split window";
    }
    {
      mode = "n";
      key = "<leader>v";
      action = "<cmd>vsplit<CR>";
      options.desc = "[V]ertically split window";
    }
    {
      mode = "n";
      key = "<C-Up>";
      action = "<cmd>m .-2<CR>==";
      options.desc = "Move line up";
    }
    {
      mode = "n";
      key = "<C-Down>";
      action = "<cmd>m .+1<CR>==";
      options.desc = "Move line down";
    }
    {
      mode = "i";
      key = "<C-Down>";
      action = "<Esc><cmd>m .+1<CR>==gi";
      options.desc = "Move line down";
    }
    {
      mode = "i";
      key = "<C-Up>";
      action = "<Esc><cmd>m .-2<CR>==gi";
      options.desc = "Move line up";
    }
    {
      mode = "v";
      key = "<C-Down>";
      action = ":m '>+1<CR>gv=gv";
      options.desc = "Move selection down";
    }
    {
      mode = "v";
      key = "<C-Up>";
      action = ":m '<-2<CR>gv=gv";
      options.desc = "Move selection up";
    }
    {
      mode = "n";
      key = "<C-u>";
      action = "<C-u>zz";
      options.desc = "Move half page up and center cursor";
    }
    {
      mode = "n";
      key = "<C-d>";
      action = "<C-d>zz";
      options.desc = "Move half page down and center cursor";
    }
    {
      mode = "n";
      key = "<leader>g";
      action = "<cmd>Neogit<CR>";
      options.desc = "Open Neo[G]it";
    }
    {
      mode = "n";
      key = "<leader>t";
      action = "<cmd>Neotree toggle<CR>";
      options.desc = "Open Neo[T]ree";
    }
  ];

}
