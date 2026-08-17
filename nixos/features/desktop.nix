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
    features = {
      containers = true;
      typography = true;
    };

    environment = {
      etc.timezone.text = config.time.timeZone;
      systemPackages = with pkgs; [
        adwaita-icon-theme
        catppuccin-cursors.mochaDark
        ghostty
        nautilus
        xwayland-satellite
      ];
    };

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
      displayManager.noctalia-greeter = {
        enable = true;
        cursorTheme.name = "catppuccin-mocha-dark-cursors";
        settings = {
          auth.allow_empty_password = true;
          shell.greeter_sync.auto_sync = true;
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
      icons.fallbackCursorThemes = ["catppuccin-mocha-dark-cursors"];
      portal.xdgOpenUsePortal = true;
    };
  };
}
