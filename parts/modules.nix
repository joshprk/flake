{
  inputs,
  lib,
  ...
}: {
  imports = with inputs; [
    agenix-rekey.flakeModule
  ];

  flake = with inputs; {
    nixosModules.default.imports = [
      agenix.nixosModules.default
      agenix-rekey.nixosModules.default
      disko.nixosModules.disko
      home-manager.nixosModules.home-manager
      impermanence.nixosModules.impermanence
    ];

    homeModules.default.imports = [
      niri.homeModules.niri
      nixvim.homeManagerModules.nixvim
      stylix.homeModules.stylix
    ];

    overlays.default = with lib; final: prev:
      foldl recursiveUpdate {} (map (fn: fn final prev) [
        agenix-rekey.overlays.default
        niri.overlays.niri
      ]);
  };
}
