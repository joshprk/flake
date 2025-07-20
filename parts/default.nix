{
  config,
  lib,
  inputs,
  ...
}: rec {
  imports = [
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

  perSystem = {pkgs, ...}: {
    formatter = pkgs.alejandra;
  };
}
