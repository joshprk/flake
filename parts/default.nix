{
  config,
  lib,
  inputs,
  ...
}: rec {
  imports = [
    inputs.agenix-rekey.flakeModule
    flake.flakeModules.default
    ./packages.nix
  ];

  flake = {
    inherit (inputs.flake-parts) lib;
    flakeModules = rec {
      flake = lib.modules.importApply ./flake-module.nix inputs;
      default = flake;
    };
  };

  perSystem = {
    config,
    lib,
    pkgs,
    ...
  }: {
    formatter = pkgs.alejandra;
  };
}
