{
  inputs,
  lib,
  ...
}: {
  imports = with inputs; [
    agenix-rekey.flakeModules.default
    home-manager.flakeModules.default
  ];

  flake = with inputs; {
    nixosModules.default.imports = [
      agenix.nixosModules.default
      agenix-rekey.nixosModules.default
      disko.nixosModules.default
      facter.nixosModules.facter
      home-manager.nixosModules.home-manager
      impermanence.nixosModules.impermanence
    ];

    homeModules.default.imports = [];

    overlays.default = with lib;
      final: prev:
        foldl recursiveUpdate {} (map (fn: fn final prev) [
          agenix-rekey.overlays.default
        ]);
  };
}
