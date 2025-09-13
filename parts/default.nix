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
      flake = lib.modules.importApply ./module.nix inputs;
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
