{
  config,
  lib,
  ...
}: {
  options.features = {
    containers = lib.mkEnableOption "the containers feature";
  };

  config = lib.mkIf config.features.containers {
    hardware.nvidia-container-toolkit.enable = config.hardware.nvidia.enabled;

    virtualisation.podman = {
      enable = true;
      autoPrune.enable = true;
    };
  };
}
