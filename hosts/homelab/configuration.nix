{
  config,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    ./disko.nix
    ../common.nix
    ../../users/austin/nixos.nix
  ];

  system.stateVersion = "26.05";
}
