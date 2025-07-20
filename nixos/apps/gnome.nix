{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.apps.gnome;
in {
  options.modules.apps.gnome = {
    enable = lib.mkEnableOption "the Gnome module";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      ghostty
    ];

    environment.gnome.excludePackages = with pkgs; [
      gedit
      gnome-terminal
      gnome-software
      gnome-music
      gnome-photos
      simple-scan
      totem
      epiphany
      geary
    ];

    services.displayManager = {
      gdm.enable = true;
    };

    services.desktopManager = {
      gnome.enable = true;
    };
  };
}
