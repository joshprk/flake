{
  config,
  lib,
  pkgs,
  flake,
  ...
}: let
  inherit (config.networking) hostName;
  cfg = config.modules.system.keyring;
in {
  options.modules.system.keyring = {
    pubkeyFile = lib.mkOption {
      type = lib.types.path;
      description = "The host public key which secrets are rekeyed for.";
      default = flake.paths.hosts + "/${hostName}/keyring.pub";
      readOnly = true;
    };

    secretsPath = lib.mkOption {
      type = lib.types.path;
      description = "The secrets folder path.";
      default = flake.paths.secrets;
      readOnly = true;
    };

    rekeyPath = lib.mkOption {
      type = lib.types.path;
      description = "The secrets folder path.";
      default = cfg.secretsPath + "/rekeyed";
      readOnly = true;
    };

    generatedPath = lib.mkOption {
      type = lib.types.path;
      description = "The vault folder path.";
      default = cfg.secretsPath;
      readOnly = true;
    };

    identityPath = lib.mkOption {
      type = lib.types.path;
      description = "The identity folder path";
      default = cfg.secretsPath + "/identities";
      readOnly = true;
    };
  };

  config = {
    age = {
      rekey = {
        agePlugins = with pkgs; [age-plugin-fido2-hmac];
        generatedSecretsDir = cfg.generatedPath;
        localStorageDir = cfg.rekeyPath + "/${hostName}";
        hostPubkey = builtins.readFile cfg.pubkeyFile;
        masterIdentities = lib.filesystem.listFilesRecursive cfg.identityPath;
        storageMode = "local";
      };

      secrets =
        cfg.generatedPath
        |> builtins.readDir
        |> builtins.attrNames
        |> builtins.filter (lib.hasSuffix ".age")
        |> map (name: {
          name = lib.removeSuffix ".age" name;
          value.rekeyFile = cfg.generatedPath + "/${name}";
        })
        |> builtins.listToAttrs;

      identityPaths = [flake.paths.key];
    };
  };
}
