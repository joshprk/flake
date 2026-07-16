{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.services.hyprpaper;
in {
  options.services.hyprpaper = {
    package = lib.mkPackageOption pkgs "hyprpaper" {};
  };

  config = {
    packages = [
      cfg.package
    ];

    xdg.config.files."hypr/hyprpaper.conf".text = ''
      wallpaper {
        monitor =
        path = ${config.wallpaper}
      }
    '';

    systemd.services.hyprpaper = {
      description = "hyprpaper";
      wantedBy = ["graphical-session.target"];
      after = ["graphical-session.target"];
      partOf = ["graphical-session.target"];

      restartTriggers = [
        config.xdg.config.files."hypr/hyprpaper.conf".source
      ];

      unitConfig = {
        ConditionEnvironment = "WAYLAND_DISPLAY";
      };

      serviceConfig = {
        ExecStart = "${lib.getExe cfg.package}";
        Restart = "always";
        RestartSec = 5;
      };
    };
  };
}
