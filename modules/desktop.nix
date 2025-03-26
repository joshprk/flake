{
  config,
  lib,
  ...
}: let
  cfg = config.settings.desktop;
in {
  options.settings = {
    desktop = {
      enable = lib.mkEnableOption "the desktop module";
    };
  };

  config = lib.mkIf cfg.enable {
    settings.networking.enable = true;
    powerManagement.enable = true;
  };
}
