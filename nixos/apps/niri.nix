{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.apps.niri;
in {
  options.modules.apps.niri = {
    enable = lib.mkEnableOption "the niri module";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      catppuccin-cursors.mochaDark
    ];

    programs.niri = {
      enable = true;
    };

    services.displayManager = {
      sessionPackages = [config.programs.niri.package];
    };

    services.gnome.gnome-keyring = {
      enable = false;
    };

    services.power-profiles-daemon = {
      enable = true;
    };

    services.udisks2 = {
      enable = true;
    };

    services.upower = {
      enable = true;
    };

    fonts.packages = with pkgs; [
      nerd-fonts.lilex
    ];

    xdg.icons = {
      enable = true;
      fallbackCursorThemes = ["catppuccin-mocha-dark-cursors"];
    };

    xdg.portal = {
      enable = true;
      configPackages = [config.programs.niri.package];
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
        xdg-desktop-portal-gnome
      ];
      config.common = {
        default = [
          "gtk"
          "gnome"
        ];
        "org.freedesktop.impl.portal.Access" = ["gtk"];
      };
    };

    security = {
      rtkit.enable = true;
      polkit.enable = true;
    };
  };
}
