{
  config,
  lib,
  pkgs,
  ...
}: {
  options.features = {
    desktop = lib.mkEnableOption "the desktop feature";
  };

  config = lib.mkIf config.features.desktop {
    features.typography = true;

    environment.systemPackages = with pkgs; [
      catppuccin-cursors.mochaDark
      ghostty
      nautilus
      xwayland-satellite
    ];

    boot.kernelPackages = lib.mkForce pkgs.linuxPackages_zen;

    programs = {
      dconf.enable = true;
      niri = {
        enable = true;
        useNautilus = true;
      };
      noctalia = {
        enable = true;
        systemd.enable = true;
        recommendedServices.enable = true;
      };
    };

    services = {
      flatpak = {
        enable = true;
        packages = ["app.zen_browser.zen"];
        update.auto.enable = true;
        update.auto.onCalendar = "daily";
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
      xserver = {
        enable = true;
        displayManager.startx.enable = true;
      };
    };

    security = {
      rtkit.enable = true;
      polkit.enable = true;
    };

    xdg = {
      icons.fallbackCursorThemes = ["catppuccin-mocha-dark-cursors"];
      portal.xdgOpenUsePortal = true;
    };
  };
}
