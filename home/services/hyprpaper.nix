{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.services.hyprpaper;
in {
  options.services.hyprpaper = {
    enable = lib.mkEnableOption "the hyprpaper service";
    package = lib.mkPackageOption pkgs "hyprpaper" {};

    wallpaper = lib.mkOption {
      type = lib.types.package;
    };
  };

  config = lib.mkIf cfg.enable {
    packages = [cfg.package];

    xdg.config.files."hypr/hyprpaper.conf".text = ''
      preload = ${cfg.wallpaper}
      wallpaper = , ${cfg.wallpaper}
    '';

    systemd.services.hyprpaper = {
      wantedBy = ["graphical-session.target"];
      unitConfig = {
        ConditionEnvironment = "WAYLAND_DISPLAY";
        Description = "hyprpaper";
        After = ["graphical-session.target"];
        PartOf = ["graphical-session.target"];
        X-Restart-Triggers = [
          "${config.xdg.config.files."hypr/hyprpaper.conf".source}"
        ];
      };
      serviceConfig = {
        ExecStart = "${lib.getExe cfg.package}";
        Restart = "always";
        RestartSec = "10";
      };
    };
  };
}
