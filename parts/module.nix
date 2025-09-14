localInputs: {
  config,
  lib,
  inputs,
  ...
}: {
  imports = [
    localInputs.agenix-rekey.flakeModule
  ];

  options.deploy = with lib; {
    clusters = mkOption {
      type = with types; attrsOf path;
      default = {};
    };

    modules = mkOption {
      type = with types; listOf deferredModule;
      default = [];
    };

    var.nixosModules = mkOption {
      type = with types; listOf deferredModule;
      default = [];
    };

    var.homeModules = mkOption {
      type = with types; listOf deferredModule;
      default = [];
    };

    var.secrets = mkOption {
      type = with types; path;
      default = "${inputs.self}/secrets";
    };

    var.identities = mkOption {
      type = with types; listOf path;
      default = lib.singleton "${inputs.self}/identity.pub";
    };

    var.overlays = mkOption {
      type = with types; listOf raw;
      default = [];
    };
  };

  config = {
    _module.args = {
      inherit localInputs;
    };

    deploy = {
      modules = with localInputs;
        lib.filesystem.listFilesRecursive ../nixos
        ++ [
          agenix.nixosModules.age
          agenix-rekey.nixosModules.agenix-rekey
          disko.nixosModules.disko
          facter.nixosModules.facter
          hjem.nixosModules.hjem
          impermanence.nixosModules.impermanence
        ];

      var.overlays = with localInputs; [
        nixvim.overlays.default
        vicinae.overlays.default
      ];
    };

    flake = {
      nixosConfigurations = lib.pipe config.deploy.clusters [
        builtins.attrValues
        (lib.concatMap (path:
          lib.pipe path [
            builtins.readDir
            builtins.attrNames
            (map (file: "${path}/${file}"))
          ]))
        (map (mod: rec {
          name = lib.pipe mod [
            builtins.baseNameOf
            builtins.unsafeDiscardStringContext
            (lib.removeSuffix ".nix")
          ];
          value = lib.nixosSystem {
            modules = config.deploy.modules ++ [mod];
            specialArgs.var =
              config.deploy.var
              // {
                libInputs = localInputs;
                host = mod;
                hostName = name;
              };
          };
        }))
        builtins.listToAttrs
      ];
    };

    perSystem = {
      config,
      pkgs,
      ...
    }: {
      devShells.default = pkgs.mkShellNoCC {
        packages = with pkgs; [
          config.agenix-rekey.package
          age-plugin-fido2-hmac
        ];
      };

      agenix-rekey = {
        homeConfigurations = {};
      };
    };

    systems = lib.mkDefault lib.systems.flakeExposed;
  };
}
