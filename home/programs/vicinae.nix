{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.programs.vicinae;
in {
  options.programs.vicinae = {
    package = lib.mkPackageOption pkgs "vicinae" {};

    settings = lib.mkOption {
      type = lib.types.attrs;
      readOnly = true;
      default = {
        faviconService = "twenty";
        font = {
          size = 10;
        };
        popToRootOnClose = true;
        rootSearch = {
          searchFiles = false;
        };
        theme = {
          name = "vicinae-dark";
        };
        window = {
          csd = true;
          opacity = 0.95;
          rounding = 10;
        };
      };
    };
  };

  config = {
    packages = [
      cfg.package
    ];

    xdg.config.files."vicinae/vicinae.json" = {
      generator = (pkgs.formats.json {}).generate "vicinae-config";
      value = cfg.settings;
    };

    # Broken as it does not preserve login shell PATH, causing app startup issues
    # Currently, niri is handling this function
    /*
    systemd.services.vicinae = {
      description = "vicinae";
      wantedBy = ["graphical-session.target"];
      after = ["graphical-session.target"];
      partOf = ["graphical-session.target"];
      bindsTo = ["graphical-session.target"];

      serviceConfig = {
        EnvironmentFile = pkgs.writeText "vicinae-env" "USE_LAYER_SHELL=1";
        Type = "simple";
        ExecStart = "${lib.getExe' cfg.package "vicinae"} server";
        Restart = "always";
        RestartSec = 5;
        KillMode = "process";
      };
    };
    */
  };
}
