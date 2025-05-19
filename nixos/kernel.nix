{config, lib, pkgs, ...}: let
  cfg = config.modules.kernel;
in {
  options.modules.kernel = {
    package = lib.mkOption {
      type = lib.types.package;
      description = "Which package to use for the Linux kernel.";
      default = pkgs.linuxPackages_latest;
    };
  };

  config = {
    boot.loader.systemd-boot.enable = lib.mkDefault true;
    boot.loader.efi.canTouchEfiVariables = lib.mkDefault true;

    boot.kernelPackages = cfg.package;
  };
}
