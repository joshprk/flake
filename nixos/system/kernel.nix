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

    secureBoot = lib.mkOption {
      type = lib.types.bool;
      description = "Whether to enable secure boot through Limine.";
      default = false;
    };
  };

  config = {
    modules.system = {
      impermanence.extraDirectories = ["/var/lib/sbctl"];
    };

    boot = {
      consoleLogLevel = 0;

      initrd = {
        systemd.enable = true;
        verbose = false;
      };

      kernelPackages = cfg.package;
      kernelParams = [
        (lib.mkIf config.boot.plymouth.enable "plymouth.use-simpledrm")
        "quiet"
      ];

      loader.limine = {
        enable = true;
        secureBoot.enable = cfg.secureBoot;
        enrollConfig = true;
        maxGenerations = 10;
      };

      plymouth.enable = true;
    };
  };
}
