{
  config,
  lib,
  pkgs,
  ...
}: {
  options.features.nvidia = lib.mkEnableOption "the nvidia feature";

  config = lib.mkIf config.features.nvidia {
    services.xserver = {
      excludePackages = with pkgs; [xterm];
      videoDrivers = ["nvidia"];
    };

    hardware.nvidia = {
      branch = "bleeding_edge";
      modesetting.enable = true;
      nvidiaSettings = false;
      open = true;
      powerManagement.enable = true;
    };
  };
}
