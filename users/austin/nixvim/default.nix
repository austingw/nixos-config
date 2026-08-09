{
  imports = [
    ./autocmds.nix
    ./keymaps.nix
    ./opts.nix
    ./plugins
  ];

  globals = {
    mapleader = " ";
    maplocalleader = " ";
    have_nerd_font = true;
  };
}
