{
  self,
  lib,
  inputs,
  ...
}: {
  metaConfig = metaModules: {config, ...}: {
    home-manager = {
      useGlobalPkgs = lib.mkDefault true;
      useUserPackages = lib.mkDefault true;
      sharedModules = metaModules.homeManagerModules;
    };

    nixpkgs = {
      inherit (metaModules) overlays;
      config = {
        inherit (config.nixpkgs) overlays;
        allowUnfree = lib.mkDefault true;
      };
    };

    nix.settings = {
      experimental-features = ["nix-command" "flakes"];
      use-xdg-base-directories = lib.mkDefault true;
    };
  };

  nixosSystem = {
    nixosModules ? [],
    homeManagerModules ? [],
    overlays ? [],
    users ? {},
  } @ metaModules:
  config: rec {
    name = value.config.networking.hostName;
    value = lib.nixosSystem {
      specialArgs = {inherit inputs users;};
      modules =
        nixosModules
        ++ [(self.hosts.metaConfig metaModules)]
        ++ [config];
    };
  };
}
