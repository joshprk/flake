{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.programs.ghostty;
in {
  options.programs.ghostty = {
    enable = lib.mkEnableOption "the ghostty program";
    package = lib.mkPackageOption pkgs "ghostty" {};

    settings = lib.mkOption {
      type = lib.types.attrs;
      default = {};
    };
  };

  config = lib.mkIf cfg.enable {
    packages = [cfg.package];

    xdg.config.files."ghostty/config" = {
      generator = (pkgs.formats.keyValue {
        listsAsDuplicateKeys = true;
        mkKeyValue = lib.generators.mkKeyValueDefault {} " = ";
      }).generate "ghostty-config";
      value = cfg.settings;
    };
  };
}
