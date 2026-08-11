{ pkgs, ... }:

{
  users = {
    mutableUsers = false;
    users.austin = {
      hashedPasswordFile = "/persist/secrets/austin-password-hash";
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "networkmanager"
      ];
      shell = pkgs.fish;
    };
  };
}
