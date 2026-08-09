{ lib, ... }:

{
  globals.mapleader = " ";

  keymaps = [
    {
      mode = "n";
      key = "<C-h>";
      command = "<C-w><C-h>";
    }
  ];

  opts = {
    number = true;
    relativenumber = true;
  };
}
