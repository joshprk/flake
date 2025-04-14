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
    };
  };

  config = lib.mkIf cfg.enable {
    programs.niri = {
      inherit (osConfig.programs.niri) package;
      settings.binds = {};
    };
  };
}
