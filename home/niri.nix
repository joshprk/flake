{
  config,
  lib,
  osConfig,
  ...
}: let
  cfg = config.settings.niri;
in {
  options.settings = {
    niri = {
      enable = lib.mkEnableOption "the Niri home module";
      
      binds = lib.mkOption {
        type = lib.types.attrs;
        default = {};
        description = "Customized binds which are merged non-recursively.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    programs.niri = {
      inherit (osConfig.programs.niri) package;
      settings.binds = with config.lib.niri.actions; {
        "Mod+H" = {
          action = focus-column-left;
        };
        "Mod+L" = {
          action = focus-column-right;
        };
      } // cfg.binds;
    };
  };
}
