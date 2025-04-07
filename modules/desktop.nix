{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.settings.desktop;
in {
  options.settings = {
    desktop = {
      enable = lib.mkEnableOption "the desktop module";
      hyprland = lib.mkEnableOption "the Hyprland window manager";
    };
  };

  config = let
    general = {
      settings.networking.enable = true;
      powerManagement.enable = true;
    };

    hyprland = {
      environment.pathsToLink = [
        "/share/xdg-desktop-portal"
        "/share/applications"
      ];

      programs.hyprland = {
        enable = true;
      };

      services.pipewire = {
        enable = true;
        pulse.enable = true;
      };

      services.xserver = {
        enable = true;
        desktopManager.xterm.enable = false;
        displayManager.lightdm.enable = false;
      };

      xdg = {
        autostart.enable = true;
        portal = {
          enable = true;
          extraPortals = with pkgs; [
            xdg-desktop-portal-hyprland
            xdg-desktop-portal-gtk
          ];
        };
      };

      security.rtkit.enable = true;

      services.displayManager.ly.enable = true;
    };
  in
    lib.mkIf cfg.enable (lib.mkMerge [
      general
      (lib.mkIf cfg.hyprland hyprland)
    ]);
}
