{
  config,
  lib,
  inputs,
  localInputs,
  ...
}: let
  cfg = config.deploy;
in {
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
    deploy.modules = with localInputs;
      lib.filesystem.listFilesRecursive ../nixos
      ++ [
        agenix.nixosModules.age
        agenix-rekey.nixosModules.agenix-rekey
        disko.nixosModules.disko
        facter.nixosModules.facter
        hjem.nixosModules.hjem
        impermanence.nixosModules.impermanence
      ];

    deploy.var = {
      overlays = lib.singleton (final: prev: {
        inherit (localInputs.nixvim.legacyPackages.${prev.system}) makeNixvim;
      });
    };

    flake.nixosConfigurations = lib.pipe cfg.clusters [
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
          modules = cfg.modules ++ [mod];
          specialArgs.var =
            cfg.var
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
}
