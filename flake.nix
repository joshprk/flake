{
  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs?ref=nixos-unstable";
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

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    ...
  }: let
    lib = nixpkgs.lib;
    forAllSystems = lib.genAttrs lib.systems.flakeExposed;
    getPkgs = system: import nixpkgs {inherit system;};

    mkSystem = {
      hostName,
      system,
      stateVersion,
    }:
      lib.nixosSystem {
        inherit system;

        specialArgs = {
          inherit hostName stateVersion;

          overlays = with self.inputs; [
            (final: prev: {zen-browser = zen-browser.packages.${system}.default;})
          ];

          homeManagerModules = with self.inputs;
            [
              nixvim.homeManagerModules.nixvim
              stylix.homeManagerModules.stylix
            ];
        };

        modules = with self.inputs; let
          hostFile = "${lib.strings.toLower hostName}.nix";
        in
          [
            home-manager.nixosModules.home-manager
            impermanence.nixosModules.impermanence
            lanzaboote.nixosModules.lanzaboote
            sops.nixosModules.sops

            ./hardware/${hostFile}
            ./hosts/${hostFile}
          ]
          ++ lib.filesystem.listFilesRecursive ./modules;
      };
  in {
    nixosConfigurations = {
      PC = mkSystem {
        hostName = "PC";
        system = "x86_64-linux";
        stateVersion = "24.11";
      };

      LT = mkSystem {
        hostName = "LT";
        system = "x86_64-linux";
        stateVersion = "24.11";
      };
    };

    devShells = forAllSystems (system: let
      pkgs = getPkgs system;
    in {
      default = pkgs.mkShell {
        buildInputs = with pkgs; [
          ssh-to-age
          sops
        ];
      };
    });

    formatter =
      forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);
  };
}
