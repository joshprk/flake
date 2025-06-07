{
  config,
  lib,
  ...
}: let
  cfg = config.modules.impermanence;
in {
  options.modules.impermanence = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "Whether to enable the impermanence module.";
      default = false;
    };

    directory = lib.mkOption {
      type = lib.types.str;
      default = "/nix/persist";
      description = ''
        Which directory to save persisted files.
      '';
    };

    extraDirectories = lib.mkOption {
      type = lib.types.listOf lib.types.anything;
      default = [];
      description = ''
        Extra directories to persist.
      '';
    };

    extraFiles = lib.mkOption {
      type = lib.types.anything;
      default = [];
      description = ''
        Extra files to persist.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    environment.persistence.${cfg.directory} = {
      enable = true;
      hideMounts = true;
      directories =
        [
          "/var/log"
          "/var/lib/nixos"
          "/var/lib/systemd"
          (let
            attrs = builtins.attrNames config.containers;
            len = builtins.length attrs;
            cond = len > 0;
          in
            lib.mkIf cond "/var/lib/nixos-containers")
        ]
        ++ cfg.extraDirectories;
      files = ["/etc/machine-id"] ++ cfg.extraFiles;
    };
  };
}
