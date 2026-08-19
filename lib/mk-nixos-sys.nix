{ inputs }:

{
  hostName,
  modules,
  system ? "x86_64-linux",
}:

inputs.nixpkgs.lib.nixosSystem {
  inherit system;

  specialArgs = {
    inherit inputs hostName;
  };

  modules = modules ++ [
    {
      networking.hostName = hostName;
    }

    inputs.home-manager.nixosModules.home-manager
    {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;

        extraSpecialArgs = {
          inherit inputs hostName;
        };

        users.austin = import ../users/austin/home.nix;
      };
    }
  ];
}
