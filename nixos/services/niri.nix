{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.services.niri;
in {
  options.modules.services.niri = {
    enable = lib.mkEnableOption "the niri module";
  };

  config = lib.mkIf cfg.enable {
    services.gnome.gnome-keyring = {
      enable = false;
    };

    programs.niri = {
      enable = true;
    };
  };
}
