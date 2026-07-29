{
  config,
  lib,
  pkgs,
  ...
}: {
  options.features = {
    nvidia = lib.mkEnableOption "the nvidia feature";
  };

  config = lib.mkIf config.features.nvidia {
    services.xserver.videoDrivers = ["nvidia"];

    hardware.nvidia = {
      branch = "bleeding_edge";
      open = true;
      modesetting.enable = true;
      powerManagement.enable = true;
      nvidiaSettings = false;
    };
  };
}
