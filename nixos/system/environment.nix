{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.system.environment;
in {
  options.modules.system.environment = {
    timeZone = lib.mkOption {
      type = lib.types.str;
      description = "The time zone used when displaying times and dates.";
      default = "America/New_York";
    };
  };

  config = {
    environment = {
      defaultPackages = lib.mkDefault [];
      enableAllTerminfo = true;
    };

    programs.command-not-found = {
      enable = false;
    };

    system.etc.overlay = {
      enable = true;
      mutable = true;
    };

    time = {
      inherit (cfg) timeZone;
    };
  };
}
