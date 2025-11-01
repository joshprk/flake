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
    hardware.nvidia-container-toolkit = lib.mkIf config.modules.system.nvidia.enable {
      enable = true;
    };

    virtualisation.docker = {
      enable = true;
    };
  };
}
