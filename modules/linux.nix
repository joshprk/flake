{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.settings.linux;
in {
  options.settings = {
    linux = {
      enable = lib.mkEnableOption "the Linux module";

      package = lib.mkOption {
        default = pkgs.linuxPackages_latest;
        example = pkgs.linuxPackages-libre;
        description = "Which package to use as the kernel.";
        type = lib.types.attrs;
      };

      verbose = lib.mkEnableOption "verbose kernel output";

      extraParams = lib.mkOption {
        default = [];
        example = ["quiet" "splash"];
        description = "Extra parameters for the kernel.";
        type = lib.types.listOf lib.types.str;
      };
    };
  };

  config = {
    boot = {
      consoleLogLevel = lib.mkIf (!cfg.verbose) 3;
      kernelPackages = cfg.package;
      kernelParams =
        []
        ++ lib.optionals (!cfg.verbose) ["quiet" "splash"]
        ++ cfg.extraParams;

      loader = {
        systemd-boot.enable = lib.mkDefault true;
        efi.canTouchEfiVariables = lib.mkDefault true;
      };
    };
  };
}
