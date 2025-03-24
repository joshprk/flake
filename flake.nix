{
  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs?ref=nixos-unstable";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs:
    import ./default.nix {
      inherit inputs;

      systemModules = with inputs; [
        home-manager.nixosModules.home-manager
      ];

      homeModules = with inputs; [];
    };
}
