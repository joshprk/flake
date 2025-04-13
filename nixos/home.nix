{
  config,
  lib,
  users ? {},
  ...
}: let
  cfg = config.settings.home;
in {
  options.settings = {
    home = {
      enable = lib.mkEnableOption "the home module";

      categories = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = ["default"];
        description = "The user categories which the host is subscribed to.";
      };

      userCategories = lib.mkOption {
        readOnly = true;
        type = lib.attrsOf (lib.types.listOf lib.types.str);
        default = {}; # TODO
        description = ''
          A read-only mapping which pairs users to hosts indirectly.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
  };
}
