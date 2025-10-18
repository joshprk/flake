{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.programs.vicinae;
in {
  options.programs.vicinae = {
    enable = lib.mkEnableOption "the vicinae shell";
    package = lib.mkPackageOption pkgs "vicinae" {};
    
    settings = lib.mkOption {
      type = lib.types.attrs;
      default = {};
    };
  };

  config = lib.mkIf cfg.enable {
    packages = [cfg.package];

    xdg.config.files."vicinae/vicinae.json" = {
      generator = (pkgs.formats.json {}).generate "vicinae-config";
      value = cfg.settings;
    };

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
  };
}
