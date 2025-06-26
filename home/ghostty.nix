{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.programs.ghostty;
in {
  options.programs.ghostty = {
    enable = lib.mkEnableOption "the ghostty user module";

    package = lib.mkOption {
      type = lib.types.package;
      description = "The ghostty package to use.";
      default = pkgs.ghostty;
    };

    settings = lib.mkOption {
      type = lib.types.attrs;
      description = "The ghostty settings to use.";
      apply = (pkgs.formats.keyValue {
        listsAsDuplicateKeys = true;
        mkKeyValue = lib.generators.mkKeyValueDefault {} " = ";
      }).generate "ghostty-config";
      default = {};
    };
  };

  config = lib.mkIf cfg.enable {
    packages = [cfg.package];

    files.".config/ghostty/config" = {
      source = cfg.settings;
    };
  };
}
