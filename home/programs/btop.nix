{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.programs.btop;
in {
  options.programs.btop = {
    package = lib.mkPackageOption pkgs "btop" {};

    settings = lib.mkOption {
      type = lib.types.attrs;
      readOnly = true;
      default = {
        color_theme = "TTY";
        theme_background = false;
      };
    };
  };

  config = {
    packages = [
      cfg.package
    ];

    xdg.config.files."btop/btop.conf" = {
      generator = (pkgs.formats.keyValue {
        listsAsDuplicateKeys = true;
        mkKeyValue = lib.generators.mkKeyValueDefault {
          mkValueString = v: with builtins;
            if isBool v then
              (if v then "True" else "False")
            else if isString v then
              ''"${v}"''
            else
              toString v;
        } " = ";
      }).generate "btop-config";
      value = cfg.settings;
    };
  };
}
