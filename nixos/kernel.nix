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

      consoleLogLevel = 0;
      initrd.verbose = false;
      plymouth.enable = true;
      kernelParams = ["quiet" "plymouth.use-simpledrm"];
    };

    boot.kernelPackages = cfg.package;
  };
}
