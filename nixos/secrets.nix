{
  config,
  lib,
  pkgs,
  ...
}: let
  privateKeyPath = "/nix/id.key";
  runtimeSecretsPath = "/run/secrets";
  secretsFile = ../secrets.age;
in {
  options.secrets = {
    hostPubkey = lib.mkOption {
      type = with lib.types; nullOr str;
      default = null;
    };
  };

  config = lib.mkIf (config.secrets.hostPubkey != null && builtins.pathExists secretsFile) {
    systemd.services.flake-secrets = {
      description = "Decrypt declared system secrets";
      wantedBy = ["sysinit.target"];
      before = ["sysinit.target" "userborn.service"];
      after = ["local-fs.target"];
      unitConfig.ConditionPathExists = privateKeyPath;
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };
      enableStrictShellChecks = true;
      path = with pkgs; [age jq];
      script = ''
        install -d -m 0700 ${runtimeSecretsPath}
        age -d -i ${privateKeyPath} ${secretsFile} \
          | nix eval --json --file - \
          | jq -j 'to_entries[] | .key + "\u0000" + .value + "\u0000"' \
          | while IFS= read -r -d "" key && IFS= read -r -d "" value; do
            printf "%s" "$value" > "${runtimeSecretsPath}/$key"
            chmod 0400 "${runtimeSecretsPath}/$key"
          done
      '';
    };
  };
}
