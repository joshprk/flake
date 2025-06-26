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
      enableAllTerminfo = true;
    };

    time = {
      inherit (cfg) timeZone;
    };
  };
}
