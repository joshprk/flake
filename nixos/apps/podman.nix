{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.apps.podman;
in {
  options.modules.apps.podman = {
    enable = lib.mkEnableOption "the podman module";
  };

  config = lib.mkIf cfg.enable {
    virtualisation.podman = {
      enable = true;
      dockerCompat = true;
      dockerSocket.enable = true;
    };
  };
}
