{
  config,
  lib,
  pkgs,
  var,
  ...
}: let
  cfg = config.modules.system.secrets;
in {
  options.modules.system.secrets = with lib; {
    keyFile = mkOption {
      type = with types; path;
      description = "The file to read the host pubkey from.";
      default = "${var.host}/keyring.pub";
    };

    secretsPath = mkOption {
      type = with types; path;
      description = "The directory to retrieve secrets from.";
      default = var.secrets;
    };

    rekeyPath = mkOption {
      type = with types; path;
      description = "The directory to store rekeyed secrets into.";
      default = "${cfg.secretsPath}/rekeyed";
    };

    masterIdentities = mkOption {
      type = with types; listOf path;
      description = "Identities to use for secrets.";
      default = var.identities;
    };
  };

  config = {
    age = {
      rekey = {
        inherit (cfg) masterIdentities;
        agePlugins = with pkgs; [age-plugin-fido2-hmac];
        hostPubkey =
          lib.mkIf
          (builtins.pathExists cfg.keyFile)
          (builtins.readFile cfg.keyFile);
        generatedSecretsDir = cfg.secretsPath;
        localStorageDir = "${cfg.rekeyPath}/${config.networking.hostName}";
        storageMode = "local";
      };

      secrets =
        if builtins.pathExists cfg.secretsPath
        then
          cfg.secretsPath
          |> builtins.readDir
          |> builtins.attrNames
          |> builtins.filter (lib.hasSuffix ".age")
          |> map (name: {
            name = lib.removeSuffix ".age" name;
            value.rekeyFile = cfg.secretsPath + "/${name}";
          })
          |> builtins.listToAttrs
        else {};

      identityPaths = ["/nix/var/agenix/host_key"];
    };
  };
}
