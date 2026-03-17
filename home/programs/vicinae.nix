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
        favicon_service = "twenty";
        font.normal = {
          size = 10;
        };
        pop_to_root_on_close = true;
        telemetry = {
          system_info = false;
        };
        theme = {
          dark = {
            name = "vicinae-dark";
          };
        };
      };
    };
  };

  config = {
    packages = [
      cfg.package
    ];

    xdg.config.files."vicinae/settings.json" = {
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
