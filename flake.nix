{
  description = "A modular system configuration.";

  outputs = inputs:
    import ./lib inputs {
      src = ./.;

      nixosModules = with inputs; [
        home-manager.nixosModules.home-manager
        impermanence.nixosModules.impermanence
        lanzaboote.nixosModules.lanzaboote
        niri.nixosModules.niri
        sops.nixosModules.sops
      ];

      homeManagerModules = with inputs; [
        niri.homeModules.niri
        nixvim.homeManagerModules.nixvim
      ];

      overlays = with inputs; [
        niri.overlays.niri
      ];
    };

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs?ref=nixos-unstable";
    };

    hardware = {
      url = "github:nixos/nixos-hardware";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence = {
      url = "github:nix-community/impermanence";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
