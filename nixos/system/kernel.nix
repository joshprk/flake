{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.system.kernel;
in {
  options.modules.system.kernel = {
    package = lib.mkOption {
      type = lib.types.raw;
      description = "The Linux kernel packages to use.";
      default = pkgs.linuxPackages_latest;
    };
  };

  config = {
    boot = {
      consoleLogLevel = lib.mkDefault 0;

      initrd = {
        systemd.enable = lib.mkDefault true;
        verbose = lib.mkDefault false;
      };

      kernelPackages = cfg.package;
      kernelParams = [
        (lib.mkIf config.boot.plymouth.enable "plymouth.use-simpledrm")
        "quiet"
      ];

      loader.limine = {
        enable = lib.mkDefault true;
        enrollConfig = lib.mkDefault true;
        maxGenerations = lib.mkDefault 10;
      };

      plymouth.enable = lib.mkDefault config.services.xserver.enable;
    };
  };
}
