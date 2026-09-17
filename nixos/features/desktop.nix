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
      typography = true;
    };

    environment = {
      etc."timezone".text = config.time.timeZone;
      sessionVariables.XCURSOR_SIZE = 24;
      systemPackages = with pkgs; [
        adwaita-icon-theme
        catppuccin-cursors.mochaDark
        ghostty
        xwayland-satellite
      ];
    };

    boot.kernelPackages = lib.mkForce pkgs.linuxPackages_zen;

    programs = {
      dconf.enable = true;
      helium.enable = true;
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

    systemd.user.services.noctalia.environment.XDG_SESSION_TYPE = "wayland";

    security = {
      rtkit.enable = true;
      polkit = {
        enable = true;
        enablePkexecWrapper = true;
      };
    };

    time.timeZone = "America/New_York";

    xdg = {
      icons.fallbackCursorThemes = [cursorTheme];
      portal.xdgOpenUsePortal = true;
    };
  };
}
