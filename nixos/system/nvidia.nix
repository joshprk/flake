{
  config,
  lib,
  pkgs,
  flake,
  ...
}: let
  cfg = config.modules.system.nvidia;
in {
  options.modules.system.nvidia = {
    enable = lib.mkEnableOption "the nvidia module";

    package = lib.mkOption {
      type = lib.types.package;
      default = config.boot.kernelPackages.nvidiaPackages.beta;
      description = ''
        Which NVIDIA driver package to use.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    services.xserver = {
      videoDrivers = ["nvidia"];
    };

    hardware.nvidia = {
      inherit (cfg) package;
      modesetting.enable = true;
      powerManagement.enable = true;
      nvidiaSettings = false;
      open = true;
    };
  };
}
