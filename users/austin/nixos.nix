{ pkgs, ... }:

{
  users = {
    mutableUsers = false;
    users.austin = {
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "networkmanager"
      ];
      shell = pkgs.fish;
    };
  };
}
