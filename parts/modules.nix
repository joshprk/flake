{inputs, ...}: {
  imports = with inputs; [
    home-manager.flakeModules.home-manager
  ];

  flake = with inputs; {
    nixosModules.default.imports = [
      disko.nixosModules.disko
      home-manager.nixosModules.home-manager
      impermanence.nixosModules.impermanence
      lanzaboote.nixosModules.lanzaboote
    ];

    homeModules.default.imports = [
      niri.homeModules.niri
      nixvim.homeManagerModules.nixvim
    ];
  };
}
