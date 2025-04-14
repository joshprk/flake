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
        type = lib.types.attrs;
        default = pkgs.linuxPackages_latest;
        description = ''
          Which package to use as the kernel.
        '';
      };

      verbose = lib.mkEnableOption "verbose kernel output";

      extraParams = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [];
        description = ''
          Extra parameters for the kernel.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
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
