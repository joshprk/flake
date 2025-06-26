{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.system.impermanence;
in {
  options.modules.system.impermanence = {
    enable = lib.mkEnableOption "the impermanence module";

    directory = lib.mkOption {
      type = lib.types.str;
      description = "Which directory to save persisted files.";
      default = "/nix/persist";
      readOnly = true;
    };

    extraDirectories = lib.mkOption {
      type = with lib.types; listOf (either attrs str);
      description = "Extra directories to persist.";
      default = [];
    };

    extraFiles = lib.mkOption {
      type = with lib.types; listOf (either attrs str);
      description = "Extra files to persist.";
      default = [];
    };
  };

  config = lib.mkIf cfg.enable {
    environment.persistence.${cfg.directory} = {
      enable = true;
      hideMounts = true;
      directories =
        cfg.extraDirectories
        ++ [
          "/var/log"
          "/var/lib/nixos"
          "/var/lib/systemd"
        ];
      files =
        cfg.extraFiles
        ++ ["/etc/machine-id"];
    };
  };
}
