{
  lib,
  inputs,
  ...
}: {
  flake.nixosConfigurations =
    ./hosts
    |> builtins.readDir
    |> lib.mapAttrs' (n: _v: rec {
      name = lib.removeSuffix ".nix" n;
      value = lib.nixosSystem {
        specialArgs.flakeInputs = inputs;
        specialArgs.homeModule = ./home;
        specialArgs.hostSpec = ./specs/${name}.json;
        modules = [./nixos ./hosts/${n}];
      };
    });

  perSystem = {
    pkgs,
    system,
    ...
  }: {
    packages.image = let
      nixos = pkgs.nixos ({modulesPath, ...}: {
        imports = ["${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"];
        environment.systemPackages = [inputs.disko.packages.${system}.default];
        nix.settings.experimental-features = ["flakes" "nix-command" "pipe-operators"];
      });
    in
      nixos.config.system.build.isoImage;
  };
}
