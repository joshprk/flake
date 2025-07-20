{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.system.persist;
in {
  options.modules.system.persist = {
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

  config = {
    environment.persistence.${cfg.directory} = {
      enable = true;
      hideMounts = true;
      directories = cfg.extraDirectories ++ ["/var/log" "/var/lib"];
      files = cfg.extraFiles ++ ["/etc/machine-id"];
    };
  };
}
