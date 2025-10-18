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
      default = pkgs.fetchurl {
        url = "https://github.com/foxt/macOS-Wallpapers/blob/master/Mojave%20Night.jpg?raw=true";
        hash = "sha256-Zv7uvjSNACpI2Yck22bsA8gwVaju2Yght7y09xko9xw=";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    packages = [
      cfg.package
    ];

    xdg.config.files."hypr/hyprpaper.conf".text = ''
      preload = ${cfg.wallpaper}
      wallpaper = , ${cfg.wallpaper}
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
        RestartSec = "10";
      };
    };
  };
}
