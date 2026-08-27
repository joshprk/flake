{
  config,
  lib,
  pkgs,
  ...
}: let
  cursorTheme = "catppuccin-mocha-dark-cursors";
in {
  options.features.desktop = lib.mkEnableOption "the desktop feature";

  config = lib.mkIf config.features.desktop {
    features = {
      containers = true;
      hyprland = true;
      niri = true;
      typography = true;
    };

    environment = {
      etc."timezone".text = config.time.timeZone;
      sessionVariables.XCURSOR_SIZE = 24;
      systemPackages = with pkgs; [
        adwaita-icon-theme
        catppuccin-cursors.mochaDark
        ghostty
        nautilus
        xwayland-satellite
      ];
    };

    programs = {
      dconf.enable = true;
      noctalia = {
        enable = true;
        systemd.enable = true;
        recommendedServices.enable = true;
      };
    };

    services = {
      displayManager.noctalia-greeter = {
        enable = true;
        cursorTheme.name = cursorTheme;
        settings = {
          auth.allow_empty_password = true;
          session.default = "hyprland";
        };
      };
      flatpak = {
        enable = true;
        packages = ["app.zen_browser.zen"];
        update.auto = {
          enable = true;
          onCalendar = "daily";
        };
      };
      gnome.gnome-keyring.enable = true;
      pipewire = {
        enable = true;
        pulse.enable = true;
        wireplumber.enable = true;
      };
      power-profiles-daemon.enable = true;
      udisks2.enable = true;
      upower.enable = true;
      xserver.enable = true;
    };

    security = {
      rtkit.enable = true;
      polkit.enable = true;
    };

    time.timeZone = "America/New_York";

    xdg = {
      icons.fallbackCursorThemes = [cursorTheme];
      portal.xdgOpenUsePortal = true;
    };
  };
}
