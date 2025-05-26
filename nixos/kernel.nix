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
      default =
        if config.modules.home.interactive
        then pkgs.linuxPackages_zen
        else pkgs.linuxPackages_latest;
    };

    secureBoot = lib.mkOption {
      type = lib.types.bool;
      description = "Whether to enable secure boot through Limine.";
      default = false;
    };
  };

  config = {
    modules.impermanence.extraDirectories = ["/var/lib/sbctl"];

    boot.loader = {
      limine = {
        enable = true;
        secureBoot.enable = cfg.secureBoot;
        enrollConfig = true;
        maxGenerations = 10;
      };
      efi.canTouchEfiVariables = true;
    };

    boot.initrd = {
      systemd.enable = true;
      verbose = false;
    };

    boot.plymouth.enable = true;
    boot.consoleLogLevel = 0;
    boot.kernelParams = [
      "quiet"
      "plymouth.use-simpledrm"
    ];
    boot.kernelPackages = cfg.package;
  };
}
