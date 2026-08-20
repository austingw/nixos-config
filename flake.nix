{
  description = "Sick and ill flake for austingw's NixOS config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dms-plugin-registry = {
      url = "github:AvengeMedia/dms-plugin-registry";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence = {
      url = "github:nix-community/impermanence";
      inputs.nixpkgs.follows = "";
      inputs.home-manager.follows = "";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
    };
  };

  outputs =
    inputs:
    let
      mkNixosSys = import ./lib/mk-nixos-sys.nix {
        inherit inputs;
      };
    in
    {
      nixosConfigurations = {
        fw13 = mkNixosSys {
          hostName = "fw13";
          modules = [
            inputs.disko.nixosModules.disko
            inputs.impermanence.nixosModules.impermanence
            inputs.nixos-hardware.nixosModules.framework-amd-ai-300-series
            ./hosts/fw13/configuration.nix
          ];

        };

        homelab = mkNixosSys {
          hostName = "homelab";
          modules = [
            inputs.disko.nixosModules.disko
            ./hosts/homelab/configuration.nix
          ];
        };
      };
    };
}
