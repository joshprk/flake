{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.kernel;
in {
  options.modules.kernel = {
    package = lib.mkOption {
      type = lib.types.raw;
      description = "Which package to use for the Linux kernel.";
      default = pkgs.linuxPackages_latest;
    };
  };

  config = {
    boot = {
      loader = {
        limine = {
          enable = true;
          enrollConfig = true;
          maxGenerations = 10;
        };
        efi.canTouchEfiVariables = true;
      };
      initrd = {
        systemd.enable = true;
        verbose = false;
      };
      plymouth.enable = true;
      consoleLogLevel = 0;
      kernelParams = ["quiet" "plymouth.use-simpledrm"];
      kernelPackages = cfg.package;
    };
  };
}
