{
  inputs,
  lib,
  ...
}: {
  imports = with inputs; [
    agenix-rekey.flakeModules.default
  ];

  flake = with inputs; {
    nixosModules.default.imports = [
      agenix.nixosModules.default
      agenix-rekey.nixosModules.default
      disko.nixosModules.default
      facter.nixosModules.facter
      hjem.nixosModules.hjem
      impermanence.nixosModules.impermanence
    ];

    overlays.default = with lib;
      final: prev:
        foldl recursiveUpdate {} (map (fn: fn final prev) [
          agenix-rekey.overlays.default
        ]);
  };
}
