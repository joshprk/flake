{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.apps.niri;
in {
  # This module is intended to produce a fully functional desktop environment.
  #
  # Along with the compositor, it should install all daemons which work through
  # d-bus, such as audio, power management, and security daemons.
  #
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

    services.gnome.gnome-keyring = {
      enable = false;
    };

    services.pipewire = {
      enable = lib.mkDefault true;
      audio.enable = lib.mkDefault true;
    };

    services.power-profiles-daemon = {
      enable = lib.mkDefault true;
    };

    services.udisks2 = {
      enable = lib.mkDefault true;
    };

    services.upower = {
      enable = lib.mkDefault true;
    };

    xdg.icons = {
      enable = lib.mkDefault true;
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
      rtkit.enable = lib.mkDefault true;
      polkit.enable = lib.mkDefault true;
    };
  };
}
