{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.apps.docker;
in {
  options.modules.apps.docker = {
    enable = lib.mkEnableOption "the podman module";
  };

  config = lib.mkIf cfg.enable {
    virtualisation.docker = {
      enable = true;
    };
  };
}
