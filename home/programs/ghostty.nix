{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.programs.ghostty;
in {
  options.programs.ghostty = {
    package = lib.mkPackageOption pkgs "ghostty" {};

    settings = lib.mkOption {
      type = lib.types.attrs;
      readOnly = true;
      default = {
        auto-update = "off";
        font-family = "JetBrainsMono Nerd Font";
        font-size = 11;
        quit-after-last-window-closed = true;
        theme = "Catppuccin Mocha";
        window-padding-color = "extend";
        window-padding-x = 4;
        window-padding-y = 4;
      };
    };
  };

  config = {
    packages = [
      cfg.package
    ];

    xdg.config.files."ghostty/config" = {
      generator = (pkgs.formats.keyValue {
        listsAsDuplicateKeys = true;
        mkKeyValue = lib.generators.mkKeyValueDefault {} " = ";
      }).generate "ghostty-config";
      value = cfg.settings;
    };
  };
}
