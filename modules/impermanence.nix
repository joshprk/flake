{
  config,
  lib,
  ...
}: let
  cfg = config.settings.impermanence;
in {
  options.settings = {
    impermanence = {
      enable = lib.mkEnableOption "the impermanence module";

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
  };

  config = lib.mkIf cfg.enable {
    environment.persistence.${cfg.directory} = {
      enable = true;
      hideMounts = true;

      directories =
        [
          "/etc/nixos"
          "/var/log"
          "/var/lib/nixos"
        ]
        ++ cfg.extraDirectories;

      files =
        [
          "/etc/machine-id"
        ]
        ++ cfg.extraFiles;
    };
  };
}
