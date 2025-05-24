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
      default = "/etc/ssh/ssh_host_ed25519_key.pub";
      readOnly = true;
    };

    pubkeyStore = lib.mkOption {
      type = with lib.types; attrsOf str;
      description = "A read-only table of named public SSH keys.";
      default = {
        root = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICOimZhc+sD7K1zHQgAX66KpB2L/daf6fxIix541Sb7I";
        joshua = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBYMjdyYJfwjRqHuyePy0xNRKYxeSuJ6e9I1g9F0eHsD";
        coffee = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM7UAw64ySV7ZQRByyK+KVKtOZZ5K1uGCR/qzq88Okch";
      };
      readOnly = true;
    };
  };

  config = {
    age.rekey = {
      inherit (cfg) hostPubkey;
      agePlugins = with pkgs; [age-plugin-fido2-hmac];
      masterIdentities = [../identity.pub];
      storageMode = "local";
      localStorageDir = ./.. + "/secrets/rekeyed/${config.networking.hostName}";
    };

    age.secrets = lib.pipe ../secrets [
      builtins.readDir
      (lib.filterAttrs (_: type: type == "regular"))
      builtins.attrNames
      (map (name: lib.nameValuePair name {rekeyFile = ../secrets + "/${name}";}))
    ];
  };
}
