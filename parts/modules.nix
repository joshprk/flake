{
  inputs,
  lib,
  ...
}: {
  flake = with inputs; {
    nixosModules.default.imports = [
      disko.nixosModules.disko
      home-manager.nixosModules.home-manager
      impermanence.nixosModules.impermanence
      lanzaboote.nixosModules.lanzaboote
      sops.nixosModules.sops
    ];

    homeModules.default.imports = [
      niri.homeModules.niri
      nixvim.homeManagerModules.nixvim
      sops.homeManagerModules.sops
      stylix.homeModules.stylix
    ];

    overlays.default = with lib;
      final: prev:
        foldl recursiveUpdate {} (map (fn: fn final prev) [
          niri.overlays.niri
        ]);
  };
}
