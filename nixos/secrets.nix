{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.secrets;
in {
  options.modules.secrets = {
    hostPubkey = lib.mkOption {
      type = with lib.types; nullOr str;
      description = "The host pubkey obtained through `ssh-keyscan`.";
      default =
        if builtins.hasAttr config.networking.hostName config.modules.secrets.pubkeyStore
        then config.modules.secrets.pubkeyStore.${config.networking.hostName}
        else "/etc/ssh/ssh_host_ed25519_key.pub";
      readOnly = true;
    };

    pubkeyStore = lib.mkOption {
      type = with lib.types; attrsOf str;
      description = "A read-only table of named public SSH keys.";
      default = {
        alpine = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHc9NstrPV8eS9UYTfhhA2FmLBcCrJe2tAMT64263At5";
        coffee = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFVAxNp75ESefhc2xg7AIurxJsdm2B/Cy5cOcbFAaDhu";
        forge = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHNAmoo0Js+KWwLmy9dgZVpoR6yHUcFMcSdepnLTWYfk";
      };
      readOnly = true;
    };

    secretsPath = lib.mkOption {
      type = lib.types.path;
      description = "The secrets folder path.";
      default = ../secrets;
      readOnly = true;
    };
  };

  config = {
    age.rekey = {
      inherit (cfg) hostPubkey;
      agePlugins = with pkgs; [age-plugin-fido2-hmac];
      masterIdentities = [../secrets/identity.pub];
      storageMode = "local";
      localStorageDir = cfg.secretsPath + "/rekeyed/${config.networking.hostName}";
    };

    age.secrets =
      if builtins.pathExists cfg.secretsPath
      then
        lib.pipe cfg.secretsPath [
          builtins.readDir
          builtins.attrNames
          (builtins.filter (lib.hasSuffix ".age"))
          (map (lib.removeSuffix ".age"))
          (map (name:
            lib.nameValuePair name {
              rekeyFile = lib.path.append cfg.secretsPath "${name}.age";
            }))
          builtins.listToAttrs
        ]
      else {};

    age.identityPaths = lib.mkIf config.modules.impermanence.enable [
      "/nix/persist/etc/ssh/ssh_host_ed25519_key"
    ];
  };
}
