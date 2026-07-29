{
  config,
  lib,
  inputs,
  ...
}: {
  flake.nixosConfigurations =
    ./hosts
    |> builtins.readDir
    |> lib.mapAttrs' (n: v: rec {
      name = lib.removeSuffix ".nix" n;
      value = lib.nixosSystem {
        specialArgs = {
          flakeInputs = inputs;
          homeModule = ./home;
          hostSpec = ./specs/${name}.json;
        };
        modules = [./nixos ./hosts/${n}];
      };
    });

  perSystem = {pkgs, ...}: let
    installEnv = lib.nixosSystem {
      specialArgs.system = pkgs.system;
      modules = [./image.nix];
    };
  in {
    packages.image = installEnv.config.system.build.isoImage;
    packages.wizard = pkgs.callPackage ./wizard {};
  };
}
