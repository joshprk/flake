{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.services.hypridle;
in {
  options.services.hypridle = {
    package = lib.mkPackageOption pkgs "hypridle" {};
  };

  config = {
    packages = [
      cfg.package
    ];

    xdg.config.files."hypr/hypridle.conf".text = ''
      listener {
        timeout = 900
        on-timeout = ${lib.getExe pkgs.niri} msg action power-off-monitors
      }
    '';

    systemd.services.hypridle = {
      description = "hypridle";
      wantedBy = ["graphical-session.target"];
      after = ["graphical-session.target"];
      partOf = ["graphical-session.target"];

      restartTriggers = [
        config.xdg.config.files."hypr/hypridle.conf".source
      ];

      unitConfig = {
        ConditionEnvironment = "WAYLAND_DISPLAY";
      };

      serviceConfig = {
        ExecStart = "${lib.getExe cfg.package}";
        Restart = "always";
        RestartSec = "10";
      };
    };
  };
}
