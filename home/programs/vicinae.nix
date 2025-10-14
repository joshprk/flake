{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.programs.vicinae;
in {
  options.programs.vicinae = {
    enable = lib.mkEnableOption "the vicinae shell";
    package = lib.mkPackageOption pkgs "vicinae" {};
    
    settings = lib.mkOption {
      type = lib.types.attrs;
      default = {};
    };
  };

  config = lib.mkIf cfg.enable {
    packages = [cfg.package];

    xdg.config.files."vicinae/vicinae.json" = {
      generator = (pkgs.formats.json {}).generate "vicinae-config";
      value = cfg.settings;
    };
  };
}
