{
  config,
  lib,
  pkgs,
  ...
}: let
  systemdTarget = "graphical-session.target";
in {
  packages = with pkgs; [noctalia];

  xdg.config.files."noctalia/config.toml" = {
    generator = (pkgs.formats.toml {}).generate "noctalia-config";
    value = {};
  };

  systemd.services.noctalia = {
    description = "Noctalia shell";
    partOf = [systemdTarget];
    after = [systemdTarget];
    wantedBy = [systemdTarget];
    enableDefaultPath = true;
    restartTriggers = [
      config.xdg.config.files."noctalia/config.toml".source
      pkgs.noctalia
    ];
    serviceConfig.ExecStart = lib.getExe pkgs.noctalia;
    serviceConfig.Restart = "on-failure";
  };
}
