{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.system.env;
in {
  options.modules.system.env = {
    timeZone = lib.mkOption {
      type = lib.types.str;
      description = "The time zone used when displaying times and dates.";
      default = "America/New_York";
    };
  };

  config = {
    environment = {
      defaultPackages = lib.mkDefault [];
      enableAllTerminfo = lib.mkDefault true;
    };

    programs.command-not-found = {
      enable = lib.mkDefault false;
    };

    system.etc.overlay = {
      enable = lib.mkDefault true;
      mutable = lib.mkDefault true;
    };

    time.timeZone = lib.mkDefault cfg.timeZone;
  };
}
