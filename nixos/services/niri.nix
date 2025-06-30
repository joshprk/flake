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

    security = {
      rtkit.enable = lib.mkDefault true;
      polkit.enable = lib.mkDefault true;
    };

    xdg.icons = {
      enable = lib.mkDefault true;
      fallbackCursorThemes = ["catppuccin-mocha-dark-cursors"];
    };
  };
}
