{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.features;
in {
  options.features = {
    desktop = lib.mkEnableOption "the desktop feature";
  };

  config = lib.mkIf cfg.desktop {
    features = {
      users = true;
    };

    modules.apps = {
      flatpak.enable = true;
      hyprland.enable = true;
    };

    zramSwap.enable = true;
  };
}
