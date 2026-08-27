{
  config,
  lib,
  pkgs,
  ...
}: {
  options.features = {
    containers = lib.mkEnableOption "the containers feature";
  };

  config = lib.mkIf config.features.containers {
    environment = {
      sessionVariables.PODMAN_COMPOSE_WARNING_LOGS = "false";
      systemPackages = with pkgs; [docker-compose];
    };

    hardware.nvidia-container-toolkit.enable = config.hardware.nvidia.enabled;

    virtualisation.podman = {
      enable = true;
      autoPrune.enable = true;
    };
  };
}
